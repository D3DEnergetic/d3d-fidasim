FUNCTION d3d_cfracs,einj
    ;; Polynomial Fit of Current Fractions
    ;;
    ;; Determination of neutral beam energy fractions from collisional radiative measurements on DIII-D
    ;; Review of Scientific Instruments 83, 10D518 (2012) https://doi.org/10.1063/1.4733614

    eb = double(einj) ;; needed to prevent overflow

    if einj lt 20.0 or einj gt 100.0 then begin
        error,'Injection Energy out of range: [20-100] keV',/halt
    endif

    ;; Old Current Fractions fit for energies between [45-85] keV
    ;; ;;GET SPECIES_MIX
    ;; cgfitf=[-0.109171,0.0144685,-7.83224e-5]
    ;; cgfith=[0.0841037,0.00255160,-7.42683e-8]
    ;; ;; Current fractions
    ;; ffracs=cgfitf[0]+cgfitf[1]*einj+cgfitf[2]*einj^2
    ;; hfracs=cgfith[0]+cgfith[1]*einj+cgfith[2]*einj^2
    ;; tfracs=1.0-ffracs-hfracs

    ;; einj^3, einj^2, einj^1, const
    cf = [ -9.16835654e-07,  9.68639427e-05,  3.63012766e-03,  1.07626578e-01]
    ch = [ -3.57007225e-07,  6.40347899e-05, -1.16506088e-03,  1.54026159e-01]
    ct = [  1.27384288e-06, -1.60898733e-04, -2.46506677e-03,  7.38347263e-01]

    ffracs = cf[0]*(eb^3) + cf[1]*(eb^2) + cf[2]*eb + cf[3]
    hfracs = ch[0]*(eb^3) + ch[1]*(eb^2) + ch[2]*eb + ch[3]
    ;;tfracs = ct[0]*eb^3 + ct[1]*eb^2 + ct[2]*eb + ct[3]
    tfracs = 1.0 - ffracs - hfracs

    return, double([ffracs,hfracs,tfracs])
END
