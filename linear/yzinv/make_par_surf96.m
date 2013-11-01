% make parameter file sobs.d for surf96 inversion/ forward calculations 
% function fid=make_par_surf96(datatype),
% datatype:
%    R: rayleigh
%    L: Love
%    J: Joint
function fid=make_par_surf96(datatype)
	if (datatype=='R') 
		% Rayleigh wave
		fid=fopen('sobs.d','w');
		fprintf(fid,'0.005 '); %df
		fprintf(fid,'0.005 '); % dcr
		fprintf(fid,'0. ');
		fprintf(fid,'0.005 '); % dcl
		fprintf(fid,'0. \n'); % dcr
		fprintf(fid,'0 '); % error based on redisual(1) or std of data(0)  
		fprintf(fid,'0  0  0  0  1  1') %  if use gam_love/c_love/u_love/gama_ray/c_ray/u_ray
		fprintf(fid,' 0  1  0\n'); % don't know what they mean
		fprintf(fid,'start.mod'); % name of starting model file
		fprintf(fid,'\n'); 
		fprintf(fid,'disp_obs.dsp');% name of dispersion data file
		fprintf(fid,'\n');
		fclose(fid);
	elseif (datatype=='L')
		% love wave
		fid=fopen('sobs.d','w');
		fprintf(fid,'0.005 '); %df
		fprintf(fid,'0.005 '); % dcr
		fprintf(fid,'0. ');
		fprintf(fid,'0.005 '); % dcl
		fprintf(fid,'0. \n'); % dcr
		fprintf(fid,'0 '); % error based on redisual(1) or std of data(0)  
		fprintf(fid,'0  1  1  0  0  0') %  if use gam_love/c_love/u_love/gama_ray/c_ray/u_ray
		fprintf(fid,' 0  1  0\n'); % don't know what they mean
		fprintf(fid,'start.mod'); % name of starting model file
		fprintf(fid,'\n'); 
		fprintf(fid,'disp_obs.dsp');% name of dispersion data file
		fprintf(fid,'\n');
		fclose(fid);
	elseif  (datatype=='J')
		% Joint inversion
		fid=fopen('sobs.d','w');
		fprintf(fid,'0.005 '); %df
		fprintf(fid,'0.005 '); % dcr
		fprintf(fid,'0. ');
		fprintf(fid,'0.005 '); % dcl
		fprintf(fid,'0. \n'); % dcr
		fprintf(fid,'0 '); % error based on redisual(1) or std of data(0)  
		fprintf(fid,'0  1  1  0  1  1') %  if use gam_love/c_love/u_love/gama_ray/c_ray/u_ray
		fprintf(fid,' 0  1  0\n'); % don't know what they mean
		fprintf(fid,'start.mod'); % name of starting model file
		fprintf(fid,'\n'); 
		fprintf(fid,'disp_obs.dsp');% name of dispersion data file
		fprintf(fid,'\n');
		fclose(fid);
	end
return
end



	
		


