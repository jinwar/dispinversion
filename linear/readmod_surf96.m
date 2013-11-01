% function to read velocity model from surf96 format model file
% created by Ge JIn, modified by Yang Zha 09/28/2012
%
% model is nlayer*4 matrix [thickness Vp Vs Density]
% 		model(:,1): H(KM)
%		model(:,2): VP(KM/S)
%		model(:,3): VS(KM/S)
%		model(:,4): DENSITY(g/cm^3)
%
function model = readmod_surf96(filename);

fid = fopen(filename,'r');
if(fid>=0)	

	for i=1:12
		stemp = fgetl(fid);
	end
	i=1;
	stemp = fgetl(fid);
	while(ischar(stemp))
		temp = sscanf(stemp,'%f');
		model(i,1) = temp(1);% thickness H(i)
		model(i,2) = temp(2);% Vp(i)
		model(i,3) = temp(3); % Vs(i)
		model(i,4) = temp(4); % density
		i=i+1;
		stemp = fgetl(fid);
	end
	
	fclose(fid);
else
	error([filename,' does not exist']);% return empty data if file is empty 
	model=[];
return
end

