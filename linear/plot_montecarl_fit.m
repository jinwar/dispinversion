%function plot_montecarl_fit()

load 3Dinv_montecarl_result.mat
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

[latN lonN] = size(montecarlo);
for ilat = 1:latN
	for ilon = 1:lonN
		if isempty(montecarlo(ilat,ilon).result)
			errmap(ilat,ilon) = NaN;
		else
			errmap(ilat,ilon) = median(montecarlo(ilat,ilon).result.errors);
		end
	end
end

while 1
figure(58)
clf
ax=worldmap(lalim,lolim);
surfacem(xi,yi,errmap);
drawpng;
colorbar
caxis([0 0.1]);

[mlat mlon bot] = inputm(1);
if bot == 'q'
	break;
end
disp([num2str(mlat),',',num2str(mlon)]);

[temp ilat] = min(abs(mlat - xnode));
[temp ilon] = min(abs(mlon - ynode));

montecarl_plot(montecarlo(ilat,ilon));
end
