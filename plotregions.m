rift = load('dispcurves/rift.mat','dispcurve');
mainland = load('dispcurves/mainland.mat');
load tomo.mat
load seiscmap.mat

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

[grdy grdx grdtopo] = grdread2('etopo1.grd');
[grdxi grdyi] = meshgrid(grdx,grdy);
grdtopo=double(grdtopo');
[xi yi] = meshgrid(xnode,ynode);
topo = interp2(grdxi,grdyi,grdtopo,xi,yi);

figure(55)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
colormap('gray');
h1=contourfm(xi,yi,topo,'linestyle','none');
ind = find(rift.dispcurve.ispick ==1);
[xi yi] = ndgrid(xnode,ynode);
plotm(xi(ind),yi(ind),'ro','markerfacecolor','r');
ind = find(mainland.dispcurve.ispick ==1);
plotm(xi(ind),yi(ind),'bo','markerfacecolor','b');
drawpng
export_fig('pics/regions','-transparent','-m2');
