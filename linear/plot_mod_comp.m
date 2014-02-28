clear
load 3Dinv_result
load 3Dinitmod
load seiscmap
load tomo
load mode_cards
amor = load('models/rajmodel/AMOR_200km.txt');
epr = load('models/rajmodel/EPR_200km.txt');
eaf = load('models/rajmodel/EAFRI_200km.txt');
chili = load('models/rajmodel/CHILI_200km.txt');
prem = load('models/jimmodel/prem');

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

[grdy grdx grdtopo] = grdread2('etopo1.grd');
[grdxi grdyi] = meshgrid(grdx,grdy);
grdtopo=double(grdtopo');
save png_topo.mat grdtopo grdxi grdyi
load png_topo

while 1
figure(23)
clf
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
h1=surfacem(xi,yi,errmat);
drawpng
caxis([0 0.1])
colorbar
if exist('mlat','var')
	plotm(mlat,mlon,'kx','linewidth',3,'markersize',10);
end
[mlat mlon bot] = inputm(1);
disp([num2str(mlat),' ',num2str(mlon)]);
if bot == 'q'
	break;
end

[temp ilat] = min(abs(mlat - xnode));
[temp ilon] = min(abs(mlon - ynode));
vel_mod = shearV3D(:,ilat,ilon);
init_mod = initV3D(:,ilat,ilon);
phv_fwd = phV3D(:,ilat,ilon);
periods = [tomo(:).period];
vec_h = diff(depth_prof);
vec_h(end+1) = vec_h(end);

for ip = 1:length(tomo)
	phv(ip) = tomo(ip).phV(ilat,ilon);
end

phv_fwd(find(phv_fwd==0))=NaN;

figure(24)
clf
hold on
set(gcf,'position',[100 300 300 500]);
%h = plotlayermods(vec_h(:),init_mod(:));
%set(h,'linewidth',2,'color','k');
%plot(amor(:,4),-amor(:,1),'c--','linewidth',2);
h = plotlayermods(vec_h(:),vel_mod(:));
set(h,'linewidth',2,'color','k');
ind = find(epr(:,1)>30);
plot(epr(ind,4),-epr(ind,1),'r--','linewidth',2);
plot(prem.mod(:,2),-prem.mod(:,1),'g--','linewidth',2);
plot(chili(ind,4),-chili(ind,1),'b--','linewidth',2);
%plot(eaf(:,4),-eaf(:,1),'m--','linewidth',2);
legend('This Study','East Pacific Rise','PREM','Chili Subduction','location','southwest');
%plot(card(7).SV(:),-card(7).deps(:,1),'r--','linewidth',2);
%plot([0 5],-[crusthmap(ilat,ilon) crusthmap(ilat,ilon)],'r--');
xlim([ 2 5])
ylim([-120 0])

figure(25)
clf
hold on
plot(periods,phv_fwd,'--','color','b','linewidth',2);
plot(periods,phv,'x','color','k','linewidth',2,'markersize',10);

end
