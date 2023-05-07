%Author: Masaki Onuki (masaki.o@msp-lab.org)
function h = trilateral_kernel(x,rho)
n = length(x);
h = zeros(n,1);

for i=1:n
    h(i)=1/(1+rho*x(i)*x(i));
end
h = h';
end
