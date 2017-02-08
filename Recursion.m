%%%%%迭代法
clc;
clear all;
close all;
tic;%计时开始
I=imread('rice.bmp');%读入图像
I=rgb2gray(I);%转换为灰度图像
[a,b]=size(I);%读取图像的大小
%%%%%%复制原始图像
I4=zeros(a,b);
I4=I;
I4=double(I4);%转换图像数据格式
%%%%%验证抗造性和滤波效果模块
%I=imnoise(I,'gaussian',0,0.01);%加入均值为0方差为0.01的高斯白噪声
%I=wiener2(I,[7 7]);%维纳滤波
%%%%%
tmin=min(I(:));%获取图像灰度最小值
tmax=max(I(:));%获取图像灰度最大值
th=(tmin+tmax)/2;%初始分割阈值设定为图像灰度平均值
th1=0;%设定临界阈值
ok=true;%循环终止条件
while ok
    g1=I>=th;
    g2=I<th;
    u1=mean(I(g1));
    u2=mean(I(g2));
    thnew=(u1+u2)/2;
    ok=abs(th-thnew)==th1;
    th=thnew;
end%迭代求取最优阈值
th=floor(th);%对最优阈值进行取整处理
J=im2bw(I,th/255);%图像二值化
figure(1);
imshow(I);title('原始图像');%输出原始图像
figure(2);
str=['迭代分割:阈值TH=',num2str(th)];
imshow(J);title(str);%输出分割结果
toc;%计时结束
%%%%%%%分割质量评价部分
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
for i=1:1:a
for j=1:1:b
    if J(i,j)==1
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
for i=1:1:a
for j=1:1:b
    if J(i,j)==1
        c1=c1+(I4(i,j)-f1)^2;
    else
        c2=c2+(I4(i,j)-f2)^2;
    end
end
end
d1=c1/b1;
d2=c2/b2;
S=1-((d1+d2)/1000000);%区域一致性