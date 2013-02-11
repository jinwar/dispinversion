% use a 2 layer crustal + mantle model to generate a reference phase velocity curve for use by CalcPhaseV_Aki
%
clear
load dispcurves/island.mat

vec_T=dispcurve.periods;
%h_mantle=20.0;
vpvs = 1.9;
%depth=[0;cumsum(refmod1(:,1))];
vec_h = [20 10 20 20];
vec_vp = [6.5 7.5 5.7 8.1];
vec_vs = vec_vp/vpvs;
vec_rho = [2.7 2.7 2.8 3.2];

refmod(:,1) = vec_h(:);
refmod(:,2) = vec_vp(:);
refmod(:,3) = vec_vs(:);
refmod(:,4) = vec_rho(:);

% write model to file
%writemod_surf96(refmod,'ref.mod');
%c_surf96 = dispR_surf96(vec_T,refmod);

[c, vg, grad_c, grad_vg] = Calc_Ray_dispersion(vec_T,refmod,1,0);

figure(54);
clf
hold on
plot(vec_T,c,'-ro');
plot(dispcurve.periods,dispcurve.phv,'-bo');

xlabel('period / seconds');
ylabel('phase velocity / km/s')

save 3layermodel.mat refmod c vg grad_c grad_vg vec_T
