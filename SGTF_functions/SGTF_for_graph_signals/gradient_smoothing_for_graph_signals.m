%Author: Masaki Onuki (masaki.o@msp-lab.org)
%Smoothing gradient vector
function [g_s_nor_mat] =gradient_smoothing_for_graph_signals(g,sigma_d,sigma_r)

[ci,cj,g2] = find(triu(g,1));

[ci2,ind] = sort(ci);
cj2 = cj(ind);
g3 = g2(ind);

N1 = length(ci);

for i=1:length(g)
    Q{i}=[];
end

for i=1:length(ci)
    Q{ci2(i)} = [Q{ci2(i)};i];
end

sigma_d2 = 2*sigma_d*sigma_d;
sigma_r2=-2*sigma_r*sigma_r;
temp = [];
ci3 = [];
cj3 = [];

%----The adjacency matrix W^g is constructed as follows----
for i=1:length(ci)
    if ~isempty(Q{cj2(i)}) && ~isempty(Q{ci2(i)})
        for j=1:length(Q{cj2(i)})
            ci3=[ci3;i];
            cj3=[cj3;Q{cj2(i)}(j)];
            temp = [temp;exp(-1/(sigma_d2))*exp((g3(i)-g3(Q{cj2(i)}(j))).^2/(sigma_r2))];
        end
    end
end
W_g = sparse([ci3,cj3],[cj3,ci3],[temp;temp],N1,N1);

%----The graph Laplacian matrix for the gradient graph is constructed as follows----
d_g = sum(W_g,2);
d_g(d_g == 0) = 1; % for isolated nodes
d_g_inv = d_g.^(-0.5);
D_g_inv = spdiags(d_g_inv,0,N1,N1);
An = D_g_inv*W_g*D_g_inv;
L.L = speye(N1) - An;


d_g=d_g.^(0.5);
D = spdiags(d_g,0,N1,N1);

%----filtering on graph spectral domain----
filterlen = 25;
filter = @(x)(trilateral_kernel_low(x));
arange = [0 2];
c=gsp_cheby_coeff(arange, filter,filterlen,filterlen+1);

g_nor=D*g3;

L.lmax = 2;
L.N = length(L.L);
g_s_nor =D_g_inv*gsp_cheby_op(L,c,g_nor);

grad_smooth_pro(ind)=g_s_nor;

N=length(g);

g_s_nor_mat = sparse([ci,cj],[cj,ci],[grad_smooth_pro;grad_smooth_pro],N,N);