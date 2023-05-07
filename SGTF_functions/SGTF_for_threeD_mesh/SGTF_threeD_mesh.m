%Author: Masaki Onuki (masaki.o@msp-lab.org)
function [SNR_SGTF,SNR_SGTF_not_opt,SNR_Noise,p_rho_opt,p_rho_not_opt]=SGTF_threeD_mesh(p,p_star,W,sigma)
W=sparse(W);

sigma_d = 1;

max_rho = 50;
rho_set=1:max_rho;

disp('Optimizing parameter rho');
Bar = waitbar(0,'Now optimizing...');
for i = 1:length(rho_set)
    perc = round(i/length(rho_set)*100,0);
    waitbar(i/length(rho_set),Bar,sprintf(['Optimization progress:', num2str(perc,4),'%%']))
    [p_rho_opt1{i},F_rho1{i}]=spectral_trilateral_for_mesh(p(:,1),sigma_d,rho_set(i),W,1);
    [p_rho_opt2{i},F_rho2{i}]=spectral_trilateral_for_mesh(p(:,2),sigma_d,rho_set(i),W,1);
    [p_rho_opt3{i},F_rho3{i}]=spectral_trilateral_for_mesh(p(:,3),sigma_d,rho_set(i),W,1);
end

for i=1:length(rho_set)
    [epsilon_m1(i)] = calc_SURE(p_rho_opt1{i},p(:,1),sigma,F_rho1{i});
    [epsilon_m2(i)] = calc_SURE(p_rho_opt2{i},p(:,2),sigma,F_rho2{i});
    [epsilon_m3(i)] = calc_SURE(p_rho_opt3{i},p(:,3),sigma,F_rho3{i});
end

[~,I1]=sort(epsilon_m1);
[~,I2]=sort(epsilon_m2);
[~,I3]=sort(epsilon_m3);
opt_rho1 = rho_set(I1(1));
opt_rho2 = rho_set(I2(1));
opt_rho3 = rho_set(I3(1));

disp('Optimization has been finished')
disp(['Optimized_rho (x coodinate) =',num2str(opt_rho1,4)])
disp(['Optimized_rho (y coodinate) =',num2str(opt_rho2,4)])
disp(['Optimized_rho (z coodinate) =',num2str(opt_rho3,4)])
p_rho_opt(:,1) = p_rho_opt1{I1(1)};
p_rho_opt(:,2) = p_rho_opt2{I2(1)};
p_rho_opt(:,3) = p_rho_opt3{I3(1)};

p_rho_not_opt(:,1) = p_rho_opt1{1};
p_rho_not_opt(:,2) = p_rho_opt2{1};
p_rho_not_opt(:,3) = p_rho_opt3{1};


MSE_SGTF = mean(mean((p_star-p_rho_opt).^2));
MSE_SGTF_not_opt = mean(mean((p_star-p_rho_not_opt).^2));
MSE_Noise = mean(mean((p_star-p).^2));

P_rms = mean(mean(p_star.*p_star));

SNR_SGTF = 10*log10(P_rms/MSE_SGTF);
SNR_SGTF_not_opt = 10*log10(P_rms/MSE_SGTF_not_opt);
SNR_Noise = 10*log10(P_rms/MSE_Noise);
