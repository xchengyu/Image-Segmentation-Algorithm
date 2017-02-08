%%%%%动态阈值分割
clc;
clear all;
close all;
tic;%计时开始
I=imread('shuisheng.bmp');%输入图像
I=rgb2gray(I);%转换为灰度图像
I=im2double(I);%图像数据类型转换
I=imresize(I,[216 216]);%改变图像尺寸便于分割图像
[I,noise]=wiener2(I,[3 3]);%维纳滤波
%%%%%%%局部直方图均衡化
[a,b]=size(I);
m=121;
n=121;
I = padarray(I, [m n], 'symmetric');%%%沿图像边缘向各方向复制图像消除边缘无法处理的问题
I1=zeros(m,n);
I2=zeros(a,b);
for i = m+1:1:m + a
for j = n+1:1:n + b
    I1=I((i-(m-1)/2):(i+(m-1)/2),(j-(m-1)/2):(j+(m-1)/2));
    I1=histeq(I1);
    I(i,j)=I1((m+1)/2,(m+1)/2);
    I1=zeros(m,n);
end
end
I2=I(m+1:m+a, n+1:n+b);
figure;
imshow(I2);%输出经LAHE处理后的图像
%%%%%%%%%
th=graythresh(I2);%用OTSU法求全局阈值并分割图像
J=im2bw(I2,th);
figure;
imshow(J);%全局阈值分割效果
Oimage=zeros(216,216);%得到与图像尺寸相同的矩阵
Oimage1=zeros(216,216);%得到与图像尺寸相同的矩阵
TH=zeros(12,12);%子块阈值矩阵X
TH1=zeros(216,216);%插值后阈值矩阵Y
for i=1:1:216
    for j=1:1:216
    Oimage(i,j)=I2(i,j);
    Oimage1(i,j)=I2(i,j);
    end
end%复制图像
TH_Oimage=graythresh(Oimage);%得到全局阈值
TH_Oimage1=zeros(216,216);%得到与图像尺寸相同的矩阵
for i=1:1:216
    for j=1:1:216
    TH_Oimage1(i,j)=TH_Oimage;
    end
end%得到与图像尺寸相同的全局阈值矩阵
for i=1:1:12
for j=1:1:12
    J=Oimage((i-1)*216/12+1:i*216/12,(j-1)*216/12+1:j*216/12);
    TH(i,j)=graythresh(J);%用OSTU算法得到每个小块儿的阈值，存入12*12的矩阵。
end
end
%现在将TH矩阵通过插值得到一个216*216的新的阈值矩阵Y，用双线性插值。
TH1=imresize(TH,18,'bilinear');%得到新的阈值矩阵Y。
%%%%对新得到的矩阵进行平滑处理，消除块状效应
A=fspecial('average',[3 3]); %生成的3X3均值滤波器  
TH1=filter2(A,TH1);           %用生成的滤波器进行滤波
%%%%
M=zeros(216,216);%结合全局阈值的动态阈值矩阵Y*
%
for i=1:1:95
    for j=1:1:90
    M(i,j)=0.5*TH_Oimage1(i,j)+(1-0.5)*TH1(i,j);%K设为0.5,全局阈值和局部阈值通过加权K结合使用。左上角。
    end
end
%
for i=96:1:216
    for j=1:1:108
    M(i,j)=0.6*TH_Oimage1(i,j)+(1-0.6)*TH1(i,j);%K设为0.6,全局阈值和局部阈值通过加权K结合使用。左下角
    end
end
%
for i=1:1:95
    for j=91:1:216
    M(i,j)=0.8*TH_Oimage1(i,j)+(1-0.2)*TH1(i,j);%K设为0.8,全局阈值和局部阈值通过加权K结合使用。右上角
    end
end
%
for i=96:1:216
    for j=109:1:216
    M(i,j)=0.8*TH_Oimage1(i,j)+(1-0.8)*TH1(i,j);%K设为0.8,全局阈值和局部阈值通过加权K结合使用。右下角
    end
end
%
for i=1:1:216
for j=1:1:216
    if(Oimage1(i,j)<=M(i,j))%将原图各个像素点用新的阈值矩阵进行分割。
        Oimage1(i,j)=0;
    else
        Oimage1(i,j)=1;
    end
end
end%图像二值化
figure;
imshow(Oimage1);%输出分割效果
toc;%计时结束