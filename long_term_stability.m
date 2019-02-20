clear
%%  ��������,����Ҫ���������
% ������ǿ�ȵȼ���C60
% ����������ģ����3.55*10^4N/mm2 
% ������ǿ�ȱ�׼ֵ��fck=60N/mm2,ftk=6N/mm2
% ��Ƭ��������� 21.98m2
% ��Ƭ��λ���Ƚ�����Ծأ�1/12*1*t^3=2.858*(10^-2)m3;
% ����ն���Чϵ����0.8 
% ��������ʣ�0.3 
% ϸɰ�ͷ����������Ϊ��͸ˮ�㣬����ʱ����ˮ������,������ϸɰ��Ŀ�϶�ȡ���Ȼ��ˮ������ͳ�����ϣ�----
% ����ʱ����Ȼ�ضȽ���Ϊ�����ض�
% K0  ˮƽ��ѹ���ʹ�ֱ��ѹ��֮�ȣ�
% j  ������Ħ���ǣ�
% p0  �ϸ����أ�ָÿ�㶼Ҫ������ϸ����� kPa
% g  �����ضȣ�kN/m3 
% H  ��ǰ������ m
fck=60; % ��������ѹǿ��MPa
ftk=6; % ����������ǿ��MPa
t=0.6; % ��Ƭ��ȣ�m��
b = 2; % ��Ƭ�����ȣ�m��
I=1/12*t^3; % ���Ծ�
l=0.48; % �����������õľ�ֹ��ѹ��ϵ��
p0=[560,0,0];  %��һ��Ϊɰ���ϸ�����(����Ϊ���裩���ڶ���Ϊ����ϸ�����
g=[20,19.8]; % ÿ�����ضȣ�kN/m3��
j=pi/6; % ������Ħ����
c=[0,44.3];  % �����������kPa
K0=1;  % �ں�����һ��ˮƽ��ѹ���ʹ�ֱ��ѹ��֮��ȡ1
R0=14.5/2; % R0Ϊ�ܵ��ܰ뾶
B1=R0*cot((pi/4+j/2)/2); % ����Terzaghi�ɶ���ѹ��Ҫ��ϵ�� 
H=[7.3,7];   % ��ǰ�����ȼ���ֵ��m��������Ϊ����,�õ������ӽ����������
%%  ���ؼ���
for i=1:2 % ������
    pv=B1*(g(i)-c(i)/B1)/(K0*tan(j))*(1-exp(-K0*tan(j)*H(i)/B1))+p0(i)*exp(-K0*tan(j)*H(i)/B1);  % pv:Terzaghi�ɶ���ѹ
    p0(i+1)=pv; % �˲���ѹ���ݸ��²�
end
ph=[l*pv,l*(pv+20*(t/2+2*(R0-t/2)))];  % ������ѹ����1Ϊ����������أ�2-1Ϊ���������κ���
gcq(1)=2600/100*t;  % һ�γ����ض�-�򻯺�Ĺ�ʽ
gcq(2)=2600/100*(t/2);   % ���γ����ض�
% h:0.8ΪԲ���ն���Чϵ��
% R0-t/2Ϊ�ṹ����뾶
% KhΪ����ز㵯�Է���ϵ��,30Mpa(�ɸĶ���
ybw=((2*pv-ph(1)-ph(2)+pi*gcq(1))*10^3*(R0-t/2)^4)/(24*(0.8*3.55*10^10*I+0.0454*30*10^6*(R0-t/2)^4)); % ���ˮƽֱ����������λ
pk=30*10^3*ybw;  % kPa  ����ز㿹��
M=zeros(19,6);  % ����أ����һ��Ϊ�������
N=zeros(19,6);  % �����������һ��Ϊ��������
theta=0:pi/18:pi;
hezai=[gcq(1),pv,ph(1),ph(2)-ph(1),pk]; % ���أ�������أ�ˮƽ���أ������β�ѹ���ز㿹��
%% ��ؼ���
% 1-5��Ϊ���أ�������أ�ˮƽ���أ������β�ѹ���ز㿹��
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
%% ��������
% 1-5��Ϊ���أ�������أ�ˮƽ���أ������β�ѹ���ز㿹��
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
%% ��ʱ�仯,ֱ����ȡ�ӻ�ģ������
% ̼�����Ӱ�죬�������ṹ�;���������Ԥ��-ţݶ�ε�21ҳ�����ڻ�����ǿ��̼�����ģ��
% fckn=fck*1.4529*exp(-0.0246*(log(1:100)-1.7154).^2);  
load dgRatio % bili
fckn = fck*bili;
ftkn = ftk*bili;
%%  ��ȫϵ������  ��·�����ƹ淶
e0=abs(M(:,6)./N(:,6)); % ������ƫ�ľ�
K=zeros(19:1); % ��ȫϵ��0�ȵ�180�ȹ�19������
alfa=1+0.648*e0./t-12.569*(e0./t).^2+15.444*(e0./t).^3; % ������ƫ��Ӱ��ϵ��
ti = 1:length(bili); % ����仯
for i=1:19  % ÿ�����氲ȫϵ��
    if e0(i)<=0.2*t
        K(i,:)=alfa(i)*fckn*1000*t*b/N(i,6);
    else
        K(i,:)=1.75*ftkn*t*1000*b/(N(i,6)*(6*e0(i)/t-1));
    end
end
huatu(M,N,K,theta,ti)
temp=table(M);
writetable(temp,'���.csv');  % д���ݳ�csv
%% ��ͼ
function [] = huatu(M,N,K,theta,ti)
    tuli = {'����','�������','ˮƽ����','�����β�ѹ','�ز㿹��','����'}; % Ҫ���ַ��ֳ�һ��һ�飬�����Ԫ������
    xianxing = {'-o','-+','-*','-x','-s','-d'}; % Ҫ���ַ��ֳ�һ��һ�飬�����Ԫ������
    subplot(2,2,1);
    for i = 1:6
        plot(theta,M(:,i),xianxing{i})
        hold on
    end
    title ('����������');
    xlabel('�������Ƕ�(rad)')
    ylabel('Moment(KN*m)')
    legend(tuli)
    subplot(2,2,2); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:6
        plot(theta,N(:,i),xianxing{i})
        hold on
    end   
    title ('�����������');
    xlabel('�������Ƕ�(rad)')
    ylabel('axial Force(KN)')
    legend(tuli)
    subplot(2,2,3); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot(ti,K(K(:,100)==min(K(:,100)),:),'-o')
    weizhi = find(K(:,100)==min(K(:,100)));
    title ('������С��ȫϵ����ʱ�仯');
    xlabel('t/(year)')
    ylabel('��ȫϵ��')
    jiaodu = round((weizhi-1)*10);
    jiaodu = sprintf('%d��λ�ð�ȫϵ��(����Ϊ0��)',jiaodu);
    legend(jiaodu)
    subplot(2,2,4); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot(theta,K(:,100),'-*')
    title ('100��ʱ�̽��������ȫϵ��');
    xlabel('��Ƭ����(rad)')
    ylabel('��ȫϵ��')
end
