function fig=drawpsf(PSFlat,PSFaxi,PSF,spec)
    fdepth=spec.fdepth;
    fig=figure;
    imagesc(PSFlat*1000,PSFaxi*1000,PSF);hold on
    axis([-3 3 fdepth*1000-1 fdepth*1000+1]);caxis([-1 1]);
    colormap(gca,'parula');
    xlabel('Lat. (mm)');
    ylabel('Axial (mm)');
    title('PSF RF');
end