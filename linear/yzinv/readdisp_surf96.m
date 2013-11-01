% function to read dispersion data used by surf96
% created by Ge JIn, modified by Yang Zha 09/28/2012
%
function data = readdisp_surf96(filename)

	infp = fopen(filename,'r');
	if(infp>=0)	
		stemp = fgetl(infp);
		ifreq=0;
		while(ischar(stemp))
			ifreq = ifreq+1;			
			temp = sscanf(stemp(20:end),'%f %f %f\n');% assume same format as SURF96 output
			data(ifreq,1) = temp(1);
			data(ifreq,2) = temp(2);
			data(ifreq,3) = temp(3);
			stemp = fgetl(infp);
		end
		fclose(infp);
		if(ifreq==0)
			data=[]; % return empty data if file is empty 
		end
	else
		error([filename,' does not exist']);% return empty data if file is empty 
		data=[];
	end
	return
end
