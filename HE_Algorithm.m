%%%%%全局直方图均衡化处理
clc;
clear all;
close all;
I=imread('shuisheng.bmp');%读入图像
I=rgb2gray(I);%转换为灰度图
I=im2double(I);%图像数据转换
figure(1);
imhist(I);%输出图像处理前的直方图
xlabel('灰度');ylabel('频数/个');
title('图像处理前直方图');
I=histeq(I);%全局直方图均衡化
figure(2);
imshow(I);title('全局直方图均衡化处理后的图像');%输出图像处理后的图像
