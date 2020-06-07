%清理窗口  
close all  ;
clear all  ;
thresh = 0.3;
%% 读取图像
img_name = 'wang8.jpg';
I = imread(img_name);
I = imresize(I,[300,400]);
I_origin= I;
%I =histeq(I);
%% 预处理
I_gray = rgb2gray(I);
YCbCr = rgb2ycbcr(I);  
% sobel
BW = edge(I_gray,'canny',thresh,'nothinning');%,thresh,'nothinning');

%figure(1);imshow(BW),axis on;
%imwrite(BW,'sobel.jpg');
BW = 1 - BW;%sobel取反
%显示原图像及相应的二值图像
figure(2);imshow(BW),axis on;
% imwrite(BW,'sobel_negate.jpg');
 hold on;
%  
%% 获得图像宽度和高度  
heigth = size(I,1);  
width = size(I,2);  
%% 根据肤色模型将图像二值化  
for i = 1:heigth  
    for j = 1:width  
        Y = YCbCr(i,j,1);  
        Cb = YCbCr(i,j,2);  
        Cr = YCbCr(i,j,3);  
        if(Y < 80)  
            I_gray(i,j) = 0;  
        else  
            if(skin(Y,Cb,Cr) == 1)  
                I_gray(i,j) = 255;  
            else  
                I_gray(i,j) = 0;  
            end  
        end  
    end  
end  
figure(3);imshow(I_gray);axis on;

I = I_gray;
SE=strel('disk',2);%('square',3);    
I = imdilate(I,SE);
%imwrite(I,'C:\Users\liwan\Desktop\brief4\Conference-LaTeX-template_10-17-19\new\1.jpg');
figure(5),imshow(I);
%%
[L,num] = bwlabel(I,8); % 寻找这个二值图像中的联通区域
STATS = regionprops(L,'EulerNumber');
 aa = find( [STATS.EulerNumber]<-11); 
 bb = find ([STATS.EulerNumber] <-11);
 holeIndices = intersect(aa,bb);
 holeL_aft = false(size(I));
for i = holeIndices
    holeL_aft( L == i ) =true;
end
figure(5),imshow(holeL_aft);
%imwrite(holeL_aft,'C:\Users\liwan\Desktop\brief4\Conference-LaTeX-template_10-17-19\new\2.jpg');

title('holeL_aft');
I = 1 - holeL_aft;
figure;imshow(I);
%imwrite(I,'C:\Users\liwan\Desktop\brief4\Conference-LaTeX-template_10-17-19\new\3.jpg');

SE=strel('disk',14);%('square',3);    
I = imopen(I,SE);
figure(6);imshow(I);
%imwrite(I,'C:\Users\liwan\Desktop\brief4\Conference-LaTeX-template_10-17-19\new\4.jpg');


I = im2uint8(I);
I_final_body = false(size(I));
I = I/255;

I_final_body= I.*I_origin;
I_final_body (I ==0 )= 100;
figure(7),imshow(I_final_body);
%imwrite(I_final_body,'C:\Users\liwan\Desktop\brief4\Conference-LaTeX-template_10-17-19\new\5.jpg');

