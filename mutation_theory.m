% 突变理论
clear
%% 多项式拟合
adata=[1,1,1,1,60,60,60,1,1,1,1,60,1,1,1];
t = 0:length(adata)-1;
p=polyfit(t,adata(1,:),4);
x1 = linspace(0,length(adata)-1);
y1 = polyval(p,x1);
figure
plot(t,adata(1,:),'o')
hold on
plot(x1,y1)
hold off
%% 监测项目稳定性变化判别
tb=0;
u1=p(2)/p(4)-3/8*p(3)^2/(p(4)^2);
v1=p(1)/p(4)-p(2)*p(3)/2/p(4)^2-3/8*p(3)^2/p(4)^2;
if 8*u1^3+27*v1^2<0
    tb=tb+1;
end