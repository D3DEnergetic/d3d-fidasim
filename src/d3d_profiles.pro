;;RESTORES PROFILES FROM GAPROFILES SAVE FILES LOCATED IN INPUTS.PROFILE_DIR DIRECTORY
FUNCTION d3d_profiles,inputs,inter_grid,equil,save=save

    ;; profiles structure
    ;;** Structure <83e8518>, 7 tags, length=5768, data length=5764, refs=1:
    ;;   RHO             DOUBLE    Array[120]
    ;;   TI              DOUBLE    Array[120] [eV]
    ;;   VTOR            DOUBLE    Array[120] [rad/s]
    ;;   TE              DOUBLE    Array[120] [eV]
    ;;   DENE            DOUBLE    Array[120] [m^-3]
    ;;   ZEFF            DOUBLE    Array[120]


	;;CREATE FILENAMES
	time_str='00000'+strtrim(string(long(round(inputs.time*1000))),1)
	time_str=strmid(time_str,4,/reverse_offset)
	shot_str=strtrim(string(inputs.shot),1)
	profile_str=shot_str+'.'+time_str

	dir = inputs.profile_dir
    ;; Look for electron density in this directory
    test = FILE_SEARCH(STRJOIN([dir,'dne*']))
    ;; if we don't find it, then look in the shot sub-directory
    if test[0] eq '' THEN dir = STRJOIN([dir,shot_str])+'/'

	ne_string=dir+'dne'+profile_str
	te_string=dir+'dte'+profile_str
	ti_string=dir+'dti'+profile_str
	imp_string=dir+'dimp'+profile_str+'_Carbon'
	omega_string=dir+'dtrot'+profile_str

	;;CHECK IF FILES EXIST
	file_array=[ne_string,te_string,ti_string,imp_string,omega_string]
	err_array=dblarr(n_elements(file_array))
	for i=0,n_elements(file_array)-1 do begin
		if file_test(file_array[i]) eq 0 then begin
			print,file_array[i]+' does not exist: Exiting'
			err_array[i]=1
		endif
	endfor
	w=where(err_array eq 1 ,nw)
	if nw ne 0 then begin
		print,'FATAL ERROR'
		profiles={err:1}
	endif else begin
		;;RESTORE DENSITY
		restore,ne_string
		dene=ne_str.dens*10.0d^(13.0d) ;;cm^-3
		dene_rho=ne_str.rho_dens

		;;RESTORE ELECTRON TEMPERATURE
		restore,te_string
		te=te_str.te ;;keV
		te_rho=te_str.rho_te

		;;RESTORE ION TEMPERATURE
		restore,ti_string
		ti=ti_str.ti ;;keV
		ti_rho=ti_str.rho_ti

		;;RESTORE ZEFF
		restore,imp_string
		zeff=impdens_str.zeff
		zeff_rho=impdens_str.rho_imp

		;;RESTORE OMEGA
		restore,omega_string
		omega=tor_rot_str.tor_rot_local ;rad/s
		omega_rho=tor_rot_str.rho_tor_rot

		;;INTERPOLATE SO THAT ALL USE THE SAME RHO
		maxrho=min([dene_rho[-1],te_rho[-1],ti_rho[-1],zeff_rho[-1],omega_rho[-1]])

		dene=interpol(dene,dene_rho,equil.flux) > 0.0
		te=interpol(te,te_rho,equil.flux) > 0.0
		ti=interpol(ti,ti_rho,equil.flux) > 0.0
		zeff=interpol(zeff,zeff_rho,equil.flux) > 1.0
		vt=inter_grid.r2d*interpol(omega,omega_rho,equil.flux)
        vr = replicate(0.0,inter_grid.nr,inter_grid.nw)
        vw = replicate(0.0,inter_grid.nr,inter_grid.nw)

		;;SAVE IN PROFILE STRUCTURE
		profiles={max_flux:maxrho,te:te,ti:ti,vr:vr,vt:vt,vw:vw,dene:dene,zeff:zeff,err:0}
	endelse
	
	if keyword_set(save) then save,profiles,filename=inputs.runid+'_profiles.sav'
	return,profiles
END
