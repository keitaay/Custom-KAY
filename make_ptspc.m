function [sctrspc,vaxi,vlat]=make_ptspc(spec)
% MAKE_PTSPC(spec)
%
%  generates a field with a single, tiny scatterer at a desired depth.
%
% INPUT:
%               spec = transducer configurations
%                      FORMAT: 1x1 struct,  containing...
%                         c       (scalar dbl., wavespeed,     m/s)
%                         fs      (scalar dbl., sample freq.,   Hz)
%                         fdepth  (scalar dbl., focal depth,     m)
%                         lim_axi (1x2 vector,  min/max axial depth)
%                         lim_lat (1x2 vector,  left/right lateral)
%                         nscat   (scalar dbl., scatterer # per res cell)
%
% OUTPUT:
%            sctrspc = scatterer field
%                      FORMAT: AxL matrix
%          vaxi/vlat = axial/lateral vector
%                      FORMAT: column vectors,  Ax1 and Lx1
%
% Created 2019-01-21  by Keita A. Yokoyama
% Modified 2019-02-15 by K. A. Y. (changed input to "spec" struct)

depth=spec.fdepth;
nyquist=spec.c/spec.fs/2;
lim_lat=spec.lim_lat;
lim_axi=spec.lim_axi;

% ---define vectors for axial/lateral positions
vaxi=(lim_axi(1):nyquist:lim_axi(2))';
vlat=(lim_lat(1):nyquist:lim_lat(2))';

% ---initialize matrix for scatterers
sctrspc=zeros(length(vaxi),length(vlat));

% ---impose point target at foal depth, in center of phantom
sctrspc(knnsearch(vaxi,depth),knnsearch(vlat,0))=1;