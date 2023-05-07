%Author: Masaki Onuki (masaki.o@msp-lab.org)
%Calculating gradient of each nodes
function [bptG] =calc_gradient(bptG,Data2)

N1 = length(bptG);

[ci,cj] = find(triu(bptG,1));

N=length(ci);

temp = [];


for i=1:N
temp=[temp;Data2(cj(i))-Data2(ci(i))];
end

bptG = sparse([ci,cj],[cj,ci],[temp;temp],N1,N1);