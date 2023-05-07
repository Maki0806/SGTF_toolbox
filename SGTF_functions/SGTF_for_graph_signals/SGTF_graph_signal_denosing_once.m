%Author: Masaki Onuki (masaki.o@msp-lab.org)
function [x_rho_opt,x_rho_non_opt,SNR_opt,SNR_not_opt,SNR_noise]=SGTF_graph_signal_denosing_once(G,y,x_star)

sigma_d = 1;

opt_rho = y.rho;
disp(['The noisy signal is smoothed by using optimal rho = ',num2str(opt_rho,4)])
[x_rho_opt,~]=spectral_trilateral_for_graph_signals(y.y,sigma_d,opt_rho,G.A,1);

disp('The noisy signal is smoothed by using rho = 1 (unoptimized parameter)')
[x_rho_non_opt,~]=spectral_trilateral_for_graph_signals(y.y,sigma_d,1,G.A,1);


MSE_opt = mean((x_star - x_rho_opt.').^2);
MSE_not_opt = mean((x_star - x_rho_non_opt.').^2);
MSE_noise = mean((x_star-y.y).^2);

P_rms = mean(x_star.*x_star);

SNR_opt = 10*log10(P_rms/MSE_opt);
SNR_not_opt = 10*log10(P_rms/MSE_not_opt);
SNR_noise = 10*log10(P_rms/MSE_noise);