function [ind,zero,nzero,sign]=FindArrayZero(Xarray,Yarray,range)
% find zero crossings in variable Yarray on grid determined by Xarray
% x and Y need to be 1d arrays
epsilon = 100000;
if length(Xarray)~=length(Yarray)
    error('size of X and Y should be the same! ')
end
izero=0;
for iy=1:length(Yarray)-1
    if((Xarray(iy)>range(1))&&(Xarray(iy+1)<range(2)))
        
    if (Yarray(iy)*Yarray(iy+1)<=0)&&(abs(Yarray(iy)*Yarray(iy+1))>0)
        izero=izero+1;
        zero(izero)=Xarray(iy)+(Xarray(iy+1)-Xarray(iy))*abs(Yarray(iy))/(abs(Yarray(iy))+abs(Yarray(iy+1)));
        ind(izero)=iy+(abs(Yarray(iy))>abs(Yarray(iy+1))); 
        % choose the closer-to-zero one to be the index
        if Yarray(iy)>Yarray(iy+1)
            % determine the sign of zero crossing; +1: - -> +; -1 + -> - 
            sign(izero)=-1;
        else
            sign(izero)=1;
        end
    end
    end
end
nzero=izero;
if nzero==0
    zero=[];
    ind=[];
    sign=[];
else
    zero=zero(:);
ind=ind(:);
sign=sign(:);
end



return

end