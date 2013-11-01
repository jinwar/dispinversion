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
[mlat mlon] = inputm(2);
%mlat = [-9.4744 -9.7132];
%mlon = [149.22 150.93];
plotm(mlat,mlon,'r','linewidth',3);
filename = ['pics/shear2Dslice_errmap.png'];
%export_fig(filename,'-transparent','-png','-m2')


N = round(distance(mlat(1),mlon(1),mlat(2),mlon(2))/0.1);

prof_lats = linspace(mlat(1),mlat(2),N);
prof_lons = linspace(mlon(1),mlon(2),N);

topo_lats = linspace(mlat(1),mlat(2),3*N);
topo_lons = linspace(mlon(1),mlon(2),3*N);

topo = interp2(grdxi,grdyi,grdtopo,topo_lats,topo_lons);

vel_prof = zeros(length(depth_prof),N);
rela_vel_prof = zeros(length(depth_prof),N);

for ip = 1:N
	[temp ilat] = min(abs(prof_lats(ip) - xnode));
	[temp ilon] = min(abs(prof_lons(ip) - ynode));
	vel_prof(:,ip) = shearV3D(:,ilat,ilon);
end

depthV3D = permute(shearV3D,[2 3 1]);
for idep = 1:length(depth_prof)
	temp = depthV3D(:,:,idep);
	temp(find(temp==0)) = NaN;
	avgV(idep) = nanmean(temp(:));
	rela_vel_prof(idep,:) = vel_prof(idep,:)./avgV(idep);
end
rela_vel_prof = rela_vel_prof - 1;

rela_vel_prof(find(vel_prof < 3.5)) = NaN;

ind = find(vel_prof == 0);
vel_prof(ind) = NaN;

xaxis = prof_lons;
figure(24)
clf
%subplot('position',[0.1 0.8 0.8 0.15])
%plot(topo_lons,topo,'k','linewidth',2);
%xlim([min(xaxis) max(xaxis)])

%subplot('position',[0.1 0.1 0.8 0.7])
contourf(xaxis,depth_prof,vel_prof,50);
shading flat
colormap(seiscmap)
colorbar('south');
xlim([min(xaxis) max(xaxis)])
text(min(xaxis),-3,'W','fontsize',20)
text(max(xaxis)-0.05,-3,'E','fontsize',20)
axis ij
caxis([3.5 4.4])
filename = ['pics/shear2Dslice.png'];
%export_fig(filename,'-transparent','-png','-m2')


figure(25)
clf
subplot('position',[0.1 0.8 0.8 0.15])
plot(topo_lons,topo,'k','linewidth',2);
xlim([min(xaxis) max(xaxis)])

subplot('position',[0.1 0.1 0.8 0.7])
contourf(xaxis,depth_prof,rela_vel_prof,30);
shading flat
colormap(seiscmap)
colorbar('south');
xlim([min(xaxis) max(xaxis)])
axis ij
caxis([-0.1 0.1]);

