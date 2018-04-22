clc;
clear;
close all;
I3=imread('D:\桌面\20.jpg');
B=rgb2gray(I3);           %转化为灰度图像
figure, imshow(B);
[m,n]=size(B);            %求出图像的列行数目
if m>=n
    L=imcrop(B,[0,0,n,n]);%裁剪为正方形图像
else
    L=imcrop(B,[0,0,m,m]);%裁剪为正方形图像
end
C1=(fft2(L));     %fftshift(平移到中心点）
D1=mat2gray(log(1+abs(C1)));%频谱图像
figure,imshow(D1);
% F=im2bw(D,0.41275);      %转化为二值图像
% figure,imshow(F);
% T = graythresh(D);
F=edge(D1, 'canny', 0.55);
figure,imshow(F);            %备用的另一种算法canny算子

[m,n]=size(F);            %求出图像的列行数目
E=imcrop(F,[30,30,m-40,n-40]);%裁剪为正方形图像，减少干扰条纹
figure,imshow(E);
theta=0:1:180;
[R,xp]=radon(E,theta);  %做Radon变换 提取角度
figure,surf(theta,xp,R);
figure,plot(theta,R);
imagesc(theta,xp,R);     %画三维图
title('R_theta X'); 
xlabel('theta(degree)'); 
ylabel('X\prime');
colormap(hot); 
colorbar;
 a=max(max(R));
 [x,y]=find(R==max(max(R)));%找出最大值点，求出角度
 if y>=180
     y=y-180
 else
     y
 end
 
  if y>=90                                     %显示专用
      I6=imrotate(L,180-y,'bilinear','crop');
 else
      I6=imrotate(L,-y,'bilinear','crop');
 end
 
 if y>=90                                       %计算专用
      I5=imrotate(L,180-y,'bilinear','loose');
 else
      I5=imrotate(L,-y,'bilinear','loose');
 end
% figure,imshow(I5);
A = conv2(I6,[-0.5 0.5]);       %//求水平轴方向上的一阶微分图像
A1 = conv2(I5,[-0.5 0.5]);       %//求水平轴方向上的一阶微分图像
% figure, imshow(A);
F=im2bw(A1,0.9575);      %转化为二值图像
figure,imshow(F);

F1=medfilt2(F,[5,5]);   %中值滤波
% figure,imshow(F1);
 if y>=90
      K=imrotate(F1,y-180,'bilinear','crop');
 else
      K=imrotate(F1,y,'bilinear','crop');
 end

figure,imshow(K);
% G=edge(K, 'canny', 0.55);
% figure,imshow(G);              %canny算子
A(:,1) = 0;                    %将第一列置0，防止边界影响
A(:,size(A,2)) = 0;            %最后一列置0，防止边界影响
% figure, imshow(dif);
for j = 1:size(A,1)          %循环行数
    s(j,:) = xcorr(A(j,:));  %//对dif每行进行自相关运算
end
% figure, imshow(s);
b=sum(s,1);                   %每一列求和
figure,plot(b);               %画图
[c,i]=min(b);                 %寻找最小值，把它赋值给c
[m,n]=find(b==c);             %寻找最小值的横坐标n，m为最小值
% m
% n
l=(n(1,2)-n(1,1))/2             %求出模糊尺度


PSF=fspecial('motion',l,y);%设置点扩散函数
% figure,imshow(PSF,[],'notruesize');
% B=imread('D:\桌面\11.png');
figure,imshow(B);
% C=deconvwnr(B,PSF);
C1=deconvlucy(B,PSF,80);

figure,imshow(C1);
%  D1=im2bw(C1,0.61275);
% figure,imshow(D1);
% F1=medfilt2(D1,[3,3]);   %中值滤波
% figure,imshow(F1);
 
 
 
 
