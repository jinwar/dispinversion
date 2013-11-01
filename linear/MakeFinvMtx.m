function  Finv=MakeFinvMtx(alpha,beta,mu,kx,gamma,eta)
f=zeros(4,4);
f(1,1)=2*beta*mu*kx*gamma*eta;
f(1,2)=-beta*mu*eta*(kx^2+eta^2);
f(1,3)=-beta*kx*eta;
f(1,4)=beta*gamma*eta;
f(2,1)=-alpha*mu*gamma*(kx^2+eta^2);
f(2,2)=2*alpha*mu*kx*gamma*eta;
f(2,3)=alpha*gamma*eta;
f(2,4)=-alpha*kx*gamma;
f(3,1)=2*beta*mu*kx*gamma*eta;
f(3,2)=-f(1,2);
f(3,3)=-f(1,3);
f(3,4)=f(1,4);
f(4,1)=f(2,1);
f(4,2)=-f(2,2);
f(4,3)=-f(2,3);
f(4,4)=f(2,4);
Finv=f;

return
end