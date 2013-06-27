function out_vs = depth_interp(depth_prof,vec_h,vec_vs)
%% function to interp the depth_prof from model output

vec_dep = cumsum(vec_h);
vec_dep = [0;vec_dep(:)];
vec_vs = [vec_vs(1);vec_vs(:)];
out_vs = zeros(size(depth_prof));

for id = 1:length(depth_prof)
	islarge = depth_prof(id) < vec_dep;
	ind = find(islarge,1);
	if ~isempty(ind)
		out_vs(id) = vec_vs(ind);
	else
		out_vs(id) = vec_vs(end);
	end
end


