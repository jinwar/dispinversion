function p=PropMtxRay(omega,kx,h,rho,alpha,beta) 

% Calcualting Propagator Matrix for Rayleigh wave (P-SV wave) for any sinlge
% layer
% h: thickness
% alpha:vp
% beta: vs 
% P: 4*4 matrix
%
P=zeros(4,4);

if (kx.^2 - (omega/alpha)^2 > 0)
    
gamma = sqrt( kx.^2 - (omega/alpha)^2);
else 
gamma = -sqrt((omega/alpha)^2-kx.^2 ) * i;    
end

if (sqrt(kx.^2 - (omega/beta)^2) > 0)
eta = sqrt(kx.^2 - (omega/beta)^2);
else
    eta = -sqrt((omega/beta)^2-kx.^2 ) * i;    
    
end

 mu=rho*beta^2;  % shear modulus 

% Construct propagator matrix for a single layer
% reference, Aki and Richards Quantiative Seismology 2nd Ed. pp 273
p(1,1)=1+2*(mu/(omega^2)/rho)*(2*(kx^2)*(sinh(gamma*h/2))^2-(kx^2+eta^2)*(sinh(eta*h/2))^2);
p(1,2)=(kx*mu/(omega^2)/rho)*((kx^2+eta^2)/gamma*(sinh(gamma*h))-2*eta*sinh(eta*h));
p(1,3)=1/(omega^2)/rho*(kx^2/gamma*(sinh(gamma*h))-eta*sinh(eta*h));
p(1,4)=2*kx/(omega^2)/rho*((sinh(gamma*h/2))^2-(sinh(eta*h/2))^2);
p(2,1)=(kx*mu/(omega^2)/rho)*((kx^2+eta^2)/eta*(sinh(eta*h))-2*gamma*sinh(gamma*h));
p(2,2)=1+2*(mu/(omega^2)/rho)*(2*kx^2*(sinh(eta*h/2))^2-(kx^2+eta^2)*(sinh(gamma*h/2))^2);
p(2,3)=-p(1,4);
p(2,4)=1/(omega^2)/rho*(kx^2/eta*sinh(eta*h)-gamma*sinh(gamma*h));
p(3,1)=(mu^2/(omega^2)/rho)*(4*kx^2*gamma*sinh(gamma*h)-(kx^2+eta^2)^2/eta*sinh(eta*h));
p(3,2)=2*mu^2*(kx^2+eta^2)*p(1,4);
p(3,3)=p(1,1);
p(3,4)=-p(2,1);
p(4,1)=-p(3,2);
p(4,2)=(mu^2/(omega^2)/rho)*(4*kx^2*eta*sinh(eta*h)-(kx^2+eta^2)^2/gamma*sinh(gamma*h));
p(4,3)=-p(1,2);
p(4,4)=p(2,2);
return
end
