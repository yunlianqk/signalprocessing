function y=wavlet_barkms(x,wname,fs)
if fs~=8000
    error('本函数只适用于采样频率为8000Hz,请调整采样频率!')
    return
end
T=wpdec(x,5,wname);           % 按wname母小波进行5层小波包分解
% 把5层小波包分解重构成17个BARK子带
y(1,:)=wprcoef(T,[5 0]);
y(2,:)=wprcoef(T,[5 1]);
y(3,:)=wprcoef(T,[5 2]);
y(4,:)=wprcoef(T,[5 3]);
y(5,:)=wprcoef(T,[5 4]);
y(6,:)=wprcoef(T,[5 5]);
y(7,:)=wprcoef(T,[5 6]);
y(8,:)=wprcoef(T,[5 7]);


y(9,:)=wprcoef(T,[4 4]);
y(10,:)=wprcoef(T,[4 5]);
y(11,:)=wprcoef(T,[5 11]);
y(12,:)=wprcoef(T,[5 12]);
y(13,:)=wprcoef(T,[4 7]);

y(14,:)=wprcoef(T,[3 4]);
y(15,:)=wprcoef(T,[3 5]);
y(16,:)=wprcoef(T,[3 6]);
y(17,:)=wprcoef(T,[3 7]);



