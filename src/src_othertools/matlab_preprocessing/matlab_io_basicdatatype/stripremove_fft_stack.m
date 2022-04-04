%remove stripe 
%by Lei Qu @ 20190415

function main
clc
clear all
close all

foldername_input='G:\stripremove\17787';
foldername_output='G:\stripremove\17787';
curdir=dir(foldername_input);
n_file=0;
% h1=figure();h2=figure;
for i=1:length(curdir)
    if(curdir(i).isdir && curdir(i).name(1)~='.')
        ;
    else
        if(length(curdir(i).name)>3 && curdir(i).name(end-2)=='r'&& curdir(i).name(end-1)=='a'&& curdir(i).name(end)=='w')
            n_file=n_file+1;
            fullfilename=[foldername_input,'/',curdir(i).name];
            fprintf('[%4d]: filename: %s\n',n_file,fullfilename);
            
            I=loadRaw2Stack(fullfilename);
            
            %����ͼ��Ƶ�ײ�ȷ������(filter_axis_dir, filter_cutoff, filter_radius)
            imgsize=size(I);
            I_slice=double(I(:,:,round(imgsize(3)/2)));
            figure;imshow(uint8(I_slice));impixelinfo 
            %��ʾ�Աȶ���ǿ��ͼ��
            c=1;    gamma=0.3;%0.6,3
            I_tmp=c*(I_slice/255).^gamma * 255;
            figure;imshow(uint8(I_tmp)); impixelinfo 
            %��ʾƵ��
            Fc=fftshift(fft2(I_slice));
            S=abs(Fc);
            S2=log(1+S);
            figure;imshow(S2,[]); impixelinfo
            
            %construct filter
%             %����ʸ״�޲��˲���(Ч�����ã�)
%             centerpos=round(imgsize(1:2)/2);
%             filter_axis_dir=0;%�˲�������ͬ����н�
%             filter_cutoff=25;%�˲���ͨ����ֹƵ��
%             filter_axis_deg=2;%ʸ״�˲����нǵ�һ��
%             H=ones(imgsize(1:2));
%             for row=1:imgsize(1)
%                 for col=1:imgsize(2)
%                     offset=[row,col]-centerpos;
%                     dis2center=sqrt(sum(offset.^2));
%                     degree2x=atan(offset(1)/offset(2))/pi*180;
%                     degree2axis=abs(filter_axis_dir-degree2x);
%                     if(dis2center>=filter_cutoff && degree2axis<=filter_axis_deg)
%                         H(row,col)=0;
%                     end
%                 end
%             end
%             figure; imshow(H);
            %������״�޲��˲���
            filter_axis_dir=175;%�˲�������ͬ����н�(Ӧ�������Ʒ����ֹ�ѡ����ʵĽǶ�)
            filter_cutoff=10;%��ֹƵ��̫�߽����µ�Ƶ���Ʋ�����ȫ����,̫���������������!ԽС������Խ��
            filter_radius=5;%�˲�����Ȱ뾶(��ֵ�ϴ�ʱĳЩ����������Χ�������ٵ�Ƶ����!)ԽСԽխ
            %����ˮƽ��״�˲���
            dim_max2=max(imgsize(1:2))*2;
            H_max=ones(dim_max2,dim_max2);
            centerpos_max=round(dim_max2/2);
            H_max(centerpos_max-filter_radius:centerpos_max+filter_radius,:)=0;
            H_max(:,centerpos_max-filter_cutoff:centerpos_max+filter_cutoff)=1;
            %��תˮƽ��״�˲���
            H_max=imrotate(H_max,filter_axis_dir,'crop');
            %��ȡͬ������ͬ��С���˲���
            H=H_max(centerpos_max-round((imgsize(1)-1)/2):centerpos_max-round((imgsize(1)-1)/2)+imgsize(1)-1,...
            centerpos_max-round((imgsize(2)-1)/2):centerpos_max-round((imgsize(2)-1)/2)+imgsize(2)-1);
            %�������˲���ת��Ϊ��˹�˲���(�����˲�����)
%             h_gaussian=fspecial('gaussian',[filter_radius*3,filter_radius*3],filter_radius);
            h_gaussian=fspecial('gaussian',[filter_radius*3,filter_radius*3],5);
            H=imfilter(H,h_gaussian,'replicate');
            %figure; imshow(H);
            figure;imshow(H.*S2,[]); impixelinfo
            figure; imshow(log(1+H.*Fc),[]);   %%ȥ���ƺ����Ƭ
             pause;
            %do filtering slice by slice
            I_output=stripremove_stack(I,H);


            %save image
            filename_output=[foldername_output,'/',curdir(i).name(1:end-7),'_remove.v3draw'];
            save_v3d_raw_img_file(uint8(I_output),filename_output);
        end
    end
end

function I_output=stripremove_stack(I,H)
I=double(I);
imgsize=size(I);
%�˲�
I_output=I;
%h1=figure;h2=figure;
for z=1:imgsize(3)
    fprintf('%d/%d\n',imgsize(3),z);
    I_slice=double(I(:,:,z));
    Fc=fftshift(fft2(I_slice));
    G=H.*Fc;
    g=real(ifft2(ifftshift(G)));
    I_output(:,:,z)=uint8(g);
    
    %figure(h1);imshow(uint8(I_slice));
    %figure(h2);imshow(uint8(g));
    drawnow;
end
%close(h1);close(h2);
