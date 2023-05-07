%Author: Masaki Onuki (masaki.o@msp-lab.org)
function [x_rho,F_rho] = spectral_trilateral_for_graph_signals(y,sigma_d,rho,A,gamma)

[g] =calc_gradient(A,y);

gradientMagnitude = sqrt(sum(g.^2,2));

minGrad = min(min(gradientMagnitude));
maxGrad = max(max(gradientMagnitude));
sigma_r = gamma*(maxGrad-minGrad);

[g_s] =gradient_smoothing_for_graph_signals(g,sigma_d,sigma_r);
[x_rho,F_rho] =detail_smoothing_for_graph_signals(g_s,y,sigma_d,sigma_r,rho,A);