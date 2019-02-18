# Custom-KAY
This repository contains code developed to streamline the analysis of ultrasound systems/images, in part to complete assignments for BME 844 (Advanced Ultrasonic Imaging, Spring 2019, Prof. Gregg Trahey) at Duke University.

All code was developed with MATLAB R2017b and Field II 3.24 on a MacBook Pro 2016 (Retina/Touchbar).

The contents of files are as follows.

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
