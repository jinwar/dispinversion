clear
noise = load('../matnoise/raytomo.mat');

xnode = noise.xnode;
ynode = noise.ynode;

selectperiods = 3
ip=selectperiods;
tomo(1).phV = noise.raytomo(ip).GV;
tomo(1).period = noise.raytomo(ip).period;
tomo(1).avgphV = nanmean(tomo(1).phV(:));
tomo(1).noise = true;

selectperiods = 1
eqdata = load('data/eikonal_stack.mat');
for ip = selectperiods
	pnum = 2;
	tomo(pnum).phV = eqdata.avgphv(ip).GV;
	tomo(pnum).period = eqdata.avgphv(ip).period;
	tomo(pnum).avgphV = nanmean(tomo(pnum).phV(:));
	tomo(pnum).noise = false;
end

load seiscmap

figure(16)
clf
hist([tomo(1).phV(:)-tomo(2).phV(:)],10);
xlabel('Phase Velocity Difference (km/s)','fontsize',15);
ylabel('Count of Data Grid','fontsize',15);
xlim([-0.4 0.2])
set(gca,'fontsize',15)
export_fig('pics/eqnoise/eqnoisehist','-transparent','-m2');

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

avgv = nanmean([tomo(1).phV(:);tomo(2).phV(:)]);
r=0.2;

figure(17)
clf
set(gcf,'position',[ 100 400  1000  500])
subplot(1,2,1)
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,tomo(1).phV);
set(gca,'position',[0.20034 0.11 0.28259 0.815]);
%set(h1,'facecolor','interp');
drawpng
% title(['Periods: ',num2str(tomo(1).period)],'fontsize',15)
caxis([avgv*(1-r) avgv*(1+r)])
% colorbar
colormap(seiscmap)
axesm(gcm,'fontsize',15);
subplot(1,2,2)
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
set(gca,'fontsize',15)
h1=surfacem(xi,yi,tomo(2).phV);
%set(h1,'facecolor','interp');
drawpng
% title(['Periods: ',num2str(tomo(2).period)],'fontsize',15)
caxis([avgv*(1-r) avgv*(1+r)])
h=colorbar
set(gca,'fontsize',15)
colormap(seiscmap)
axesm(gcm,'fontsize',15);
% export_fig('pics/eqnoise/eqnoisephv','-transparent','-m2');
