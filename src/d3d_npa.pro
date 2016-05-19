FUNCTION d3d_npa
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

    a_cent = dblarr(3,3)
    a_redge = dblarr(3,3)
    a_tedge = dblarr(3,3)
    d_cent = dblarr(3,3)
    d_redge = dblarr(3,3)
    d_tedge = dblarr(3,3)
    
    for i=0,2 do begin
        r0 = reform(npap[i,*])
        v0 = reform(npa_mid[i,*]) - r0
        v0 = v0/sqrt(total(v0*v0))
        basis = line_basis(r0,v0)
        a_cent[*,i] = basis##[0.0, 0.0, 0.0] + r0
        a_redge[*,i] = basis##[0.0, 0.5, 0.0] + r0
        a_tedge[*,i] = basis##[0.0, 0.0, 0.5] + r0
        d_cent[*,i] = basis##[-25.4, 0.0, 0.0] + r0
        d_redge[*,i] = basis##[-25.4, 0.5, 0.0] + r0
        d_tedge[*,i] = basis##[-25.4, 0.0, 0.5] + r0
    endfor
    nchan = 3L
    system = 'ssNPA'
    id = ['npa1','npa2','npa3']
    radius = iwall[*,0]*100.d0
    a_shape = replicate(2,nchan)
    d_shape = replicate(2,nchan)
    return, {nchan:nchan,system:system,data_source:source_file(),$
             id:id, radius:radius,a_shape:a_shape,d_shape:d_shape,$
             d_cent:d_cent,d_redge:d_redge,d_tedge:d_tedge, $
             a_cent:a_cent,a_redge:a_redge,a_tedge:a_tedge}

END
