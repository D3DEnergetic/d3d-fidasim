;;RESTORES PROFILES FROM GAPROFILES SAVE FILES LOCATED IN INPUTS.PROFILE_DIR DIRECTORY
FUNCTION d3d_profiles,inputs,igrid,flux,save=save

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
    	    print,file_array[i]+' does not exist'
    	    err_array[i]=1
    	endif
    endfor
    w=where(err_array eq 1 ,nw)
    if nw ne 0 then begin
    	error, 'Missing profiles',/halt
    	profiles={err:1}
    endif else begin
    	;;RESTORE DENSITY
    	restore,ne_string
    	dene=ne_str.dens*10.0d^(13.0d) ;;cm^-3
    	dene_rho=ne_str.rho_dens
    
    	;;RESTORE ELECTRON TEMPERATURE
    	restore,te_string
    	te=double(te_str.te) ;;keV
    	te_rho=te_str.rho_te
    
    	;;RESTORE ION TEMPERATURE
    	restore,ti_string
    	ti=double(ti_str.ti) ;;keV
    	ti_rho=ti_str.rho_ti
    
    	;;RESTORE ZEFF
    	restore,imp_string
    	zeff=double(impdens_str.zeff)
    	zeff_rho=impdens_str.rho_imp
    
    	;;RESTORE OMEGA
    	restore,omega_string
    	omega=double(tor_rot_str.tor_rot_local) ;rad/s
    	omega_rho=tor_rot_str.rho_tor_rot
    
    	;;INTERPOLATE SO THAT ALL USE THE SAME RHO
    	maxrho=min([dene_rho[-1],te_rho[-1],ti_rho[-1],zeff_rho[-1],omega_rho[-1]])

    	dene=interpol(dene,dene_rho,flux) > 0.0d0
    	te=interpol(te,te_rho,flux) > 0.0d0
    	ti=interpol(ti,ti_rho,flux) > 0.0d0
    	zeff=interpol(zeff,zeff_rho,flux) > 1.0d0
    	vt=igrid.r2d*interpol(omega,omega_rho,flux)
        vr = replicate(0.0d0,igrid.nr,igrid.nz)
        vz = replicate(0.0d0,igrid.nr,igrid.nz)
        
        s = size(flux,/dim)
        mask = intarr(s[0],s[1])
        w = where(flux le maxrho)
        mask[w] = 1

	;;SAVE IN PLASMA STRUCTURE
        plasma={data_source:strjoin(file_array,','), time:inputs.time, $
                mask:mask,te:te,ti:ti,vr:vr,vt:vt,vz:vz,dene:dene,zeff:zeff}
    endelse
	
    return, plasma
END
