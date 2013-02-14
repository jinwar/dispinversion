clear;

noise = load('../matnoise/raytomo.mat');

xnode = noise.xnode;
ynode = noise.ynode;

selectperiods = 3:14
pnum = 0;
for ip = fliplr(selectperiods)
	pnum = pnum+1;
	tomo(pnum).phV = noise.raytomo(ip).GV;
	tomo(pnum).period = noise.raytomo(ip).period;
	tomo(pnum).avgphV = nanmean(tomo(pnum).phV(:));
	tomo(pnum).noise = true;
end

selectperiods = 1:5
eqdata = load('data/eikonal_stack.mat');
for ip = selectperiods
	pnum = pnum+1;
	tomo(pnum).phV = eqdata.avgphv(ip).GV;
	tomo(pnum).period = eqdata.avgphv(ip).period;
	tomo(pnum).avgphV = nanmean(tomo(pnum).phV(:));
	tomo(pnum).noise = false;
end

%figure(22)
%clf
%hold on
%ind = find([tomo(:).noise]);
%plot([tomo(ind).period],[tomo(ind).avgphV],'-ro');
%ind = find(~[tomo(:).noise]);
%plot([tomo(ind).period],[tomo(ind).avgphV],'-bo');
%
save('tomo.mat','tomo','xnode','ynode');
