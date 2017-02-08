%%%%%最小错误概率法
clc;
close all;
clear all;
tic;%计时开始
I=imread('rice.bmp');%读入图像
I1=rgb2gray(I);%转换为灰度图像
%%%%%抗造性能检测以及滤波效果检测
%I1=imnoise(I1,'gaussian',0,0.01);%加入均值为0方差为0.01的高斯白噪声
%I1=wiener2(I1,[7 7]);%维纳滤波
%I1=filter2(fspecial('average',[3 3]),I1);%均值滤波
%I1=round(I1);%灰度值取整
%%%%%
I1=double(I1);
figure(1);
imshow(I1,[0 255]);%输出图像（滤波，加噪，或者原图）
%%%%%复制图像
[a,b]=size(I1);%提取图像尺寸
I4=zeros(a,b);
I4=I;%复制图像
I4=rgb2gray(I4);%转换为灰度图
I4=double(I4);%数据格式转换
%%%%%
I1max=max(max(I1));%获取图像最大灰度值
I1min=min(min(I1));%获取图像最小灰度值
GTH=zeros(I1max+1,1);%目标函数矩阵
for TH=I1min:1:I1max
count_back=0;
count_object=0;
sum_back=0;
sum_object=0;
average_back=0;
average_object=0;
variance_object=0;
variance_back=0;
pow_object=0;
pow_back=0;
for i=1:1:a
for j=1:1:b
if I1(i,j)<=TH
    count_object=count_object+1;
    sum_object=sum_object+I1(i,j);
else
    count_back=count_back+1;
    sum_back=sum_back+I1(i,j);
end
end
end%求背景与目标的像素点以及灰度总和
if count_object<=1||count_back<=1%防止方差为0
    GTH(TH+1,1)=100;
else
    average_object=sum_object/count_object;
    average_back=sum_back/count_back;
end
if average_object>I1min&&average_back<I1max&&average_object<I1max&&average_object>I1min%防止方差为0
    for i=1:1:a
    for j=1:1:b
    if I1(i,j)<=TH
    pow_object=pow_object+(I1(i,j)-average_object)^2;
    else
    pow_back=pow_back+(I1(i,j)-average_back)^2;
    end
    end
    end%求方差的分子部分
    variance_object=pow_object/(count_object-1);
    variance_back=pow_back/(count_back-1);
    GTH(TH+1,1)=1+count_object*log(variance_object)+count_back*log(variance_back)-2*(count_object*log(count_object)+count_back*log(count_back));%目标函数
else
    GTH(TH+1,1)=100;
end

end
Gmin=min(min(GTH));%获取最小值
THbest=max(find(GTH(:,1)==Gmin)-1);%获取最大的可能阈值
 for i=1:1:a
 for j=1:1:b
    if I1(i,j)<=THbest
  I1(i,j)=0;
    else
  I1(i,j)=1;
    end
end
end
t=['最小误差法阈值分割，阈值=' num2str(THbest)];
figure(3);imshow(I1);title(t);%输出分割结果
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
    if I1(i,j)==1
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
    if I1(i,j)==1
        c1=c1+(I4(i,j)-f1)^2;
    else
        c2=c2+(I4(i,j)-f2)^2;
    end
end
end
d1=c1/b1;
d2=c2/b2;
S=1-((d1+d2)/1000000);%区域一致性