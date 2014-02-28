clear;

noise_period = [10 18];
eq_period = [20 70];
eq_avg_period = [70 120];

noise = load('data/raytomo.mat');

xnode = noise.xnode;
ynode = noise.ynode;

periods = [noise.raytomo(:).period];
selectperiods = find(periods >= noise_period(1) & periods <= noise_period(2));
pnum = 0;
for ip = fliplr(selectperiods)
	pnum = pnum+1;
	tomo(pnum).phV = smoothmap_avg(noise.raytomo(ip).GV,1);
	tomo(pnum).period = noise.raytomo(ip).period;
	tomo(pnum).avgphV = nanmean(tomo(pnum).phV(:));
	tomo(pnum).noise = true;
end


eqdata = load('data/helmholtz_stack_LHZ.mat');
periods = [eqdata.avgphv(:).period];
selectperiods = find(periods >= eq_period(1) & periods <= eq_period(2));

for ip = selectperiods
	pnum = pnum+1;
	tomo(pnum).phV = eqdata.avgphv(ip).GV_cor;
	tomo(pnum).period = eqdata.avgphv(ip).period;
	tomo(pnum).avgphV = nanmean(tomo(pnum).phV(:));
	tomo(pnum).noise = false;
end

figure(22)
clf
hold on
ind = find([tomo(:).noise]);
plot([tomo(ind).period],[tomo(ind).avgphV],'-ro');
ind = find(~[tomo(:).noise]);
plot([tomo(ind).period],[tomo(ind).avgphV],'-bo');

save('tomo.mat','tomo','xnode','ynode');
