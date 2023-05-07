%Author: Masaki Onuki (masaki.o@msp-lab.org)
function [SNR_SGTF,SNR_SGTF_not_opt,SNR_Noise,p_rho_opt,p_rho_not_opt]=SGTF_threeD_mesh_once(p,p_star,W)
W=sparse(W);

sigma_d = 1;

opt_rhoX = p.rhoX;
opt_rhoY = p.rhoY;
opt_rhoZ = p.rhoZ;
disp('The noisy mesh is smoothed by using optimal rhos: ')
disp(['rho for x coodinate = ',num2str(opt_rhoX,4)])
disp(['rho for y coodinate = ',num2str(opt_rhoY,4)])
disp(['rho for z coodinate = ',num2str(opt_rhoZ,4)])
[p_rho_opt(:,1),~]=spectral_trilateral_for_mesh(p.p(:,1),sigma_d,opt_rhoX,W,1);
[p_rho_opt(:,2),~]=spectral_trilateral_for_mesh(p.p(:,2),sigma_d,opt_rhoY,W,1);
[p_rho_opt(:,3),~]=spectral_trilateral_for_mesh(p.p(:,3),sigma_d,opt_rhoZ,W,1);

disp('The noisy mesh is smoothed by using rho = 1 (unoptimized parameter)')
[p_rho_not_opt(:,1),~]=spectral_trilateral_for_mesh(p.p(:,1),sigma_d,1,W,1);
[p_rho_not_opt(:,2),~]=spectral_trilateral_for_mesh(p.p(:,2),sigma_d,1,W,1);
[p_rho_not_opt(:,3),~]=spectral_trilateral_for_mesh(p.p(:,3),sigma_d,1,W,1);


MSE_SGTF = mean(mean((p_star-p_rho_opt).^2));
MSE_SGTF_not_opt = mean(mean((p_star-p_rho_not_opt).^2));
MSE_Noise = mean(mean((p_star-p.p).^2));

P_rms = mean(mean(p_star.*p_star));

SNR_SGTF = 10*log10(P_rms/MSE_SGTF);
SNR_SGTF_not_opt = 10*log10(P_rms/MSE_SGTF_not_opt);
SNR_Noise = 10*log10(P_rms/MSE_Noise);
