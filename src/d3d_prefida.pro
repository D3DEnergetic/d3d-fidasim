PRO d3d_prefida, inputs, igrid=igrid,bgrid=bgrid

   profile_dir = file_dirname(source_file())
   fida_dir = get_fidasim_dir()

   basic_inputs = {device:'D3D',$
                   ab:2.01410178d0,ai:2.0141078d0,impurity_charge:6,$
                   lambdamin:647.0d0,lambdamax:667.0d0,nlambda:2000,$
                   n_fida:5000000L,n_npa:500000L,n_nbi:50000L, $
                   n_pfida:50000000L,n_pnpa:50000000L, $
                   n_halo:500000L,n_dcx:500000L,n_birth:10000L,$
                   ne_wght:50,np_wght:50,nphi_wght:100,emax_wght:100.0d0,$
                   nlambda_wght:1000,lambdamin_wght:647.d0,lambdamax_wght:667.d0,$
                   calc_npa:0,calc_brems:0,calc_fida:0,calc_neutron:0,$
                   calc_nbi:0,calc_dcx:0,calc_halo:0,calc_cold:0,$
                   calc_birth:0,calc_fida_wght:0,calc_npa_wght:0,calc_pfida:0,calc_pnpa:0,$
                   install_dir:fida_dir,tables_file:fida_dir+'/tables/atomic_tables.h5'}

    if not keyword_set(igrid) then begin
        igrid = rz_grid(100.0,240.d0,70,-100.d0,100.d0,100)
    endif

    if not keyword_set(bgrid) then begin
        nbi = d3d_beams(inputs.beam)
        bgrid = beam_grid(nbi,240.d0)
    endif

    cfracs = d3d_cfracs(inputs.einj)
    inputs = create_struct(inputs,basic_inputs,bgrid,"current_fractions",cfracs)

    w = where("spec_diag" eq strlowcase(TAG_NAMES(inputs)), nw)
    if nw ne 0 then begin
        c = inputs.spec_diag
        for i=0,n_elements(c)-1 do begin
            spec = d3d_chords(c[i], shot=inputs.shot)
            inputs.calc_fida = 1
            inputs.calc_nbi = 1
            inputs.calc_brems = 1
            inputs.calc_halo = 1
            inputs.calc_dcx = 1
        endfor
    endif

    w = where("npa_diag" eq strlowcase(TAG_NAMES(inputs)),nw)
    if nw ne 0 then begin
        if n_elements(inputs.npa_diag) ne 0 then begin
            if inputs.npa_diag eq 'ssnpa' then begin
                npa = d3d_npa()
                inputs.calc_npa = 1
            endif
            if inputs.npa_diag eq 'inpa' then begin
                npa = d3d_inpa()
                inputs.calc_npa = 2
            endif
        endif
    endif

    fields = read_geqdsk(inputs.geqdsk_file,igrid,flux=flux,g=g,btipsign=btipsign)
    plasma = extract_transp_plasma(inputs.transp_file,inputs.time,igrid,flux,profiles=prof)

    case strlowcase(inputs.dist_type) of
        'nubeam': dist = read_nubeam(inputs.dist_file,igrid,btipsign=btipsign,$
                  e_range=inputs.e_range, p_range=inputs.p_range)
        'mc_nubeam': dist=read_mc_nubeam(inputs.dist_file,btipsign=btipsign,$
                     ntotal=inputs.ntotal,e_range=inputs.e_range,p_range=inputs.p_range)
        'spiral': dist = read_spiral(inputs.dist_file,btipsign=btipsign,ntotal=inputs.ntotal)
    endcase

    prefida,inputs,igrid,nbi,plasma,fields,dist,spec=spec,npa=npa

END
