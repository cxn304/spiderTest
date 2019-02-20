% A���󣬼����Ŀ��������ʱ��������
% v���ɷ�����   pcaa��ά����kά��������������ɵľ���  a��������  k����kά
function [ pcaa,V ] = fastpca( A,k )
%UNTITLED Summary of this function goes here
[r c]=size(A);
meanvec=mean(A);
A=double(A);
z=(A-repmat(meanvec,r,1));
covmatt=z*z';
[V d]=eigs(covmatt,k); % VΪ������������dΪ����ֵ����
V=z'*V;
for i=1:k
    V(:,i)=V(:,i)/norm(V(:,i));
end
pcaa=z*V;
save('pca.mat','V','meanvec');

end

