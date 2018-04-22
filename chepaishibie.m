function []=main(jpg)
close all
clc
tic        									%测定算法执行的时间

%  [fn,pn,fi]=uigetfile('D:\桌面\zz.jpg','选择图片');			%读入图片
I=imread('D:\桌面\sss.jpg');
figure,imshow(I);title('原始图像');				%显示原始图像

Im1=rgb2gray(I);
figure(2),subplot(1,2,1),
imshow(Im1);
title('灰度图');
figure(2),
subplot(1,2,2),
imhist(Im1);
title('灰度图的直方图');						%显示图像的直方图

Tiao=imadjust(Im1,[0.19,0.78],[0,1]); 				%调整图片
figure(3),
subplot(1,2,1),
imshow(Tiao);title('增强灰度图');
figure(3),
subplot(1,2,2),
imhist(Tiao);
title('增强灰度图的直方图');

Im2=edge(Im1,'sobel',0.15,'both'); 				%使用sobel算子进行边缘检测
figure(4),
imshow(Im2);
title('sobel算子实现边缘检测')

se=[1;1;1];
Im3=imerode(Im2,se); 							%图像腐蚀 
figure(5),
imshow(Im3);
title('腐蚀效果图');
se=strel('rectangle',[25,25]); 					% 创建由指定形状的结构元素，矩形
Im4=imclose(Im3,se);							%对图像实现闭运算figure(6),
imshow(Im4);
title('平滑图像的轮廓');

Im5=bwareaopen(Im4,700); 					%删除小面积图形 
figure(7),
imshow(Im5);
title('移除小对象');

[y,x,z]=size(Im5);
Im6=double(Im5);
Blue_y=zeros(y,1);								%创建元素为零的数组或矩阵y*1
 for i=1:y
    for j=1:x
             if(Im6(i,j,1)==1) 
                  Blue_y(i,1)= Blue_y(i,1)+1; 	%根据Im5的y值确定
            end  
     end       
 end
 [temp MaxY]=max(Blue_y);						%垂直方向车牌区域确定
 PY1=MaxY;
 while ((Blue_y(PY1,1)>=5)&&(PY1>1))
        PY1=PY1-1;
 end    
 PY2=MaxY;
 while ((Blue_y(PY2,1)>=5)&&(PY2<y))
        PY2=PY2+1;
 end
 IY=I(PY1:PY2,:,:);
 Blue_x=zeros(1,x);
 for j=1:x
     for i=PY1:PY2
            if(Im6(i,j,1)==1)
                Blue_x(1,j)= Blue_x(1,j)+1; 			%根据Im5的x值确定 
            end  
     end       
 end
 PX1=1;
 while ((Blue_x(1,PX1)<3)&&(PX1<x))
       PX1=PX1+1;
 end    
 PX2=x;
 while ((Blue_x(1,PX2)<3)&&(PX2>PX1))
        PX2=PX2-1;
 end
 PX1=PX1-1;										%对车牌区域的校正
 PX2=PX2+1;
  dw=I(PY1:PY2-6,PX1:PX2 ,:); 
figure(8),
subplot(1,2,1),
imshow(IY),
title('垂直方向合理区域');
figure(8),
subplot(1,2,2),
imshow(dw),
title('定位剪切后的彩色车牌图像')

imwrite(dw,'dw.jpg'); 								%把图像写入图形文件中

a=imread('dw.jpg');
b=rgb2gray(a);
imwrite(b,'车牌灰度图像.jpg');
figure(9);
subplot(3,2,1),
imshow(b),
title('1.车牌灰度图像')

g_max=double(max(max(b)));
g_min=double(min(min(b)));
T=round(g_max-(g_max-g_min)/3); 					%T为设定的二值化的阈值
[m,n]=size(b);
d=(double(b)>=T);  % d为二值图像
imwrite(d,'车牌二值图像.jpg');
figure(9);
subplot(3,2,2),
imshow(d),
title('2.车牌二值图像')
figure(9),
subplot(3,2,3),
imshow(d),
title('3.均值滤波前')

h=fspecial('average',3);
d=im2bw(round(filter2(h,d)));
imwrite(d,'均值滤波后.jpg');
figure(9),
subplot(3,2,4),
imshow(d),
title('4.均值滤波后')

se=eye(2); 
[m,n]=size(d); % d为二值图像
if bwarea(d)/m/n>=0.365
    d=imerode(d,se);
elseif bwarea(d)/m/n<=0.235
    d=imdilate(d,se);
end
imwrite(d,'膨胀或腐蚀处理后.jpg');
figure(9),
subplot(3,2,5),
imshow(d),
title('5.膨胀或腐蚀处理后')

d=QieGe(d);								%寻找连续有文字的块
[m,n]=size(d);
k1=1;k2=1;s=sum(d);j=1;
while j~=n
    while s(j)==0
        j=j+1;
    end
    k1=j;
    while s(j)~=0 && j<=n-1
        j=j+1;
    end
    k2=j-1;
    if k2-k1>=round(n/6.5)
        [val,num]=min(sum(d(:,[k1+5:k2-5])));
        d(:,k1+num+5)=0; 
    end
end

d=QieGe(d);
y1=10;y2=0.25;flag=0;word1=[];
while flag==0
    [m,n]=size(d);
    left=1;wide=0;
    while sum(d(:,wide+1))~=0
        wide=wide+1;
    end
    if wide<y1  
        d(:,[1:wide])=0;
        d=QieGe(d);
    else
        temp=QieGe(imcrop(d,[1 1 wide m]));
        [m,n]=size(temp);
        all=sum(sum(temp));
        two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
        if two_thirds/all>y2
            flag=1;word1=temp; 
        end
        d(:,[1:wide])=0;d=QieGe(d);
    end
end

[word2,d]=FenGe(d);	%分割出第二个字符
[word3,d]=FenGe(d);	%分割出第三个字符
[word4,d]=FenGe(d);	%分割出第四个字符
[word5,d]=FenGe(d);	%分割出第五个字符
[word6,d]=FenGe(d);	%分割出第六个字符
[word7,d]=FenGe(d);	%分割出第七个字符

word1=imresize(word1,[40 20]);	%模板字符大小统一为40*20为字符辨认做准备
word2=imresize(word2,[40 20]);
word3=imresize(word3,[40 20]);
word4=imresize(word4,[40 20]);
word5=imresize(word5,[40 20]);
word6=imresize(word6,[40 20]);
word7=imresize(word7,[40 20]);
figure(10)
subplot(2,7,1),
imshow(word1),
title('1');
subplot(2,7,2),
imshow(word2),
title('2');
subplot(2,7,3),
imshow(word3),
title('3');
subplot(2,7,4),
imshow(word4),
title('4');
subplot(2,7,5),
imshow(word5),
title('5');
subplot(2,7,6),
imshow(word6),
title('6');
subplot(2,7,7),
imshow(word7),
title('7');
imwrite(word1,'1.jpg');
imwrite(word2,'2.jpg');
imwrite(word3,'3.jpg');
imwrite(word4,'4.jpg');
imwrite(word5,'5.jpg');
imwrite(word6,'6.jpg');
imwrite(word7,'7.jpg');
% 
% liccode=char(['0':'9' 'A':'Z' '京辽鲁陕苏浙']);   	%建立自动识别字符代码表，顺序应与文件夹中的相同  
% l=1;                                              
% for I=1:7
%       ii=int2str(I);                         	%将整数转换为字符串
%      t=imread([ii,'.jpg']);
%       SegBw2=imresize(t,[40 20],'nearest');    	%改变图像的大小
%         if l==1             	%第一位汉字识别
%             kmin=37;
%             kmax=40;
%       elseif l>=2&&l<=3     	%第二、三位 A~Z 字母识别，可根据车牌情况做修改
%             kmin=11;
%             kmax=36;
%       elseif l>=4 & l<=7	%第三、四位 0~9  A~Z字母和数字识别，可根据车牌情况做修改
%             kmin=1;
%             kmax=10;        
%         end        
%         for k2=kmin:kmax
%             fname=strcat('字符模板\',liccode(k2),'.jpg');
%             SamBw2 = imread(fname);
%             Dm=0;
%             for k1=1:40
%                 for l1=1:20
%                     if  SegBw2(k1,l1)==SamBw2(k1,l1)
%                         Dm=Dm+1;   	%判断分割字符与模板字符的相似度
%                     end
%                 end
%             end
%             Error(k2)=Dm;
%         end
%         Error1=Error(kmin:kmax);
%         MinError=max(Error1);
%         findc=find(Error1==MinError);	%返回矩阵中非0项的坐标
%         Resault(l*2-1)=liccode(findc(1)+kmin-1);
%         Resault(l*2)=' ';
%         l=l+1;     
% end
% t=toc  
% Resault
% msgbox(Resault,'识别结果')
% 
% fid=fopen('Data.xls','a+');
% fprintf(fid,'%s\r\n',Resault,datestr(now));
% fclose(fid);                   			%将识别结果保存在Data.xls中
% 
% function [word,result]=FenGe(d) 			%定义分割字符用函数（1）
% word=[];flag=0;y1=8;y2=0.5;
%     while flag==0
%         [m,n]=size(d);
%         wide=0;
%         while sum(d(:,wide+1))~=0 && wide<=n-2
%             wide=wide+1;
%         end
%         temp=QieGe(imcrop(d,[1 1 wide m]));
%         [m1,n1]=size(temp);
%         if wide<y1 && n1/m1>y2
%             d(:,[1:wide])=0;
%             if sum(sum(d))~=0
%                 d=QieGe(d);  	%切割出最小范围
%             else word=[];flag=1;
%             end
%         else
%             word=QieGe(imcrop(d,[1 1 wide m]));
%             d(:,[1:wide])=0;
%             if sum(sum(d))~=0;
%                 d=QieGe(d);flag=1;
%             else d=[];
%             end
%         end
%     end
%          result=d;       
% function e=QieGe(d) 	%定义分割字符用函数（2）
% [m,n]=size(d);
% top=1;bottom=m;left=1;right=n;   % init
% while sum(d(top,:))==0 && top<=m
%     top=top+1;
% end
% while sum(d(bottom,:))==0 && bottom>=1
%     bottom=bottom-1;
% end
% while sum(d(:,left))==0 && left<=n
%     left=left+1;
% end
% while sum(d(:,right))==0 && right>=1
%     right=right-1;
% end
% dd=right-left;
% hh=bottom-top;
% e=imcrop(d,[left top dd hh]);
