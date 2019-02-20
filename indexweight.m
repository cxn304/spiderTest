%% 评价指标权重计算，a代表各个指标的重要性程度列阵，列阵格式为1行n列，数值越大重要性程度越高
% 返回归一化的重要性程度列阵
function [rweight]=indexweight(a)   
cd=length(a);
C=zeros(cd,cd);
O=zeros(cd,cd);
A=zeros(cd,cd);
for i=1:cd
    for j=1:cd
        if a(i)>a(j)
            C(i,j)=1;
        elseif a(i)<a(j)
            C(i,j)=-1;
        end
    end
end
for i=1:cd
    for j=1:cd
        O(i,j)=(sum(C(i,:))+sum(C(:,j)))/cd;
        A(i,j)=exp(O(i,j));
    end
end
[x,y]=eig(A);%求矩阵的特征值和特征向量，x为特征向量矩阵，y为特征值矩阵。
eigenvalue=diag(y);%求对角线向量
lamda=max(eigenvalue);%求最大特征值
for i=1:length(A)%求最大特征值对应的序数
    if lamda==eigenvalue(i)
        break;
    end
end
y_lamda=x(:,i);%求矩阵最大特征值对应的特征向量
rweight = y_lamda/sum(y_lamda); %归一化权重函数,输出量,就是权向量W
end
