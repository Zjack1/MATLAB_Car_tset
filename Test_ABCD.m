clc;
clear all;
close all;		
I=imread('D:\桌面\1111.jpg');                    %读入图片
figure,imshow(I);title('原始图像');				%显示原始图像
E=rgb2gray(I);
figure,imshow(E);
bw=edge(E,'sobel',0.111,'both');%边缘提取
figure;imshow(bw);
theta=1:180;%再在1到180度角内对图像进行旋转，记录下边缘提取后的图像在x轴方向上的投影，
[R,xp]=radon(bw,theta);%当x轴方向上的投影最小的时候即表示图像中字符平行于y轴，已经完成矫正
[I0,J]=find(R>=max(max(R)));%J记录了倾斜角
qingxiejiao=90-J
g=imrotate(E,qingxiejiao,'bilinear','crop');
figure,imshow(g);
C=im2bw(g,0.65);
figure,imshow(C);
C1=medfilt2(C,[3,3]);%中值滤波
figure,imshow(C1);

E1=edge(C1,'sobel',0.111,'both');%边缘提取
figure,imshow(E1);
[m n]=size(E1);
% 求垂直投影
for y=1:n
     S(y)=sum(E1(1:m,y));
end
y=1:n;
figure,
subplot(211),plot(y,S(y));
title('垂直投影');
% 求水平投影
for x=1:m
    S(x)=sum(E1(x,:));
end
x=1:m;
subplot(212),plot(x,S(x));
title('水平投影');





