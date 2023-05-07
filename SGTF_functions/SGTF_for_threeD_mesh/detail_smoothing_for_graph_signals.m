%Author: Masaki Onuki (masaki.o@msp-lab.org)
function [x_rho,F_rho] =detail_smoothing_for_graph_signals(g_s,y,sigma_r,rho)


g_s = triu(g_s,1);
[ci,cj] = find(g_s);

sigma_r2=-2*sigma_r*sigma_r;
g_s2=g_s.*g_s;

%----The adjacency matrix W is constructed as follows----
for i = 1:length(ci)
g_s(ci(i),cj(i)) = exp((g_s2(ci(i),cj(i)))/(sigma_r2));
end

W = g_s+g_s';

%----The graph Laplacian matrix is constructed as follows----
N = length(W);
d = sum(W,2);
d(d == 0) = 1; % for isolated nodes
d_inv = d.^(-0.5);
D_inv =spdiags(d_inv,0,N,N);
An = D_inv*W*D_inv;
L.L = speye(N) - An;

d=d.^(0.5);
D = spdiags(d,0,N,N);

%----filtering on graph spectral domain----
filterlen = 25;
filter = @(x)(trilateral_kernel(x,rho));
arange = [0 2];
c=gsp_cheby_coeff(arange, filter,filterlen,filterlen+1);

y=double(y(:));
y_nor=D*y;

L.lmax = 2;
L.N = length(L.L);
x_rho = D_inv*gsp_cheby_op(L,c,y_nor);

F_rho = gsp_cheby_op(L,c,speye(N));
