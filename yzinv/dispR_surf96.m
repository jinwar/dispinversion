% function of calculating rayleigh wave dispersion 
% 	model: [thickness vp vs]
% 	vec_T: period 
% 	data: [phv];
function phv = dispR_surf96(vec_T,model)

system('surf96 39'); % clean up
system('rm start.mod');
system('rm temp.dsp');

% make surf96 par file
make_par_surf96('R');

% write model to file
display('Writing model file..');

datatemp(:,1) = vec_T(:);
datatemp(:,2) = 3;
datatemp(:,3)  =0.1;

writedisp_surf96(datatemp,'disp_obs.dsp'); % write temp data into dispersion file 
writemod_surf96(model,'start.mod');

% run surf96 

system('surf96 1 27 temp.dsp');
% read dispersion from tmep file
data=readdisp_surf96('temp.dsp');

if(~isempty(data));
	phv=data(:,2);
else
	phv=[]
end
%
system('surf96 39'); % clean up

	return
end


