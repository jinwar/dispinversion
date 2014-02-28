function plot_init_mod();

load 3Dinitmod
load seiscmap
lalim = [min(xi(:)) max(xi(:))];
lolim = [min(yi(:)) max(yi(:))];
	
figure(11)
clf
subplot(1,2,1)
ax = worldmap(lalim, lolim);
surfacem(xi,yi,sedhmap);
title('Sediment Thickness')
colormap(seiscmap);
colorbar
drawpng
subplot(1,2,2)
ax = worldmap(lalim, lolim);
surfacem(xi,yi,sedvmap);
title('Sediment Velocity')
colormap(seiscmap);
colorbar
caxis([1 3])
drawpng

figure(13)
clf
subplot(2,2,1)
ax = worldmap(lalim, lolim);
surfacem(xi,yi,crusthmap);
title('Crustal Thickness')
colormap(seiscmap);
colorbar
drawpng
caxis([20 40])
subplot(2,2,2)
ax = worldmap(lalim, lolim);
surfacem(xi,yi,ori_crusthmap);
title('Crustal Thickness')
colormap(seiscmap);
colorbar
drawpng
caxis([20 40])

subplot(2,2,4)
ax = worldmap(lalim, lolim);
surfacem(xi,yi,crustvmap);
title('Crustal Velocity')
caxis([3 4])
colormap(seiscmap);
colorbar
drawpng

subplot(2,2,3)
ax = worldmap(lalim, lolim);
surfacem(xi,yi,crusthmap./ori_crusthmap);
title('Relative moho depth change')
colormap(seiscmap);
colorbar
drawpng

figure(14)
clf
ax = worldmap(lalim, lolim);
surfacem(xi,yi,mantlevmap);
title('Mantle Velocity')
colormap(seiscmap);
colorbar
drawpng
caxis([4 4.8])

figure(15)
clf
ax = worldmap(lalim, lolim);
surfacem(xi,yi,errmap);
title('Err map')
colorbar
drawpng
caxis([0 .1])
