clear;

load 3Dinv_result
load seiscmap
load tomo
load 3Dinitmod.mat

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

%[grdy grdx grdtopo] = grdread2('etopo1.grd');
%[grdxi grdyi] = meshgrid(grdx,grdy);
%grdtopo=double(grdtopo');
%save png_topo.mat grdtopo grdxi grdyi
%load png_topo
shearV3D = permute(shearV3D,[2 3 1]);
thickness = diff(depth_prof);

r = 0.1;
r = 0.08;
rvjet = flipud(colormap('jet'));

depths = 10:10:120;
%for idep = 1:length(depths)
for idep = 2:2
	figure(86)
	clf
	set(gcf,'color',[1 1 1]);
	[temp depind] = min(abs(depth_prof - depths(idep)));
	vmap = shearV3D(:,:,depind);
	vmap(find(vmap == 0)) = NaN;
	ax = worldmap(lalim, lolim);
	set(ax, 'Visible', 'off')
	setm(ax,'fontsize',20)
%	setm(gca,'parallellabel','off')
	h1=surfacem(xi,yi,vmap);
	caxis(nanmean(vmap(:))*[1-r 1+r]);
	drawpng
	colorbar('southoutside','fontsize',18)
%	title([num2str(depth_prof(depind)),' km'])
	colormap(seiscmap)
	filename = ['pics/depthslices/sheardepth_',num2str(depths(idep))];
	export_fig(filename,'-png','-transparent','-m2');
end

% get the average crust velocity
%shearV3D = permute(shearV3D,[3 1 2]);
load 3Dinv_result
crustvmap = vmap;
crustvmap(:) = NaN;
for ix = 1:size(xi,1)
	for iy = 1:size(xi,2)
		if ~isnan(vmap(ix,iy))
			crust_ind = find(depth_prof < crusthmap(ix,iy));
			crust_ind = crust_ind(:);
			vels = shearV3D(crust_ind,ix,iy);
			crustvmap(ix,iy) = sum(vels'.*thickness(crust_ind))./sum(thickness(crust_ind));
		end
	end
end
figure(86)
clf
set(gcf,'color',[1 1 1]);
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,crustvmap);
caxis(nanmean(crustvmap(:))*[1-r 1+r]);
drawpng
colorbar
colormap(seiscmap)
filename = ['pics/depthslices/sheardepth_crust'];
%export_fig(filename,'-png','-transparent','-m2');

% get the average lower crust velocity
crustvmap = vmap;
crustvmap(:) = NaN;
for ix = 1:size(xi,1)
	for iy = 1:size(xi,2)
		if ~isnan(vmap(ix,iy))
			crust_ind = find(depth_prof < crusthmap(ix,iy) & depth_prof > crusthmap(ix,iy) - 5 );
			clear vels;
			vels = shearV3D(crust_ind,ix,iy);
			if ~isempty(find(vels>4.3))
				keyboard;
			end
			crustvmap(ix,iy) = sum(vels'.*thickness(crust_ind))./sum(thickness(crust_ind));
		end
	end
end
figure(86)
clf
set(gcf,'color',[1 1 1]);
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,crustvmap);
caxis(nanmean(crustvmap(:))*[1-r 1+r]);
drawpng
colorbar
colormap(seiscmap)
filename = ['pics/depthslices/sheardepth_lowercrust'];
%export_fig(filename,'-png','-transparent','-m2');

% get the average lower crust velocity
crustvmap = vmap;
crustvmap(:) = NaN;
for ix = 1:size(xi,1)
	for iy = 1:size(xi,2)
		if ~isnan(vmap(ix,iy))
			crust_ind = find(depth_prof > crusthmap(ix,iy) & depth_prof < crusthmap(ix,iy) + 5 );
			clear vels;
			vels = shearV3D(crust_ind,ix,iy);
			crustvmap(ix,iy) = sum(vels'.*thickness(crust_ind))./sum(thickness(crust_ind));
		end
	end
end
figure(86)
clf
set(gcf,'color',[1 1 1]);
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,crustvmap);
caxis(nanmean(crustvmap(:))*[1-r 1+r]);
drawpng
colorbar
colormap(seiscmap)
filename = ['pics/depthslices/sheardepth_uppermantle'];
%export_fig(filename,'-png','-transparent','-m2');


figure(23)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,errmat);
drawpng
caxis([0 0.1])
colorbar
