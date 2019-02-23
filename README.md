# Custom-KAY
This repository contains code developed by Keita A. Yokoyama to streamline the analysis of ultrasound systems and images in MATLAB. This repository has been created, in part, to complete assignments for BME 844 (Advanced Ultrasonic Imaging, Spring 2019, Prof. Gregg Trahey) at Duke University, and make my code available for others.

All code was developed with MATLAB R2017b and Field II 3.24 on a MacBook Pro 2016 (Retina/Touchbar).

The contents of files are as follows.

## Recommended Definition of Variables
**UPDATED 2019-02-23:** default parameters can be automatically loaded with `setDefaultSit`.
Set up your default configuration as follows.

```
field_init(-1);         spec=setDefaultSit;
set_field('c',spec.c);  set_sampling(spec.fs);  subx=1;  suby=5;

% ---define transducer on transmit
Tx=xdc_focused_array(spec.Nelem,spec.elemwidth,spec.elemheight,...
    spec.elemkerf,spec.fdepth,subx,suby,spec.focus);
xdc_excitation(Tx,spec.impexc);     xdc_impulse(Tx,spec.impresp);
xdc_center_focus(Tx,[0,0,0]);       xdc_focus(Tx,0,spec.focus);

% ---define transducer on receive
Rx=xdc_focused_array(spec.Nelem,spec.elemwidth,spec.elemheight,...
    spec.elemkerf,spec.fdepth,subx,suby,spec.focus);
xdc_impulse(Rx,spec.impresp);
xdc_center_focus(Rx,[0,0,0]);       xdc_dynamic_focus(Rx,0,0,0);
```

## Analysis Preparation
### [Get PSF]

Takes transducer objects and imaging/simulation specs, and returns a point-spread function (PSF).

### [Correct Field Time]

Corrects the timescale outputted by Field II. The default "tstart" variable given by Field II indicates the timepoint of the first axial position in simulation (creating the illusion that the focal depth is "deeper" than it should be); this script will correct for that.

### [Draw PSF]

Like its name suggests, this function will draw the RF image of a transducer's point-spread function.

### Make a Spatial Grid with a [Point Target] or [Scatterer Field]

Creates a point-target in space, and creates a field of randomly distributed scatterers, respectively.

## Create Images
### [Convolve PSF with Scatterer Space]

This function convolves a PSF with a given matrix of spatial positions with scatterer fields.

### [Generate a B-Mode Image]

This function creates a figure with a B-mode, properly formatted.

[Get PSF]:getpsf.m
[Correct Field Time]:correct_fieldtime.m
[Draw PSF]:drawpsf.m
[Point Target]:make_ptspc.m
[Scatterer Field]:make_sctrspc.m
[Convolve PSF with Scatterer Space]:convpsf.m
[Generate a B-Mode Image]:bmode.m
