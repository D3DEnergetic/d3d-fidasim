function claudio_geometry
    dir = file_dirname(source_file())
    c = read_csv(dir+'/claudio_geometry.csv',n_table_header=1)
    fiber = c.field1
    xlens = c.field2
    ylens = c.field3
    zlens = c.field4
    xmid = c.field5
    ymid = c.field6
    zmid = c.field7
    radius = sqrt(xmid^2 + ymid^2)
    nchan = n_elements(xmid)
    lens = dblarr(3,nchan)
    pos = dblarr(3,nchan)
    axis = dblarr(3,nchan)
    ids = strarr(nchan)
    suffix = ['a','b','c']
    cnt = 0
    for i=0,nchan-1 do begin
        sid = i mod 3
        lens[*,i] = [xlens[i],ylens[i],zlens[i]]
        axis[*,i] = [xmid[i],ymid[i],zmid[i]] - lens[*,i]
        axis[*,i] = axis[*,i]/sqrt(total(axis[*,i]*axis[*,i]))
        ids[i] = 'p'+string(ceil(float(i+1)/3),FOR='(I02)')+suffix[sid]
    end
    spot_size=replicate(2.0d0,nchan)
    sigma_pi = replicate(1.0d0,nchan)
    chords = {system:'Claudio OBLIQUE',nchan:long(nchan),data_source:'claudio marini:claudio_geometry.csv',$
              id:ids, sigma_pi:sigma_pi,radius:radius,spot_size:spot_size,lens:lens,axis:axis}
    return, chords
end
