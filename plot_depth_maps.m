clear;

load 3Dinv_result
load seiscmap
load tomo

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

[grdy grdx grdtopo] = grdread2('etopo1.grd');
[grdxi grdyi] = meshgrid(grdx,grdy);
grdtopo=double(grdtopo');
save png_topo.mat grdtopo grdxi grdyi
load png_topo

shearV3D = permute(shearV3D,[2 3 1]);

depths = 5:10:120;

figure(86)
clf
Ncol = 3; Nrow = floor(length(depths)/Ncol) + 1;
for idep = 1:length(depths)
	[temp depind] = min(abs(depth_prof - depths(idep)));
	vmap = shearV3D(:,:,depind);
	vmap(find(vmap == 0)) = NaN;
	subplot(Ncol,Nrow,idep)
	ax = worldmap(lalim, lolim);
	set(ax, 'Visible', 'off')
	h1=geoshow(xi,yi,vmap,'displaytype','texturemap');
	drawpng
	colorbar
	title([num2str(depth_prof(depind)),' km'])
end
colormap(seiscmap)

figure(23)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,errmat);
drawpng
caxis([0 0.1])
colorbar
