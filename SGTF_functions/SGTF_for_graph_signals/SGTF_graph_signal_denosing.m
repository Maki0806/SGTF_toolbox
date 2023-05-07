%Author: Masaki Onuki (masaki.o@msp-lab.org)
function [x_rho_opt,x_rho_non_opt,SNR_opt,SNR_not_opt,SNR_noise]=SGTF_graph_signal_denosing(G,y,x_star,sigma)

sigma_d = 1;

%The regularization parameters rho are varied from 0 to 100 in steps of 1
%for reducing the calculation time in this code. 
max_rho = 100;
rho_set=0:max_rho;

disp('Optimizing parameter rho');
Bar = waitbar(0,'Now optimizing...');
for i = 1:length(rho_set)
    perc = round(i/length(rho_set)*100,0);
    waitbar(i/length(rho_set),Bar,sprintf(['Optimization progress:', num2str(perc,4),'%%']))
    [x_rho{i},F_rho{i}]=spectral_trilateral_for_graph_signals(y,sigma_d,rho_set(i),G.A,1);   
end

for i=1:length(rho_set)
    [epsilon_m(i)] = calc_SURE(x_rho{i}.',y,sigma,F_rho{i});
end

[~,I]=sort(epsilon_m);
opt_rho = rho_set(I(1));

disp(['Optimization has been finished:Optimized_rho =',num2str(opt_rho,4)])
x_rho_opt = x_rho{I(1)};
[x_rho_non_opt,~]=spectral_trilateral_for_graph_signals(y,sigma_d,1,G.A,1);


MSE_opt = mean((x_star - x_rho_opt.').^2);
MSE_not_opt = mean((x_star - x_rho_non_opt.').^2);
MSE_noise = mean((x_star-y).^2);

P_rms = mean(x_star.*x_star);

SNR_opt = 10*log10(P_rms/MSE_opt);
SNR_not_opt = 10*log10(P_rms/MSE_not_opt);
SNR_noise = 10*log10(P_rms/MSE_noise);