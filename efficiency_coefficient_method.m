%% efficiency_coefficient_method ��Чϵ����
%% ԭʼ������Ƭ
clear
Data = readtable('Result.csv'); % �ô˷�����ȡcsv�ļ����table��ʽ
node_id = Data{:,3}; % ע���ǻ�����
monitor_item = Data{:,4}; % ע���ǻ�����
monitor_value = Data{:,5};
monitor_time = Data{:,6};
% zongsj = length(monitor_item);
Monitoring = unique(monitor_item(1:500)); % ���Դ���unique�����������һ�������в�ͬԪ��
% Monitoring(1) = monitor_item(1); % ���������Ŀ�����б�
% for i = 2:500
%     if sum(strcmp(Monitoring,monitor_item(i))) == 0 % ��������Ŀ����Monitoring�����У����������Ͼ���
%         j = j+1;
%         Monitoring(j) = monitor_item(i);
%     end
% end
itemsl = length(Monitoring);
jihe = cell(3,itemsl); % �������Ŀ��Ƭ��Ԫ������һ�д������ƣ��ڶ�����2�����飬��һ�нڵ��ţ��ڶ��м����ֵ�������б�ʾʱ��
for i = 1:itemsl
    jihe(1,i) = Monitoring(i);
    zwz = strcmp(monitor_item,Monitoring(i)); % logical array
    ind0 = find(zwz==1); % tempλ��
    itemqp(1:length(ind0),1) = node_id(ind0,:); % ȡ������disp�����м�����ͬ��㣬����Ҫ��ֵ�.
    itemqp(1:length(ind0),2) = monitor_value(ind0,:);
    jihe{2,i} = itemqp;
    jihe{3,i} = monitor_time(ind0,:);
    clear itemqp
end
for i = 1:itemsl
    temp2 = unique(jihe{2,i}(:,1));
    for j = 1:length(temp2)
        weizhi = find(jihe{2,i}(:,1)==temp2(j)); % ������������λ��
        shuju(1,j) = temp2(j);
        shuju(2:length(weizhi)+1,j) = jihe{2,i}(weizhi,2);
    end
    mingcheng = Monitoring{i}; % ��cell����ת��Ϊstring����
    save(mingcheng,'shuju');
end
for i = 1:itemsl
    figure
    plot(jihe{2,i}(:,2))
    title(jihe{1,i})
    xlabel('t')
    ylabel('value')
end
%% �����ܶȷֲ�weibull�ֲ�
junz = mean(jihe{2,3}(:,2)); % ��ֵ
bzcha = sqrt(var(jihe{2,3}(:,2))); % ��׼��
xc = (bzcha/junz)^-1.086; % ��״����
cc = junz/gamma(1+1/xc); % �߶Ȳ���
h = histogram(jihe{2,3}(:,2),16); % ��ֱ��ͼ�����ܶȷֲ���״ͼ
nhcs = makedist('Weibull', 'a', cc, 'b', xc); % ��weibull�ֲ�
x = 0:0.1:30; % ��ȡֵ����
y = pdf(nhcs,x); % �������ܶ��������
plot(x,y)
T = 10:10:100; % ��������
xmax = cc*(log(T)).^(1/xc); % �������ڱ������ܳ��ֵ����ֵ
%% ��Чϵ����
myzhbyxz(1,:)=[200,10,1,1,0.5,100]; % ����ֵ
myzhbyxz(2,:)=[5,2,0,0,0,5]; % ������ֵ
x=zeros(12,length(myzhbyxz)); % �������
for i=1:12
    x(i,:)=rand(1,length(myzhbyxz)).*myzhbyxz(1,:);
end
e=zeros(12,length(myzhbyxz));
for i=1:12
    for j=1:length(myzhbyxz)
    e(i,j)=(x(i,j)-myzhbyxz(2,j))/(myzhbyxz(1,j)-myzhbyxz(2,j))*40+60; % efficiency_coefficient
    end
end
%% ���ɷַ���
% x��ΪҪ�����nάԭʼ���ݡ��������matlab�Դ����������������µ�nά�ӹ�������ݣ���score����
% ��������֮ǰ��nάԭʼ����һһ��Ӧ��
% score�����ɵ�nά�ӹ�������ݴ���score����Ƕ�ԭʼ���ݽ��еĽ������������µ�����ϵ�»�õ����ݡ�
% ������nά���ݰ��������ɴ�С���С������ڸı�����ϵ�ľ����£��ֶ�nά��������
% latent����һά��������ÿһ�������Ƕ�Ӧscore����Ӧά�Ĺ����ʣ���Ϊ��ռ��nά������������n�����ݡ�
% �ɴ�С���У���ΪscoreҲ�ǰ��������ɴ�С���У���
% coef����ϵ�����󡣾��ɹ���coef����֪��x�����ת����score�ġ����Կ��������ɷֵ�Ȩ�أ�ԭʼ����*coef����
% ���Ǽ���ԭʼ���ݣ��ֱ����coef�����и���ԭʼ���ݶ�Ӧ��Ȩ��ֵ��ˣ�coef��Ȩ�����б�ʾ��
% �����ԭ����x*coeff(:,1:n)������Ҫ�ĵ������ݣ����е�n�����뽵������ά��?��n��ȡֵȡ���ڶ�����ֵ���ۼƹ����ʵļ��㡣
[coef,score,latent,t2] = princomp(x); %#ok<PRINCOMP>
jg=x*coef(:,1:2); % �뽵��2ά������������б�ʾ