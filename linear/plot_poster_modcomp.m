clear
load 3Dinv_result
load 3Dinitmod
load seiscmap
load tomo
load mode_cards
amor = load('models/rajmodel/AMOR_200km.txt');
epr = load('models/rajmodel/EPR_200km.txt');
eaf = load('models/rajmodel/EAFRI_200km.txt');
Chile = load('models/rajmodel/CHILI_200km.txt');
prem = load('models/jimmodel/prem');

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

[grdy grdx grdtopo] = grdread2('etopo1.grd');
[grdxi grdyi] = meshgrid(grdx,grdy);
grdtopo=double(grdtopo');
save png_topo.mat grdtopo grdxi grdyi
load png_topo

plats = [-9.5791,-9.3495,-9.4493,-10.1375,-8.6897];
plons = [150.732,150.2563,149.5579,149.9627,150.8231];
pnames = ['ABCDE'];

figure(23)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off');
axesm(gcm,'fontsize',20);
%h1=surfacem(xi,yi,errmat);
h1=surfacem(grdxi,grdyi,grdtopo);
drawpng
%caxis([0 0.1])
demcmap(grdtopo);

mlat = [-10.197 -8.6096]; mlon = [  149.66 150.71];
plotm(mlat,mlon,'k','linewidth',5);
mlat = [-9.5 -9.5]; mlon = [149.2 150.9];
plotm(mlat,mlon,'k','linewidth',5);

plotm(plats,plons,'rx','linewidth',3,'markersize',20);
plotm(plats,plons,'ro','linewidth',3,'markersize',20);
for ip = 1:length(plats)
	textm(plats(ip),plons(ip)+0.15,pnames(ip),'color','r','fontsize',30,'linewidth',2);
end

filename = ['pics/1Dmodels/topomap'];
export_fig(filename,'-transparent','-png','-m2')

for ip = 1:length(plats)

mlat = plats(ip);
mlon = plons(ip);

[temp ilat] = min(abs(mlat - xnode));
[temp ilon] = min(abs(mlon - ynode));
vel_mod = shearV3D(:,ilat,ilon);
init_mod = initV3D(:,ilat,ilon);
phv_fwd = phV3D(:,ilat,ilon);
periods = [tomo(:).period];
vec_h = diff(depth_prof);
vec_h(end+1) = vec_h(end);

for i = 1:length(tomo)
	phv(i) = tomo(i).phV(ilat,ilon);
end

phv_fwd(find(phv_fwd==0))=NaN;

figure(24)
clf
hold on
set(gcf,'position',[100 300 300 500]);
set(gca,'fontsize',18);
%h = plotlayermods(vec_h(:),init_mod(:));
%set(h,'linewidth',2,'color','k');
%plot(amor(:,4),-amor(:,1),'c--','linewidth',2);
h = plotlayermods(vec_h(:),vel_mod(:));
set(h,'linewidth',5,'color','k');
ind = find(epr(:,1)>30);
plot(epr(ind,4),-epr(ind,1),'r--','linewidth',3);
prem.mod(end-8,1) = 35;
ind = find(prem.mod(:,1)>=35);
plot(prem.mod(ind,2),-prem.mod(ind,1),'g--','linewidth',3);
ind = find(Chile(:,1)>30);
plot(Chile(ind,4),-Chile(ind,1),'b--','linewidth',3);
%plot(eaf(:,4),-eaf(:,1),'m--','linewidth',2);
h = legend(['This study: '],'East Pacific Rise','PREM','Chile Subduction','location','southwest');
set(h,'fontsize',15);
text(4.5,-10,pnames(ip),'fontsize',30);

%plot(card(7).SV(:),-card(7).deps(:,1),'r--','linewidth',2);
%plot([0 5],-[crusthmap(ilat,ilon) crusthmap(ilat,ilon)],'r--');
xlim([ 2 5])
ylim([-120 0])
filename = ['pics/1Dmodels/',pnames(ip),'_prof'];
export_fig(filename,'-transparent','-png','-m2')

figure(25)
clf
hold on
plot(periods,phv_fwd,'--','color','b','linewidth',2);
plot(periods,phv,'x','color','k','linewidth',2,'markersize',10);

end
