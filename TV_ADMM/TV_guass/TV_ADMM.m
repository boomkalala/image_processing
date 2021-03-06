clc;clear;close all;
%读取图像
image = imread('lena.jpg');subplot(2,2,1);imshow(image);title('原图');

%噪声图像
f = imnoise(image,'gaussian',0,0.01);
subplot(2,2,2);imshow(f);title('噪声图像');
f = double(f);

%初始化参数参数
[m,n] = size(f);
lamda = 25;
mu = 0.5;
w = zeros(m,n,2);
bita = zeros(m,n,2);
iteration = 5000;
u = f;

for step = 1:iteration
    %k+1步的u
    div_w = divergence(w(:,:,1),w(:,:,2));
    div_bita = divergence(bita(:,:,1),bita(:,:,2));
    u = (f - mu*(div_w - center_diff(u)) - div_bita)./(1+4*mu);
    
    %k+1步的w
    [ux,uy] = gradient(u);
    gra_u = cat(3,ux,uy);
    q = gra_u - bita./mu;
    abs_q = sqrt(q(:,:,1).^2 + q(:,:,2).^2);
    for i = 1:2
        w(:,:,1) = max(abs_q - lamda./mu,0).*q(:,:,1)./ (abs_q + eps);
        w(:,:,2) = max(abs_q - lamda./mu,0).*q(:,:,2)./ (abs_q + eps);
    end
    
    %k+1步的bita
    bita = bita + mu*(w - gra_u);
    
    %能量函数
    abs_u = sqrt(ux.^2 + uy.^2);
    E(step)=sum(sum(lamda.*abs_u+0.5.*(u-f).^2));
    
    %stop iteration
    if step>2
        if abs((E(step)-E(step-1))/E(step))<0.000001
            break;
        end
    end
end

subplot(2,2,3);imshow(uint8(u));title('result');
subplot(2,2,4);plot(E);xlabel('Iterations');ylabel('Energy');legend('Energy/Iterations');
PSNR=psnr(uint8(u),uint8(f))





















