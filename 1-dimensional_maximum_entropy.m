%%%%%一维最大熵法
clc;
clear all;
close all;
tic;%计时开始
I=imread('rice.bmp');%读入图像
I=rgb2gray(I);%转换为图像
%I=round(imnoise(I,'gaussian',0,0.01));%加入噪声
I=double(I);%图像数据格式转换
%I=round(medfilt2(I,[7 7]));%中值滤波
%I=round(filter2(fspecial('average',[7 7]),I));%均值滤波
%I=round(wiener2(I,[9 9]));%维纳滤波，三种滤波效果比较后选择最佳滤波器
[a,b]=size(I);%读取图像尺寸
%%%%%%复制原始图像
I4=zeros(a,b);
I4=I;
%%%%%
Gray=zeros(256,1);%灰度直方图矩阵
for i=1:1:a
for j=1:1:b
    Gray(I(i,j)+1,1)=Gray(I(i,j)+1,1)+1;
end
end%统计图像灰度分布
%figure;
%bar(Gray,0.2);%绘制灰度直方图
count=sum(Gray);
gray=Gray/count;%转换为各灰度概率
max=max(max(I));%求图像最大灰度值
min=min(min(I));%求图像最小灰度值
Hbest=zeros(max+1,1);%目标函数矩阵
for th=min:1:max
    H=0;
    H_all=0;
    HO=0;
    HB=0;
    P=sum(gray((min+1):(th+1),1));
    if P~=0&&P~=1
        for s=(min+1):1:(th+1)
            if gray(s,1)~=0
               H=-gray(s,1)*log(gray(s,1))+H;  
            end
               HO=log(P)+H/P;
        end
        for s=(min+1):1:(max+1)
            if gray(s,1)~=0
                H_all=-gray(s,1)*log(gray(s,1))+H_all;
            end
            HB=log(1-P)+(H_all-H)/(1-P);
        end
           Hbest(th+1,1)=HB+HO;%目标函数     
    end
    P=0;    
end
Hmax=0;
THbest=0;
for s=1:1:(max+1)
    if Hbest(s,1)>=Hmax
        Hmax=Hbest(s,1);
        THbest=s-1;
    end
end%求最优阈值
 for i=1:1:a
 for j=1:1:b
    if I(i,j)<=THbest
  I(i,j)=0;
    else
  I(i,j)=255;
    end
end
 end%图像二值化
t=['一维最大熵法阈值分割，阈值=' num2str(THbest)];
imshow(I);title(t);%输出分割结果
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