function main
clc
clear all
close all
foldername_input='D:\Allen\data\�½��ļ���';
foldername_output='D:\Allen\data';
% foldername_input='./545_ori';
% foldername_output='./545_stripremoved';
curdir=dir(foldername_input); %�����ļ������ƣ������ļ�����ŵ���2D��Ƭ%�ṹ��
n_file=0;
%h1=figure();h2=figure;   %���������µĴ���
for i=1:length(curdir)   %�ӵ�һ����Ƭ�����һ����Ƭ
    if(curdir(i).isdir && curdir(i).name(1)~='.')%%����Ҫ������ļ�ʲô������
        ;
    else     %%����������ļ���������������
        if(length(curdir(i).name)>3 && curdir(i).name(end-2)=='r'&& curdir(i).name(end-1)=='a'&& curdir(i).name(end)=='w')
		%%�ж��ǲ���tif�ļ�������ִ����������
            filename=curdir(i).name;            
            n_file=n_file+1;
            fullfilename=[foldername_input,'/',curdir(i).name];%%ȡ������·���ļ����µ�n_file��tif�ļ�
            fprintf('[%4d]: filename: %s\n',n_file,fullfilename);%%��ӡ�ļ������ǵڼ���
            
% %             if(~strcmpi(filename,'mouse17545redl5_s20100.png')) continue; end
%             if(~strcmpi(filename,'mouse17302l5_s20100.png')) continue; end
            I = loadRaw2Stack(fullfilename);  %%������ļ�
            I_output=stripremove(I);    %%�Ը��ļ�����stripremove�����������2D�Ĳ���
            
            figure(h1);imshow(I);        %%չʾȥ����ǰ��ͼ��
            figure(h2);imshow(I_output);  %%չʾȥ���ƺ��ͼ��
            drawnow;
            save_v3d_raw_img_file(I_output,[foldername_output,'/',filename]);
            %imwrite(I_output,[foldername_output,'/',filename]);   %%��ȥ�����ͼ�񱣴�
        end
    end
end

function I_output=stripremove(I)
I=double(I);
imgsize=size(I);
%���Ļ���Ƶ��
    Fc=fftshift(fft2(I1));    
%%fftshift����Ƶ�����Ƶ�Ƶ������
    S=abs(Fc);
 %������ǿ�����к��Ƶ��
    S2=log(1+S/max(S(:))*1000);% S2=log(1+S);
     figure;imshow(S2,[])
 impixelinfo 
%�����޲��˲����������խ�Ĵ����˲�������ֹĳһƵ�ʵ���ź�ͨ��
  radius=30;%60
  radius_notch=3;
  centerpos=round(imgsize/2);
  H=ones(size(I1)); %%����ȫ1����
%������״�޲��˲�����Ч�����ã�
H(centerpos(1)-radius_notch:centerpos(1)+radius_notch,1:centerpos(2)-radius+radius_notch)=0;
H(centerpos(1)-radius_notch:centerpos(1)+radius_notch,centerpos(2)+radius-radius_notch:end)=0;
G=H.*Fc;
 figure;imshow(log(1+abs(G)/max(abs(G(:)))*1000),[])
g=real(ifft2(ifftshift(G)));
I_output=uint8(g);


%save_v3d_raw_img_file(uint8(I_new),filename_avg);
% figure;imshow(uint8(g));
