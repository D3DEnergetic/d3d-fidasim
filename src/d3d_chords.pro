FUNCTION get_npa_geom
    ;;Rev. Sci. Instrum. 83, 10D304 (2012) <-NPA Geometry
    detuvw = fltarr(3,3)
    detuvw[0,*] = [2.52,.08,.81]
    detuvw[1,*] = [2.5,.05,.86]
    detuvw[2,*] = [2.49,.09,.89]
    npap = detuvw*0.
    for i=0,2 do begin
        npap[i,0] = -(detuvw[i,0] + detuvw[i,1])/sqrt(2.)
        npap[i,1] = (detuvw[i,1] - detuvw[i,0])/sqrt(2.)
        npap[i,2] = -detuvw[i,2]
    endfor
    npap *= 100

    iwall = fltarr(3,3)
    iwall[0,*] = [0.95,1.15,32.4]
    iwall[1,*] = [0.95,0.70,4.19]
    iwall[2,*] = [0.95,0.49,-10.96]
    npa_mid = iwall*0.
    for i=0,2 do begin
        npa_mid[i,0] = iwall[i,0]*cos(!pi*(225+iwall[i,2])/180)
        npa_mid[i,1] = iwall[i,0]*sin(!pi*(225+iwall[i,2])/180)
        npa_mid[i,2] = iwall[i,1]
    endfor
    npa_mid *= 100
    ulos = npa_mid[*,0]
    vlos = npa_mid[*,1]
    wlos = npa_mid[*,2]
    uhead = npap[*,0]
    vhead = npap[*,1]
    whead = npap[*,2]
    nchan = n_elements(ulos)
    ra = replicate(0.5d0,nchan)
    rd = replicate(0.5d0,nchan)
    h = replicate(25.4d0,nchan)

    return, {uhead:uhead, vhead:vhead, whead:whead,$
             ulos:ulos, vlos:vlos, wlos:wlos,$
             ra:ra, rd:rd, h:h}

END

FUNCTION get_mainion_geom,shot,beam

    common bst_chord_param,chord_param
    beam = strlowcase(beam)
    CASE beam of
        '210rt': mchords = ['m09','m10','m11','m12','m13','m14','m15','m16']
        '30lt' : mchords = ['m01','m02','m03','m04','m05','m06','m07','m08']
        '330lt' : mchords = ['m17','m18','m19','m20']
        ELSE: return, {err:1}
    ENDCASE

    ulens = []
    vlens = []
    wlens = []
    ulos = []
    vlos = []
    wlos = []
    for i=0,n_elements(mchords)-1 do begin
        bst_chord_param,shot,mchords[i],beam
        ulens = [ulens,chord_param.geometry.lens[0]]
        vlens = [vlens,chord_param.geometry.lens[1]]
        wlens = [wlens,chord_param.geometry.lens[2]]
        ulos = [ulos,chord_param.geometry.location[0]]
        vlos = [vlos,chord_param.geometry.location[1]]
        wlos = [wlos,chord_param.geometry.location[2]]
    endfor

    return, {chords:mchords,ulens:ulens,vlens:vlens,wlens:wlens,$
             ulos:ulos,vlos:vlos,wlos:wlos,$
             ra:ulos*0,rd:ulos*0,h:ulos*0}
END

FUNCTION get_oblique_geom,shot

    chrds = oblique_spatial(shot)
    str_names=tag_names(chrds)
    umid=[]
    vmid=[]
    chords=[]
    for i=0,n_tags(chrds)-1 do begin
        if str_names[i] eq 'CALDATE' then continue
        umid=[umid,chrds.(i).fibers.x]
        vmid=[vmid,chrds.(i).fibers.y]
        chords=[chords,replicate(str_names[i],3)]
    endfor
    wmid=umid*0

    ulens=replicate(-46.02,n_elements(umid))
    vlens=replicate(-198.5,n_elements(umid))
    wlens=replicate(122.0,n_elements(umid))
    
    return, {chords:chords,ulens:ulens,vlens:vlens,$
             wlens:wlens,ulos:umid,vlos:vmid,wlos:wmid,$
             ra:umid*0,rd:umid*0,h:umid*0}

END

FUNCTION get_cer_geom,shot,isource,system=system

    if not keyword_set(system) then system = 'vertical'

    a=GET_CERGEOM(shot)
    b=GET_CER_BEAM_ORDER(shot)
    beams=['30LT','30RT','150LT','150RT','210LT','210RT','330LT','330RT']
    nchan=n_elements(a.labels)

    ulens = [] & ulos=ulens
    vlens = [] & vlos=vlens
    wlens = [] & wlos=wlens
    chords = []

    whb=where(b eq beams[isource])
    for i=0,nchan-1 do begin
        rl=a.rcers[i]*100.
        phil=a.phicers[i]
        rb=a.rcere[i,whb]*100.
        phib=a.phicere[i,whb]

        if phib le 360.0 then begin
            wlens = [wlens, a.zcers[i]*100.]
            ulens = [ulens, a.rcers[i]*COS((90. - a.phicers[i])*!DTOR)*100.]
            vlens = [vlens, a.rcers[i]*SIN((90. - a.phicers[i])*!DTOR)*100.]
            wlos = [wlos, a.zcere[i,whb]*100.]
            ulos = [ulos, a.rcere[i,whb]*COS((90 - a.phicere[i,whb])*!DTOR)*100.]
            vlos = [vlos, a.rcere[i,whb]*SIN((90 - a.phicere[i,whb])*!DTOR)*100.]
            chords = [chords, a.labels[i]]
        endif
    endfor

    CASE strlowcase(system) of
        'vertical': tmp=execute("w=where(strmid(chords,0,1) eq 'V',nw)")
        'tangential': tmp=execute("w=where(strmid(chords,0,1) eq 'T',nw)")
        'edge_tangential': BEGIN
        ;; Edge tangentials from 345R0
            edge_chords = ['TANG8','TANG23','TANG9','TANG24',$
                           'TANG10','TANG11','TANG12','TANG13',$
                           'TANG14','TANG15','TANG16']
            w=[]
            FOR i=0,N_ELEMENTS(edge_chords)-1 DO BEGIN
                w = [w,WHERE(STRCMP(edge_chords[i],chords))]
            ENDFOR
        END
        else: tmp=execute("w=where(strmid(chords,0,1) ne 'V',nw)")
    ENDCASE

    output={chords:chords[w], ulens:ulens[w], vlens:vlens[w], wlens:wlens[w], $
            ulos:ulos[w], vlos:vlos[w], wlos:wlos[w], ra:ulos[w]*0, rd:ulos[w]*0, h:ulos[w]*0}
    return,output
END

FUNCTION d3d_chords,shot,fida_diag,isource=isource

    if n_elements(isource) eq 0 then isource=6
    fida_diag=strupcase(fida_diag)
    ;; fida structure (15 == number of chords/channels)
    ;;** Structure <88d87f8>, 9 tags, length=800, data length=792, refs=1:
    ;;   SIGMA_PI_RATIO  DOUBLE          0.90000000 ;;COULD BE ARRAY
    ;;   NCHAN           LONG                15
    ;;   ULOS            DOUBLE    Array[15]
    ;;   VLOS            DOUBLE    Array[15]
    ;;   WLOS            DOUBLE    Array[15]
    ;;   ULENS           DOUBLE    Array[15]
    ;;   VLENS           DOUBLE    Array[15]
    ;;   WLENS           DOUBLE    Array[15]
    ;;   RA              FLOAT     Array[15]
    ;;   RD              FLOAT     Array[15]
    ;;   H               FLOAT     Array[15]

    ;; SELECT THE VIEWS
    for i=0,n_elements(fida_diag)-1 do begin
        CASE (fida_diag[i]) OF
            'VERTICAL': begin
                cer_chords = get_cer_geom(shot,isource,system='vertical')
                ulos = cer_chords.ulos
                vlos = cer_chords.vlos
                wlos = cer_chords.wlos
                uhead = cer_chords.ulens
                vhead = cer_chords.vlens
                whead = cer_chords.wlens
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
            end
            'OBLIQUE': begin
                oblique_chords=get_oblique_geom()
                ulos = oblique_chords.ulos
                vlos = oblique_chords.vlos
                wlos = oblique_chords.wlos
                uhead = oblique_chords.ulens
                vhead = oblique_chords.vlens
                whead = oblique_chords.wlens
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
            end
            'TANGENTIAL': begin
                cer_chords = get_cer_geom(shot,isource,system='tangential')
                ulos = cer_chords.ulos
                vlos = cer_chords.vlos
                wlos = cer_chords.wlos
                uhead = cer_chords.ulens
                vhead = cer_chords.vlens
                whead = cer_chords.wlens
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
            end
            'ET330': begin
                cer_chords = get_cer_geom(shot,isource,system='edge_tangential')
                ulos = cer_chords.ulos
                vlos = cer_chords.vlos
                wlos = cer_chords.wlos
                uhead = cer_chords.ulens
                vhead = cer_chords.vlens
                whead = cer_chords.wlens
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
            end
            'MAIN_ION30': begin
                main_chords = get_mainion_geom(shot,'30lt')
                ulos = main_chords.ulos
                vlos = main_chords.vlos
                wlos = main_chords.wlos
                uhead = main_chords.ulens
                vhead = main_chords.vlens
                whead = main_chords.wlens
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
            end
            'MAIN_ION210': begin
                main_chords = get_mainion_geom(shot,'210rt')
                ulos = main_chords.ulos
                vlos = main_chords.vlos
                wlos = main_chords.wlos
                uhead = main_chords.ulens
                vhead = main_chords.vlens
                whead = main_chords.wlens
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
            end
            'MAIN_ION330': begin
                main_chords = get_mainion_geom(shot,'330lt')
                ulos = main_chords.ulos
                vlos = main_chords.vlos
                wlos = main_chords.wlos
                uhead = main_chords.ulens
                vhead = main_chords.vlens
                whead = main_chords.wlens
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
            end
            'NPA': begin
                npa_chords = get_npa_geom()
                ulos = npa_chords.ulos
                vlos = npa_chords.vlos
                wlos = npa_chords.wlos
                uhead = npa_chords.uhead
                vhead = npa_chords.vhead
                whead = npa_chords.whead
                ra = npa_chords.ra
                rd = npa_chords.rd
                h = npa_chords.h
                nchan = n_elements(ulos)
                sigma_pi = replicate(1.d0,nchan)
                chan_id = replicate(1.d0,nchan)
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
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
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
                ra = replicate(0.d0,nchan)
                rd = replicate(0.d0,nchan)
                h = replicate(0.d0,nchan)
                chan_id = replicate(0.d0,nchan)
            end
            ELSE: begin
                PRINT, '% Diagnostic unknown'
                STOP
            end
        ENDCASE

        if i eq 0 then begin
            uloss=ulos & vloss=vlos & wloss=wlos
            uheads=uhead & vheads=vhead & wheads=whead
            nchans=nchan & sigma_pis=sigma_pi & ras=ra & rds=rd
            hs=h & chan_ids=chan_id
        endif else begin
            uloss=[uloss,ulos] & vloss=[vloss,vlos] & wloss=[wloss,wlos]
            uheads=[uheads,uhead] & vheads=[vheads,vhead] & wheads=[wheads,whead]
            nchans+=nchan & sigma_pis=[sigma_pis,sigma_pi] & ras=[ras,ra] & rds=[rds,rd]
            hs=[hs,h] & chan_ids=[chan_ids,chan_id]
        endelse
    endfor

    ;;SAVE IN FIDA STRUCTURE
    fida={nchan:nchans,diag:fida_diag,ulos:double(uloss),vlos:double(vloss),wlos:double(wloss),$
          ulens:double(uheads),vlens:double(vheads),wlens:double(wheads),$
          sigma_pi_ratio:sigma_pis,ra:ras,rd:rds,h:hs,chan_id:chan_ids}
    return,fida
END
