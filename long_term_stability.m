clear
%%  材料属性,是需要输入的数据
% 混凝土强度等级：C60
% 混凝土弹性模量：3.55*10^4N/mm2 
% 混凝土强度标准值：fck=60N/mm2,ftk=6N/mm2
% 管片截面面积： 21.98m2
% 管片单位长度截面惯性矩：1/12*1*t^3=2.858*(10^-2)m3;
% 抗弯刚度有效系数：0.8 
% 弯矩增大率：0.3 
% 细砂和粉质黏土都视为不透水层，计算时采用水土合算,这里因细砂层的空隙比、天然含水量均无统计资料，----
% 计算时以天然重度近似为饱和重度
% K0  水平土压力和垂直土压力之比；
% j  土的内摩擦角；
% p0  上覆荷载；指每层都要计算的上附荷载 kPa
% g  土的重度；kN/m3 
% H  当前土层厚度 m
fck=60; % 混凝土抗压强度MPa
ftk=6; % 混凝土抗拉强度MPa
t=0.6; % 管片厚度（m）
b = 2; % 管片计算宽度（m）
I=1/12*t^3; % 惯性矩
l=0.48; % 该土层试验测得的静止侧压力系数
p0=[560,0,0];  %第一个为砂土上附荷载(这里为假设），第二个为黏土上附荷载
g=[20,19.8]; % 每层土重度（kN/m3）
j=pi/6; % 土的内摩擦角
c=[0,44.3];  % 土的黏着力：kPa
K0=1;  % 在涵洞顶一般水平土压力和垂直土压力之比取1
R0=14.5/2; % R0为管道总半径
B1=R0*cot((pi/4+j/2)/2); % 计算Terzaghi松动土压需要的系数 
H=[7.3,7];   % 当前土层厚度假设值（m），这里为两层,用的是扬子江隧道的数据
%%  外载计算
for i=1:2 % 两层土
    pv=B1*(g(i)-c(i)/B1)/(K0*tan(j))*(1-exp(-K0*tan(j)*H(i)/B1))+p0(i)*exp(-K0*tan(j)*H(i)/B1);  % pv:Terzaghi松动土压
    p0(i+1)=pv; % 此层土压传递给下层
end
ph=[l*pv,l*(pv+20*(t/2+2*(R0-t/2)))];  % 侧向土压力，1为侧向均布荷载，2-1为侧向三角形荷载
gcq(1)=2600/100*t;  % 一次衬砌重度-简化后的公式
gcq(2)=2600/100*(t/2);   % 二次衬砌重度
% h:0.8为圆环刚度有效系数
% R0-t/2为结构计算半径
% Kh为竖向地层弹性反力系数,30Mpa(可改动）
ybw=((2*pv-ph(1)-ph(2)+pi*gcq(1))*10^3*(R0-t/2)^4)/(24*(0.8*3.55*10^10*I+0.0454*30*10^6*(R0-t/2)^4)); % 隧道水平直径处的最大变位
pk=30*10^3*ybw;  % kPa  侧向地层抗力
M=zeros(19,6);  % 各弯矩，最后一列为截面弯矩
N=zeros(19,6);  % 各轴力，最后一列为截面轴力
theta=0:pi/18:pi;
hezai=[gcq(1),pv,ph(1),ph(2)-ph(1),pk]; % 自重，竖向荷载，水平荷载，三角形侧压，地层抗力
%% 弯矩计算
% 1-5列为自重，竖向荷载，水平荷载，三角形侧压，地层抗力
for i=1:19
    if theta(i)>=0 && theta(i)<pi/2
        M(i,1)=(3/8*pi-theta(i)*sin(theta(i))-5/6*cos(theta(i)))*hezai(1)*(R0-t/2)^2;
    else
        M(i,1)=(-1/8*pi+(pi-theta(i))*sin(theta(i))-5/6*cos(theta(i))-0.5*pi*sin(theta(i))^2)*hezai(1)*(R0-t/2)^2;
    end
end
    M(:,2)=0.25*(1-2*sin(theta).^2)*hezai(2)*(R0-t/2)^2;
    M(:,3)=0.25*(1-2*cos(theta).^2)*hezai(3)*(R0-t/2)^2;
    M(:,4)=1/48*(6-3*cos(theta)-12*cos(theta).^2+4*cos(theta).^3)*hezai(4)*(R0-t/2)^2;
for i=1:19
    if i<=10
        if theta(i)>=0 && theta(i)<pi/4
            M(i,5)=(0.2346-0.3536*cos(theta(i)))*hezai(5)*(R0-t/2)^2;
        elseif theta(i)>=pi/4 && theta(i)<=pi/2
            M(i,5)=(-0.3487+0.5*sin(theta(i))^2+0.2357*cos(theta(i))^3)*hezai(5)*(R0-t/2)^2;
        end
    else
        M(i,5)=M(20-i,5);
    end
end
for i=1:19
    M(i,6)=sum(M(i,1:5));
end
%% 轴力计算
% 1-5列为自重，竖向荷载，水平荷载，三角形侧压，地层抗力
for i=1:19
    if theta(i)>=0 && theta(i)<pi/2
        N(i,1)=(theta(i)*sin(theta(i))-1/6*cos(theta(i)))*hezai(1)*(R0-t/2);
    else
        N(i,1)=(-pi*sin(theta(i))-theta(i)*sin(theta(i))+pi*sin(theta(i))^2-1/6*cos(theta(i)))*hezai(1)*(R0-t/2); 
    end
end
    N(:,2)=hezai(2)*(R0-t/2)*sin(theta).^2;
    N(:,3)=hezai(3)*(R0-t/2)*cos(theta).^2;
    N(:,4)=1/16*(cos(theta)+8*cos(theta).^2-4*cos(theta).^3)*hezai(4)*(R0-t/2);
for i=1:19
    if i<=10
        if theta(i)>=0 && theta(i)<pi/4
            N(i,5)=0.3536*hezai(5)*(R0-t/2)*cos(theta(i));
        elseif theta(i)>=pi/4 && theta(i)<=pi/2
            N(i,5)=(-0.7071*cos(theta(i))+cos(theta(i))^2+0.7071*cos(theta(i))*sin(theta(i))^2)*hezai(5)*(R0-t/2);
        end
    else
        N(i,5)=N(20-i,5);
    end
end
for i=1:19
    N(i,6)=sum(N(i,1:5));
end
%% 经时变化,直接提取劣化模型数据
% 碳化深度影响，混凝土结构耐久性与寿命预测-牛荻涛第21页。基于混凝土强度碳化深度模型
% fckn=fck*1.4529*exp(-0.0246*(log(1:100)-1.7154).^2);  
load dgRatio % bili
fckn = fck*bili;
ftkn = ftk*bili;
%%  安全系数计算  公路隧道设计规范
e0=abs(M(:,6)./N(:,6)); % 轴向力偏心距
K=zeros(19:1); % 安全系数0度到180度共19个数据
alfa=1+0.648*e0./t-12.569*(e0./t).^2+15.444*(e0./t).^3; % 轴向力偏心影响系数
ti = 1:length(bili); % 经年变化
for i=1:19  % 每个截面安全系数
    if e0(i)<=0.2*t
        K(i,:)=alfa(i)*fckn*1000*t*b/N(i,6);
    else
        K(i,:)=1.75*ftkn*t*1000*b/(N(i,6)*(6*e0(i)/t-1));
    end
end
huatu(M,N,K,theta,ti)
temp=table(M);
writetable(temp,'弯矩.csv');  % 写数据成csv
%% 绘图
function [] = huatu(M,N,K,theta,ti)
    tuli = {'自重','竖向荷载','水平荷载','三角形侧压','地层抗力','合力'}; % 要把字符分成一组一组，最好用元胞数组
    xianxing = {'-o','-+','-*','-x','-s','-d'}; % 要把字符分成一组一组，最好用元胞数组
    subplot(2,2,1);
    for i = 1:6
        plot(theta,M(:,i),xianxing{i})
        hold on
    end
    title ('隧道截面弯矩');
    xlabel('隧道截面角度(rad)')
    ylabel('Moment(KN*m)')
    legend(tuli)
    subplot(2,2,2); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:6
        plot(theta,N(:,i),xianxing{i})
        hold on
    end   
    title ('隧道截面轴力');
    xlabel('隧道截面角度(rad)')
    ylabel('axial Force(KN)')
    legend(tuli)
    subplot(2,2,3); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot(ti,K(K(:,100)==min(K(:,100)),:),'-o')
    weizhi = find(K(:,100)==min(K(:,100)));
    title ('截面最小安全系数经时变化');
    xlabel('t/(year)')
    ylabel('安全系数')
    jiaodu = round((weizhi-1)*10);
    jiaodu = sprintf('%d°位置安全系数(顶部为0°)',jiaodu);
    legend(jiaodu)
    subplot(2,2,4); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot(theta,K(:,100),'-*')
    title ('100年时刻截面各处安全系数');
    xlabel('管片截面(rad)')
    ylabel('安全系数')
end
