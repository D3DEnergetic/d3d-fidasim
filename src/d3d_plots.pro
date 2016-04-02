PRO d3d_plots,inputs,inter_grid,beam_grid,nbi,chords,fida,equil,nbgeom,plasma,fbm

	g=equil.g

	ind=long(beam_grid.nz/2.0)
	!p.multi=0
	;;PLOTTING PLANE VIEW BEAMS AND CHORDS
	window,0 & wset,0
	loadct,39,/silent

	;;GET PROPER RANGES
	xmin=min(beam_grid.u_grid) & ymin=min(beam_grid.v_grid) & zmin=min(beam_grid.w_grid)
	xmax=max(beam_grid.u_grid) & ymax=max(beam_grid.v_grid) & zmax=max(beam_grid.w_grid)
	if xmin lt 0 then xmin1=1.2*xmin else xmin1=0.8*xmin
	if xmax lt 0 then xmax1=0.8*xmax else xmax1=1.2*xmax
	if ymin lt 0 then ymin1=1.2*ymin else ymin1=0.8*ymin
	if ymax lt 0 then ymax1=0.8*ymax else ymax1=1.2*ymax
	if zmin lt 0 then zmin1=1.2*zmin else zmin1=0.8*zmin
	if zmax lt 0 then zmax1=0.8*zmax else zmax1=1.2*zmax

	x_range=[xmin1,xmax1] & y_range=[ymin1,ymax1] & z_range=[zmin1,zmax1]

	plot,beam_grid.u_grid,beam_grid.v_grid,psym=3,color=0,background=255,$
          xrange=x_range,yrange=y_range,title='PLANE VIEW',xtitle='U [cm]',ytitle='V [cm]'

    los=fida.los
	for i=0,fida.nchan-1 do $
		oplot,chords.ulens[los[i]]+[0,2*(chords.ulos[los[i]]-chords.ulens[los[i]])],$
        chords.vlens[los[i]]+[0,2*(chords.vlos[los[i]]-chords.vlens[los[i]])],$
        color=50

	src=nbi.uvw_src
	pos=(nbi.uvw_pos-nbi.uvw_src)*1000+nbi.uvw_src
	oplot,[src[0],pos[0]],[src[1],pos[1]],thick=2,color=230

	w=where(g.bdry[0,*] gt 0.)
	rmin=.9*100.*min(g.bdry[0,w]) & rmax=1.1*100.*max(g.bdry[0,w])
	rmaxis=100.*g.rmaxis
	phi=2.*!pi*findgen(501)/500.
	oplot,rmin*cos(phi),rmin*sin(phi),color=150
	oplot,rmaxis*cos(phi),rmaxis*sin(phi),color=150,linestyle=2
	oplot,rmax*cos(phi),rmax*sin(phi),color=150

	;----------------------------------------------
	;;PLOT CROSS SECTION BEAM AND CHORDS
	window,1 & wset,1
	plot,[0],[0],/nodata,xrange=[rmin,rmax], $
            yrange=100.*[-1.1,1.1],$
			color=0,background=255,title='ELEVATION',xtitle='R [cm]',ytitle='Z [cm]'

	oplot,inter_grid.r2d,inter_grid.w2d,psym=3,color=0
    oplot,beam_grid.r_grid,beam_grid.w_grid,psym=3,color=0

	; Lines of sight
	for i=0,fida.nchan-1 do begin
		if chords.wlos[los[i]] ne chords.wlens[los[i]] then begin
			z=(chords.wlos[los[i]]-chords.wlens[los[i]])*findgen(201)/100.+chords.wlens[los[i]]
			x=(chords.ulos[los[i]]-chords.ulens[los[i]])*(z-chords.wlens[los[i]])/ $
			  (chords.wlos[los[i]]-chords.wlens[los[i]]) + chords.ulens[los[i]]
			y=(chords.vlos[los[i]]-chords.vlens[los[i]])*(z-chords.wlens[los[i]])/ $
			  (chords.wlos[los[i]]-chords.wlens[los[i]]) + chords.vlens[los[i]]
			oplot,sqrt(x^2+y^2),z,color=50
		endif else begin
    		y=(chords.vlos[los[i]]-chords.vlens[los[i]])*findgen(201)/100.+chords.vlens[los[i]]
    		x=(chords.ulos[los[i]]-chords.ulens[los[i]])*(y-chords.vlens[los[i]])/ $
      		  (chords.vlos[los[i]]-chords.vlens[los[i]]) + chords.ulens[los[i]]
		    oplot,sqrt(x^2+y^2),replicate(chords.wlens[los[i]],201),color=50
		endelse
	endfor

	; Equilibrium
	oplot,100.*g.bdry[0,*],100.*g.bdry[1,*],color=150
	oplot,100.*g.lim[0,*],100.*g.lim[1,*],color=0

  	!p.multi=0

END
