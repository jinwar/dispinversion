function [dispphv periods] = pickdisp_fun(lat,lon)

load tomo.mat

[xi yi] = ndgrid(xnode,ynode);
lalim = [min(xnode) max(xnode)];
lolim = [min(ynode) max(ynode)];

dist = distance(xi,yi,lat,lon);
[temp ind] = min(dist(:));
ind

for ip = 1:length(tomo)
	dispphv(ip) = tomo(ip).phV(ind);
	periods(ip) = tomo(ip).period;
end

