clear;

load tomo.mat
load seiscmap
moho = load('data/moho_pick.mat');

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];
r = 0.1;
figure(65)
clf
set(gcf,'color',[1 1 1])
Ncol = 4; Nrow = floor(length(tomo)/Ncol)+1;
%Ncol = 4; Nrow = floor(length(tomo)/Ncol/2)+1;
for ip = 1:1:length(tomo)
	subplot(Nrow,Ncol,floor(ip))
	ax = worldmap(lalim, lolim);
	set(ax, 'Visible', 'off')
% 	geoshow(xi,yi,tomo(ip).phV,'displaytype','texturemap');
    surfacem(xi,yi,tomo(ip).phV);
	colormap(seiscmap)
	drawpng
	title(num2str(tomo(ip).period),'fontsize',15);
	caxis([tomo(ip).avgphV*(1-r) tomo(ip).avgphV*(1+r)]);
    colorbar
end

figure(66)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
% 	geoshow(xi,yi,tomo(ip).phV,'displaytype','texturemap');
surfacem(moho.yi,moho.xi,moho.moho_surf);
colormap(seiscmap)
drawpng
colorbar

