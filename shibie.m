clc;
clear all;
close all;
liccode=char(['111111111122222222223333333333444444444455555555556666666666'...
    '7777777777888888888899999999990000000000AAAAAAAAAABBBBBBBBBBCCCCCCCCCC'...
    'DDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHJJJJJJJJJJKKKKKKKKKK'...
    'LLLLLLLLLLMMMMMMMMMMNNNNNNNNNNPPPPPPPPPPQQQQQQQQQQRRRRRRRRRRSSSSSSSSSS'...
    'TTTTTTTTTTUUUUUUUUUUVVVVVVVVVVWWWWWWWWWWXXXXXXXXXXYYYYYYYYYYZZZZZZZZZZ'...
    '川黑京辽鲁闽苏皖豫浙皖鲁鲁']);  %建立自动识别字符代码表 
Y1=imread('D:\桌面\测试车牌\分割字符\1.bmp');   %读取图片文件中的数据

 for k1=341:353
            fname=strcat('D:\桌面\测试车牌\总字符2\',num2str(k1),'.bmp');
            B1=imread(fname);  %读取图片文件中的数据
            C=Y1-B1; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A1(k1-340)=d;
 end
 [a1,b1]=min(A1);
 
 Y2=imread('D:\桌面\测试车牌\分割字符\2.bmp');   %读取图片文件中的数据
 for k2=101:340
            fname=strcat('D:\桌面\测试车牌\总字符2\',num2str(k2),'.bmp');
            B2=imread(fname);  %读取图片文件中的数据
            C=Y2-B2; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A2(k2-100)=d;
 end
 [a2,b2]=min(A2);

 Y3=imread('D:\桌面\测试车牌\分割字符\3.bmp');   %读取图片文件中的数据
 for k3=1:340
            fname=strcat('D:\桌面\测试车牌\总字符2\',num2str(k3),'.bmp');
            B3=imread(fname);  %读取图片文件中的数据
            C=Y3-B3; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A3(k3)=d;
 end
 [a3,b3]=min(A3);
 
  Y4=imread('D:\桌面\测试车牌\分割字符\4.bmp');   %读取图片文件中的数据
 for k4=1:340
            fname=strcat('D:\桌面\测试车牌\总字符2\',num2str(k4),'.bmp');
            B4=imread(fname);  %读取图片文件中的数据
            C=Y4-B4; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A4(k4)=d;
 end
 [a4,b4]=min(A4);

  Y5=imread('D:\桌面\测试车牌\分割字符\5.bmp');   %读取图片文件中的数据
 for k5=1:340
            fname=strcat('D:\桌面\测试车牌\总字符2\',num2str(k5),'.bmp');
            B5=imread(fname);  %读取图片文件中的数据
            C=Y5-B5; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A5(k5)=d;
 end
 [a5,b5]=min(A5);
 
   Y6=imread('D:\桌面\测试车牌\分割字符\6.bmp');   %读取图片文件中的数据
 for k6=1:340
            fname=strcat('D:\桌面\测试车牌\总字符2\',num2str(k6),'.bmp');
            B6=imread(fname);  %读取图片文件中的数据
            C=Y6-B6; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A6(k6)=d;
 end
 [a6,b6]=min(A6);
 
   Y7=imread('D:\桌面\测试车牌\分割字符\7.bmp');   %读取图片文件中的数据
 for k7=1:340
            fname=strcat('D:\桌面\测试车牌\总字符2\',num2str(k7),'.bmp');
            B7=imread(fname);  %读取图片文件中的数据
            C=Y7-B7; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A7(k7)=d;
 end
 [a7,b7]=min(A7);

 figure,title(['车牌号码:',liccode(b1+340),liccode(b2+100),liccode(b3),...
     liccode(b4),liccode(b5),liccode(b6),liccode(b7)],'Color','b'); 








% 
% ii=int2str(I);   %转换为串
% Y=imread(['D:\桌面\测试车牌\分割字符\',ii,'.jpg']);   %读取图片文件中的数据
% %       figure,imshow(SegBw2);
% 
%         if l==1                 %第一位汉字识别i
%             kmin=35;
%             kmax=44;
%         elseif l==2             %第二位 A~Z 字母识别
%             kmin=11;
%             kmax=34;
%         elseif l>=3             %第三位以后是字母或数字识别
%             kmin=1;
%             kmax=34;
%         end
%         
%         A=zeros(1,90);
%         for k2=kmin:kmax
%             fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k2),'.bmp');
%             B = imread(fname);  %读取图片文件中的数据
%             C=Y-B; % 以上相当于两幅图相减得到第三幅图
%             d=sum(sum(C));
%             A(k2)=d;
% %             A(end+1)=d
%         
%         end
% 
% dw=imread('D:\桌面\测试车牌\s.jpg');
% % figure,imshow(dw),title(['车牌号码:', Code],'Color','b'); 




