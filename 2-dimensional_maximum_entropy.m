%%%%%二维最大熵法
clc;
clear all;
close all;
tic;%计时开始
I=imread('sidescan.JPG');%读入图像
I=rgb2gray(I);%转换为灰度图像
%I=imnoise(I,'gaussian',0,0.01);%加入均值为0方差为0.01的高斯白噪声
I=double(I);%图像数据转换
[a,b]=size(I);%获取图像尺寸
%%%%%%复制原始图像
I4=zeros(a,b);
I4=I;
%%%%%
%I=round(medfilt2(I,[7 7]));%中值滤波
%I=round(filter2(fspecial('average',[7 7]),I));%均值滤波，两种滤波二选一
figure(1);
imshow(I/255);%输出图像
I1=round(filter2(fspecial('average',[3 3]),I));%求邻域均值图像

Imax=max(max(I));%获取图像灰度值最大值
Imin=min(min(I));%获取图像灰度值最小值
I1max=max(max(I1));%获取邻域图像灰度值最大值
I1min=min(min(I1));%获取邻域图像灰度值最小值
P=zeros(Imax+1,I1max+1);%统计图像灰度-邻域灰度像素频数矩阵
Z=zeros(Imax+1,I1max+1);%目标函数矩阵
X=zeros(Imax+1,I1max+1);%目标像素总概率矩阵
for i=1:1:a
for j=1:1:b
    P(I(i,j)+1,I1(i,j)+1)=P(I(i,j)+1,I1(i,j)+1)+1;
end
end%统计图像灰度-邻域灰度像素频数
p=P/(a*b);%求灰度-邻域灰度概率
Hl=0;
for s=(Imin+1):1:(Imax+1)
for t=(I1min+1):1:(I1max+1)
    if p(s,t)~=0;
    Hl=Hl-p(s,t)*log(p(s,t));%求整幅图像二维离散熵
    end
end
end
for s=(Imin+1):1:(Imax+1)
for t=(I1min+1):1:(I1max+1)
    Ha=0;
    Pa=sum(sum(p((Imin+1):s,(I1min+1):t)));%目标概率总和
    X(s,t)=Pa;%不同阈值组下目标概率总和
if Pa>0&&Pa<1
for u=(Imin+1):1:s
for v=(I1min+1):1:t
    if p(u,v)~=0;
        Ha=Ha-p(u,v)*log(p(u,v));%灰度-邻域灰度图像中A区的熵
    end
end
end
    Z(s,t)=log(Pa*(1-Pa))+(Ha/Pa)+((Hl-Ha)/(1-Pa));%目标函数
end
end
end
Zmax=(max(max(Z)));%求最大的目标函数
[sbest1,tbest1]=find(Z==Zmax);%得到最优阈值组
sbest=sbest1(1)-1;
tbest=tbest1(1)-1;%从最优阈值组中选取第一组阈值
 for i=1:1:a
 for j=1:1:b
    if I(i,j)<=sbest&&I1(i,j)<=tbest
  I(i,j)=0;
    elseif I(i,j)>sbest&&I1(i,j)>tbest
  I(i,j)=255;
    end
end
 end%图像二值化
figure(2);
T=['二维最大熵法阈值分割，阈值=' num2str(sbest)];
imshow(I);title(T);%输出分割结果
toc;%计时结束
%%%%%%%分割效果评价部分
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
    if I(i,j)==255
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
    if I(i,j)==255
        c1=c1+(I4(i,j)-f1)^2;
    else
        c2=c2+(I4(i,j)-f2)^2;
    end
end
end
d1=c1/b1;
d2=c2/b2;
S=1-((d1+d2)/1000000);%区域一致性