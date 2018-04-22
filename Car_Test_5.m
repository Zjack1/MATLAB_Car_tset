clc;
clear all;
close all;		
I=imread('D:\桌面\55.jpg');                    %读入图片
figure,imshow(I);title('原始图像');				%显示原始图像
E=rgb2gray(I);
figure,imshow(E);
bw=edge(E,'canny',0.311,'both');%边缘提取
% figure;imshow(bw);
theta=1:180;%再在1到180度角内对图像进行旋转，记录下边缘提取后的图像在x轴方向上的投影，
[R,xp]=radon(bw,theta);%当x轴方向上的投影最小的时候即表示图像中字符平行于y轴，已经完成矫正
[I0,J]=find(R>=max(max(R)));%J记录了倾斜角
qingxiejiao=90-J
g=imrotate(E,qingxiejiao,'bilinear','crop');
figure,imshow(g);

C1=medfilt2(g,[3,3]);%中值滤波
figure,imshow(C1);

E1=edge(g,'sobel',0.12,'both');%边缘提取
figure,imshow(E1);
se=[1;1;1];          %腐蚀处理
D=imerode(E1,se);
figure,imshow(D);
se=strel('rectangle',[5,22]);
F=imclose(D,se); %闭运算
figure,imshow(F);%平滑处理

E2=bwareaopen(F,1300); 					%删除小面积图形 
figure,imshow(E2);
title('移除小对象');


[m n]=size(E2);
% for y=1:n      % 求垂直投影
%      S1(y)=sum(E1(1:m,y));
% end
% y=1:n;
% figure,subplot(211),plot(y,S1(y));
% title('垂直投影');
% 
% for x=1:m  % 求水平投影
%     S2(x)=sum(E1(x,:));
% end
% x=1:m;
% subplot(212),plot(x,S2(x));
% title('水平投影');

Sx=sum(E2);     % 求垂直投影
for i=1:n         
    if Sx(i)>10  %设置阈值
        x(i)=Sx(i);
    else
        x(i)=0;
    end
end
figure,subplot(211),plot(1:n,x);
% figure,pl                   ot(1:n,Sx);   
Sy=sum(E2,2);    % 求水平投影
for i=1:m         
    if Sy(i)>10   %设置阈值
        y(i)=Sy(i);
    else
        y(i)=0;
    end
end
subplot(212),plot(1:m,y);
% figure,plot(1:m,Sy);
[d1 d2]=find(x>=1);
a=minmax(d2);
a1=a(1,1)+5;
a2=a(1,2)-5;
a3=a2-a1;
[f1 f2]=find(y>=1);
b=minmax(f2);
b1=b(1,1);
b2=b(1,2);
b3=b2-b1;
L=imcrop(g,[a1,b1,a3,b3]);%裁剪
figure,imshow(L);
C=im2bw(L,0.495);
figure,imshow(C);
C1=medfilt2(C,[3,3]);%中值滤波
figure,imshow(C1);






