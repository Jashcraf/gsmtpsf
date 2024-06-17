# gsmtpsf
PSF Simulation tools for simulating the effects of polarization aberrations on the Giant Segmented Mirror Telescopes. More comprehensive simulations are being developed in [this repository](https://github.com/Jashcraf/polarization-gsmts-II). 

This repo holds notebooks and files used in the simulation effort for Ashcraft et al 2024 "Theoretical Limits on Polarization Differential Imaging for the GSMTs imposed by Polarization Aberrations" presented at SPIE Astronomical Telescopes + Instrumentation.

To generate AO-corrected phase screens using PAOLA, install the PAOLA IDL package and run the `@gemini_sim.pro` script in this repository.

Examples of polarization aberration simulation are included in `gemini_sim.ipynb` and `gsmt_sim.ipynb`, which rely on [HCIPy](https://github.com/ehpor/hcipy) and [Poke](https://github.com/Jashcraf/poke). Using the GPI Apodized Pupil Lyot Coronagraph model requires the [gpipsfs](https://github.com/geminiplanetimager/gpipsfs) package.

The data generated for this study is too large to be hosted on a Github repository, and may be made available upon reasonable request.
