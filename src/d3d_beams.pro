FUNCTION d3d_beams,bname
; Returns the nbi structure

    bnames = ['30lt','30rt','150lt','150rt','210lt','210rt','330lt','330rt']
    isource = where(strmatch(bnames,bname,/fold_case) eq 1,nw)
    if nw eq 0 then error, 'Unknown beam: '+bname,/halt
    
	;; Here are the TRANSP numbers
	;; This places the aperture as actually located, and the source is
	;; then "xedge" cm further away from the vessel.
	;;     30LT     30RT 150LT 150RT 210LT     210RT     330LT 330RT
	us_NB=[430.24933, 393.89442, $
	       180.16372, 235.25667, $
	       -235.25671, -180.16376, $
	       -180.16373, -235.25668]
	vs_NB=[456.44009, 499.06619,$
	       -600.82700, -590.65572,$
	       -590.65570, -600.82699,$
	       600.82700, 590.65572]


	; Cross-over points [30,30,150,150,210,210,330,330] measured by CER group
	u_co=[129.2599,129.2599, 142.2877, 142.2877, -141.09, -141.09,-139.4861,-139.4861]
	v_co=[239.3489,239.3489,-232.1300,-232.1300, -230.40, -230.40, 233.7739, 233.7739]

	;; 30LT is closer to the beamers' description, not original CER Grierson.
	u_co[0]=132.334 & u_co[1]=u_co[0]
	v_co[0]=238.76 & v_co[1]=v_co[0]
	nsources=n_elements(vs_NB)

	uvw_src=[[double(us_NB)],[double(vs_NB)],[replicate(0.0d,nsources)]]
        ;; Location of the crossover in machine coordinates
	uvw_pos=[[double(u_co)],[double(v_co)],[replicate(0.0d,nsources)]]

    axis = uvw_pos - uvw_src
;	focy=replicate(1d33,nsources)      ; horizontal focal length
;	(infinity)
    focy=999999.9d0 ; so f90 can read input 
	focz=1000d0     ; vertical focal length is 10 m
	divy=replicate(8.73d-3,3)    ; horizontal divergence in radians
	divz=replicate(2.27d-2,3)

	bmwidra=6d0     ; ion source half width in cm
	bmwidza=24d0    ; ion source half height in cm
    ;a=get_beam_power(inputs.shot,inputs.time*1000.,inputs.isource)
	
    ;;SAVE IN NBI STRUCTURE
    cur_axis = reform(axis[isource,*])
    cur_axis = cur_axis/sqrt(total(cur_axis^2.0))

    nbi={shape:1,data_source:source_file(),name:bname,$
         divy:divy,divz:divz,focy:focy,focz:focz,$
         src:reform(uvw_src[isource,*]),axis:cur_axis,widy:bmwidra,widz:bmwidza}

    return,nbi
END
