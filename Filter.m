%%%%%%空域滤波程序
clc;
clear all;
close all;
I=imread('sidescan.JPG');%读入图像
I=rgb2gray(I);%转换为灰度图像
I=im2double(I);%修改图像数据格式
T1=['原始图像'];
figure(1);subplot(1,2,1);imshow(I);title(T1);%输出原始图像
I=imnoise(I,'gaussian',0,0.01);%给图像加入噪声
T2=['添加均值为0，方差为0.01的高斯噪声后的图像'];
subplot(1,2,2);imshow(I);title(T2);%输出加噪声图像

%均值滤波
A=fspecial('average',[3 3]); %生成系统预定义的3X3均值滤波器  
Y11=filter2(A,I);%用生成的滤波器进行滤波
T31=['3×3均值滤波'];
figure(2);subplot(2,2,1);imshow(Y11);title(T31);%输出滤波后图像
A=fspecial('average',[5 5]); %生成系统预定义的5X5均值滤波器  
Y12=filter2(A,I);%用生成的滤波器进行滤波
T32=['5×5均值滤波'];
subplot(2,2,2);imshow(Y12);title(T32);%输出滤波后图像
A=fspecial('average',[7 7]); %生成系统预定义的7X7均值滤波器  
Y13=filter2(A,I);%用生成的滤波器进行滤波
T33=['7×7均值滤波'];
subplot(2,2,3);imshow(Y13);title(T33);%输出滤波后图像
A=fspecial('average',[9 9]); %生成系统预定义的3X3均值滤波器  
Y14=filter2(A,I);%用生成的滤波器进行滤波
T34=['9×9均值滤波'];
subplot(2,2,4);imshow(Y14);title(T34);%输出滤波后图像

%中值滤波
Y21=medfilt2(I,[3 3]);%生成系统预定义的3X3中值滤波器，进行滤波
T41=['3×3中值滤波'];
figure(3);subplot(2,2,1);imshow(Y21);title(T41);%输出滤波后图像
Y22=medfilt2(I,[5 5]);%生成系统预定义的5X5中值滤波器，进行滤波
T42=['5×5中值滤波'];
subplot(2,2,2);imshow(Y22);title(T42);%输出滤波后图像
Y23=medfilt2(I,[7 7]);%生成系统预定义的7X7中值滤波器，进行滤波
T43=['7×7中值滤波'];
subplot(2,2,3);imshow(Y23);title(T43);%输出滤波后图像
Y24=medfilt2(I,[9 9]);%生成系统预定义的9X中值滤波器，进行滤波
T44=['9×9中值滤波'];
subplot(2,2,4);imshow(Y24);title(T44);%输出滤波后图像

%维纳滤波
Y41=wiener2(I,[3 3]);%生成系统预定义的3X3维纳滤波器，进行滤波
T61=['3×3维纳滤波'];
figure(5);subplot(2,2,1);imshow(Y41);title(T61);%输出滤波后图像
Y42=wiener2(I,[5 5]);%生成系统预定义的3X3维纳滤波器，进行滤波
T62=['5×5维纳滤波'];
subplot(2,2,2);imshow(Y42);title(T62);%输出滤波后图像
Y43=wiener2(I,[7 7]);%生成系统预定义的3X3维纳滤波器，进行滤波
T63=['7×7维纳滤波'];
subplot(2,2,3);imshow(Y43);title(T63);%输出滤波后图像
Y44=wiener2(I,[9 9]);%生成系统预定义的3X3维纳滤波器，进行滤波
T64=['9×9维纳滤波'];
subplot(2,2,4);imshow(Y44);title(T64);%输出滤波后图像
