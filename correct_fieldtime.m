function terror=correct_fieldtime(spec,varargin)
% MINIMUM:  terror = CORRECT_FIELDTIME(spec)
% FULL:     terror = CORRECT_FIELDTIME(spec,type,way)
%
%  gets the difference in timepoints between "t_start" output from
%  Field II simulations and the true first instance of fast-time.
%
%  the output takes into account differences in sound wave travel times due
%  to transducer elevational lensing! simply subtract the output of this
%  function from "t_start" to get a corrected time vector.
%
% REQUIRED INPUT:
%       spec = transducer configurations
%              FORMAT: 1x1 struct,  containing...
%                         c          (scalar double, wavespeed,        m/s)
%                         fs         (scalar double, sample freq.,      Hz)
%                         focus      (1x3 vector,    focus position,     m)
%                         elemheight (scalar double, element height,     m)
%                         impexc     (1xX vector,    impulse,   normalized)
%                         impresp    (1xX vector,    imp. response,  norm.)
%
% OPTIONAL INPUT:
%       type = transducer type
%              FORMAT: string (default: 'linear')
%                NOTE: currently only accepts 'linear' and 'focusedlinear'
%
%        way = echo's time-of-flight is 1- or 2-way
%              FORMAT: 1 (to/from transducer) or 2 (to AND from; default)
%
% OUTPUT:
%     terror = time between Field start time and true focal region
%              FORMAT: scalar double
%
% Created 2019-02-15 by Keita A. Yokoyama

    switch nargin
        case 1
            type='linear';
            way=2;
        case 2
            type=varargin{1};
            way=2;
        case 3
            type=varargin{1};
            way=varargin{2};
    end
% extract needed transducer configuration
    fdepth=spec.focus(3); eheight=spec.elemheight; c=spec.c; dt=1/spec.fs;
    exci=spec.impexc;      resp=spec.impresp;

% correct for average height of elevational lens' curvature
    if strcmp(type,'focusedlinear')
         lensshift=( sqrt(fdepth.^2+(eheight/2).^2) - fdepth )*2/c;
    else,lensshift=0;
    end
    
% get transducer's transfer function (its vector length is needed)
% then calculate the timeshift error
    if way==1
        H=conv(exci,resp);
        terror=dt* length(H)/2 + lensshift;
    elseif way==2
        H=conv(conv(exci,resp),resp);
        terror=dt* length(H)/2 + lensshift*2;
    end
end