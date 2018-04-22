clear;
clc;
close all;
I=imread('D:\桌面\300.jpg');
[y,x,z]=size(I);
myI=double(I);
%%%%%%%%%%% RGB to HSI %%%%%%%%
tic % 测定算法执行的时间，开始计时
%%%%%%%%%%% 统计分析 %%%%%%%%%%%%%%%
%%%%%%%% Y 方向 %%%%%%%%%%
Blue_y=zeros(y,1);
for i=1:y
for j=1:x
if((myI(i,j,1)<=30)&&((myI(i,j,2)<=70)&&(myI(i,j,2)>=49))&&((myI(i,j,3)<=142)&&(myI(i,j,3)>=100)))
% 蓝色RGB的灰度范围
Blue_y(i,1)= Blue_y(i,1)+1; % 蓝色象素点统计
end
end
end
[temp MaxY]=max(Blue_y); % Y方向车牌区域确定
PY1=MaxY;
while ((Blue_y(PY1,1)>0)&&(PY1>1))
PY1=PY1-1;
end
PY2=MaxY;
while ((Blue_y(PY2,1)>0)&&(PY2<y))
PY2=PY2+1;
end
IY=I(PY1:PY2,:,:);
if PY2<y-2
PY1=PY1-2; % 对车牌区域的修正
PY2=PY2+2;
end
%%%%%%%% X 方向 %%%%%%%%%%
Blue_x=zeros(1,x); % 进一步确定X方向的车牌区域
for j=1:x
for i=PY1:PY2
if((myI(i,j,1)<=30)&&((myI(i,j,2)<=70)&&(myI(i,j,2)>=49))&&((myI(i,j,3)<=142)&&(myI(i,j,3)>=100)))
Blue_x(1,j)= Blue_x(1,j)+1;
end
end
end
PX1=1;
while ((Blue_x(1,PX1)<1))&&(PX1<x)
PX1=PX1+1;
end
PX2=x;
while ((Blue_x(1,PX2)<1))&&(PX2>PX1)
PX2=PX2-1;
end
if PX2<x-2
PX1=PX1-2; % 对车牌区域的修正
PX2=PX2+2;
end
Plate=I(PY1:PY2,PX1-2:PX2,:);
t=toc; % 读取计时
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure,imshow(I);
figure,plot(Blue_y);grid
figure,plot(Blue_x);grid
figure,imshow(IY);
figure,imshow(Plate);
