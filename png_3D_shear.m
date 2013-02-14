% script to inverse the 3D shear velocity structure of PNG, using ambient noise and earthquake rayleigh wave inversion
%
% written by Ge Jin, jinwar@gmail.com


clear

load yzinv/regions.mat

load tomo.mat

[Nlat Nlon] = size(tomo(1).phV);
Ndepth = size(region(1).outmod,1);
shearV3D = zeros(Ndepth,Nlat,Nlon);
regmap = zeros(Nlat,Nlon);
errmat = zeros(Nlat,Nlon);
periods = [tomo.period];
make_par_surf96('R');

for ilat = 1:Nlat
	for ilon = 1:Nlon
		disp(['ilat:',num2str(ilat),' ilon:',num2str(ilon)]);
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
		for ireg = 1:length(region)
			initmodel = region(ireg).outmod;
			err(ireg) = disperr(velT,phv,phvstd,grv,grvstd,initmodel);
		end
		[minerr mini] = min(err);
		regmap(ilat,ilon) = mini;
%		mini = 2;
		regmap(ilat,ilon) = mini;
		initmodel = region(mini).outmod;
		h_crust=-1;
		waterdepth=0;
		[outmod phv_fwd] = invdispR(velT,phv,phvstd,grv,grvstd,initmodel,h_crust,waterdepth,10)
		misfit = (phv_fwd(:)-phv(:));
		rms=sqrt(sum(misfit.^2)/length(velT))
		shearV3D(:,ilat,ilon) = outmod(:,3);
		errmat(ilat,ilon) = rms;
	end
end

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];
depth_prof = cumsum(region(1).outmod(:,1));

save 3Dinv_result shearV3D errmat regmap xnode ynode depth_prof

figure(47)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,regmap);
drawpng

figure(48)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,errmat);
drawpng
