function fig=bmode(baxi,blat,bimage)
% fig = BMODE(baxi,blat,bimage)
%
%  displays the B-mode image.
%
% INPUT:
%       baxi = axial scale
%              FORMAT: Ax1 vector (meter)
%       blat = lateral scale
%              FORMAT: Lx1 vector (meter)
%     bimage = B-mode image
%              FORMAT: AxL vector
%
% OUTPUT:
%        fig = figure handle for generated image
%
% Created 2019-01-22 by Keita A. Yokoyama
    fig=figure;
    imagesc(blat*1000,baxi*1000,bimage);hold on
    xlabel('Lateral (mm)')
    ylabel('Axial (mm)')
    title('B-Mode')
    axis image;colormap gray
end