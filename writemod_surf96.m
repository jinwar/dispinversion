% write velocity model to surf96 format file
% 
% created by Yang Zha 09/28/2012
% modified 10/17/2012 to include density in model
% 
% model is nlayer*4 matrix [H Vp Vs Density]
% 		model(:,1): H(KM)
%		model(:,2): VP(KM/S)
%		model(:,3): VS(KM/S)
%		model(:,4): DENSITY(g/cm^3)		
function fid=writemod_surf96(model,filename)
%
% set up constant parameters
%rho=3.0; % constant density
%rho_water = 1.0; % water density
QP=1000;
QS=200;
fid = fopen(filename,'w');

	fprintf(fid,'MODEL.01\n');
	fprintf(fid,'model\n');
	fprintf(fid,'ISOTROPIC\n');
	fprintf(fid,'KGS\n');
	fprintf(fid,'FLAT EARTH\n');
	fprintf(fid,'1-D\n');
	fprintf(fid,'CONSTANT VELOCITY\n');
	fprintf(fid,'LINE08\n');
	fprintf(fid,'LINE09\n');
	fprintf(fid,'LINE10\n');
	fprintf(fid,'LINE11\n');
	fprintf(fid,'      H(KM)   VP(KM/S)   VS(KM/S) RHO(GM/CC)     QP         QS       ETAP       ETAS      FREFP      FREFS    \n');
	for i=1:size(model,1)
		fprintf(fid,'     %7.4f',model(i,1)); % H(z)
		fprintf(fid,'     %7.4f',model(i,2));	% Vp
		fprintf(fid,'     %7.4f',model(i,3));	% Vs
		fprintf(fid,'     %7.4f',model(i,4));	% density
		fprintf(fid,'  	  %7.4f',QP); % QP	
		if(model(i,3)<=0.01)
			fprintf(fid,'  	  %7.4f',0); % QS
		else
			fprintf(fid,'  	  %7.4f',QS); % QS
		end
		fprintf(fid,'     0.00'); %ETAP
		fprintf(fid,'     0.00');%ETAS
		fprintf(fid,'     1.00'); %
		fprintf(fid,'     1.00    ');
		fprintf(fid,'\n');
	end

	fclose(fid);
end
