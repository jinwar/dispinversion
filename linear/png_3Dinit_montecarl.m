
clear

load 3Dinitmod
load seiscmap
load png_topo.mat
load tomo.mat

[xi yi] = ndgrid(xnode,ynode);
topo = interp2(grdxi,grdyi,grdtopo,xi,yi);
periods = [tomo.period];


[m n] = size(xi);
for ilat = 1:m
	for ilon = 1:n
		montecarlo(ilat,ilon) = struct;
	end
end
for ilat = 1:m
	temp_file = ['temp_midsave_',num2str(ilat),'.mat'];
	if exist(temp_file,'file')
		load(temp_file);
		continue;
	end
	for ilon = 1:n
		layernum = 0;
		clear vec_h vec_vs vec_vp vec_rho initmodel
		disp(['ilat:',num2str(ilat),' ilon:',num2str(ilon)]);
		% prepare the dispersion curve
		clear phv velT
		velT = periods;
		for ip = 1:length(periods)
			phv(ip) = tomo(ip).phV(ilat,ilon);
		end
		badind = find(isnan(phv));
		phv(badind) = [];
		velT(badind) = [];
		if max(phv(find(velT < 10))) > phv(find(velT>10,1))
			phv(find(velT<10)) = [];
			velT(find(velT<10)) = [];
		end
		
		if length(phv) < 10
			continue;
		end
		phvstd = 0.05*ones(size(phv));
		grv = [];
		grvstd = [];
		if errmap(ilat,ilon) > 0
			datastr.crustv = crustvmap(ilat,ilon);
			datastr.crusth = crusthmap(ilat,ilon);
			datastr.sedh = sedhmap(ilat,ilon);
			datastr.sedv = sedvmap(ilat,ilon);
			datastr.mantlev = mantlevmap(ilat,ilon);
			datastr.topo = topo(ilat,ilon);
			datastr.periods = velT;
			datastr.phv = phv;
			datastr.phvstd = phvstd;
			datastr.grv = grv;
			datastr.grvstd = grvstd;
			montecarlo(ilat,ilon).result = montecarl_inv(datastr);
			montecarlo(ilat,ilon).datastr = datastr;
			montecarlo(ilat,ilon).lat = xi(ilat,ilon);
			montecarlo(ilat,ilon).lon = yi(ilat,ilon);
		end
	end
	save(temp_file);
end

save 3Dinv_montecarl_result.mat montecarlo xnode ynode xi yi
system('rm temp_midsave_*.mat');

