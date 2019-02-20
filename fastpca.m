% A矩阵，监测项目是列数，时间是行数
% v主成分向量   pcaa降维数后k维样本特征向量组成的矩阵  a样本矩阵  k降至k维
function [ pcaa,V ] = fastpca( A,k )
%UNTITLED Summary of this function goes here
[r c]=size(A);
meanvec=mean(A);
A=double(A);
z=(A-repmat(meanvec,r,1));
covmatt=z*z';
[V d]=eigs(covmatt,k); % V为特征向量矩阵，d为特征值矩阵。
V=z'*V;
for i=1:k
    V(:,i)=V(:,i)/norm(V(:,i));
end
pcaa=z*V;
save('pca.mat','V','meanvec');

end

