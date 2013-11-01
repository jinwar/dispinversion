

clear

load 3Dinitmod
load seiscmap
load png_topo.mat
load tomo.mat


sedlayernum = 2;
crustlayernum = 4;
mantle_layer_thickness = [10*ones(1,10)];
vpvs = 1.8;
crusthmap = crusthmap*0.8;
depth_prof = [2:2:10, 12:2:40, 45:5:100, 110:20:150];

[xi yi] = ndgrid(xnode,ynode);
topo = interp2(grdxi,grdyi,grdtopo,xi,yi);
periods = [tomo.period];


[m n] = size(xi);
final_errmap = zeros(m,n);
Ndepth = length(depth_prof);
shearV3D = zeros(Ndepth,m,n);
initV3D = zeros(Ndepth,m,n);

for ilat = 1:m
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
			for ilayer = 1:sedlayernum
				layernum = layernum+1;
				vec_h(layernum) = sedhmap(ilat,ilon)./sedlayernum;
				vec_vs(layernum) = sedvmap(ilat,ilon);
				vec_rho(layernum) = 2.7;
			end
			for ilayer = 1:crustlayernum
				layernum = layernum+1;
				vec_h(layernum) = (crusthmap(ilat,ilon)-sedhmap(ilat,ilon))./crustlayernum;
				vec_vs(layernum) = crustvmap(ilat,ilon);
				vec_rho(layernum) = 2.7;
			end
			for ilayer = 1:length(mantle_layer_thickness)
				layernum = layernum+1;
				vec_h(layernum) = mantle_layer_thickness(ilayer);
				vec_vs(layernum) = mantlevmap(ilat,ilon);
				vec_rho(layernum) = 3.3;
			end
			vec_vp = vec_vs*vpvs;
			initmodel(:,1) = vec_h(:);
			initmodel(:,2) = vec_vp(:);
			initmodel(:,3) = vec_vs(:);
			initmodel(:,4) = vec_rho(:);
			initV3D(:,ilat,ilon) = depth_interp(depth_prof,vec_h,vec_vs);
			if topo(ilat,ilon) < -1000
				waterdepth = -topo(ilat,ilon)/1e3;
				initmodel = [waterdepth 1.5 0 1;initmodel];
			else
				waterdepth = 0;
			end
			h_crust = crusthmap(ilat,ilon);
			[outmod phv_fwd] = invdispR(velT,phv,phvstd,grv,grvstd,initmodel,h_crust,waterdepth,10);
			misfit = (phv_fwd(:)-phv(:));
			rms=sqrt(sum(misfit.^2)/length(velT))
			if rms > 0.1
				outmod1 = outmod;
				rms1 = rms;
%				phv = smooth(phv,3);
				[outmod phv_fwd] = invdispR(velT,phv,phvstd,grv,grvstd,initmodel,h_crust,waterdepth,100);
				misfit = (phv_fwd(:)-phv(:));
				rms=sqrt(sum(misfit.^2)/length(velT))
				if rms > rms1
					outmod = outmod1;
					rms = rms1;
				end
			end
			vec_h = outmod(:,1);
			vec_vs = outmod(:,3);
			shearV3D(:,ilat,ilon) = depth_interp(depth_prof,vec_h,vec_vs);
			final_errmap(ilat,ilon) = rms;
			if length(phv_fwd) == length(periods)
				phV3D(:,ilat,ilon) = phv_fwd(:);
			else
				for ip = 1:length(velT)
					phV3D(find(velT(ip) == periods),ilat,ilon) = phv_fwd(ip);
				end
			end
		end
	end
end

errmat = final_errmap;
regmap = final_errmap;

save 3Dinv_result shearV3D final_errmap xnode ynode depth_prof regmap errmat xnode ynode initV3D phV3D periods

			

