clc;
clear all;
close all;
liccode=char(['0':'9' 'ABCDEFGHJKLMNPQRSTUVWXYZ' '川黑京辽鲁闽苏皖豫浙']);  %建立自动识别字符代码表  
% SubBw2=zeros(32,16);   %产生40*20的全0矩阵
l=1;
for I=1:7
      ii=int2str(I);   %转换为串
     Y=imread(['D:\桌面\测试车牌\分割字符\',ii,'.jpg']);   %读取图片文件中的数据
%       figure,imshow(SegBw2);

        if l==1                 %第一位汉字识别i
            kmin=35;
            kmax=44;
        elseif l==2             %第二位 A~Z 字母识别
            kmin=11;
            kmax=34;
        elseif l>=3             %第三位以后是字母或数字识别
            kmin=1;
            kmax=34;
        end
        
        A=zeros(1,90);
        for k2=kmin:kmax
            fname=strcat('D:\桌面\测试车牌\标准字符1\',liccode(k2),'.bmp');
            B = imread(fname);  %读取图片文件中的数据
            C=Y-B; % 以上相当于两幅图相减得到第三幅图
            d=sum(sum(C));
            A(k2)=d;
%             A(end+1)=d
        
        end
%         Error1=Error(kmin:kmax);
%         MinError=min(Error1);
%         findc=find(Error1==MinError);
%         Code(l*2-1)=liccode(findc(1)+kmin-1);
%         Code(l*2)=' ';
%         l=l+1;
end
dw=imread('D:\桌面\测试车牌\s.jpg');
% figure,imshow(dw),title(['车牌号码:', Code],'Color','b'); 




