
FUNCTION inpa_geometry

  ;; lower phosphor
  lphor = [ $
  [-2216.0125898,664.0300435,-752.7063991], $
  [-2231.8362094,587.3225107,-770.4562785], $
  [-2196.3541534,591.1636874,-818.6876902], $
  [-2180.5305338,667.8712202,-800.9378107]]

  ;; upper phosphor
  uphor = [ $
  [-2260.4624551,659.4353424,-738.4681449], $
  [-2274.3157469,592.2792896,-754.0078423], $
  [-2241.9685667,586.9779584,-759.9344985], $
  [-2228.1152749,654.1340112,-744.3948012]]

  ;; 3mm*3mm pinhole, rectangular
  pinhole = [ $
  [-2175.937,708.141,-715.473], $
  [-2174.423,705.719,-714.552], $
  [-2172.649,705.912,-716.964], $
  [-2174.163,708.333,-717.884]]

  ;; stripping foil
  foil = FLTARR(7,3,4)

  foil[0,*,*] = [ $
  [ -2211.060,703.109,-740.469], $
  [ -2212.499,696.136,-742.082], $
  [ -2209.542,696.456,-746.101], $
  [ -2208.104,703.429,-744.488]]

  foil[1,*,*] = [ $
  [-2213.032,693.550,-742.680], $
  [-2214.471,686.577,-744.294], $
  [-2211.514,686.897,-748.313], $
  [-2210.075,693.870,-746.700]]

  foil[2,*,*] = [ $
  [-2215.004,683.991,-744.892], $
  [-2216.442,677.018,-746.506], $
  [-2213.486,677.338,-750.525], $
  [-2212.047,684.311,-748.912]]

  foil[3,*,*] = [ $
  [-2216.976,674.432,-747.104], $
  [-2218.414,667.460,-748.718], $
  [-2215.457,667.780,-752.737], $
  [-2214.019,674.752,-751.124]]

  foil[4,*,*] = [ $
  [-2218.948,664.873,-749.316], $
  [-2220.386,657.901,-750.930], $
  [-2217.429,658.221,-754.949], $
  [-2215.991,665.193,-753.335]]

  foil[5,*,*] = [ $
  [-2220.920,655.315,-751.528], $
  [-2222.358,648.342,-753.141], $
  [-2219.401,648.662,-757.161], $
  [-2217.963,655.635,-755.547]]

  foil[6,*,*] = [ $
  [-2222.891,645.756,-753.740], $
  [-2224.330,638.783,-755.353], $
  [-2221.373,639.103,-759.373], $
  [-2219.935,646.076,-757.759]]

  nchan=(SIZE(foil,/DIMENSIONS))[0]
  a_cent=DBLARR(3,nchan)
  a_redge=DBLARR(3,nchan)
  a_tedge=DBLARR(3,nchan)
  d_cent=DBLARR(3,nchan)
  d_redge=DBLARR(3,nchan)
  d_tedge=DBLARR(3,nchan)
  radius=DBLARR(nchan)
  FOR i=0,nchan-1 DO BEGIN
     a_cent[*,i]=MEAN(pinhole,DIMENSION=2)
     a_redge[*,i]=MEAN([[pinhole[*,0]],[pinhole[*,3]]],DIMENSION=2)
     a_tedge[*,i]=MEAN(pinhole[*,0:1],DIMENSION=2)
     d_cent[*,i]=MEAN(foil[i,*,*],DIMENSION=3)
     d_redge[*,i]=MEAN([[REFORM(foil[i,*,0])],[REFORM(foil[i,*,3])]],DIMENSION=2)
     d_tedge[*,i]=MEAN(foil[i,*,0:1],DIMENSION=3)

     dis=a_cent[*,i]-d_cent[*,i]
     axi=dis/SQRT(TOTAL(dis^2))
     ds=-a_cent[2]/axi[2]
     xy=a_cent[0:1]+axi[0:1]*ds
     radius[i]=SQRT(TOTAL(xy^2))
  ENDFOR

  inpa={nchan:nchan, $
        system:'INPA', $
        data_source:'inpa_geometry', $
        id:STRTRIM(INDGEN(7)+1,2), $
        radius:radius/10., $
        a_shape:INTARR(7)+2, $
        d_shape:INTARR(7)+1, $
        a_cent:a_cent/10., $
        a_redge:a_redge/10., $
        a_tedge:a_tedge/10., $
        d_cent:d_cent/10., $
        d_redge:d_redge/10., $
        d_tedge:d_tedge/10. $
       }

  RETURN,inpa

END
