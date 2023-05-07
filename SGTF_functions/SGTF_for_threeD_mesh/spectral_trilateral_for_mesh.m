%Author: Masaki Onuki (masaki.o@msp-lab.org)
function [p_rho,F_rho] = spectral_trilateral_for_mesh(p,sigma_d,rho,A,gamma)

[g] =calc_gradient(A,p);

gradientMagnitude = sqrt(sum(g.^2,2));

minGrad = min(min(gradientMagnitude));
maxGrad = max(max(gradientMagnitude));
sigma_r = gamma*(maxGrad-minGrad);

%Gradient smoothing
[g_s] =gradient_smoothing_for_mesh(g,sigma_d,sigma_r);

%Smoothing with smoothed gradient
[p_rho,F_rho] =detail_smoothing_for_graph_signals(g_s,p,sigma_r,rho);