% INVERT 1D velocity model from Rayleigh wave dispersion, using SURF96
% INVERT FOR SHEAR VELOCITY AND KEEP THICKNESS FIXED
% ALSO KEEP VP/VS FIXED, DENSITY FROM VP 
%:INPUT: 
%	vec_T: vector of periods
%	phv: phase velocity data
%	phvstd : error of phase velocity
%	grv: group velocity data
%	grvstd : error of group velocity
%	startmodel : nlayer x 4 array of data:
%		model(:,1): H(KM)
%		model(:,2): VP(KM/S)
%		model(:,3): VS(KM/S)
%		model(:,4): DENSITY(g/cm^3)
%	h_crust: crustal thickness from extra data to control differential smoothing near moho, if <0 then pass
%	waterdepth: depth of seafloor from surface (used to determine where to allow sharp change)
%
%OUTPUT: 
%	outmodel: inveted 1D model nlayer x 3 array of data:
%	disp_fwd: predicted dispersion of final inverted model.
function [outmodel phv_fwd]= invdispR(vec_T,phv,phvstd,grv,grvstd,startmodel,h_crust,waterdepth,varargin)

%Created by Yang Zha 09/27/2012
% modified 10/17/2012 to include density in model

niteration=5;
diff_smooth = 0;

if(nargin==9)
	niteration=varargin{1};
end

%%(0) generate a sobs.d file in the current directory (constant inversion parameters)
%make_par_surf96('R'); % make a control file for surf96
display('===========1D Rayleigh Dispersion Inversion============');
% clean up

system('surf96 39'); 
system('rm start.mod');
system('rm disp_obs.dsp');
%%(1) write starting model to file in current directory  

display('Writing model file..');

writemod_surf96(startmodel,'start.mod');

%%(2) write dispersion data to file
%
%
display('Writing dispersion data...');

if length(phv)==length(vec_T)

	Cdata(:,1)=vec_T(:);
	Cdata(:,2)=phv(:);
	Cdata(:,3)=phvstd(:);

	writedisp_surf96(Cdata,'disp_obs.dsp'); %write phase velocity data
end
if length(grv)==length(vec_T)
	Udata(:,1)=vec_T(:);
	Udata(:,2)=grv(:);
	Udata(:,3)=grvstd(:);

	writedisp_surf96(Udata,'disp_obs.dsp','R','U',1) %write group velocity data
end
%	for ifreq=1:length(freqs)
%			fprintf(outfp,'SURF96 R C X   0     %6.4f     %6.4f     %6.4f\n',...
%				1/freqs(ifreq),phv(ifreq)/3280.84,phvstd(ifreq)/3280.84);
%	end
%end
%	for ifreq=1:length(freqs)
%			fprintf(outfp,'SURF96 R U X   0     %6.4f     %6.4f     %6.4f\n',...
%				1/freqs(ifreq),grv(ifreq)/3280.84,grvstd(ifreq)/3280.84;
%	end
%end


%%(3) set smoothing constraints, allow sharp change of velocity at moho and ocean surface


vec_z=cumsum(startmodel(:,1)); % convert from layer thickness to depth

nl=length(startmodel(:,1)); % number of layers

mohodepth=waterdepth+h_crust; % mooho depth

ind_sf = find(abs(vec_z-waterdepth)==min(abs(vec_z-waterdepth))); % find layer number correspinding to seafloor


% Smoothing scheme: permit large smoothing at seafloor and moho. larger change in the crust than in the mantle
%
%
display('Setting smoohting profile...');

system('surf96 36 1'); % set smoothign type

cmdtemp = ['surf96 31 ',num2str(ind_sf),' 10']; % large change at seafloor
system(cmdtemp);

if(h_crust>0)
	ind_moho = find(abs(vec_z-mohodepth)==min(abs(vec_z-mohodepth))); % find layer number correspinding to moho depth
	
	for il = ind_sf+1:ind_moho-2
		cmdtemp = ['surf96 31 ',num2str(il),' 1']; % higher change permitted in crust;
		system(cmdtemp);
	end
	
	for il = ind_moho-1:ind_moho+1
		cmdtemp = ['surf96 31 ',num2str(il),' 5']; % even higher change permitted near moho;
		system(cmdtemp);
	end
	
	cmdtemp=['surf96 31 ',num2str(nl),' 1']; % make weight of bottom layer =  (no constrain at all)
	%system(cmdtemp);
	
end


%% (4) Perform inversion
%
%####
%	start the first inversion with a slightly higher damping
%	do avoid an overshoot in the first model estimate
%####
display('Start inversion....');
display(['do ', num2str(niteration), ' iterations ..']);

system('surf96 32 10 > log_surf96.txt');
system('surf96 37 2 1 2 6 >> log_surf96.txt');
%####
%	do 10 inversions
%####
display('Writing log file..');

system('surf96 32 2 >> log_surf96.txt');

cmdtemp=['surf96 37 ',num2str(niteration),' 1 2 6 >> log_surf96.txt'];
system(cmdtemp);

system('surf96 45 >> log_surf96.txt'); % write smoothing info into log

system('surf96 17 >> log_surf96.txt'); % write dispersion of final model info into log

system('surf96 28 final.mod'); % output model

system('surf96 1 27 temp.dsp');
%

system('surf96 39'); % clean up


%%(5) Read output model from file
display('Getting inverted model from:  final.mod..');

outmodel = readmod_surf96('final.mod');
% read dispersion from tmep file
data=readdisp_surf96('temp.dsp');

if(~isempty(data));
	phv_fwd=data(:,2);
else
	phv_fwd=[]
end


display('=================Inversion Finished========================');

return
end



