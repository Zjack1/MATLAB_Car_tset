clc;
clear all;
close all;
for i=1:353
    fname=strcat('D:\桌面\测试车牌\总字符\',num2str(i),'.bmp');
    I=imread(fname);  %读取图片文件中的数据
%   I=imread('D:\桌面\测试车牌\总字符\7.bmp');
    J=imresize(I,[32 16],'nearest');
    K=im2bw(J,0.495);
    
    f=strcat('D:\桌面\测试车牌\总字符2\',num2str(i),'.bmp');
    imwrite(K,f);
end
