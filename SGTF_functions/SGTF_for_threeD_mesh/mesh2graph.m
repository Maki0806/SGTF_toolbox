function [Orig_signal,W,tri]=mesh2graph(range)

xyz = load('teapot_coord.txt');
xyz = xyz*range;
tri = load('teapot_tri.txt');
tri(:,1) = [];
tri = tri+1;

nn = size(xyz,1);

conn=cell(nn,1);
dim=size(tri);
for i=1:dim(1)
    for j=1:dim(2)
        conn{tri(i,j)}=[conn{tri(i,j)},i];
    end
end
count=0;
connnum=zeros(1,nn);
for i=1:nn
    conn{i}=sort(conn{i});
    connnum(i)=length(conn{i});
    count=count+connnum(i);
end

%% make weight matrix W

W = zeros(nn, nn);
for k = 1:nn
    % Find vertex neighborhood
    indt01=conn{k}; % Element indices
    indv01 = tri(indt01,:); 
    indv01 = unique(indv01(:));
    W(k, indv01) = 1;
    W(k,k) = 0;
end

G = gsp_graph(W);
G.org_signal = xyz;


Orig_signal = G.org_signal;