function [sctrspc,vaxi,vlat]=make_sctrspc(rescelsize,spec,seed)
% MAKE_SCTRSPC(lim_axi,spec,seed)
%
%  generates a field of scatterers, with the specified size.
%
% INPUT:
%         rescelsize = resolution cell size
%                      FORMAT: 1x2 vector, as outputted
%                              from getpsf.m
%               seed = random number generator seed
%                      FORMAT: double scalar
%                              will be set randomly, if zero
%               spec = transducer configurations
%                      FORMAT: 1x1 struct,  containing...
%                         c       (scalar dbl., wavespeed,    m/s)
%                         fs      (scalar dbl., sample freq.,  Hz)
%                         lim_axi (1x2 vector,  min/max axial depth)
%                         lim_lat (1x2 vector,  left/right lateral)
%                         nscat   (scalar dbl., scatterer # per res cell)
%
%
% OUTPUT:
%            sctrspc = scatterer field
%                      FORMAT: AxL matrix
%          vaxi/vlat = axial/lateral vector
%                      FORMAT: column vectors,  Ax1 and Lx1
%
% Created  2019-01-21 by Keita A. Yokoyama
% Modified 2019-02-12 by Keita A. Y. (changed input to "spec" struct)
nscat=spec.nscat;
nyquist=spec.c/spec.fs/2;
lim_lat=spec.lim_lat;
lim_axi=spec.lim_axi;

% ---define vectors for axial/lateral positions
vaxi=(lim_axi(1):nyquist:lim_axi(2))';
vlat=(lim_lat(1):nyquist:lim_lat(2))';

% ---initialize matrix for scatterers
sctrspc=zeros(length(vaxi),length(vlat));

% ---find number of resolution cells
numrescells=...
    diff([vaxi(1),vaxi(end)]) * diff([vlat(1),vlat(end)]) /...
    (rescelsize(1)*rescelsize(2));
N=ceil(nscat*ceil(numrescells));

% ---impose scatterer amplitudes
rng(seed);
sctrspc=sctrspc(:);
sctrloc=randi([1,length(sctrspc)],N,1);
sctrspc(sctrloc)=1;
sctrspc=reshape(sctrspc,[length(vaxi),length(vlat)]);