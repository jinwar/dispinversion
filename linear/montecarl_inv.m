function inv_struct = montecarl_inv(data_str);

make_par_surf96('R');
setup_parameters;

% parameter setup
test_N = parameters.testN;
crusth_var = parameters.crusth_var;
sedh_var = parameters.sedh_var;
velocity_var = parameters.velocity_var;
r = parameters.r;

sedlayernum = parameters.sedlayernum;
crustlayernum = parameters.crustlayernum;
mantle_layer_thickness = parameters.mantle_layer_thickness;
vpvs = parameters.vpvs;

% obtain the dispersion curve
velT = data_str.periods;
phv = data_str.phv;
phvstd = data_str.phvstd;
grv = data_str.grv;
grvstd = data_str.grvstd;
topo = data_str.topo;

% run the tests
for itest = 1:test_N
	clear vec_h vec_vs vec_vp vec_rho initmodel
	% reset the initial model
	crustv = data_str.crustv;
	crusth = data_str.crusth;
	sedh = data_str.sedh;
	sedv = data_str.sedv;
	mantlev = data_str.mantlev;
	% proturb the model
	crustv = ((-1 + 2*rand())*velocity_var+1)*crustv;
	sedv = ((-1 + 2*rand())*velocity_var+1)*sedv;
	mantlev = ((-1 + 2*rand())*velocity_var+1)*mantlev;
	sedh = sedh + (-1 + 2*rand())*sedh_var;
	crusth = crusth + (-1 + 2*rand())*crusth_var;
	% setup the model and start inverse
	layernum = 0;
	for ilayer = 1:sedlayernum
		layernum = layernum+1;
		vec_h(layernum) = sedh./sedlayernum;
		vec_vs(layernum) = sedv;
		vec_rho(layernum) = 2.7;
	end
	for ilayer = 1:crustlayernum
		layernum = layernum+1;
		vec_h(layernum) = (crusth-sedh)./crustlayernum;
		vec_vs(layernum) = crustv;
		vec_rho(layernum) = 2.7;
	end
	for ilayer = 1:length(mantle_layer_thickness)
		layernum = layernum+1;
		vec_h(layernum) = mantle_layer_thickness(ilayer);
		vec_vs(layernum) = mantlev;
		vec_rho(layernum) = 3.3;
	end
	vec_vp = vec_vs*vpvs;
	initmodel(:,1) = vec_h(:);
	initmodel(:,2) = vec_vp(:);
	initmodel(:,3) = vec_vs(:);
	initmodel(:,4) = vec_rho(:);
	if topo < -1000
		waterdepth = -topo/1e3;
		initmodel = [waterdepth 1.5 0 1;initmodel];
	else
		waterdepth = 0;
	end
	h_crust = crusth;
%			h_crust = -1;
	err = disperr(velT,phv,phvstd,grv,grvstd,initmodel);
	if err > 0.3
		errors(itest) = 99;
		continue;
	end
	
	try
	[outmod phv_fwd] = invdispR(velT,phv,phvstd,grv,grvstd,initmodel,h_crust,waterdepth,10);
	catch
		disp('Error in inversion');
		outmod = [];
		phv_fwd = [];
	end
	if ~isempty(outmod)
	misfit = (phv_fwd(:)-phv(:));
	rms=sqrt(sum(misfit.^2)/length(velT))
	final_mods(:,itest) = outmod(:,3);
	init_mods(:,itest) = initmodel(:,3);
	vec_hs(:,itest) = outmod(:,1);
	phv_fwds(:,itest) = phv_fwd(:);
	errors(itest) = rms;
	else
		errors(itest) = 99;
	end
end
if size(init_mods,2) < length(errors)
	final_mods(:,test_N) = 0;
	init_mods(:,test_N) = 0;
	vec_hs(:,test_N) = 0;
	phv_fwds(:,test_N) = 0;
end

% find bad inversions
error_tol = median(errors(find(errors<0.3)))*(1+r);
bad_test_ind = find(errors > error_tol);
errors(bad_test_ind) = [];
init_mods(:,bad_test_ind) = [];
final_mods(:,bad_test_ind) = [];
vec_hs(:,bad_test_ind) = [];
phv_fwds(:,bad_test_ind) = [];
test_N = test_N - length(bad_test_ind);

[depth_node init_avg init_std] = mod_statistic(vec_hs,init_mods);
[depth_node final_avg final_std] = mod_statistic(vec_hs,final_mods);

inv_struct.final_mods = final_mods;
inv_struct.init_mods = init_mods;
inv_struct.vec_hs = vec_hs;
inv_struct.phv_fwds = phv_fwds;
inv_struct.errors = errors;
inv_struct.init_avg = init_avg;
inv_struct.final_avg = final_avg;
inv_struct.init_std = init_std;
inv_struct.final_std = final_std;
inv_struct.depth_node = depth_node;
