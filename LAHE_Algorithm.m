%局部直方图均衡化处理：子块重叠算法；
clc;
clear all;
close all;
tic;%开始计时
I=imread('shuisheng.bmp');%读入图像
I=rgb2gray(I);%转换为灰度图
I=im2double(I);%转换图像数据格式
I=imresize(I,[216 216]);%改变图像大小，插值变换原理
[a,b]=size(I);%提取图像的尺寸
m=73;
n=73;%设置移动模块大小
I = padarray(I, [m n], 'symmetric');%以图像边缘为中心对图像进行对称复制，长度方向向外复制n列，宽度方向向外复制m行，消除LAHE算法无法对图像边界点进行处理的缺陷
I1=zeros(m,n)%生成空的移动模块;
I2=zeros(a,b);%生成与原图像尺寸相同的矩阵
for i = m+1:1:m + a
for j = n+1:1:n + b
    I1=I((i-(m-1)/2):(i+(m-1)/2),(j-(m-1)/2):(j+(m-1)/2));
    I1=histeq(I1);
    I(i,j)=I1((m+1)/2,(m+1)/2);
    I1=zeros(m,n);
end
end%局部直方图均衡化处理
I2=I(m+1:m+a, n+1:n+b);%将处理后图像有效部分提取出来
figure(1);
imshow(I2);%输出LAHE处理后的图像
title('局部直方图均衡化处理后的图像')
figure(2);
imhist(I2);%输出LAHE处理后的图像直方图
xlabel('灰度');
ylabel('频数/个');
title('图像处理后直方图');
toc;%计时结束