%%%%%一维OTSU法
clc;
clear all;
close all;
tic;%计时开始
I=imread('rice.bmp');%读入图像
I=rgb2gray(I);%转换为灰度图像
%%%%%复制图像
[a,b]=size(I);%提取图像尺寸
I4=zeros(a,b);
I4=I;
I4=double(I4);%数据格式转换
%%%%%
%%%%%抗造性能检测以及滤波效果检测
%I=imnoise(I,'gaussian',0,0.01);%加入均值为0方差为0.01的高斯白噪声
%I=wiener2(I,[7 7]);%维纳滤波
%I=filter2(fspecial('average',[3 3]),I);%均值滤波
%I=round(I);%灰度值取整
%%%%%
I=double(I);%数据格式变换
figure(1);
imshow(I,[0 255]);%输出图像（滤波，加噪，或者原图）

Imax=round(max(max(I)));%获得图像最大灰度值
Imin=round(min(min(I)));%获得图像最小灰度值
variance=zeros(Imax+1,1);%目标函数矩阵
for TH=Imin:1:Imax
count_back=0;
count_object=0;
count_whole=0;
sum_back=0;
sum_object=0;
average_back=0;
average_object=0;
average_whole=0;
for i=1:1:a
for j=1:1:b
if I(i,j)<=TH
    count_object=count_object+1;
    sum_object=sum_object+I(i,j);
else
    count_back=count_back+1;
    sum_back=sum_back+I(i,j);
end
end
end
%求背景与目标的像素点以及灰度总和
if count_object<=1||count_back<=1%防止平均值为0
    variance(TH+1,1)=0;
else
    average_object=sum_object/count_object;
    average_back=sum_back/count_back;
    count_whole=count_object+count_back;
    average_whole=(sum_object+sum_back)/count_whole;
    variance(TH+1,1)=(count_object/count_whole)*(average_object-average_whole)^2+(count_back/count_whole)*(average_back-average_whole)^2;%目标函数值
end
end
variancemax=max(max(variance));%找目标函数最大值
THbest=max(find(variance(:,1)==variancemax)-1);%输出最优阈值组中最大值
 for i=1:1:a
 for j=1:1:b
    if I(i,j)<=THbest
  I(i,j)=0;
    else
  I(i,j)=255;
    end
end
 end%图像二值化
t=['一维最大类间方差法阈值分割，阈值=' num2str(THbest)];
figure(2);
imshow(I);title(t);%输出图像
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