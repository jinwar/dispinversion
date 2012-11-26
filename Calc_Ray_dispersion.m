% Calculate rayleuigh wave dispersion for a multilayer strucutre.
% using propergator matrix method.
%[c, vg, grad_c, grad_vg] = Calc_Ray_dispersion(t_vec,model,num_mode,IFplot)
% 3-layer structure and a halfspace
% INPUT: 
% t_vec period of interest
% model= [thickness_vec, alpha_vec, beta_vec, rho_vec] in unitt of km/s and
% rho in unit of g/cm^3
% model_btm= [alpha_btm,beta_btm,rho_btm] 
% num_mode: number of mode to calculate, if non-exist, then return NAN.  
% IFplot: 0 or 1
% OUTPUT:
% c: matrix of phase velocity of each mode in each column
% vg: matrix of group velocity of each mode in each column
% grad_c : matrix of gradient/slope of phase velocity of each mode in each column
% grad_vg : matrix of slope of group velocity of each mode in each column 
%
function [c, vg, grad_c, grad_vg] = Calc_Ray_dispersion(t_vec,model,num_mode,IFplot)

t_vec=t_vec(:);
c=ones(length(t_vec),num_mode)*nan;

[r,c]=size(model);
model_btm = model(r,2:4);
model=model(1:r-1,:);



thickness_vec = model(:,1);
alpha_vec  = model(:,2);
beta_vec = model(:,3);
rho_vec =  model(:,4);

nlayer=length(thickness_vec);

% property of halfspace bottom 
alpha_btm = model_btm(1); 
beta_btm = model_btm(2);
rho_btm = model_btm(3);

mu_btm=rho_btm*beta_btm^2;
% --



ifreq=1;
Nkx = 2000;

f_vec=1./t_vec;

for ifreq = 1:length(f_vec)
f=f_vec(ifreq);
   
omega=2*pi*f;
    
fprintf('frequency: %f\n', f );

kxmin = omega/beta_btm;
kxmax = 4*kxmin;


kx_vec = kxmin+(kxmax-kxmin)*(0:Nkx-1)'/(Nkx-1);
c_vec = omega./kx_vec;


       
   for ikx=1:Nkx
        
          P=eye(4); % initiate prop Mtx to be identical matrix
        for ilayer=1:nlayer
            
            
        P_layer=PropMtxRay(omega,kx_vec(ikx),thickness_vec(ilayer),rho_vec(ilayer),alpha_vec(ilayer),beta_vec(ilayer));
% matrix elements w/o any simplification
        P=P_layer*P;
        end
        % construct Finv
          
          gamma = sqrt( kx_vec(ikx)^2 - (omega/alpha_btm)^2);
          eta = sqrt(kx_vec(ikx)^2 - (omega/beta_btm)^2);
          
          Finv=MakeFinvMtx(alpha_btm,beta_btm,mu_btm,kx_vec(ikx),gamma,eta);
          Finv=beta_btm/(2*alpha_btm*mu_btm*gamma*eta*omega)*Finv;
          P;
          T=Finv*P; % complete transfer matrix
          
          M(ikx,:,:)=T(3:4,1:2);
          
          R(ikx)=M(ikx,1,1)*M(ikx,2,2)-M(ikx,1,2)*M(ikx,2,1);
          
          
%plot( z, real(ux), 'r-', 'LineWidth', 3 );


%plot( z, imag(uz), 'b-', 'LineWidth', 3 );

   end
          %figure; hold on
         %plot(omega./kx_vec,R','-o');ylim([-10,10])
         %title(strcat('frequency is ',num2str(f),'Hz'))
         %[Rmin,iRmin]= min(abs(R))
         [iRmin,zero,nzero,sign]=FindArrayZero(c_vec,R,[0 6.0]);
         %[ind,zero,nzero]=FindArrayZero(Xarray,Yarray,range)
         bestkx = kx_vec(iRmin);
         R(iRmin);


         crayleigh = omega./bestkx;
         
         %lamda(ifreq)=crayleigh/f;
         if nzero>0
         for imode=1:length(crayleigh)
             if imode <= num_mode
             c(ifreq,imode) = crayleigh(length(crayleigh)+1-imode);
             end
         end
                        
         elseif nzero==0
             
             fprintf('  no solution found, check search range    ');
         end
         
         
         

         %fprintf('    C-rayleigh/beta %f\n', crayleigh/beta_btm );

% gamma and eta with best kx

%        bestgamma = sqrt( bestkx^2 - (omega/alpha_btm)^2);
%        besteta = sqrt(bestkx^2 - (omega/beta_btm)^2);

% unsimplified matrix elements best n
        M11=M(iRmin,1,1);
        M12=M(iRmin,1,2);
        M21=M(iRmin,2,1);
        M22=M(iRmin,2,2);
        
   
end
% --plot vertical axis
% calculate group velocity and wave number
c_fund=c(:,1);% fundamental mode
for imode=1:num_mode

%size(c_fund)
%size(f_vec)
vec_k=2*pi*f_vec./c(:,imode);
freq_vg = 0.5* ( f_vec(1:length(f_vec)-1)+f_vec( 2:length(f_vec)) );
vec_vg= 2*pi*diff(f_vec)./diff(vec_k);
vg(:,imode)=interp1(freq_vg,vec_vg,f_vec,'linear','extrap');

%c_overtone=interp1(f_over,c_overtone,f_vec);

slope_c=diff(c(:,imode))./diff(t_vec);
slope_vg=diff(vg(:,imode))./diff(t_vec);

mtx_slope_vg(:,imode)=interp1(freq_vg,slope_vg,f_vec,'linear','extrap')
mtx_slope_c(:,imode)=interp1(freq_vg,slope_c,f_vec,'linear','extrap')
%
end
if (IFplot)
    
figure;subplot(1,3,1);
plotlayermods(thickness_vec,[alpha_vec,beta_vec],'-',-2.5);xlim([0,10]) ;
legend('VP','VS');xlabel('km/s');ylabel('depth / km');
title('1D PROFILE');

subplot(1,3,[2 3]);

plot(1./f_vec,c,'-bo','linewidth',1.5);hold on
plot(1./f_vec,vg,'-go','linewidth',1.5)

ylim([0,5]);
ylabel('c-rayleigh / (km/s)','fontsize',15);xlabel('period / s','fontsize',15);
legend('Fundemental Rayleigh Wave','Fundamental mode group velocity ','First Overtone');

%title(strcat('Oceanic rayleigh wave dispersion with ', num2str(thickness_vec(1)),' km deep ocean '),'fontsize',15);
%rel_err=abs(c_fund-0.9194*beta_btm)./(0.9194*beta_btm);
%figure;semilogy(1./f_vec,rel_err,'-o');
end
c_fund=c_fund(:);
%c_overtone=c_overtone(:);

grad_c=mtx_slope_c;
grad_vg=mtx_slope_vg;



return 

end

