clc;
clear all;
close all;		
I=imread('D:\桌面\300.jpg');                    %读入图片
figure,imshow(I);title('原始图像');				%显示原始图像
E=rgb2gray(I);
figure,imshow(E);
bw=edge(E,'canny',0.00511,'both');%边缘提取

theta=1:180;%再在1到180度角内对图像进行旋转，记录下边缘提取后的图像在x轴方向上的投影，
[R,xp]=radon(bw,theta);%当x轴方向上的投影最小的时候即表示图像中字符平行于y轴，已经完成矫正
[I0,J]=find(R>=max(max(R)));%J记录了倾斜角
qingxiejiao=90-J
g=imrotate(E,qingxiejiao,'bilinear','crop');

C1=medfilt2(g,[3,3]);%中值滤波
figure,imshow(C1);

E1=edge(g,'sobel',0.12,'both');%边缘提取
figure,imshow(E1);
se=[1;1;1];          %腐蚀处理
D=imerode(E1,se);
figure,imshow(D);
se=strel('rectangle',[15,15]);
F=imclose(D,se); %闭运算
figure,imshow(F);%平滑处理

E2=bwareaopen(F,2300); 					%删除小面积图形 
figure,imshow(E2);
title('移除小对象');
