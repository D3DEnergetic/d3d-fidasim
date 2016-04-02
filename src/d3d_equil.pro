FUNCTION d3d_equil,inputs,grid

	equil={err:1}
	;; Get eqdsk
    time_str='00000'+strtrim(string(long(round(inputs.time*1000))),1)
    time_str=strmid(time_str,4,/reverse_offset)
    shot_str=strtrim(string(inputs.shot),1)
    profile_str=shot_str+'.'+time_str

    gfile=inputs.profile_dir+'/g'+profile_str
	gfiletest=findfile(gfile)
    ;; if equilbrium not in profile directory then look in a shot dir
    if gfiletest eq '' then begin
        gfile=inputs.profile_dir+'/'+shot_str+'/g'+profile_str
        gfiletest=findfile(gfile)
    endif

	if gfiletest ne '' then begin
		print,'Restoring equilbrium from gfile: ',gfile
        if file_test(gfile,/EXECUTABLE)	then begin
       	    restore,gfile
       	endif else g=readg(gfile)
	endif else begin
		print,'Fetching equilbrium from MDS+'
		g=readg(inputs.shot,inputs.time*1000,RUNID=inputs.equil,status=gerr)
		if gerr ne 1 then begin
			print,'readg failed'
			equil={err:1}
			goto,GET_OUT
		endif
	endelse

    rhogrid=rho_rz(g,grid.r2d/100.,grid.w2d/100.,/do_linear)

	calculate_bfield,bp,br,bphi,bz1,g
;	help,bp,br,bphi,bz1
	;; Get radial electric field on efit's grid from potential
	;; epoten is on a grid of equally spaced points in psi from g.ssimag to g.ssibry
	dpsi=(g.ssibry-g.ssimag)/(n_elements(g.epoten)-1)
	psi=g.ssimag + dpsi*findgen(n_elements(g.epoten))
	npot=n_elements(g.epoten)
	epot=replicate(g.epoten[npot-1],n_elements(g.r),n_elements(g.z))
	for i=0l,n_elements(g.r)-1 do begin
		for j=0l,n_elements(g.z)-1 do begin
			psi1=g.psirz[i,j]
			dum=min(abs(psi1-psi),kpsi)
			if kpsi ne npot-1 then epot[i,j]=spline(psi,g.epoten,[psi1])
		endfor
	endfor
	; E = - grad(Phi)    EFIT units should be V/m
	er=-(shift(epot,-1,0) - shift(epot,1,0))/(g.r[2]-g.r[0])
	ez1=-(shift(epot,0,-1) - shift(epot,0,1))/(g.z[2]-g.z[0])

	;; Interpolate cylindrical fields onto (r,w) mesh
	b_r=dblarr(grid.nr,grid.nw) & b_t=b_r & b_w=b_r
	e_r=dblarr(grid.nr,grid.nw) & e_t=e_r & e_w=e_r

	for i=0L,grid.nr-1 do for j=0L,grid.nw-1 do begin
		rgrid=(.01*grid.r2d[i,j] - g.r[0])/(g.r[1]-g.r[0]) ; in grid units
		zgrid=(.01*grid.w2d[i,j] - g.z[0])/(g.z[1]-g.z[0])    ; WWH 3/31/07
		b_r[i,j]  =interpolate(br,[rgrid],[zgrid])
		e_r[i,j]  =interpolate(er,[rgrid],[zgrid])
		b_t[i,j]=interpolate(bphi,[rgrid],[zgrid])
		e_w[i,j]  =interpolate(ez1,[rgrid],[zgrid])
		b_w[i,j]  =interpolate(bz1,[rgrid],[zgrid])
	endfor

	equil={g:g,flux:rhogrid,br:b_r,bt:b_t,bw:b_w,er:e_r,et:e_t,ew:e_w,err:0}
	GET_OUT:
	return,equil
END
