clear;

load tomo.mat
load seiscmap
moho = load('data/moho.mat');

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];
r = 0.05;
figure(65)
clf
Ncol = 5; Nrow = floor(length(tomo)/Ncol)+1;
for ip = 1:length(tomo)
	subplot(Nrow,Ncol,ip)
	ax = worldmap(lalim, lolim);
	set(ax, 'Visible', 'off')
% 	geoshow(xi,yi,tomo(ip).phV,'displaytype','texturemap');
    surfacem(xi,yi,tomo(ip).phV);
	colormap(seiscmap)
	drawpng
	title(num2str(tomo(ip).period));
	caxis([tomo(ip).avgphV*(1-r) tomo(ip).avgphV*(1+r)]);
    colorbar
end

figure(66)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
% 	geoshow(xi,yi,tomo(ip).phV,'displaytype','texturemap');
surfacem(moho.xi,moho.yi,moho.mohodepth);
colormap(seiscmap)
drawpng
colorbar

