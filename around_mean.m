%%%%%自己写的求邻域均值矩阵的函数
function I1=around_mean(I)
[a,b]=size(I);
I1=zeros(a,b);
for i=1:1:a
for j=1:1:b
    if  i==1&&j>1&&j<b
        I1(i,j)=(I(i,j+1)+I(i,j-1)+I(i+1,j+1)+I(i+1,j)+I(i+1,j-1))/5;
    elseif i>1&&i<a&&j==1
        I1(i,j)=(I(i-1,j)+I(i+1,j)+I(i-1,j+1)+I(i,j+1)+I(i+1,j+1))/5;
    elseif i==a&&j>1&&j<b
        I1(i,j)=(I(i,j+1)+I(i,j-1)+I(i-1,j-1)+I(i-1,j)+I(i-1,j+1))/5;
    elseif i>1&&i<a&&j==b
        I1(i,j)=(I(i-1,j)+I(i+1,j)+I(i-1,j-1)+I(i,j-1)+I(i+1,j-1))/5;
    elseif i==1&&j==1
        I1(i,j)=(I(i,j+1)+I(i+1,j+1)+I(i+1,j))/3;
    elseif i==a&&j==1
        I1(i,j)=(I(i,j+1)+I(i-1,j+1)+I(i-1,j))/3;
    elseif i==a&&j==b
        I1(i,j)=(I(i,j-1)+I(i-1,j)+I(i-1,j-1))/3;
    elseif i==1&&j==b
        I1(i,j)=(I(i,j-1)+I(i+1,j)+I(i+1,j-1))/3;
    else
        I1(i,j)=(I(i-1,j-1)+I(i,j-1)+I(i+1,j-1)+I(i-1,j)+I(i+1,j)+I(i-1,j+1)+I(i,j+1)+I(i+1,j+1))/8;
    end
end
end%生成各点领域均值矩阵
end