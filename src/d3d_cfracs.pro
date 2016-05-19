FUNCTION d3d_cfracs,einj

    ;;GET SPECIES_MIX
    cgfitf=[-0.109171,0.0144685,-7.83224e-5]
    cgfith=[0.0841037,0.00255160,-7.42683e-8]
    ;; Current fractions
    ffracs=cgfitf[0]+cgfitf[1]*einj+cgfitf[2]*einj^2
    hfracs=cgfith[0]+cgfith[1]*einj+cgfith[2]*einj^2
    tfracs=1.0-ffracs-hfracs

    return, double([ffracs,hfracs,tfracs])
END
