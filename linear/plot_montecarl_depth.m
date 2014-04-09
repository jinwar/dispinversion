clear;

load 3Dinv_montecarl_result.mat
load seiscmap;
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

[latN lonN] = size(montecarlo);
for ilat = 1:latN
	for ilon = 1:lonN
		if isempty(montecarlo(ilat,ilon).result)
			errmap(ilat,ilon) = NaN;
		else
			errmap(ilat,ilon) = median(montecarlo(ilat,ilon).result.errors);
			depth_node = montecarlo(ilat,ilon).result.depth_node;
		end
	end
end

depths = 10:10:90;
r = 0.1;

figure(28)
clf
figure(29)
clf
Ncol = 3; Nrow = floor(length(depths)/Ncol) + 1;
for idep = 1:length(depths)
	[temp depind] = min(abs(depth_node - depths(idep)));
	depthmap = zeros(latN,lonN);
	stdmap = zeros(latN,lonN);
	for ilat = 1:latN
		for ilon = 1:lonN
			if isempty(montecarlo(ilat,ilon).result)
				depthmap(ilat,ilon) = NaN;
				continue;
			end
			depthmap(ilat,ilon) = montecarlo(ilat,ilon).result.final_avg(depind);
			stdmap(ilat,ilon) = montecarlo(ilat,ilon).result.final_std(depind);
		end
	end
	figure(28)
	subplot(Nrow,Ncol,idep)
	ax = worldmap(lalim, lolim);
	set(ax, 'Visible', 'off')
%	h1=geoshow(xi,yi,depthmap,'displaytype','texturemap');
	surfacem(xi,yi,depthmap);
	caxis(nanmean(depthmap(:))*[1-r 1+r]);
	colormap(seiscmap);
	drawpng
	colorbar
	title(['SV: ',num2str(depth_node(depind)),' km'],'fontsize',20)

	figure(29)
	subplot(Nrow,Ncol,idep)
	ax = worldmap(lalim, lolim);
	set(ax, 'Visible', 'off')
%	h1=geoshow(xi,yi,stdmap,'displaytype','texturemap');
	surfacem(xi,yi,stdmap);
	colormap(seiscmap);
	drawpng
	colorbar
	title(['SV STD: ',num2str(depth_node(depind)),' km'],'fontsize',20)
	
end  % end of depth loop
