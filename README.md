# d3d-fidasim
DIII-D routines for running FIDASIM

#Installation
FIDASIM is already install on Iris as a module.
```
module load fidasim # release version
```

#Example
See `d3d_inputs.pro` for available settings

```
IDL> inputs = d3d_inputs()
IDL> d3d_prefida,inputs
```
