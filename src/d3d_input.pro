FUNCTION nstx_inputs
    shot = 141648L
    time = 0.770d0
    comment = 'TEST shot'
    runid='141648.00770'

    transp_file = ''
    geqdsk_file = '/p/fida/lstagner/NSTX/g141648.00770'
    profile_dir = '/p/fida/lstagner/'
    dist_file = '/p/fida/lstagner/NSTX/141648E01_fi_3.cdf'
    dist_type = 'nubeam'
    result_dir = '/p/fida/lstagner/NSTX/'
    btipsign = -1.0
    spec_diag = ['OBLIQUE']
    npa_diag = ['']
    beam = '210rt'
    pinj = 1.98d0
    einj = 90.47d0
    
    inputs = vars_to_struct()
    return, inputs
END
