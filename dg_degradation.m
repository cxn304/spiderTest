% rebar degradation 锈蚀盾构管片承载力计算模型
%% 一般参数
clear
n = 8; % 受拉钢筋根数
di = 12; % 第i根钢筋的钢筋直径mm
Asi = pi*(di/2)^2; % 截面面积mm2
kcr = 1; % 钢筋位置修正系数，中部钢筋取1.6，边上钢筋取1.0
kce = 3.5; % 小环境条件修正系数，杭州取3.5
T = 17; % 环境温度
c = 25; % 混凝土保护层厚度mm,地铁设计规范,25或30
fcu = 50; % 混凝土立方体抗压强度MPa
RH = 0.71; % 环境湿度
mc = 1.2; % mc是混凝土立方体抗压强度平均值与标准值比值，这个要查实际数据.我先取1.1表示混凝土经时变化后强度有增长
Kmc = 1.5;  % Kmc表示不定性随机变量，初始取1，往往是当有实验结果和计算结果之后，对模型进行修正加上的一个系数。
Kme2 = 1; % 锈胀开裂后钢筋锈蚀深度计算模式不定性系数
Kmcr = 0.9; % 锈胀开裂时钢筋锈蚀深度计算模式不定性系数
Kme1 = 1.5; % 混凝土保护层锈胀开裂前锈蚀深度计算模式不定性系数。
fy = 400; % 三级钢屈服强度Mpa
h0 = 600; % 管片厚度0.6m
b = 1000; % 管片宽度1.0m
fc = fcu/1.4; % 轴心抗压强度
afa1 = 1; % 混凝土规范6.2.6
%% 钢筋开始锈蚀时间 皆为一般参数确定后的常量,是随机模型.
% 这一部分应该没有大问题
% 碳化系数根据数据测量差别不大，量纲是正确的
% k这个混凝土碳化系数，要再找多方面资料，关于Kmc的，需要有实际数据支撑。
% fcu是随时程变化的变量，我暂且用常量来表示。。。。。
k = 2.56*Kmc*1*1.2*1.2*1.1*T^0.25*(1-RH)*RH*(58/fcu*mc-0.76); % 前面几个系数参考牛-p27，"mc对结果影响极其大"，常量。
x0 = 4.86*(-RH^2+1.5*RH-0.45)*(c-5)*(log(fcu)-2.3); % 碳化残量,这里书上是fcuk，fcuk应该是抗压强度标准值就是标号。
% 碳化残量指钢筋开始锈蚀时，碳化区到钢筋的距离。
ti = ((c-x0)/k)^2; % 钢筋开始锈蚀时间!!!!!
%% 锈蚀深度计算 锈胀开裂前 这一部分调参通过
% 裂缝宽度为0.1mm定义为混凝土开裂，此时锈蚀量为deltacr。牛-p81中建材所钢筋平均锈蚀深度为0.02mm。
% 考虑到使用的是强度比较高的混凝土，暂时先将Kmcr定义为0.9，则混凝土开裂时-钢筋平均锈蚀深度为0.06mm。
lamdae1 = 46*kcr*kce*exp(0.04*T)*(RH-0.45)^0.6667*c^(-1.36)*fcu^(-1.83); % 锈胀开裂前的钢筋锈蚀速度,(mm/年)牛-p75。常数
deltacr = Kmcr*kcr*(0.008*c/di+0.00055*fcu+0.022); % 保护层锈胀开裂时钢筋锈蚀深度，常数。调参后也是合理范围
tcr = deltacr/lamdae1; % 锈胀开裂时间，常数
deltaci = lamdae1*(tcr-ti); % 这个量是按照锈蚀速度推导的tcr时钢筋腐蚀量，与“牛”书中的deltacr不同，
% 所以此时会使钢筋经时腐蚀量发生突变
%% 主程序，时程变化承载力计算
msu = zeros(1,100); % 100年的承载力
Ase = zeros(1,100); % 100年的等效截面面积
xh = zeros(1,100); % 100年的混凝土受压区高度
xssd = zeros(1,100); % 100年的混凝土锈蚀深度
for t = 1:100
    i = int16(t);
    if t<=tcr
        if t<ti
            deltaei = 0;
        else
            deltae1 = Kme1*lamdae1*(t-ti); % 保护层开裂前,锈胀开裂前的钢筋锈蚀深度，牛-p75。
            deltaei = deltae1; % 保护层开裂前的钢筋锈蚀深度赋值给-----当前的钢筋锈蚀深度.这个变量是要随时间变化的，是一个数组。
        end
    elseif t>tcr % 锈蚀深度计算 锈胀开裂后,此时会让deltaei发生突变，不过变化量不大,原因在deltaci那一行
        if lamdae1>0.008
            deltae2 = deltacr+Kme2*2.5*lamdae1*(t-tcr); % 保护层锈胀开裂后钢筋锈蚀深度
            deltaei = deltae2;
        else
            deltae2 = deltacr+Kme2*(4*lamdae1-187.5*lamdae1^2)*(t-tcr);
            deltaei = deltae2; % 当前的钢筋锈蚀深度
        end
    end
    xssd(i) = deltaei;
    Ase(i) = n*jmmj(deltaei,di,deltacr,Asi); % 等效截面面积计算mm2,前面有个n表示几根钢筋
    xh(i) = Ase(i)*fy/afa1/fc/b; % 混凝土受压区高度
    msu(i) = afa1*fc*b*xh(i)*(h0-xh(i)/2); % 锈蚀管片正截面承载力
end
huatu(t,msu)
bili = msu/msu(1);
save ('dgRatio.mat','bili');
%% 绘图
function [] = huatu(t,msu)
    tii = 1:t;
    scolor = linspace(1,100);
    scatter(tii,msu,25,scolor,'filled');
    hold on 
    plot(tii,msu)
    title ('The time-varying model of Concrete strength');
    xlabel('t/a')
    ylabel('structure reactance(Pa)')
end
%% 协同工作系数计算
function [ksi] = xtgz(deltaei,deltacr)
    if deltaei<=deltacr
        ksi = 1;
    elseif deltaei>deltacr && deltaei<=0.3
        ksi = 1-0.85*(deltaei-deltacr); % 测试当deltaei=0.3时，ksi=0.7956.与0.745+0.7*deltacr相当
    else
        ksi = 0.745+0.7*deltacr; % 注意，这里是个常数
    end
end
%% 锈蚀钢筋截面损失率/等效截面面积计算
% 对于这个函数，根据现有模型计算出来的当截面损失率在8.4%时，承载力下降20.7%.与书中吻合比较好
% 说明这个函数适用性是可以的。
% 单根钢筋的截面损失率计算。
function [Ase] = jmmj(deltaei,di,deltacr,Asi)
    etas = 4*deltaei/di; % 钢筋锈蚀截面损失率
    ksi = xtgz(deltaei,deltacr);
    if etas<=0.05  % 这里经过我修改公式，之前的有突变
        afasi = 1-1.01*etas;
    elseif etas>0.05 && etas<=0.15 % 钢筋锈蚀截面损失率大于0.15后，则判断失效？？？？？
        afasi = 1-1.077*etas;
    end
    Ase = ksi*afasi*Asi; % 受拉钢筋等效截面面积,
end