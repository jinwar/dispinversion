% script to inverse the 3D shear velocity structure of PNG, using ambient noise and earthquake rayleigh wave inversion
% using same 1D initial model
% adding water depth variation
% adding Moho thickness variation
%
% written by Ge Jin, jinwar@gmail.com

clear
tic
load tomo.mat
load png_topo.mat
moho = load('data/moho_pick.mat');

[xi yi] = ndgrid(xnode,ynode);
topo = interp2(grdxi,grdyi,grdtopo,xi,yi);

% Define search parameters:
%sedh = [1 3 5];
%sedv = [2.5];
%crusth_ratio = [1];
%crustv = [3.5 3.6 3.7];
%mantlev = [4.1 4.3 4.5];
sedh = [2 4];
sedv = [2.5];
crusth_ratio = [1.0];
crustv = [3.4 3.5 3.6];
mantlev = [4.3 4.5 4.7];

paranum = 0;
for isedh = 1:length(sedh)
	for isedv = 1:length(sedv)
		for icrusth = 1:length(crusth_ratio)
			for icrustv = 1:length(crustv)
				for imantlev = 1:length(mantlev)
					paranum = paranum+1;
					paraind(:,paranum) = [isedh; isedv; icrusth; icrustv; imantlev];
				end
			end
		end
	end
end

vpvs = 1.8;

[Nlat Nlon] = size(tomo(1).phV);
regmap = zeros(Nlat,Nlon);
sedhmap = zeros(Nlat,Nlon);
sedvmap = zeros(Nlat,Nlon);
crustvmap = zeros(Nlat,Nlon);
crusthmap = zeros(Nlat,Nlon);
ori_crusthmap = zeros(Nlat,Nlon);

mantlevmap = zeros(Nlat,Nlon);

errmap = zeros(Nlat,Nlon);
periods = [tomo.period];
phV3D = zeros(length(periods),Nlat,Nlon);

make_par_surf96('R');

for ilat = 1:Nlat
	for ilon = 1:Nlon
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
		if length(phv) < 10
			continue;
		end
		phvstd = 0.05*ones(size(phv));
		grv = [];
		grvstd = [];
		% prepare the initial model
		crusth = interp2(moho.yi',moho.xi',moho.moho_surf',xi(ilat,ilon),yi(ilat,ilon));
		if isnan(crusth)
			continue;
		end
		tic
		for ipara = 1:size(paraind,2)
			vec_h(1) = sedh(paraind(1,ipara));
			vec_vs(1) = sedv(paraind(2,ipara));
			vec_rho(1) = 2.7;
			vec_h(2) = crusth * crusth_ratio(paraind(3,ipara)) - sedh(paraind(1,ipara));
			vec_vs(2) = crustv(paraind(4,ipara));
			vec_rho(2) = 2.7;
			vec_h(3) = 100;
			vec_vs(3) = mantlev(paraind(5,ipara));
			vec_rho(3) = 3.3;
			vec_vp = vec_vs.*vpvs;
			initmod.model(:,1) = vec_h(:);
			initmod.model(:,2) = vec_vp(:);
			initmod.model(:,3) = vec_vs(:);
			initmod.model(:,4) = vec_rho(:);
			initmodel = initmod.model;
			if topo(ilat,ilon) < 0
				waterdepth = -topo(ilat,ilon)/1e3;
				initmodel = [waterdepth 1.5 0 1;initmodel];
			else
				waterdepth = 0;
			end
			err(ipara) = disperr(velT,phv,phvstd,grv,grvstd,initmodel);
		end
		toc
		[minerr mini] = min(err);
		fprintf('Sedh: %4.1f Sedv: %4.1f ',sedh(paraind(1,mini)),sedv(paraind(2,mini)));
		fprintf('crusth: %4.1f crustv: %4.1f ',crusth_ratio(paraind(3,mini)),crustv(paraind(4,mini)));
		fprintf('mantlev: %4.1f ',mantlev(paraind(5,mini)));
		fprintf('MinErr: %4.3f \n ',minerr);
		initmodmap(ilat,ilon) = mini;
		sedhmap(ilat,ilon) = sedh(paraind(1,mini));
		sedvmap(ilat,ilon) = sedv(paraind(2,mini));
		crusthmap(ilat,ilon) = crusth*crusth_ratio(paraind(3,mini));
		crustvmap(ilat,ilon) = crustv(paraind(4,mini));
		mantlevmap(ilat,ilon) = mantlev(paraind(5,mini));
		errmap(ilat,ilon) = minerr;
		ori_crusthmap(ilat,ilon) = crusth;
		
		h_crust=-1;
	end
end

save 3Dinitmod ...
		sedh sedv crusth_ratio crustv mantlev ...
		initmodmap sedhmap sedvmap crusthmap crustvmap mantlevmap ori_crusthmap errmap...
		xi yi

%
[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];
%depth_prof = vec_z;
%
%save 3Dinv_result shearV3D errmat xnode ynode depth_prof regmap phV3D vec_h initV3D
%
%figure(48)
%clf
%ax = worldmap(lalim, lolim);
%set(ax, 'Visible', 'off')
%h1=surfacem(xi,yi,errmat);
%drawpng
%figure(49)
%clf
%ax = worldmap(lalim, lolim);
%set(ax, 'Visible', 'off')
%h1=surfacem(xi,yi,regmap);
%drawpng
toc
