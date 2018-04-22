clc;
clear all;
close all;
I=imread('D:\桌面\测试车牌\aaaa.jpg');
figure,imshow(I);title('原始图像');				%显示原始图像

Im1=rgb2gray(I);
% figure(2),imshow(Im1);
% title('灰度图');
Tiao=imadjust(Im1,[0.19,0.78],[0,1]); 		%调整图片拉伸灰度值
% figure(3),imshow(Tiao);title('增强灰度图');
Im2=edge(Im1,'sobel',0.15,'both'); 		%使用sobel算子进行边缘检测
% figure(4),imshow(Im2);
% title('sobel算子实现边缘检测')

se=[1;1;1];    %se为刷子，一个模板核
Im3=imerode(Im2,se); 		%图像腐蚀 
% figure,imshow(Im3);
% title('腐蚀效果图');
se=strel('rectangle',[5,21]); % 创建由指定形状的结构元素，矩形
Im4=imclose(Im3,se);		%对图像实现闭运算figure(6),
% figure,imshow(Im4);
% title('平滑图像的轮廓');

Im5=bwareaopen(Im4,	700); 	%删除小面积图形 
% figure(7),imshow(Im5);
% title('移除小对象');

[y,x]=size(Im5);
Im6=double(Im5); %double精度类型
Blue_y=zeros(y,1);								%创建元素为零的数组或矩阵y*1
 for i=1:y %从每行开始遍历图像
    for j=1:x
             if(Im6(i,j,1)==1) %求得图像中的白像素点
                  Blue_y(i,1)= Blue_y(i,1)+1; %求每行的白色像素点个数
            end  
     end       
 end
 [temp,MaxY]=max(Blue_y);		%求每行白色像素点最多的行数目，并且赋值给MaxY
 PY1=MaxY;
 while ((Blue_y(PY1,1)>=5)&&(PY1>1))%设置阈值行像素点大于5求取边缘的对应的坐标值
        PY1=PY1-1;%从最大的开始向上寻找上边缘坐标
 end    
 PY2=MaxY;    %上边缘坐标
 while ((Blue_y(PY2,1)>=10)&&(PY2<y))%从上边缘坐标开始向下寻找下边缘坐标
        PY2=PY2+1;
 end
 IY=I(PY1:PY2,:,:);%裁剪
%  figure,imshow(IY);
 
 Blue_x=zeros(1,x);
 for j=1:x  %从每列开始遍历图像
     for i=PY1:PY2
            if(Im6(i,j,1)==1)%寻找每列中白色像素点
                Blue_x(1,j)= Blue_x(1,j)+1; %求每列白色像素点个数
            end  
     end       
 end
 PX1=1;%给PX1赋初值1
 while ((Blue_x(1,PX1)<10)&&(PX1<x))%阈值为10，即白色像素点为3的时候停止寻找
       PX1=PX1+1;%向右寻找
 end    
 PX2=x;%给PX2赋初值x
 while ((Blue_x(1,PX2)<10)&&(PX2>PX1))%阈值为3，即白色像素点为3的时候停止寻找
        PX2=PX2-1;%向左寻找
 end
PX1=PX1-1;					%对车牌区域的校正
PX2=PX2+1;
dw=I(PY1+2:PY2-1,PX1+2:PX2-3 ,:); %裁剪
% figure,imshow(dw);
C1=im2bw(dw,0.51); %二值化图像
% figure,imshow(C1);
C=medfilt2(C1,[3,3]);%中值滤波去噪声
% figure,imshow(C);



v=zeros(19,1);
[m1,n1]=size(C);
S=sum(C);     % 求垂直投影
figure,plot(1:n1,S);
for e=1:n1-1
    if((S(e)==0&S(e+1)>0)|(S(e)>0&S(e+1)==0))
        v(e)=e;
    end
end
V=find(v>0);

if V(1)==1||S(V(1)-1)==0%防止S(0)的出现
    if(V(2)-V(1))<(n1/15)
        V(2)=[];
        V(1)=[];
    end
elseif S(V(1)-1)>0
    if V(1)<(n1/15)
        V(1)=[];
    end
end
[k,k1]=size(V);%V中存储着C投影节点的位置
% if S(V(k)+1)==0
%     if (V(k)-V(k-1))<(n1/15)
%         
%         V(k-1)=[];
%         [k,k1]=size(V);
%         V(k)=[];
%     end
%     
% elseif S(V(k)+1)>0
%     if (n1-V(k))<(n1/15)
%        [k,k1]=size(V); 
%         V(k)=[];
%     end
% end
% [k2,k3]=size(V);
% C1=C;%中值滤波去噪声
if S(V(1))>0       %第一个节点在汉字的右边
    if V(1)>(n1/15)%
%       D=C(:,1:n1);%裁剪特定图像
        D1=C1(:,2:V(1));
        figure,subplot(1,7,1),imshow(D1);
        D2=C1(:,V(2)+1:V(3));
        D2=bwareaopen(D2,100); 	%删除小面积图形 
        subplot(1,7,2),imshow(D2);
        if (V(7)-V(6))<(n1/18)
            D3=C1(:,(2*V(6)-V(7))+1:(2*V(7)-V(6)));
        else
            D3=C1(:,V(6)+1:V(7));
        end
    subplot(1,7,3),imshow(D3);
    if (V(9)-V(8))<(n1/18)
        D4=C1(:,(2*V(8)-V(9))+1:(2*V(9)-V(8)));
    else
        D4=C1(:,V(8)+1:V(9));
        
    end
    subplot(1,7,4),imshow(D4);
    if (V(11)-V(10))<(n1/18)
        D5=C1(:,(2*V(10)-V(11))+1:(2*V(11)-V(10)));
    else
        D5=C1(:,V(10)+1:V(11));
    end
    subplot(1,7,5),imshow(D5);
    if (V(13)-V(12))<(n1/18)
        D6=C1(:,(2*V(12)-V(13))+1:(2*V(13)-V(12)));
    else
        D6=C1(:,V(12)+1:V(13));
    end
    subplot(1,7,6),imshow(D6);
    if (V(15)-V(14))<(n1/18)
        D7=C1(:,(2*V(14)-V(15))+1:(2*V(15)-V(14)));
    else
        D7=C1(:,V(14)+1:V(15));
    end
    subplot(1,7,7),imshow(D7);
        
    end
else             %第一个节点在汉字的坐标
%     D=C(:,V(1)+1:n1);%裁剪一般图像
%     figure,imshow(D);
    D1=C1(:,V(1)+1:V(2));
    figure,subplot(1,7,1),imshow(D1);
    D2=C1(:,V(3)+1:V(4));
    D2=bwareaopen(D2,150); 	%删除小面积图形 
    subplot(1,7,2),imshow(D2);
    if (V(8)-V(7))<(n1/18)
        D3=C1(:,(2*V(7)-V(8))+1:(2*V(8)-V(7)));
        D3=bwareaopen(D3,50); 	%删除小面积图形 
    else
        D3=C1(:,V(7)+1:V(8));
        D3=bwareaopen(D3,90); 	%删除小面积图形 
    end
    subplot(1,7,3),imshow(D3);
    if (V(10)-V(9))<(n1/18)
        D4=C1(:,(2*V(9)-V(10))+1:(2*V(10)-V(9)));
        D4=bwareaopen(D4,50); 	%删除小面积图形 
    else
        D4=C1(:,V(9)+1:V(10));
        D4=bwareaopen(D4,100); 	%删除小面积图形 
    end
    subplot(1,7,4),imshow(D4);
    if (V(12)-V(11))<(n1/18)
        D5=C1(:,(2*V(11)-V(12))+1:(2*V(12)-V(11)));
        D5=bwareaopen(D5,50); 	%删除小面积图形 
    else
        D5=C1(:,V(11)+1:V(12));
        D5=bwareaopen(D5,50); 	%删除小面积图形 
    end
    subplot(1,7,5),imshow(D5);
    if (V(14)-V(13))<(n1/18)
        D6=C1(:,(2*V(13)-V(14))+1:(2*V(14)-V(13)));
        D6=bwareaopen(D6,50); 	%删除小面积图形 
    else
        D6=C1(:,V(13)+1:V(14));
        D6=bwareaopen(D6,90); 	%删除小面积图形 
    end
    subplot(1,7,6),imshow(D6);
    if (V(16)-V(15))<(n1/18)
        D7=C1(:,(2*V(15)-V(16))+1:(2*V(16)-V(15)));
        D7=bwareaopen(D7,50); 	%删除小面积图形 
    else
        D7=C1(:,V(15)+1:V(16));
        D7=bwareaopen(D7,50); 	%删除小面积图形 
    end
    subplot(1,7,7),imshow(D7);
end

[e1,f1]=size(D1);
 E1=sum(D1,2);    % 求水平投影
% figure,plot(1:e3,E3);   
if E1(1)>0&&E1(e1)>0
    G1=D1;
else
    for e=1:e1-1
        if ((E1(e)==0&E1(e+1)>0)|(E1(e)>0&E1(e+1)==0))
        q1(e)=e;
        Q1=find(q1>0);
        end
    end
    if E1(1)>0&E1(e1)==0
        G1=D1(1:max(Q1),:);
    elseif E1(1)==0&E1(e1)==0
        G1=D1(min(Q1)+1:max(Q1),:);
    elseif (E1(1)==0&E1(e1)>0)
        G1=D1(min(Q1)+1:e1,:);
    end
end
          
[e2,f2]=size(D2);
 E2=sum(D2,2);    % 求水平投影
% figure,plot(1:e3,E3);   
if E2(1)>0&&E2(e2)>0
    G2=D2;
else
    for e=1:e2-1
        if ((E2(e)==0&E2(e+1)>0)|(E2(e)>0&E2(e+1)==0))
        q2(e)=e;
        Q2=find(q2>0);
        end
    end
    if E2(1)>0&E2(e2)==0
        G2=D2(1:max(Q2),:);
    elseif E2(1)==0&E2(e2)==0
        G2=D2(min(Q2)+1:max(Q2),:);
    elseif E2(1)==0&E2(e2)>0
        G2=D2(min(Q2)+1:e2,:);
    end
end

[e3,f3]=size(D3);
 E3=sum(D3,2);    % 求水平投影
% figure,plot(1:e3,E3);   
if E3(1)>0&&E3(e3)>0
    G3=D3;
else
    for e=1:e3-1
        if ((E3(e)==0&E3(e+1)>0)|(E3(e)>0&E3(e+1)==0))
        q3(e)=e;
        Q3=find(q3>0);
        end
    end
    if E3(1)>0&E3(e3)==0
        G3=D3(1:max(Q3),:);
    elseif E3(1)==0&E3(e3)==0
        G3=D3(min(Q3)+1:max(Q3),:);
    elseif E3(1)==0&E3(e3)>0
        G3=D3(min(Q3)+1:e3,:);
    end
end

[e4,f4]=size(D4);
 E4=sum(D4,2);    % 求水平投影
% figure,plot(1:e3,E3);   
if E4(1)>0&&E4(e4)>0
    G4=D4;
else
    for e=1:e4-1
        if ((E4(e)==0&E4(e+1)>0)|(E4(e)>0&E4(e+1)==0))
        q4(e)=e;
        Q4=find(q4>0);
        end
    end
    if E4(1)>0&E4(e4)==0
        G4=D4(1:max(Q4),:);
    elseif E4(1)==0&E4(e4)==0
        G4=D4(min(Q4)+1:max(Q4),:);
    elseif E4(1)==0&E4(e4)>0
        G4=D4(min(Q4)+1:e4,:);
    end
end

[e5,f5]=size(D5);
 E5=sum(D5,2);    % 求水平投影
% figure,plot(1:e3,E3);   
if E5(1)>0&&E5(e5)>0
    G5=D5;
else
    for e=1:e5-1
        if ((E5(e)==0&E5(e+1)>0)|(E5(e)>0&E5(e+1)==0))
        q5(e)=e;
        Q5=find(q5>0);
        end
    end
    if E5(1)>0&E5(e5)==0
        G5=D5(1:max(Q5),:);
    elseif E5(1)==0&E5(e5)==0
        G5=D5(min(Q5)+1:max(Q5),:);
    elseif E5(1)==0&E5(e5)>0
        G5=D5(min(Q5)+1:e5,:);
    end
end

[e6,f6]=size(D6);
 E6=sum(D6,2);    % 求水平投影
% figure,plot(1:e3,E3);   
if E6(1)>0&&E6(e6)>0
    G6=D6;
else
    for e=1:e6-1
        if ((E6(e)==0&E6(e+1)>0)|(E6(e)>0&E6(e+1)==0))
        q6(e)=e;
        Q6=find(q6>0);
        end
    end
    if E6(1)>0&E6(e6)==0
        G6=D6(1:max(Q6),:);
    elseif E6(1)==0&E6(e6)==0
        G6=D6(min(Q6)+1:max(Q6),:);
    elseif E6(1)==0&E6(e6)>0
        G6=D6(min(Q6)+1:e6,:);
    end
end

[e7,f7]=size(D7);
 E7=sum(D7,2);    % 求水平投影
% figure,plot(1:e3,E3);   
if E7(1)>0&&E7(e7)>0
    G7=D7;
else
    for e=1:e7-1
        if ((E7(e)==0&E7(e+1)>0)|(E7(e)>0&E7(e+1)==0))
        q7(e)=e;
        Q7=find(q7>0);
        end
    end
    if E7(1)>0&E7(e7)==0
        G7=D7(1:max(Q7),:);
    elseif E7(1)==0&E7(e7)==0
        G7=D7(min(Q7)+1:max(Q7),:);
    elseif E7(1)==0&E7(e7)>0
        G7=D7(min(Q7)+1:e7,:);
    end
end
figure,subplot(1,7,1),imshow(G1);
subplot(1,7,2),imshow(G2);
subplot(1,7,3),imshow(G3);
subplot(1,7,4),imshow(G4);
subplot(1,7,5),imshow(G5);
subplot(1,7,6),imshow(G6);
subplot(1,7,7),imshow(G7);
G1=imresize(G1,[32 16],'nearest');
G2=imresize(G2,[32 16],'nearest');
G3=imresize(G3,[32 16],'nearest');
G4=imresize(G4,[32 16],'nearest');
G5=imresize(G5,[32 16],'nearest');
G6=imresize(G6,[32 16],'nearest');
G7=imresize(G7,[32 16],'nearest');
imwrite(im2bw(G1,0.495),'D:\桌面\测试车牌\分割字符\1.jpg');
imwrite(im2bw(G2,0.495),'D:\桌面\测试车牌\分割字符\2.jpg');
imwrite(im2bw(G3,0.495),'D:\桌面\测试车牌\分割字符\3.jpg');
imwrite(im2bw(G4,0.495),'D:\桌面\测试车牌\分割字符\4.jpg');
imwrite(im2bw(G5,0.495),'D:\桌面\测试车牌\分割字符\5.jpg');
imwrite(im2bw(G6,0.495),'D:\桌面\测试车牌\分割字符\6.jpg');
imwrite(im2bw(G7,0.495),'D:\桌面\测试车牌\分割字符\7.jpg');


liccode=char(['111111111122222222223333333333444444444455555555556666666666'...
    '7777777777888888888899999999990000000000AAAAAAAAAABBBBBBBBBBCCCCCCCCCC'...
    'DDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHJJJJJJJJJJKKKKKKKKKK'...
    'LLLLLLLLLLMMMMMMMMMMNNNNNNNNNNPPPPPPPPPPQQQQQQQQQQRRRRRRRRRRSSSSSSSSSS'...
    'TTTTTTTTTTUUUUUUUUUUVVVVVVVVVVWWWWWWWWWWXXXXXXXXXXYYYYYYYYYYZZZZZZZZZZ'...
    '川黑京辽鲁闽苏皖豫浙皖鲁鲁']);  %建立自动识别字符代码表 
Y1=imread('D:\桌面\测试车牌\分割字符\1.jpg');   %读取图片文件中的数据

 for k1=341:353
            fname=strcat('D:\桌面\测试车牌\总字符1\',num2str(k1),'.jpg');
            B1=imread(fname);  %读取图片文件中的数据
            C=Y1-B1; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A1(k1-340)=d;
 end
 [a1,b1]=min(A1);
 
 Y2=imread('D:\桌面\测试车牌\分割字符\2.jpg');   %读取图片文件中的数据
 for k2=101:340
            fname=strcat('D:\桌面\测试车牌\总字符1\',num2str(k2),'.jpg');
            B2=imread(fname);  %读取图片文件中的数据
            C=Y2-B2; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A2(k2-100)=d;
 end
 [a2,b2]=min(A2);

 Y3=imread('D:\桌面\测试车牌\分割字符\3.jpg');   %读取图片文件中的数据
 for k3=1:340
            fname=strcat('D:\桌面\测试车牌\总字符1\',num2str(k3),'.jpg');
            B3=imread(fname);  %读取图片文件中的数据
            C=Y3-B3; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A3(k3)=d;
 end
 [a3,b3]=min(A3);
 
  Y4=imread('D:\桌面\测试车牌\分割字符\4.jpg');   %读取图片文件中的数据
 for k4=1:340
            fname=strcat('D:\桌面\测试车牌\总字符1\',num2str(k4),'.jpg');
            B4=imread(fname);  %读取图片文件中的数据
            C=Y4-B4; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A4(k4)=d;
 end
 [a4,b4]=min(A4);

  Y5=imread('D:\桌面\测试车牌\分割字符\5.jpg');   %读取图片文件中的数据
 for k5=1:340
            fname=strcat('D:\桌面\测试车牌\总字符1\',num2str(k5),'.jpg');
            B5=imread(fname);  %读取图片文件中的数据
            C=Y5-B5; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A5(k5)=d;
 end
 [a5,b5]=min(A5);
 
   Y6=imread('D:\桌面\测试车牌\分割字符\6.jpg');   %读取图片文件中的数据
 for k6=1:340
            fname=strcat('D:\桌面\测试车牌\总字符1\',num2str(k6),'.jpg');
            B6=imread(fname);  %读取图片文件中的数据
            C=Y6-B6; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A6(k6)=d;
 end
 [a6,b6]=min(A6);
 
   Y7=imread('D:\桌面\测试车牌\分割字符\7.jpg');   %读取图片文件中的数据
 for k7=1:340
            fname=strcat('D:\桌面\测试车牌\总字符1\',num2str(k7),'.jpg');
            B7=imread(fname);  %读取图片文件中的数据
            C=Y7-B7; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A7(k7)=d;
 end
 [a7,b7]=min(A7);

 figure,imshow(dw),title(['车牌号码:','   ',liccode(b1+340),liccode(b2+100),'  ',liccode(b3),...
     liccode(b4),liccode(b5),liccode(b6),liccode(b7)],'Color','r'); 







% liccode=char(['0':'9' 'ABCDEFGHJKLMNPQRSTUVWXYZ' '川黑京辽鲁闽苏皖豫浙']);  %建立自动识别字符代码表 
% Y1=imread('D:\桌面\测试车牌\分割字符\1.bmp');   %读取图片文件中的数据
%  for k1=35:44
%             fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k1),'.bmp');
%             B=imread(fname);  %读取图片文件中的数据
%             C=Y1-B; % 以上相当于两幅图相减得到第三幅图
%             d=sum(sum(C));
%             A1(k1-34)=d;
%  end
%  [a1,b1]=min(A1);
%  
%  Y2=imread('D:\桌面\测试车牌\分割字符\2.jpg');   %读取图片文件中的数据
%  for k2=11:34
%             fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k2),'.bmp');
%             B=imread(fname);  %读取图片文件中的数据
%             C=Y2-B; % 以上相当于两幅图相减得到第三幅图
%             d=sum(sum(C));
%             A2(k2-10)=d;
%  end
%  [a2,b2]=min(A2);
% 
%  Y3=imread('D:\桌面\测试车牌\分割字符\3.jpg');   %读取图片文件中的数据
%  for k3=1:34
%             fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k3),'.bmp');
%             B=imread(fname);  %读取图片文件中的数据
%             C=Y3-B; % 以上相当于两幅图相减得到第三幅图
%             d=sum(sum(C));
%             A3(k3)=d;
%  end
%  [a3,b3]=min(A3);
%  
%   Y4=imread('D:\桌面\测试车牌\分割字符\4.jpg');   %读取图片文件中的数据
%  for k4=1:34
%             fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k4),'.bmp');
%             B=imread(fname);  %读取图片文件中的数据
%             C=Y4-B; % 以上相当于两幅图相减得到第三幅图
%             d=sum(sum(C));
%             A4(k4)=d;
%  end
%  [a4,b4]=min(A4);
% 
%   Y5=imread('D:\桌面\测试车牌\分割字符\5.jpg');   %读取图片文件中的数据
%  for k5=1:34
%             fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k5),'.bmp');
%             B=imread(fname);  %读取图片文件中的数据
%             C=Y5-B; % 以上相当于两幅图相减得到第三幅图
%             d=sum(sum(C));
%             A5(k5)=d;
%  end
%  [a5,b5]=min(A5);
%  
%    Y6=imread('D:\桌面\测试车牌\分割字符\6.jpg');   %读取图片文件中的数据
%  for k6=1:34
%             fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k6),'.bmp');
%             B=imread(fname);  %读取图片文件中的数据
%             C=Y6-B; % 以上相当于两幅图相减得到第三幅图
%             d=sum(sum(C));
%             A6(k6)=d;
%  end
%  [a6,b6]=min(A6);
%  
%    Y7=imread('D:\桌面\测试车牌\分割字符\7.jpg');   %读取图片文件中的数据
%  for k7=1:34
%             fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k7),'.bmp');
%             B=imread(fname);  %读取图片文件中的数据
%             C=Y7-B; % 以上相当于两幅图相减得到第三幅图
%             d=sum(sum(C));
%             A7(k7)=d;
%  end
%  [a7,b7]=min(A7);
% 
%  figure,imshow(dw),title(['车牌号码:',liccode(b1+34),liccode(b2+10),'  ',liccode(b3),...
%      liccode(b4),liccode(b5),liccode(b6),liccode(b7)],'Color','r'); 

