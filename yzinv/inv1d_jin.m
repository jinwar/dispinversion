% Matlab script to test 1D inversion function invdispR.m
%
% 09/30/2012
clear
% set parameters
h_crust=-1;
waterdepth=0;

%avgmodfile='/Volumes/Work/Lau_research/inversion/test/avg1d.mod';
%avgmodfile='/Volumes/Work/Lau_research/inversion/test/avg1d.mod';


% make another starting model
depth = [0:5:20, 25:5:100, 110:20:150];
vec_h = diff(depth);
vec_z=depth(2:end);


% forward

% Inversion
%
%

region(1).name = 'rift';
region(2).name = 'mainland';
region(3).name = 'northern';
region(1).color = 'r';
region(2).color = 'b';
region(3).color = 'k';
region(1).crusth = 25;
region(1).crustv = 3.7;
region(1).mantlev = 4.3;
region(1).sedh = 10;
region(1).sedv = 3;
region(2).crusth = 35;
region(2).crustv = 3.7;
region(2).mantlev = 4.3;
region(2).sedh = 10;
region(2).sedv = 3;

for ir = 1:2
    % load data
    
    vec_vs=region(ir).crustv*ones(size(vec_h));
    mantleind = find(depth > region(ir).crusth)-1;
    vec_vs(mantleind) = region(ir).mantlev;
    sedind = find(depth < region(ir).sedh);
    vec_vs(sedind) = region(ir).sedv;
    vec_vp=vec_vs*1.9;
    vec_rho=2.7*ones(size(vec_h));
    vec_rho(mantleind)=3.3;
    
    startmod2(:,1) = vec_h(:);
    startmod2(:,2) = vec_vp(:);
    startmod2(:,3) = vec_vs(:);
    startmod2(:,4) = vec_rho(:);
    
    filename = sprintf('../dispcurves/%s.mat',region(ir).name);
    load(filename);
    vec_T = dispcurve.periods(:);
    phv = dispcurve.phv(:);
    phvstd = 0.05*ones(size(phv));
    
    grv=[];
    grvstd=[];
    
    writemod_surf96(startmod2,'hs2.mod');
    h_crust=-1;
    waterdepth=0;
    startmod = startmod2;
    make_par_surf96('R'); % make a sobs.d file for inversion
    [outmod phv_fwd]= invdispR(vec_T,phv,phvstd,grv,grvstd,startmod,h_crust,waterdepth,100)
    
    misfit = (phv_fwd-phv)./phvstd;
    rms=sqrt(sum(misfit.^2)/length(vec_T))
    
    region(ir).phv = phv;
    region(ir).outmod = outmod;
    region(ir).vec_T = vec_T;
    region(ir).phv_fwd = phv_fwd;
    region(ir).startmod = startmod2;
    
end

% plot model
fsize = 20;
figure(1);
clf
set(gcf,'position',[500 400 400 500])
hold on;
% for ir=1:2
%     h = plotlayermods(region(ir).startmod(:,1),region(ir).startmod(:,3),'--');
%     set(h,'linewidth',2,'color',region(ir).color);
% end
for ir=1:2
    h = plotlayermods(region(ir).outmod(:,1),region(ir).outmod(:,3));
    set(h,'linewidth',2,'color',region(ir).color);
end
%plotlayermods(region(3).outmod(:,1),region(3).outmod(:,3),'-k');
ylim([-80 0])
% xlim([2 5])
legend('Rift Initial','Mainland Initial','Rift Final','Mainland Final','Location','SouthWest');
legend('Rift Model','Mainland Model','Location','SouthWest');
ylabel('Depth (km)','fontsize',fsize);
xlabel('Shear Velocity (km/s)','fontsize',fsize);
set(gca,'fontsize',fsize)
export_fig(['pics/',region(1).name,'_',region(2).name,'_mod'],'-transparent','-m2');


% plot disp curve fitting
figure(2)
clf
hold on;
for ir=1:2
    modh(ir)=plot(region(ir).vec_T,region(ir).phv_fwd,'--','color',region(ir).color,'linewidth',2);
    obsh(ir)=plot(region(ir).vec_T,region(ir).phv,'x','color',region(ir).color,'linewidth',2,'markersize',fsize);
    xlabel('Period (s)','fontsize',fsize);
    ylabel('Phase Velocity (km/s)','fontsize',fsize);
    xlim([5 50])
    set(gca,'fontsize',fsize)
end
legend('Rift Model Prediction','Rift Observation','Mainland Model Prediction','Mainland Observation','Location','SouthEast');
export_fig(['pics/',region(1).name,'_',region(2).name,'_dispfit'],'-transparent','-m2');

