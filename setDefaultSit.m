function spec=setDefaultSit
% spec=SETDEFAULTSIT
%
%  creates a struct with the default transducer configuration for most
%  assignments in BME844.
%
% INPUT:  none
%
% OUTPUT: struct "spec"
%
% Created 2019-02-23 by Keita A. Yokoyama

f0=5E6; bw=0.75; N=128; fdepth=40E-3; Fnum=[]; exclength=0.5;

% ---define wave properties
c=1540;lambda=c/f0;

% ---define transducer constants
focus=[0 0 fdepth];    fs=f0*20;
elempitch=lambda/2;    angsens=45;    elemhght=10E-3;
elemwidth=lambda/(pi*sind(angsens));  elemkerf=elempitch-elemwidth;

% ---define simulation/image properties
nscat=21;%scatterers per resolution cell
lim_axi=fdepth+([-2 2]*1E-3);         lim_lat=[-5 5]*1E-3;

[impresp,~]=makeImpulseResponse(bw,f0,fs);
exc=sin( 2*pi*f0*( 0:1/fs:exclength/f0 ) );

% --save settings in struct
spec.f0=f0;  spec.fs=fs;  spec.bw=bw;  spec.Nelem=N;  spec.Fnum=Fnum;
spec.c=c;  spec.lambda=lambda;  spec.fdepth=fdepth;   spec.focus=focus;
spec.elemwidth=elemwidth;       spec.elemheight=elemhght;
spec.elempitch=elempitch;       spec.elemkerf=elemkerf;
spec.lim_axi=lim_axi;           spec.lim_lat=lim_lat;     spec.nscat=nscat;
spec.impexc=exc;                spec.impresp=impresp;
