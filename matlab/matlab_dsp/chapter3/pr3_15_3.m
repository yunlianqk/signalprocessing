%
% pr3_15_3 
clear all; clc; close all;

d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.25,0.4,0.25,40);  % 设置滤波器的参数集合
designmethods (d)         % 给出参数集合适用的滤波器
hd = design(d,'ellip');   % 设计契比雪夫I型滤波器
[B,A]=tf(hd);             % 求出滤波器系数

[N,wn]=ellipord(0.25,0.4,0.25,40); % 以传统使用方法求滤波器的阶数和带宽
[b,a]=ellip(N,0.25,40,wn);         % 计算滤波器的系数
% 第一部分显示系数
fprintf('B=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',B);
fprintf('A=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n\n',A);

fprintf('b=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n',b);
fprintf('a=%5.6f   %5.6f   %5.6f   %5.6f   %5.6f\n\n',a);

% 第二部分显示级联结构的系数
hd
info(hd)                  % 显示hd中的信息
AB=hd.sosMatrix;          % 取得hd中的系数部分
BB=AB(:,1:3);             % 转换成B和A
AA=AB(:,4:6);
G=hd.ScaleValues;         % 取得hd中的增益部分
% 显示级联结构的系数值和增益值
for k=1 : 2
    fprintf('第%2d节\n',k)
    fprintf('BB=%5.6f   %5.6f   %5.6f\n',BB(k,:))
    fprintf('AA=%5.6f   %5.6f   %5.6f\n',AA(k,:))
    fprintf('G(%2d)=%5.6f\n',k,G(k))
end
fprintf('G( 3)=%5.6f\n',G(3))


