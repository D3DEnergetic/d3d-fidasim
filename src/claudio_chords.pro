function claudio_chords
    dir = file_dirname(source_file())
    c = read_csv(dir+'/claudio_geometry.csv',n_table_header=1)
    xmid = c.field1
    ymid = c.field2
    zmid = c.field3
    xlens = c.field4
    ylens = c.field5
    zlens = c.field6

    radius = sqrt(xmid^2 + ymid^2)
    nchan = n_elements(xmid)
    lens = dblarr(3,nchan)
    pos = dblarr(3,nchan)
    axis = dblarr(3,nchan)
    ids = strarr(nchan)
    suffix = ['c','b','a']
    cnt = 0
    for i=nchan-1,0,-1 do begin
        sid = i mod 3
        lens[*,i] = [xlens[i],ylens[i],zlens[i]]
        axis[*,i] = [xmid[i],ymid[i],zmid[i]] - lens[*,i]
        axis[*,i] = axis[*,i]/sqrt(total(axis[*,i]*axis[*,i]))
        ids[i] = 'p'+string(ceil(float(cnt+1)/3),FOR='(I02)')+suffix[cnt mod 3]
        cnt = cnt + 1
    end
    spot_size=replicate(2.0d0,nchan)
    sigma_pi = replicate(1.0d0,nchan)
    sid = sort(ids)
    chords = {system:'Claudio OBLIQUE',nchan:long(nchan),data_source:'claudio marini:claudio_geometry.csv',$
              id:ids[sid], sigma_pi:sigma_pi,radius:radius[sid],spot_size:spot_size,lens:lens[*,sid],axis:axis[*,sid]}

    return, chords
end
