clear;

load 3Dinv_result
load seiscmap
load tomo
load pngcoastline

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

%[grdy grdx grdtopo] = grdread2('etopo1.grd');
%[grdxi grdyi] = meshgrid(grdx,grdy);
%grdtopo=double(grdtopo');
%save png_topo.mat grdtopo grdxi grdyi
load png_topo

figure(88)
clf
hold on
ax = worldmap(lalim, lolim);
set(ax, 'Visible', 'off')
geoshow(grdxi,grdyi,grdtopo,'displaytype','texturemap');
demcmap(grdtopo);
drawpng

depthV3D = permute(shearV3D,[3 2 1]);
for idep = 1:length(depth_prof)
	temp = depthV3D(:,:,idep);
	temp(find(temp==0)) = NaN;
	avgV(idep) = nanmean(temp(:));
	rela_vel_3D(:,:,idep) = depthV3D(:,:,idep) ./ avgV(idep);
end

start_depth = 35;
rela_vel_3D(:,:,find(depth_prof<start_depth)) = NaN;
rela_vel_3D(find(rela_vel_3D == 0)) = NaN;
rela_vel_3D = rela_vel_3D-1;


coastlat = [S.Lat];
coastlon = [S.Lon];
ind = find(coastlat > lalim(2) | coastlat < lalim(1) | coastlon > lolim(2) | coastlon < lolim(1));
coastlat(ind) = NaN;
coastlon(ind) = NaN;

[xi3 yi3 zi3] = meshgrid(xnode,ynode,depth_prof);
figure(87)
clf
hold on
depth = ones(size(coastlat))*start_depth;
plot3(coastlat,coastlon,depth,'g','linewidth',3)
N=10;
color_ind = round(linspace(40,1,N+1));
colors = seiscmap(color_ind,:);
alphas = linspace(0.1,1,N);
for i=3:N
	hpatch = patch(isosurface(xi3,yi3,zi3,rela_vel_3D,-i/100));
%	isonormals(xi3,yi3,zi3,rela_vel_3D,hpatch);
%	set(hpatch,'FaceColor',colors(i+1,:),'EdgeColor','none','FaceAlpha',0.1)
	set(hpatch,'FaceColor','r','EdgeColor','none','FaceAlpha',min([0.2*i,1]))
end

%hpatch = patch(isosurface(xi3,yi3,zi3,rela_vel_3D,0.03));
%set(hpatch,'FaceColor',[0 0 1],'EdgeColor','none')
%hpatch = patch(isosurface(xi3,yi3,zi3,rela_vel_3D,+0.03));
%set(hpatch,'FaceColor','b','EdgeColor','none')
view([-17 40])
%view([-76 40])
set(gcf,'Renderer','zbuffer'); 
camlight; lighting phong
camlight left; 
camlight right; 
set(gca,'zdir','reverse')
axis ij
box on
grid on

xlim(lalim)
ylim(lolim)
zlim([start_depth 120])
%colorbar
%colormap(seiscmap)
%caxis([-N/100,N/100])
filename = ['pics/shear3Dvolumne_EW.png'];
%export_fig(filename,'-transparent','-png','-m2')

rotate3d on
