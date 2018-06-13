FUNCTION d3d_beams,bname
; Returns the nbi structure

    nb_30lt = {NAME:'30LT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:114.6d0,XLBAPA:[186.1d0],$
               XLBTNA:802.8d0,XBZETA:44.2889d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_30rt = {NAME:'30RT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:76.2d0,XLBAPA:[186.1d0],$
               XLBTNA:817.3d0,XBZETA:50.1602d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_21lt = {NAME:'210LT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:76.2d0,XLBAPA:[186.1d0],$
               XLBTNA:817.3d0,XBZETA:249.84d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:-1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_21rt = {NAME:'210RT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:114.6d0,XLBAPA:[186.1d0],$
               XLBTNA:802.8d0,XBZETA:255.711d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:-1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_33lt = {NAME:'330LT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:114.6d0,XLBAPA:[186.1d0],$
               XLBTNA:802.8d0,XBZETA:104.289d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_33rt = {NAME:'330RT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:76.2d0,XLBAPA:[186.1d0],$
               XLBTNA:874.3d0,XBZETA:110.16d0,$
               XYBAPA:0.d0,XYBSCA:0.d0, NLCO:1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    CASE strlowcase(bname) OF
        '30lt': nbi = nubeam_geometry(nb_30lt)
        '30rt': nbi = nubeam_geometry(nb_30rt)
        '210lt': nbi = nubeam_geometry(nb_21lt)
        '210rt': nbi = nubeam_geometry(nb_21rt)
        '330lt': nbi = nubeam_geometry(nb_33lt)
        '330rt': nbi = nubeam_geometry(nb_33rt)
        ELSE: error,'No geometry for beam '+beam,/halt
    ENDCASE

    return,nbi
END
