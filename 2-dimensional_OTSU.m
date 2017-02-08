%%%%%二维OTSU法
clc;%算法来自1.基于阈值的图像分割算法的研究2.基于模糊阈值的图像分割方法研究_孙光灵3.基于遗传算法的水声图像分割技术研究_刘辰龙sidescan.JPG
clear all;
close all;
tic;%计时开始
I=imread('rice.bmp');%读入图像
%I=imnoise(I,'gaussian',0,0.01);%加入噪声
I=rgb2gray(I);%转换为灰度图像
I=double(I);%数据类型转换
%I=round(wiener2(I,[7 7]));%维纳滤波器滤波
[a,b]=size(I);%获取图像尺寸
%%%%%%复制原始图像
I4=zeros(a,b);
I4=I;
%%%%%
I1=zeros(a,b);
I1=round(filter2(fspecial('average',[3 3]),I));%生成邻域均值矩阵
Imax=max(max(I));%获取图像灰度最大值
Imin=min(min(I));%获取图像灰度最小值
Imean=mean(mean(I));%获取图像灰度平均值
I1max=max(max(I1));%获取邻域图像灰度最大值
I1min=min(min(I1));%获取邻域图像灰度最小值
I1mean=mean(mean(I1));%获取邻域图像灰度平均值
variance=zeros(Imax+1,I1max+1);%目标函数矩阵
for s=Imin:1:Imax
for t=I1min:1:I1max
    Isum_back=0;
    Isum_object=0;
    I1sum_back=0;
    I1sum_object=0;
    Iaverage_back=0;
    Iaverage_object=0;
    I1average_back=0;
    I1average_object=0;
    count_back=0;
    count_object=0;
for i=1:1:a
for j=1:1:b
if I(i,j)>s&&I1(i,j)>t
       Isum_object=Isum_object+I(i,j);
       I1sum_object=I1sum_object+I1(i,j);
       count_object=count_object+1;
elseif I(i,j)<=s&&I1(i,j)<=t
       Isum_back=Isum_back+I(i,j);
       I1sum_back=I1sum_back+I1(i,j);
       count_back=count_back+1;
end
end
end%求图像及邻域图像中目标与背景的各自对应总灰度值、平均灰度值和像素个数
if count_object==0||count_back==0%防止分母为0
   variance(s+1,t+1)=0;
else    
    Iaverage_object=Isum_object/count_object;
    Iaverage_back=Isum_back/count_back;
    I1average_object=I1sum_object/count_object;
    I1average_back=I1sum_back/count_back;
    variance(s+1,t+1)=(count_object/(a*b))*((Iaverage_object-Imean)^2+(I1average_object-I1mean)^2)+(count_back/(a*b))*((Iaverage_back-Imean)^2+(I1average_back-I1mean)^2);%求目标函数
end
end
end
variancemax=max(max(variance));%求目标函数最大值
[s1,t1]=find(variance==variancemax);%求最优阈值组向量
s=s1(1)-1;
t=t1(1)-1;%求最大阈值组
 for i=1:1:a
 for j=1:1:b
    if I(i,j)>s&&I1(i,j)>t
  I(i,j)=255;
    else
  I(i,j)=0;
    end
end
 end%图像二值化处理
T=['二维最大类间方差法阈值分割，阈值','s=',num2str(s),',','t=',num2str(t)];
figure;
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