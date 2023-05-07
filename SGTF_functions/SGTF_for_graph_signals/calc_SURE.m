%Author: Masaki Onuki (masaki.o@msp-lab.org)
function [epsilon_m] = calc_SURE(F_rho_y,y,sigma,F_rho)

y=double(y);

Mse_F_rho_y = mean((F_rho_y-y).^2);
div_F_rho = trace(F_rho);
 
epsilon_m = Mse_F_rho_y + 2*(sigma^2)*div_F_rho/(length(y))-sigma^2;