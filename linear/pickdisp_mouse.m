clear;

load tomo.mat
load seiscmap.mat

ip = 7;
radius = 30;
r=0.1;

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

figure(64)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,tomo(ip).phV);
%set(h1,'facecolor','interp');
drawpng
title(['Periods: ',num2str(tomo(ip).period)],'fontsize',15)
avgv = nanmean(tomo(ip).phV(:));
caxis([avgv*(1-r) avgv*(1+r)])
colorbar
colormap(seiscmap)

ispickmat = zeros(size(tomo(ip).phV));
while 1
	[lat0 lon0 button] = inputm(1);
	if button == 3
		break;
	end
	dist = distance(xi,yi,lat0,lon0);
	dist = deg2km(dist);
	ind = find(dist < radius);
	ispickmat(ind) = 1;
	plotm(xi(ind),yi(ind),'ro');
end

ind = find(ispickmat ==1);
for ip = 1:length(tomo)
	dispphv(ip) = nanmean(tomo(ip).phV(ind));
end

figure(65)
clf
hold on
ind = find([tomo(:).noise]);
plot([tomo(:).period],[dispphv],'-ko');
h1=plot([tomo(ind).period],[dispphv(ind)],'-ro');
ind = find(~[tomo(:).noise]);
h2=plot([tomo(ind).period],[dispphv(ind)],'-bo');
legend([h1,h2],'Noise','Teleseismic','Location','best');
xlabel('Periods (s)');
ylabel('Phase Velocity (km/s)');


dispcurve.periods = [tomo(:).period];
dispcurve.phv = dispphv;
dispcurve.ispick = ispickmat;

filename = input('Output file name (./dispcurves/*.mat): ','s');

save(['dispcurves/',filename,'.mat'], 'dispcurve');
