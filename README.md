# Custom-KAY
This repository contains code developed by Keita A. Yokoyama to streamline the analysis of ultrasound systems and images in MATLAB. This repository has been created, in part, to complete assignments for BME 844 (Advanced Ultrasonic Imaging, Spring 2019, Prof. Gregg Trahey) at Duke University, and make my code available for others.

All code was developed with MATLAB R2017b and Field II 3.24 on a MacBook Pro 2016 (Retina/Touchbar).

The contents of files are as follows.

## Recommended Definition of Variables
```
%% setup
f0=5E6; bw=0.75; N=128; fdepth=40E-3; Fnum=5; exclength=0.5;

% ---define wave properties
c=1540;lambda=c/f0;

% ---define transducer constants
focus=[0 0 fdepth];    fs=f0*20;      nyquist=c/fs/2; 
elempitch=lambda/2;    angsens=45;    elemhght=10E-3;
elemwdth=lambda/(pi*sin(angsens));    elemkerf=elempitch-elemwdth;
subx=1;  suby=5;

% ---define simulation/image properties
nscat=11;%scatterers per resolution cell
lim_axi=fdepth+([-5 5]*1E-3);         lim_lat=[-5 5]*1E-3;

%% configure Field II
set_sampling(fs);

% ---define impulse and response
[impresp,impresptime]=makeImpulseResponse(bw,f0,fs);
exc=sin( 2*pi*f0*( 0:1/fs:exclength/f0 ) );

% ---define transducer on transmit
Tx=xdc_focused_array(N,elemwdth,elemhght,elemkerf,fdepth,subx,suby,focus);
xdc_excitation(Tx,exc); xdc_impulse(Tx,impresp); xdc_center_focus(Tx,[0,0,0]); xdc_focus(Tx,0,focus);

% ---define transducer on receive
Rx=xdc_focused_array(N,elemwdth,elemhght,elemkerf,fdepth,subx,suby,focus);
xdc_impulse(Rx,impresp); xdc_center_focus(Rx,[0,0,0]);
xdc_dynamic_focus(Rx,0,0,0);%xdc_focus(Rx,0,focus);

% ---consolidate configuration info in a single structure
spec.f0=f0; spec.fs=fs; spec.bw=bw; spec.Nelem=N; spec.Fnum=Fnum; spec.c=c; spec.lambda=lambda; spec.fdepth=fdepth; spec.focus=focus; spec.elemwidth=elemwdth; spec.elemheight=elemhght; ppec.elempitch=elempitch; spec.elemkerf=elemkerf; spec.lim_axi=lim_axi; spec.lim_lat=lim_lat; spec.nscat=nscat; spec.impexc=exc; spec.impresp=impresp;

% ---clear memory
clearvars -except Tx Rx spec
```

## Analysis Preparation
### getpsf.m
Takes transducer objects and imaging/simulation specs, and returns a point-spread function (PSF).

### correct_fieldtime.m
Corrects the timescale outputted by Field II. The default "tstart" variable given by Field II indicates the timepoint of the first axial position in simulation (creating the illusion that the focal depth is "deeper" than it should be); this script will correct for that.

### drawpsf.m
Like its name suggests, this function will draw the RF image of a transducer's point-spread function.

### make_ptspc.m and make_sctrspc.m
Creates a point-target in space, and creates a field of randomly distributed scatterers, respectively.

## Create Images
### convpsf.m
This function convolves a PSF with a given matrix of spatial positions with scatterer fields.

### bmode.m
This function creates a figure with a B-mode, properly formatted.
