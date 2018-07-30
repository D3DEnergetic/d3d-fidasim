FUNCTION get_mainion_geom,shot,beam

    common bst_chord_param,chord_param
    beam = strlowcase(beam)
    CASE beam of
        '210rt': mchords = ['m09','m10','m11','m12','m13','m14','m15','m16']
        '30lt' : mchords = ['m01','m02','m03','m04','m05','m06','m07','m08']
        '330lt' : mchords = ['m17','m18','m19','m20']
        ELSE: error,'No Main-ion chords for beam '+beam,/halt
    eNDCASE

    nchan = long(n_elements(mchords))
    radius = dblarr(nchan)
    axis = dblarr(3,nchan)
    lens = dblarr(3,nchan)
    pos = dblarr(3,nchan)

    for i=0L,nchan-1 do begin
        bst_chord_param,shot,mchords[i],beam
        lens[*,i] = chord_param.geometry.lens
        pos[*,i] = chord_param.geometry.location
        axis[*,i] = pos[*,i] - lens[*,i]
        radius[i] = sqrt(total(pos[0,i]^2 + pos[1,i]^2))
        axis[*,i] = axis[*,i]/sqrt(total(axis[*,i]^2))
    endfor
    sigma_pi = replicate(1.d0,nchan)
    spot_size = replicate(0.d0,nchan)

    return, {data_source:source_file(),system:'MAIN_ION:'+beam,nchan:nchan,id:mchords, $
             lens:lens,axis:axis,sigma_pi:sigma_pi,spot_size:spot_size,radius:radius}

END

FUNCTION oblique_geo_from_patch, patchfile, skip=skip

    suffix = ['a','b','c']

    restore, patchfile
    pnames = TAG_NAMES(patchdat)
    nchan = 0
    lens = []
    axis = []
    radius = []
    id = []
    sigma_pi = []
    spot_size = []
    for i = 0,n_elements(pnames)-1 do begin
        if keyword_set(skip) then begin
            tmp = where(strlowcase(pnames[i]) eq skip,nw)
            if nw gt 0 then continue
        endif
        if patchdat.(i).x eq '' then continue
        f = patchdat.(i).fibers
        for j=0,n_elements(f.fibers)-1 do begin
            fnum = f.fibers[j]
            name = 'p'+string(ceil(float(fnum)/3),FOR='(I02)')+suffix[fnum mod 3 -1]
            IF N_ELEMENTS(id) && TOTAL(STRCMP(name,id)) THEN CONTINUE
            nchan = nchan + 1
            lens = [[lens],[-46.02d0,-198.5d0,122.d0]]
            pos = double([f.x[j], f.y[j], 0.d0])
            a = pos - [-46.02d0,-198.5d0,122.d0]
            a = double(a/sqrt(total(a*a)))
            axis = [[axis],[a]]
            radius = [ radius, double(f.r[j])]
            id = [id, name]
            spot_size = [spot_size,2.d0]
            sigma_pi = [sigma_pi,1.d0]
        endfor
    endfor
    sid = sort(id)
    chords = {system:'OBLIQUE',nchan:long(nchan),data_source:patchfile,lens:lens[*,sid],axis:axis[*,sid], $
              id:id[sid], sigma_pi:sigma_pi[sid],radius:radius[sid],spot_size:spot_size[sid]}

    return, chords

END

FUNCTION get_oblique_geom,shot

    fidadir = '/fusion/projects/diagnostics/fida'
    tmp = read_ascii(fidadir+'/calib/patch/patch.txt',comment_symbol=';')
    patches = long(tmp.field1)
    patch_num = patches[2,(where(patches[0,*] le shot))[-1]]
    patch_file = file_search(fidadir+'/calib/patch/.','patch'+strcompress(patch_num,/remove_all)+'.dat',/fold)
    print, 'Getting Oblique geometry from patch '+string(patch_num,for='(I02)')
    return, oblique_geo_from_patch(patch_file)

END

FUNCTION get_cer_geom,shot,isource,system=system

    if not keyword_set(system) then system = 'vertical'

    a=GET_CERGEOM(shot)
    b=GET_CER_BEAM_ORDER(shot)
    beams=['30LT','30RT','150LT','150RT','210LT','210RT','330LT','330RT']

    whb=where(b eq beams[isource])
    wphi = where(a.phicere[*,whb] le 360.0,nw)

    nchan = long(nw)
    lens = dblarr(3,nchan)
    pos = dblarr(3,nchan)
    axis = dblarr(3,nchan)
    radius = dblarr(nchan)
    chords = strarr(nchan)
    for i=0,nchan-1 do begin
        rl=a.rcers[wphi[i]]*100.
        zl=a.zcers[wphi[i]]*100.
        phil=a.phicers[wphi[i]]

        rb=a.rcere[wphi[i],whb]*100.
        zb=a.zcere[wphi[i],whb]*100.
        phib=a.phicere[wphi[i],whb]

        lens[0,i] = rl*cos((90.0 - phil)*!DTOR)
        lens[1,i] = rl*sin((90.0 - phil)*!DTOR)
        lens[2,i] = zl

        pos[0,i] = rb*cos((90.0 - phib)*!DTOR)
        pos[1,i] = rb*sin((90.0 - phib)*!DTOR)
        pos[2,i] = zb
        radius[i] = rb

        axis[*,i] = pos[*,i] - lens[*,i]
        axis[*,i] = axis[*,i]/sqrt(total(axis[*,i]^2))
        id = a.labels[wphi[i]]
        CASE strmid(id,0,1) OF
            'T': chords[i] = strjoin(strsplit(id,'ANG',/extract))
            'V': chords[i] = strjoin(strsplit(id,'ERT',/extract))
            ELSE: chords[i] = id
        ENDCASE
    endfor
    sigma_pi = replicate(1.d0,nchan)
    spot_size = replicate(0.d0,nchan)

    CASE strlowcase(system) of
        'vertical': BEGIN
            w=where(strmid(chords,0,1) eq 'V',nw)
        END
        'tangential': BEGIN
            w=where(strmid(chords,0,1) eq 'T',nw)
        END
        'edge_tangential': BEGIN
        ;; Edge tangentials from 345R0
            edge_chords = ['T8','T23','T9','T24',$
                           'T10','T11','T12','T13',$
                           'T14','T15','T16']
            w=[]
            FOR i=0,N_ELEMENTS(edge_chords)-1 DO BEGIN
                w = [w,WHERE(STRCMP(edge_chords[i],chords))]
            ENDFOR
        END
        else: BEGIN
            warn, 'Unknown CER system: '+system+'. Using VERTICAL'
            w=where(strmid(chords,0,1) eq 'V',nw)
        END
    ENDCASE

    output={data_source:source_file(),system:system,id:chords[w], $
            nchan:long(nw), lens:lens[*,w],axis:axis[*,w],$
            radius:radius[w],sigma_pi:sigma_pi[w],spot_size:spot_size[w]}

    return,output
END

FUNCTION d3d_chords,fida_diag,calib=calib,isource=isource,shot=shot

    fida_diag=strupcase(fida_diag)
    dir = file_dirname(source_file())
    nchan = 0
    system = []
    id = []
    axis = []
    lens = []
    radius = []
    sigma_pi = []
    spot_size = []

    ;; SELECT THE VIEWS
    for i=0,n_elements(fida_diag)-1 do begin
        CASE (fida_diag[i]) OF
            'VERTICAL': begin
                c = get_cer_geom(shot,6,system='vertical')
            end
            'OBLIQUE': begin
                c = get_oblique_geom(shot)
            end
            'TANGENTIAL': begin
                c = get_cer_geom(shot,isource,system='tangential')
            end
            'TANGENTIAL30': begin
                c = get_cer_geom(shot,0,system='tangential')
            end
            'TANGENTIAL210': begin
                c = get_cer_geom(shot,5,system='tangential')
            end
            'TANGENTIAL330': begin
                c = get_cer_geom(shot,6,system='tangential')
            end
            'ET330': begin
                c = get_cer_geom(shot,isource,system='edge_tangential')
            end
            'MAIN_ION30': begin
                c = get_mainion_geom(shot,'30lt')
            end
            'MAIN_ION210': begin
                c = get_mainion_geom(shot,'210rt')
            end
            'MAIN_ION330': begin
                c = get_mainion_geom(shot,'330lt')
            end
            'BES_ARRAY': begin
                ulos = [133.617,  133.490,  133.350,  133.222,  133.094, $
                        132.965,  132.837,  132.708,  132.579,  132.449, $
                        132.320,  132.190,  132.073,  131.942,  131.811, $
                        131.693,  131.575,  131.443,  131.324,  131.205, $
                        131.086,  130.966,  130.846,  130.725,  130.605, $
                        130.498,  130.376,  130.255,  130.146,  130.024, $
                        129.915,  129.806]

                vlos = [-168.692, -167.515, -166.219, -165.040, -163.856, $
                        -162.669, -161.482, -160.293, -159.100, -157.904, $
                        -156.706, -155.506, -154.424, -153.217, -152.009, $
                        -150.919, -149.828, -148.610, -147.511, -146.411, $
                        -145.309, -144.204, -143.095, -141.983, -140.870, $
                        -139.879, -138.758, -137.635, -136.635, -135.507, $
                        -134.502, -133.493]

                wlos = replicate(0.,32)

                uhead = replicate(261.7,32)
                vhead = replicate(-70.1,32)
                whead = replicate(15.0 ,32)

                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
            end
            '2D_CAMERA': begin
                ;;FROM fida_vanzeeland DIII-D 2-D camera at 90 degrees
                uhead = [276.326]
                vhead = [-5.45047]
                whead = [7.62]
                ulos = [19.6787]
                vlos = [179.223]
                wlos = [0.]
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
            end
            ELSE: begin
                PRINT, '% Diagnostic unknown'
                STOP
            end
        ENDCASE
        system = [system, c.system]
        nchan = nchan + c.nchan
        id = [id, c.id]
        axis = [[axis],[c.axis]]
        lens = [[lens],[c.lens]]
        radius = [radius,c.radius]
        sigma_pi = [sigma_pi,c.sigma_pi]
        spot_size = [spot_size,c.spot_size]

    endfor

    if nchan eq 0 then begin
        error,'No valid FIDA/BES systems selected',/halt
    endif

    return, {system:strjoin(system,", ",/single),data_source:source_file(), $
             nchan:nchan,axis:axis,lens:lens,id:id,$
             radius:radius,sigma_pi:sigma_pi,spot_size:spot_size}
    return,fida
END
