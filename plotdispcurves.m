%%Scripts to plot dispersion curves from different regions.

island = load('dispcurves/island.mat');
mainland = load('dispcurves/mainland.mat');

figure(33)
clf
hold on
h1 = plot(island.dispcurve.periods,island.dispcurve.phv,'r-o');
h2 = plot(mainland.dispcurve.periods,mainland.dispcurve.phv,'b-o');
legend([h1 h2],'Island','Mainland','Location','Best')
xlabel('Periods (s)','fontsize',20);
ylabel('Phase Velocity (km/s)','fontsize',20);
set(gca,'fontsize',15)
