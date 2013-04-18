function outmap = smoothmap_avg(inmap,gridnum);
% function to apply 2D running smooth on a 2D matrix

[m n] = size(inmap);
outmap = inmap;
for ix = 1:m
	for iy = 1:n
		indx = ix-gridnum:ix+gridnum;
		indx(find(indx<=0 | indx >m)) = [];
		indy = iy-gridnum:iy+gridnum;
		indy(find(indy<=0 | indy >n)) = [];
		avgmap = inmap(indx,indy);
		outmap(ix,iy) = nanmean(avgmap(:));
	end
end

return
