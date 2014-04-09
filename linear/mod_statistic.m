function [depth_nodes avg_vel_prof std_vel_prof] = mod_statistic(vec_hs,mods);

setup_parameters;

depth_nodes = parameters.depth_nodes;
vec_nodes = parameters.vec_nodes;

[depthN testN] = size(vec_hs);

[xi yi] = ndgrid(depth_nodes,vec_nodes);
mod_dens = zeros(length(depth_nodes),length(vec_nodes));

for itest = 1:testN
	depth_prof = cumsum(vec_hs(:,itest));
	depth_ind = find(depth_nodes < depth_prof(1));
	[temp vel_ind] = min(abs(vec_nodes - mods(1,itest)));
	mod_dens(depth_ind,vel_ind) = mod_dens(depth_ind,vel_ind) + 1;
	% vertical density
	for ilayer = 2:depthN
		depth_ind = find(depth_nodes<=depth_prof(ilayer) & depth_nodes>depth_prof(ilayer-1) );
		[temp vel_ind] = min(abs(vec_nodes - mods(ilayer,itest)));
		if isempty(depth_ind) continue; end
		mod_dens(depth_ind,vel_ind) = mod_dens(depth_ind,vel_ind) + 1;
	end
	% horizontal density
	for ilayer = 2:depthN
		if mods(ilayer,itest)==mods(ilayer-1,itest) continue; end
		[temp depth_ind] = min(abs(depth_nodes - depth_prof(ilayer-1)));
		vec_jump = [mods(ilayer-1,itest) mods(ilayer,itest)];
		[temp vel_ind] = find(vec_nodes>=min(vec_jump) & vec_nodes<max(vec_jump));
		if isempty(vel_ind) continue; end
%		mod_dens(depth_ind,vel_ind) = mod_dens(depth_ind,vel_ind) + 1;
	end
end

for ilayer = 1:size(mod_dens,1)
	[temp velinds] = find(mod_dens(ilayer,:)>0);
	vels = vec_nodes(velinds);
	weights = mod_dens(ilayer,velinds);
	avg_vel_prof(ilayer) = sum(vels.*weights)./sum(weights);
	std_vel_prof(ilayer) = var(vels,weights)^0.5;
end

avg_vel_prof = smooth(avg_vel_prof,5);
std_vel_prof = smooth(std_vel_prof,5);

%figure(38)
%clf
%hold on
%cmap = colormap('gray');
%cmap = flipud(cmap);
%colormap(cmap);
%contourf(yi,-xi,mod_dens)
%shading flat
%plot(avg_vel_prof,-depth_nodes,'r')
%plot(avg_vel_prof+std_vel_prof,-depth_nodes,'r')
%plot(avg_vel_prof-std_vel_prof,-depth_nodes,'r')
%caxis([0 testN/20]);
%colorbar
