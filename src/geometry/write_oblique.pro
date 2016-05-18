FUNCTION oblique_geo_from_patch(patchfile,skip=skip)

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
        f = patchdat.(i).fibers
        for j=0,n_elements(f.fibers)-1 do begin
            fnum = f.fibers[j]
            nchan = nchan + 1
            lens = [[lens],[-46.02d0,-198.5d0,122.d0]]
            pos = double([f.x[j], f.y[j], 0.d0])
            a = pos - [-46.02d0,-198.5d0,122.d0]
            a = double(a/sqrt(total(a*a)))
            axis = [[axis],[a]]
            radius = [ radius, double(f.r[j])]
            id = [id, 'p'+strcompress(string(ceil(float(fnum)/3)),/remove_all)+suffix[fnum mod 3 -1]]
            spot_size = [spot_size,2.d0]
            sigma_pi = [sigma_pi,1.d0]
        endfor
    endfor

    chords = {system:'oblique',nchan:long(nchan),data_source:patchfile,lens:lens,axis:axis, $
              id:id, sigma_pi:sigma_pi,radius:radius,spot_size:spot_size}

END

PRO write_oblique

    ;forward2012
    f2012 = '/e/alfven/fida/calib/patch/forward2012/PATCH12.dat'
    forward2012 = oblique_geo_from_patch(f2012)

    ;forward2015
    f2015 = '/e/alfven/fida/calib/patch/forward2015/PATCH13.dat'
    forward2015 = oblique_geo_from_patch(f2015,skip = ['f05','f06','f08'])

    oblique = {forward2015:forward2015,forward2012:forward2012}
    chords = {oblique:oblique}

    write_hdf5,chords,filename = 'd3d_chords.h5',/clobber
END
