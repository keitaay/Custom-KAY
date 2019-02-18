function [PSF,rescelsize,PSFaxi,PSFlat,debug]=getpsf(Tx,Rx,spec)
% [PSF,rescelsize,PSFaxi,PSFlat,debug] = GETPSF (Tx,Rx,spec)
%
%  determines the resolution cell size of a Field transducer
%  in pulse-echo configuration.
%
% INPUT:
%         Tx = transmit transducer object
%              FORMAT: Field-II object
%         Rx = receive transducer object
%              FORMAT: Field-II object
%       spec = transducer configurations
%              FORMAT: 1x1 struct,  containing...
%                         lambda     (scalar double, wavelength,         m)
%                         c          (scalar double, wavespeed,        m/s)
%                         fs         (scalar double, sample freq.,      Hz)
%                         focus      (1x3 vector,    focus position,     m)
%                         elemheight (scalar double, element height,     m)
%                         impexc     (1xX vector,    impulse,   normalized)
%                         impresp    (1xX vector,    imp. response,  norm.)
%                         lim_axi    (1x2 vector,    axial image limit,  m)
%                         lim_lat    (1x2 vector,    lat. image limit,   m)
%
% OUTPUT:
%        PSF = RF image of point-spread function
%              FORMAT: AxL matrix (A=axial, L=lateral)
% rescelsize = resolution cell size
%              FORMAT: 1x2 vector (lateral, axial)
%     PSFaxi = axial label for spatial position in PSF
%              FORMAT: Ax1
%     PSFlat = lateral label for spatial position in PSF
%              FORMAT: Lx1
%      debug = debug; contains transmit/receive PSFs separately
%              FORMAT: struct
%
% Created 2019-01-21 by Keita A. Yokoyama
%% Define a resolution cell
% ---extract transducer specs from struct
    dt=1/spec.fs;%time sample differential
    c=spec.c;focus=spec.focus;height=spec.elemheight;
    impexc=spec.impexc;impresp=spec.impresp;
    lim_lat=spec.lim_lat;

% ---define lateral PSF scale
    nyquist=dt*c/2;
    PSFlat=(lim_lat(1):nyquist:lim_lat(2))';
    
% ---define spatial coordinates to create PSF
    points=zeros(length(PSFlat),3);
    points(:,1)=PSFlat;
    points(:,3)=focus(3);
    
% ---define transfer functions (to find required vector lengths)
    transfer1way=conv(impexc,impresp);
    transfer2way=conv(transfer1way,impresp);
    
% for each of 3 scenarios (transmit, receive, pulse-echo)...
for i=1:3
% ---find and normalize point-spread function
    switch i
        case 1,[PSF,tstart]=calc_hp(Tx,points);
        case 2,[PSF,tstart]=calc_hp(Rx,points);
        case 3,[PSF,tstart]=calc_hhp(Tx,Rx,points);
    end
    PSF=PSF./max(abs(PSF(:)));
    
% ---correction 1: elevational lens distance (presuming focused array)
    lensshift=( sqrt(focus(3).^2+(height/2).^2) - focus(3) )*2/c;
    
% ---correction 2: shift to peak pulse (not start time of impulse response)
    if i==3, terror= dt* length(transfer2way)/2 + lensshift*2;
    else,    terror= dt* length(transfer1way)/2 + lensshift;
    end
    
% ---define correction factor to "tstart"
    tshift=tstart-terror;
    
% ---get fast-time vector, relative to start of Field
    timing=( 0 : dt : dt*(size(PSF,1)-1) )';
    
% ---apply correction to time vector, then convert into PSF axial label
    PSFaxi=(timing+tshift)*c/2;
    
% ---save transmit/receive PSFs as debug info
    switch i
        case 1,debug.TxPSF=PSF;debug.Txaxi=PSFaxi*2;
        case 2,debug.RxPSF=PSF;debug.Rxaxi=PSFaxi*2;
    end
    
    if i~=3,clearvars PSF;end
end

%% Get size of resolution cell
% ---draw envelope for PSF
    env=abs(hilbert(PSF));
    env=env/max(max(env));
    [~,col]=max(max(env));
    [~,row]=max(max(env'));%#ok<UDIM>
    
% ---identify indices meeting -6dB threshold
    resaxi=find(env(:,col)>=0.5);
    reslat=find(env(row,:)>=0.5);
    
% ---determine PSF size meeting threshold
    axicel=PSFaxi(max(resaxi))-PSFaxi(min(resaxi));
    latcel=PSFlat(max(reslat))-PSFlat(min(reslat));
    rescelsize=[latcel,axicel];
end