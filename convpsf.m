function [images,vector]=convpsf(PSF,sctrin,spec)
% [RF,bimage,sctrout,imgaxi,imglat] = CONVPSF(PSF,sctrin,spec)
%
%  convolves a PSF and scatterers, then get the resulting RF and B-mode.
%
% INPUT:
%                PSF = point-spread function from getpsf.m
%                      FORMAT: A1xL1 matrix
%             sctrin = input scatterer space
%                      FORMAT: A1xL1 matrix
%               spec = transducer configurations
%                      FORMAT: 1x1 struct,  containing...
%                         c      (scalar double, wavespeed, m/s)
%                         fs     (scalar double, sample freq., Hz)
%                         focus  (1x3 vector,    focus position, m)
%
% OUTPUT:
%             images = images
%                      FORMAT: 1x1 struct,  containing...
%                         RF     (A2xL2 matrix)
%                         bimage (A2xL2 matrix)
%                         sctrout(A2xL2 matrix, output scatterer space)
%             vector = vector labels
%                      FORMAT: 1x1 struct,  containing...
%                         imgaxi (A2x1 vector, m)
%                         imglat (L2x1 vector, m)
%
% Created 2019-01-24 by Keita A. Yokoyama

%% perform convolution of  PSF and scatterer field
    c=spec.c;
    fs=spec.fs;
    focus=spec.focus;
    nyquist=c/2/fs;
    
% ---convolve scatterers with PSF
    A=fftshift(fft2(ifftshift( sctrin )));
    B=fftshift(fft2(ifftshift( PSF )));
    %fft2( PSF,size(sctrin,1),size(sctrin,2) )
    C=A.*B;
    D=ifft2(C);
    
% ---define range of RF matrix that were generated redundantly
    cropaxilim=floor(size(PSF,1)/2);
    cropaxi=cropaxilim:size(D,1)-cropaxilim;
    
    croplatlim=floor(size(D,2)/2);
    croplat=croplatlim:size(D,2);
    
% ---drop the first and last size(PSF)/2 samples
    RF=D(cropaxi,croplat);sctrout=sctrin(cropaxi,croplat);
    
% ---clear unused variables (mainly for debugging)
    clearvars PSF sctrin spec A B C D
    
%% format
    imgaxi=(-size(sctrout,1)/2:(size(sctrout,1)-1)/2)*nyquist+focus(3);
    imglat=(0:size(sctrout,2)-1)*nyquist;
    
% ---center lateral vector about zero
    imglat=imglat-imglat(end)/2;
    
%% get B-mode
    bimage=abs(hilbert(RF));
    
%% pack output variables into structures
    images.RF=RF/max(abs(RF(:)));%normalize amplitude for easier analysis
    images.bimage=bimage;
    images.sctrout=sctrout;
    vector.imgaxi=imgaxi;
    vector.imglat=imglat;
end