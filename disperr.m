function err = disperr(periods,phv,phvstd,grv,grvstd,initmodel)

% Write model file
writemod_surf96(initmodel,'start.mod');

% Write dipersion file
outfp = fopen('disp_obs.dsp','w');
for ifreq=1:length(periods)
    fprintf(outfp,'SURF96 R C X   0     %6.4f     %6.4f     %6.4f\n',...
        periods(ifreq),phv(ifreq),phvstd(ifreq));
end
if length(grv) == length(periods)
	for ifreq=1:length(periods)
		fprintf(outfp,'SURF96 R U X   0     %6.4f     %6.4f     %6.4f\n',...
			periods(ifreq),grv(ifreq),grvstd(ifreq));
	end
end
fclose(outfp);

% cleanup
system('surf96 39');

% run and output dispersion
system('surf96 1 17 | awk ''{if ($1=="R") print $5,$6,$7}'' > temp');

% read in dispersion 
data = load('temp');

err = sum((data(:,2)-data(:,1)).^2./data(:,3));
err = err ./sum(1./data(:,3));
err = err.^0.5;

end
