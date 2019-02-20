%% efficiency_coefficient_method 功效系数法
%% 原始数据切片
clear
Data = readtable('Result.csv'); % 用此方法读取csv文件变成table格式
node_id = Data{:,3}; % 注意是花括号
monitor_item = Data{:,4}; % 注意是花括号
monitor_value = Data{:,5};
monitor_time = Data{:,6};
% zongsj = length(monitor_item);
Monitoring = unique(monitor_item(1:500)); % 用自带的unique函数可以求得一个数列中不同元素
% Monitoring(1) = monitor_item(1); % 监测数据项目名称列表
% for i = 2:500
%     if sum(strcmp(Monitoring,monitor_item(i))) == 0 % 如果监测项目不在Monitoring矩阵中，则把其加入上矩阵
%         j = j+1;
%         Monitoring(j) = monitor_item(i);
%     end
% end
itemsl = length(Monitoring);
jihe = cell(3,itemsl); % 按监测项目切片后元胞；第一行代表名称，第二行是2列数组，第一列节点编号，第二列监测数值；第三行表示时间
for i = 1:itemsl
    jihe(1,i) = Monitoring(i);
    zwz = strcmp(monitor_item,Monitoring(i)); % logical array
    ind0 = find(zwz==1); % temp位置
    itemqp(1:length(ind0),1) = node_id(ind0,:); % 取出来的disp数据有几个不同测点，这是要拆分的.
    itemqp(1:length(ind0),2) = monitor_value(ind0,:);
    jihe{2,i} = itemqp;
    jihe{3,i} = monitor_time(ind0,:);
    clear itemqp
end
for i = 1:itemsl
    temp2 = unique(jihe{2,i}(:,1));
    for j = 1:length(temp2)
        weizhi = find(jihe{2,i}(:,1)==temp2(j)); % 监测点在数组中位置
        shuju(1,j) = temp2(j);
        shuju(2:length(weizhi)+1,j) = jihe{2,i}(weizhi,2);
    end
    mingcheng = Monitoring{i}; % 把cell类型转换为string类型
    save(mingcheng,'shuju');
end
for i = 1:itemsl
    figure
    plot(jihe{2,i}(:,2))
    title(jihe{1,i})
    xlabel('t')
    ylabel('value')
end
%% 概率密度分布weibull分布
junz = mean(jihe{2,3}(:,2)); % 均值
bzcha = sqrt(var(jihe{2,3}(:,2))); % 标准差
xc = (bzcha/junz)^-1.086; % 形状参数
cc = junz/gamma(1+1/xc); % 尺度参数
h = histogram(jihe{2,3}(:,2),16); % 做直方图概率密度分布柱状图
nhcs = makedist('Weibull', 'a', cc, 'b', xc); % 做weibull分布
x = 0:0.1:30; % 量取值区间
y = pdf(nhcs,x); % 做概率密度拟合曲线
plot(x,y)
T = 10:10:100; % 重现周期
xmax = cc*(log(T)).^(1/xc); % 重现周期变量可能出现的最大值
%% 功效系数法
myzhbyxz(1,:)=[200,10,1,1,0.5,100]; % 满意值
myzhbyxz(2,:)=[5,2,0,0,0,5]; % 不允许值
x=zeros(12,length(myzhbyxz)); % 监测数据
for i=1:12
    x(i,:)=rand(1,length(myzhbyxz)).*myzhbyxz(1,:);
end
e=zeros(12,length(myzhbyxz));
for i=1:12
    for j=1:length(myzhbyxz)
    e(i,j)=(x(i,j)-myzhbyxz(2,j))/(myzhbyxz(1,j)-myzhbyxz(2,j))*40+60; % efficiency_coefficient
    end
end
%% 主成分分析
% x：为要输入的n维原始数据。带入这个matlab自带函数，将会生成新的n维加工后的数据（即score）。
% 此数据与之前的n维原始数据一一对应。
% score：生成的n维加工后的数据存在score里。它是对原始数据进行的解析，进而在新的坐标系下获得的数据。
% 他将这n维数据按供献率由大到小分列。（即在改变坐标系的景象下，又对n维数据排序）
% latent：是一维列向量，每一个数据是对应score里响应维的供献率，因为数占领n维所以列向量有n个数据。
% 由大到小分列（因为score也是按供献率由大到小分列）。
% coef：是系数矩阵。经由过程coef可以知道x是如何转换成score的。可以看到各个成分的权重，原始矩阵*coef矩阵
% 就是几个原始数据，分别乘以coef矩阵中各个原始数据对应的权重值相乘，coef中权重以列表示。
% 用你的原矩阵x*coeff(:,1:n)才是你要的的新数据，其中的n是你想降到多少维。?而n的取值取决于对特征值的累计贡献率的计算。
[coef,score,latent,t2] = princomp(x); %#ok<PRINCOMP>
jg=x*coef(:,1:2); % 想降到2维，用这个，以列表示