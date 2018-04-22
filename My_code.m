clc;
clear all;
close all;		
I=imread('D:\桌面\55.jpg');          %读入图片
% figure,imshow(I);title('原始图像');	  %显示原始图像
E1=rgb2gray(I);                      %灰度图像
% figure,imshow(E1);
A=medfilt2(E1,[3 3]);                 %中值滤波
figure,imshow(A);
E1=edge(A,'sobel',0.15,'both');%边缘提取
figure,imshow(E1);
b1=imclose(E1,strel('rectangle',[5,19]));%取矩形核模的闭运算
figure,imshow(b1);
b2=imopen(b1,strel('rectangle',[5,19]));%取[5,19]矩形核模的开运算
figure,imshow(b2);
b3=imclose(b2,strel('rectangle',[11,15]));%取[11,5]矩形核模的开运算
figure,imshow(b3);
% se=strel('rectangle',[5,19]);
% E1=imclose(E1,se);
% figure,imshow(E1);

% E1=bwareaopen(E1,2000); 			%删除小面积图形 
% figure,imshow(E1);
% title('移除小对象');


E2=imfill(E1,'holes');  %充填
figure, imshow(E2); 

[m n]=size(E1);




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
    if Sx(i)>40   %设置阈值10
        x(i)=Sx(i);
    else
        x(i)=0;
    end
end
figure,subplot(211),plot(1:n,x);
% figure,plot(1:n,Sx);   
Sy=sum(E2,2);    % 求水平投影
for i=1:m         
    if Sy(i)>20   %设置阈值20
        y(i)=Sy(i);
    else
        y(i)=0;
    end
end
subplot(212),plot(1:m,y);
% figure,plot(1:m,Sy);
[d1 d2]=find(x>=1);
a=minmax(d2);
a1=a(1,1);
a2=a(1,2);
a3=a2-a1;
[f1 f2]=find(y>=1);
b=minmax(f2);
b1=b(1,1);
b2=b(1,2);
b3=b2-b1;
L=imcrop(A,[a1,b1,a3,b3]);%裁剪
figure,imshow(L);









