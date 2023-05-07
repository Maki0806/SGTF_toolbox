%Author: Masaki Onuki (masaki.o@msp-lab.org)
function h = trilateral_kernel_low(x)
n = length(x);
h = zeros(n,1);

for i=1:n
    h(i)=exp(-(x(i)^2)/(2));
end
h = h';
end
