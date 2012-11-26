clear;

load tomo.mat
load seiscmap.mat

ip = 10;
radius = 20;
r=0.1;

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

figure(64)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
surfacem(xi,yi,tomo(ip).phV);
drawpng
title(['Periods: ',num2str(tomo(ip).period)],'fontsize',15)
avgv = nanmean(tomo(ip).phV(:));
caxis([avgv*(1-r) avgv*(1+r)])
colorbar
colormap(seiscmap)

[lat0 lon0] = inputm(1);
dist = distance(xi,yi,lat0,lon0);
dist = deg2km(dist);
ind = find(dist < radius);

plotm(xi(ind),yi(ind),'ro');

for ip = 1:length(tomo)
	dispphv(ip) = nanmean(tomo(ip).phV(ind));
end

figure(65)
clf
hold on
ind = find([tomo(:).noise]);
h1=plot([tomo(ind).period],[dispphv(ind)],'-ro');
ind = find(~[tomo(:).noise]);
h2=plot([tomo(ind).period],[dispphv(ind)],'-bo');
legend([h1,h2],'Noise','Teleseismic');
xlabel('Periods (s)');
ylabel('Phase Velocity (km/s)');


dispcurve.periods = [tomo(:).period];
dispcurve.phv = dispphv;
dispcurve.ind = find(dist < radius);

save dispcurves/mainland.mat dispcurve;
