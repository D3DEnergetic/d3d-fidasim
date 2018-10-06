FUNCTION d3d_beams,bname
; Returns the nbi structure

    nb_30lt = {NLJCCW:1, NAME:'30LT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:114.6d0,XLBAPA:[186.1d0],$
               XLBTNA:802.8d0,XBZETA:44.2889d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_30rt = {NLJCCW:1, NAME:'30RT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:76.2d0,XLBAPA:[186.1d0],$
               XLBTNA:817.3d0,XBZETA:50.1602d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_15lta = {NLJCCW:1, NAME:'150LT_A', NBSHAP:1, $
                FOCLZ:1.0d33, FOCLR:1.0d33, $
                DIVZ:1.7453d-2, DIVR:8.727d-3, $
                BMWIDZ:6.d0,BMWIDR:5.d0 , $
                RTCENA:118.015d0,XLBAPA:[483.d0,632.407d0],$
                XLBTNA:846.124d0,XBZETA:284.1d0,$
                XYBAPA:2.9214d0,XYBSCA:18.1d0 , NLCO:1,$
                NBAPSHA:[1,1], RAPEDGA:[14.3350d0,50.d0],$
                XZPEDGA:[18.9835d0,50.d0],$
                XRAPOFFA:[2.11893d0,0.d0],$
                XZAPOFFA:[-2.47104d0,32.3975d0] }

    nb_15ltb = {NLJCCW:1, NAME:'150LT_B', NBSHAP:1, $
                FOCLZ:1.0d33, FOCLR:1.0d33, $
                DIVZ:1.7453d-2, DIVR:8.727d-3, $
                BMWIDZ:6.d0,BMWIDR:5.d0 , $
                RTCENA:118.015d0,XLBAPA:[483.d0,632.982d0],$
                XLBTNA:846.101d0,XBZETA:284.1d0,$
                XYBAPA:-1.02290d0,XYBSCA:6.10003d0 , NLCO:1,$
                NBAPSHA:[1,1], RAPEDGA:[14.3350d0,50.d0],$
                XZPEDGA:[18.9835d0,50.d0],$
                XRAPOFFA:[2.11893d0,0.d0],$
                XZAPOFFA:[1.52075d0,32.026d0] }

    nb_15ltc = {NLJCCW:1, NAME:'150LT_C', NBSHAP:1, $
                FOCLZ:1.0d33, FOCLR:1.0d33, $
                DIVZ:1.7453d-2, DIVR:8.727d-3, $
                BMWIDZ:6.d0,BMWIDR:5.d0 , $
                RTCENA:118.015d0,XLBAPA:[483.d0,632.407d0],$
                XLBTNA:846.016d0,XBZETA:284.1d0,$
                XYBAPA:-3.80738d0,XYBSCA:-5.89996d0 , NLCO:1,$
                NBAPSHA:[1,1], RAPEDGA:[14.3350d0,50.d0],$
                XZPEDGA:[18.9835d0,50.d0],$
                XRAPOFFA:[2.11893d0,0.d0],$
                XZAPOFFA:[4.24756d0,33.839d0] }

    nb_15ltd = {NLJCCW:1, NAME:'150LT_D', NBSHAP:1, $
                FOCLZ:1.0d33, FOCLR:1.0d33, $
                DIVZ:1.7453d-2, DIVR:8.727d-3, $
                BMWIDZ:6.d0,BMWIDR:5.d0 , $
                RTCENA:118.015d0,XLBAPA:[483.d0,633.284d0],$
                XLBTNA:846.093d0,XBZETA:284.1d0,$
                XYBAPA:-7.75138d0,XYBSCA:-17.9d0 , NLCO:1,$
                NBAPSHA:[1,1], RAPEDGA:[14.3350d0,50.d0],$
                XZPEDGA:[18.9835d0,50.d0],$
                XRAPOFFA:[2.11893d0,0.d0],$
                XZAPOFFA:[8.23764d0,35.2435d0] }

    nb_15rta = {NLJCCW:1, NAME:'150RT_A', NBSHAP:1, $
                FOCLZ:1.0d33, FOCLR:1.0d33, $
                DIVZ:2.27d-2, DIVR:8.73d-3, $
                BMWIDZ:6.d0,BMWIDR:5.d0 , $
                RTCENA:72.5919d0,XLBAPA:[483.d0,632.407d0],$
                XLBTNA:861.039d0,XBZETA:289.67d0,$
                XYBAPA:5.47964d0,XYBSCA:18.12d0 , NLCO:1,$
                NBAPSHA:[1,1], RAPEDGA:[14.3350d0,50.d0],$
                XZPEDGA:[18.9835d0,50.d0],$
                XRAPOFFA:[2.11893d0,0.d0],$
                XZAPOFFA:[-2.47104d0,32.3975d0] }

    nb_15rtb = {NLJCCW:1, NAME:'150RT_B', NBSHAP:1, $
                FOCLZ:1.0d33, FOCLR:1.0d33, $
                DIVZ:2.27d-2, DIVR:8.73d-3, $
                BMWIDZ:6.d0,BMWIDR:5.d0 , $
                RTCENA:72.5915d0,XLBAPA:[483.d0,632.982d0],$
                XLBTNA:860.985d0,XBZETA:289.67d0,$
                XYBAPA:1.48932d0,XYBSCA:6.12d0 , NLCO:1,$
                NBAPSHA:[1,1], RAPEDGA:[14.3350d0,50.d0],$
                XZPEDGA:[18.9835d0,50.d0],$
                XRAPOFFA:[2.11893d0,0.d0],$
                XZAPOFFA:[1.52075d0,34.0206d0] }

    nb_15rtc = {NLJCCW:1, NAME:'150RT_C', NBSHAP:1, $
                FOCLZ:1.0d33, FOCLR:1.0d33, $
                DIVZ:2.27d-2, DIVR:8.73d-3, $
                BMWIDZ:6.d0,BMWIDR:5.d0 , $
                RTCENA:72.5915d0,XLBAPA:[483.d0,632.903d0],$
                XLBTNA:860.985d0,XBZETA:289.67d0,$
                XYBAPA:-1.19915d0,XYBSCA:-5.87d0 , NLCO:1,$
                NBAPSHA:[1,1], RAPEDGA:[14.3350d0,50.d0],$
                XZPEDGA:[18.9835d0,50.d0],$
                XRAPOFFA:[2.11893d0,0.d0],$
                XZAPOFFA:[4.24756d0,33.839d0] }

    nb_15rtd = {NLJCCW:1, NAME:'150RT_D', NBSHAP:1, $
                FOCLZ:1.0d33, FOCLR:1.0d33, $
                DIVZ:2.27d-2, DIVR:8.73d-3, $
                BMWIDZ:6.d0,BMWIDR:5.d0 , $
                RTCENA:72.5919d0,XLBAPA:[483.d0,633.284d0],$
                XLBTNA:861.039d0,XBZETA:289.67d0,$
                XYBAPA:-5.22964d0,XYBSCA:-17.87d0 , NLCO:1,$
                NBAPSHA:[1,1], RAPEDGA:[14.3350d0,50.d0],$
                XZPEDGA:[18.9835d0,50.d0],$
                XRAPOFFA:[2.11893d0,0.d0],$
                XZAPOFFA:[8.23764d0,35.2435d0] }

    nb_21lt = {NLJCCW:1, NAME:'210LT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:76.2d0,XLBAPA:[186.1d0],$
               XLBTNA:817.3d0,XBZETA:249.84d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:-1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_21rt = {NLJCCW:1, NAME:'210RT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:114.6d0,XLBAPA:[186.1d0],$
               XLBTNA:802.8d0,XBZETA:255.711d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:-1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_33lt = {NLJCCW:1, NAME:'330LT', NBSHAP:1, $
               FOCLZ:1000.d0, FOCLR:1.0d33, $
               DIVZ:2.27d-2, DIVR:8.73d-3, $
               BMWIDZ:24.d0,BMWIDR:6.d0 , $
               RTCENA:114.6d0,XLBAPA:[186.1d0],$
               XLBTNA:802.8d0,XBZETA:104.289d0,$
               XYBAPA:0.d0,XYBSCA:0.d0 , NLCO:1,$
               NBAPSHA:[1], RAPEDGA:[8.85d0], XZPEDGA:[24.0d0],$
               XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_33rt = {NLJCCW:1, NAME:'330RT', NBSHAP:1, $
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
        '150lt_a': nbi = nubeam_geometry(nb_15lta)
        '150lt_b': nbi = nubeam_geometry(nb_15ltb)
        '150lt_c': nbi = nubeam_geometry(nb_15ltc)
        '150lt_d': nbi = nubeam_geometry(nb_15ltd)
        '150rt_a': nbi = nubeam_geometry(nb_15rta)
        '150rt_b': nbi = nubeam_geometry(nb_15rtb)
        '150rt_c': nbi = nubeam_geometry(nb_15rtc)
        '150rt_d': nbi = nubeam_geometry(nb_15rtd)
        '210lt': nbi = nubeam_geometry(nb_21lt)
        '210rt': nbi = nubeam_geometry(nb_21rt)
        '330lt': nbi = nubeam_geometry(nb_33lt)
        '330rt': nbi = nubeam_geometry(nb_33rt)
        ELSE: error,'No geometry for beam '+beam,/halt
    ENDCASE

    return,nbi
END
