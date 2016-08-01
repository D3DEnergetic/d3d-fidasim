FUNCTION d3d_inputs

shot = 159243
time = 0.519d0 ;seconds
pinj =  1.702d0     ;; Beam Power [MW]
einj = 70.811d0     ;; Beam Energy [keV]
transp_file = '/p/fida/lstagner/SOURCESINK/dists/159243/159243H05.CDF'
geqdsk_file = '/p/fida/lstagner/SOURCESINK/dists/159243/g159243.00519'
dist_file = '/p/fida/lstagner/SOURCESINK/dists/159243/159243H05_fi_1.cdf'
dist_type = 'nubeam'
e_range = [5.0, 100.0]
p_range = [-1.0, 1.0]
btipsign = -1.0
spec_diag = {oblique:'forward2012'}
npa_diag = {ssnpa:'forward2012'}
beam = '210rt'
runid = '518'
result_dir = '/p/fida/lstagner/SOURCESINK/159243L02'
comment = 'example FIDASIM run'

inputs = vars_to_struct()

return, inputs

END
