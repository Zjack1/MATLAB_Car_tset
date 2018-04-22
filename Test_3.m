
clc;
clear all;
close all;		
I=imread('D:\桌面\200.jpg');                    %读入图片
figure,imshow(I);title('原始图像');				%显示原始图像

Im1=rgb2gray(I);
figure,imshow(Im1);
B=medfilt2(Im1,[3 3]);%中值滤波
figure,imshow(B);
% figure(2),subplot(1,2,1);
% figure,imshow(B);
% title('灰度图');
% figure(2),
% subplot(1,2,2),
% imhist(B);
% title('灰度图的直方图');						%显示图像的直方图

Tiao=imadjust(B,[0.18,0.78],[0,1]); 				%调整图片
figure(4),
% subplot(1,2,1),
imshow(Tiao);
% title('增强灰度图');
% figure(5),
% subplot(1,2,2),
% imhist(Tiao);
% title('增强灰度图的直方图');
C=im2bw(Tiao,0.65);
figure,imshow(C);
Im2=edge(Tiao,'sobel',0.251,'both'); 				%使用sobel算子进行边缘检测
figure,
imshow(Im2);
title('sobel算子实现边缘检测')

%求解X方向的投影像素范围
[ix1,iy1]=xfenge(goal1)


%求解y方向的投影像素范围
[jx1,jy1]=yfenge(goal1)


%字符区域分割：
goal4=goal3(ix1:iy1,jx1:jy1);
    imwrite(goal4,'goal4.jpg');
figure(21);imshow(goal4);
[m,n]=size(goal4)
%[L,num] = bwlabel(goal4,8);%区域标记，1,2,3,4


ysum(n-1)=0;
for y=1:n-1
ysum(y)=sum(goal4(:,y));
end
%y=1:n-1;
%figure(12)
%plot(y,ysum)%画出y方向上的像素分布


%找出ysum分布的几个与y轴交点就是单个字符在y轴上分布的区间
i=1;j=1;
for y=1:n-2
    if (ysum(y)==0)&(ysum(y+1)~=0)
        yy(i)=y
        i=i+1;
    end
    
    if (ysum(y)~=0)&(ysum(y+1)==0)
        yx(j)=y
        j=j+1;
    end
end
[m_yy,n_yy]=size(yy);%求出字符的分布并分割
if n_yy==3 %根据n_yy和n_yx的个数及分布区间，选择分割区间
%segment
num1=goal4(1:m , 1:yx(1));%分割出字符1
figure(23);imshow(num1);


num2=goal4(1:m ,yy(1):yx(2));%分割出字符2
figure(24);imshow(num2);


num3=goal4(1:m ,  yy(2):yx(3));%分割出字符3
figure(25);imshow(num3);


num4=goal4(1:m ,  yy(3):n);%分割出字符4
figure(26);imshow(num4);


%[m1,n1]=size(num1)%求出各个字符的大小
%[m2,n2]=size(num2)
%[m3,n3]=size(num3)
%[m4,n4]=size(num4)
%对单个字符细分，避免字体出现大小不一致的情况，也就是再在x轴上进行分割
[ix1,iy1]=xfenge(num1)
[ix2,iy2]=xfenge(num2)
[ix3,iy3]=xfenge(num3)
[ix4,iy4]=xfenge(num4)
num1=goal4(ix1:iy1 , 1:yx(1));
figure(23);imshow(num1);


num2=goal4(ix2:iy2 ,yy(1):yx(2));
figure(24);imshow(num2);


num3=goal4(ix3:iy3 ,  yy(2):yx(3));
figure(25);imshow(num3);


num4=goal4(ix4:iy4 ,  yy(3):n);
figure(26);imshow(num4);
