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

figure(23)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,errmat);
drawpng
caxis([0 0.1])
colorbar
[mlat mlon] = inputm(1);
plotm(mlat,mlon,'kx','linewidth',3,'markersize',10);

[temp ilat] = min(abs(mlat - xnode));
[temp ilon] = min(abs(mlon - ynode));
vel_mod = shearV3D(:,ilat,ilon);
init_mod = initV3D(:,ilat,ilon);
phv_fwd = phV3D(:,ilat,ilon);
periods = [tomo(:).period];

for ip = 1:length(tomo)
	phv(ip) = tomo(ip).phV(ilat,ilon);
end

phv_fwd(find(phv_fwd==0))=NaN;

figure(24)
clf
hold on
h = plotlayermods(vec_h(:),vel_mod(:));
set(h,'linewidth',2,'color','b');
h = plotlayermods(vec_h(:),init_mod(:));
set(h,'linewidth',2,'color','k');
xlim([ 2 5])

figure(25)
clf
hold on
plot(periods,phv_fwd,'--','color','b','linewidth',2);
plot(periods,phv,'x','color','k','linewidth',2,'markersize',10);
