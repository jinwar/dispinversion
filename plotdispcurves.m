%%Scripts to plot dispersion curves from different regions.

island = load('dispcurves/island.mat');
mainland = load('dispcurves/mainland.mat');
northern = load('dispcurves/northern.mat');
filename = 'pics/is_main_disp';

figure(33)
clf
hold on
h1 = plot(island.dispcurve.periods,island.dispcurve.phv,'r-o');
h2 = plot(mainland.dispcurve.periods,mainland.dispcurve.phv,'b-o');
h3 = plot(northern.dispcurve.periods,northern.dispcurve.phv,'g-o');
legend([h1 h2 h3],'Island','Mainland','northern','Location','Best')
xlabel('Periods (s)','fontsize',20);
ylabel('Phase Velocity (km/s)','fontsize',20);
set(gca,'fontsize',15)

export_fig(filename,'-transparent','-png','-m2')

