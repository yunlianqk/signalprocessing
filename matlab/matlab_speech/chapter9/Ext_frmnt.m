function formant1=Ext_frmnt(y,p,thr1,fs)
fn=size(y,2);
formant1=zeros(fn,3);
for i=1 : fn
        u=y(:,i);                                   % 取一帧数据
        a=lpc(u,p);                                 % 求出LPC系数
        root1=roots(a);                             % 求根

        mag_root=abs(root1);                        % 取根之模值
        arg_root=angle(root1);                      % 取根之相角
        f_root=arg_root/pi*fs/2;                    % 把相角转换成频率
        fmn1=[];                                    % 初始化
        k=1;
        for j=1:p
            if mag_root(j)>thr1                     % 是否满足条件
                if arg_root(j)>0  & arg_root(j)<pi & f_root(j)>200
                    fmn1(k)=f_root(j);              % 满足,保存共振峰频率
                    k=k+1;
                end
            end
        end
        if ~isempty(fmn1)                           % 对求出的共振峰频率排序
            fl=length(fmn1);
            fmnt1=sort(fmn1);
            formant1(i,1:min(fl,3))=fmnt1(1:min(fl,3));% 最多取三个
        end
end
