%%%%%标准遗传算法
clc;
clear all;
close all;
tic;%计时开始
I=imread('%sidescan.JPG');%输入图像
I=rgb2gray(I);%转换为灰度图像
I=im2double(I);%转换数据格式

%%%%局部直方图均衡化，LAHE算法
I=imresize(I,[216 216]);
[I,noise]=wiener2(I,[3 3]);  
[u,v]=size(I);
m=73;
n=73;
I= padarray(I, [m n], 'symmetric');
I1=zeros(m,n);
X=zeros(u,v);
for i = m+1:1:m + u
for j = n+1:1:n + v
    I1=I((i-(m-1)/2):(i+(m-1)/2),(j-(m-1)/2):(j+(m-1)/2));
    I1=histeq(I1);
    I(i,j)=I1((m+1)/2,(m+1)/2);
    I1=zeros(m,n);
end
end
X=round(255*I(m+1:m+u, n+1:n+v));
%%%%
%%%%复制图像
I4=zeros(u,v);
I4=X;
%%%%
figure(1);
imshow(X/255);%输出图像
[m,n]=size(X);%提取图像尺寸
X1=zeros(m,n);%构建邻域矩阵
X1=around_mean(X);%求邻域均值图像，around_mean函数自己写的
NIND=30;%个体数目
MAXGEN=30;%最大遗传代数
PRECI=16;%变量的二进制位数
GGAP=1;%代沟0.9

%建立区域描述器
FieldD=[16;1;(2^16);1;0;1;1];
%FieldD函数的结构：
%FieldD=[len  lb  ub  code  scale  lbin  ubin]
%len:包含在Chrom在中的每个子串的长度（PRECI）
%lb ,ub:分别指每个变量的下界和上界
%code:表明子串是怎么样编码的。code=1,为标准的二进制编码；code=2，为格雷编码。
%scale:每个子串是否用的对数刻度还是算术刻度.scale=0，为算术刻度；scale=1，为对数刻度。
%lbin  ubin：是否包括变量的边界，为0则去掉边界;为1则包括边界。

Chrom=crtbp(NIND,PRECI);%创建初始种群
gen=0;
Gen=zeros(30,1);
phen=bs2rv(Chrom,FieldD);%初始种群十进制转换
Objv=target1(X,X1,phen);%计算种群适应度值
while gen<MAXGEN %最大遗传数
    Gen(gen+1,1)=max(Objv);
    FitnV=ranking(-Objv);%分配适应度值
    SelCh=select('sus',Chrom,FitnV,GGAP);%选择，设置了代沟，代沟的含义见《matlab遗传算法工具箱.pdf》 63面rws
    SelCh=recombin('xovsp',SelCh,0.6);%重组xovsp
    SelCh=mut(SelCh,0.01);%变异
    phenSel=bs2rv(SelCh,FieldD);%子代十进制转换
    ObjVSel=target1(X,X1,phenSel);%计算子代适应度值
    [Chrom,Objv]=reins(Chrom,SelCh,1,1,Objv,ObjVSel);%重插入
    gen=gen+1;%代数加1
end
figure(2);
plot(Gen);%绘制最优适应度函数值变化曲线
grid on;
xlabel('代数/代');
ylabel('适应度函数');
title('最优适应度函数值变化曲线');
axis([0 30 2000 3000])
[Y,I]=max(Objv);%找到最大适应度函数值
M=bs2rv(Chrom(I,:),FieldD);%获取最优阈值组
%
b=zeros(16,1);
t=16;
while M~0
        b(t)=mod(M,2);
        M=(M-b(t))/2;
        t=t-1;
end
M1=0;
M2=0;
    for t=1:1:8
        M1=M1+b(t)*2^(8-t);%M1是各像素点的值,此步为进制转换
    end
    for t=9:1:16
        M2=M2+b(t)*2^(16-t);%M2是各像素点临域的值,此步为进制转换
    end
for i=1:1:m
for j=1:1:n
    if X(i,j)>M1 && X1(i,j)>M2
        X(i,j)=255;
    else
        X(i,j)=0;
    end
end
end%图像二值化
t=['二维最大类间方差法阈值分割，阈值','M1=',num2str(M1),',','M2=',num2str(M2)];
figure(3);
imshow(X/255);title(t);%输出分割效果
toc;%计时结束
%%%%%%%评价部分
f1=0;
f2=0;%两个区域的平均值
a1=0;
a2=0;%两个区域的灰度总和
b1=0;
b2=0;%两个区域的数目
c1=0;
c2=0;%两个区域的平方差和
d1=0;
d2=0;%两个区域的方差
for i=1:1:u
for j=1:1:v
    if X(i,j)==255
        b1=b1+1;
        a1=a1+I4(i,j);
    else
        b2=b2+1;
        a2=a2+I4(i,j);
    end
end
end
f1=a1/b1;
f2=a2/b2;
D=abs(f1-f2)/(f1+f2);%对比度
for i=1:1:u
for j=1:1:v
    if X(i,j)==255
        c1=c1+(I4(i,j)-f1)^2;
    else
        c2=c2+(I4(i,j)-f2)^2;
    end
end
end
d1=c1/b1;
d2=c2/b2;
S=1-((d1+d2)/1000000);%区域一致性