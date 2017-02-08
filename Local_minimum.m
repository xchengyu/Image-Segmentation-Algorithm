%%%%%双峰法
clc;
clear all;
close all;
tic;%计时开始
I=imread('rice.bmp');%读入图像
I=rgb2gray(I);%转换为灰度图像
figure(1);
imshow(I);title('原始图像');%输出原始图像
figure(2);
imhist(I);title('直方图');axis([0 255 0 10000]);%输出原始图像直方图
xlabel('灰度');
ylabel('频数/个');
th=130;%选取阈值
J=im2bw(I,th/255);%图像二值化
figure(3);
imshow(J);title('双峰法处理结果');%输出分割结果
toc;%计时结束