clc;
clear all;
close all;		
I=imread('D:\桌面\300.jpg');                    %读入图片
figure,imshow(I);title('原始图像');				%显示原始图像

Im1=rgb2gray(I);
figure,imshow(Im1);
B=medfilt2(Im1,[5 5]);%中值滤波
figure,imshow(B);

Tiao=imadjust(B,[0.18,0.78],[0,1]); 				%调整图片灰度值范围
figure(4),imshow(Tiao);

C=im2bw(Tiao,0.455);
figure,imshow(C);
D=medfilt2(C,[5 5]);%中值滤波
figure,imshow(D);
I2=edge(Tiao,'sobel',0.151,'both'); 				%使用sobel算子进行边缘检测
figure,imshow(I2);
title('sobel算子实现边缘检测');

theta=1:180;%再在1到180度角内对图像进行旋转，记录下边缘提取后的图像在x轴方向上的投影，
[R,xp]=radon(I2,theta);%当x轴方向上的投影最小的时候即表示图像中字符平行于y轴，已经完成矫正
[I0,J]=find(R>=max(max(R)));%J记录了倾斜角
qingxiejiao=90-J
g=imrotate(I2,qingxiejiao,'bilinear','crop');
figure,imshow(g);









