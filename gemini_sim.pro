; THIS IS A DEMO FILE FOR RUNNING PAOLA
; =====================================
; 
; This file borrows heavilly from examples 4 and 5 of batch.pro, which
; is included in the paola installation. We are using it to generate AO-corrected
; phase screens which are then fed into HCIPy

;===============================================================================
;================= DEFINITION OF OPTICAL TURBULENCE PARAMETERS =================
;===============================================================================

;Height for computation of atmospheric turbulence, predominantly ground layer
height = [0, 10] * 1000

;Cn2 distribution
cn2 = [0.5, 4.5]
dcn2=cn2/total(cn2)

;wind velocity profile
v = [15.0, 13]
windir = [0, 10]
vx=v*cos(windir) ; PARANAL
vy=v*sin(windir) ; PARANAL
wind=dblarr(2,2) ; PARANAL
wind(*,0)=vx & wind(*,1)=vy ; PARANAL
w0=0.7 ; seeing angle @ 500 nm
L0=27.d  ; 27-m outer-scale
za=30 ; zenith angle 30 deg

;4TH EXAMPLE====================================================================
;======================== NGS AO OTF/PSF =======================================
;===============================================================================

;we will use here a simple telescope architecture - just a monolithic mirror rep the gemini telescope
mir=SEGPOS(40,0) ; INPUT MIRROR DIAMETER HERE
;pixel and matrices size. Here, as we are going to compute an AO PSF, we
;need to tell about all the parameters of the calculation:
;PSF pixel size here is half the Nyquist lambda/2/D, if you want Nyquist, set
;dxf to -1
dxf=-1
;matrix size set to default, i.e. such that = 8 times PSF FWHM is seeing limited
;mode, that's the minimum, you can set another value but it must be >= this one
n_psf=2200
;microns, imaging wavelength
lambda=1.6
;off-axis angle of the NGS [asec], assuming science object is on-axis
ang=0
;angle of vector towards NGS, relative to x-axis (y-axis is +90)
ori=0
;WFS integration time in ms
wfs_int= 1;0.4
;loop time lag
lag=0.05;0.05
;by default WFS pitch = r0(lambda) but you can set any value here
wfspitch= 0.18 ; from Conod et al
;conjugation height of the AO deformable mirror wrt pupil
dmh=0
;WFS detector read-out-noise e/px
ron= 0.5
;NGS magnitude
ngs_mag=10
;filter name for which the NGS magnitude is given
ngs_fil='R'
;NGS associated black body temperature [K]
ngs_tem=5700
;we assume a perfect DM (square DM spatial transfer function),
;and actpitch = wfs lenslet pitch
dm_params={dm_height:dmh,dmtf:-1,actpitch:wfspitch}
;closed loop gain
gainCL=1;0.5
;refractivity dispersion ratio of WFS to DM correction
;defined as [n(LAM_WFS)-1] / [n(imaging wavelength)-1]
disp=0.99

;now we build the WFS structure variable, for a 4-quadrant and for a "spot"
;based SH-WFS, with 6 pixels / lenslet width (for the other stuff, please see
;PAOLA header manual with IDL> doc_ibrary,'paola.pro')
wfs_params4Q={mirvec:-1,nblenses:-1,extrafilter:[.6,-1,0.94],$
              wfs_pitch:wfspitch,wfs_ron:ron,algorithm:'4q'}
wfs_paramsCG={mirvec:-1,nblenses:-1,extrafilter:[.6,-1,0.94],$
              wfs_pitch:wfspitch,wfs_ron:ron,algorithm:'cg',$
              wfs_jitter:0.0,wfs_pxfov:6,wfs_pxsize:-1}

;pixel and matrix sizes determination
ps=PIXMATSIZE(mir,dxf,n_psf,lambda,w0,L0,za,height,dcn2,wind,$
              wfspitch,dmh,ang,ori,wfs_int,lag)


;5TH EXAMPLE====================================================================
;===================== GENERATING AO CORRECTED PHASE SCREENS ===================
;===============================================================================
tsc=PSFOTFTSC(mir,ps,/pupil)
N_PSFS = 100
phaselist = MAKE_ARRAY(N_PSFS, 2208, 2208, /DOUBLE, VALUE = 0.)
FOR i = 0,N_PSFS do begin $
    ngsw=PAOLA('ngs',ps,tsc,w0,L0,za,height,dcn2,wind,dm_params,wfs_paramsCG, $
                ang,45,wfs_int,lag,'closed',gainCL,ngs_mag,ngs_fil,ngs_tem,/wave,/post_tiptilt) & $
    ww=wave(ngsw.psd_wave,ngsw.dfp_wave,tscpup=ngsw.pup_wave) & $
    phaselist[i, 0:-1, 0:-1] = ww.phase & $
ENDFOR


FITS_WRITE,'gsmt_phs_screen_09.fits',phaselist 