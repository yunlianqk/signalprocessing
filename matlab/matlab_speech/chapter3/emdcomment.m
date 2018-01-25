% EMD 计算经验模式分解
%
%
%   语法
%
%
% IMF = EMD(X)
% IMF = EMD(X,...,'Option_name',Option_value,...)
% IMF = EMD(X,OPTS)
% [IMF,ORT,NB_ITERATIONS] = EMD(...)
%
%
%   描述
%
%
% IMF = EMD(X) X是一个实矢量，计算方法参考[1]，计算结果包含在IMF矩阵中，每一行包含一个IMF分量，
% 最后一行是残余分量，默认的停止条件如下[2]：
%
%   在每一个点, mean_amplitude < THRESHOLD2*envelope_amplitude （注：平均幅度与包络幅度的比值小于门限2）
%   &
%   mean of boolean array {(mean_amplitude)/(envelope_amplitude) > THRESHOLD} < TOLERANCE 
%  （注：平均幅度与包络幅度比值大于门限的点数占信号总点数中的比例小于容限）
%   &
%   |#zeros-#extrema|<=1 （注：过零点和极值点个数相等或者相差1）
%
% 这里 mean_amplitude = abs(envelope_max+envelope_min)/2 （注：平均幅度等于上下包络相互抵消后残差的一半的绝对值，理想情况等于0）
% 且 envelope_amplitude = abs(envelope_max-envelope_min)/2 （注：包络幅度等于上下包络相对距离的一半，理想情况等于上下包络本身的绝对值）
% 
% IMF = EMD(X) X是一个实矢量，计算方法参考[3]，计算结果包含在IMF矩阵中，每一行包含一个IMF分量，
% 最后一行是残余分量，默认的停止条件如下[2]：
%
%   在每一个点, mean_amplitude < THRESHOLD2*envelope_amplitude（注：平均幅度与包络幅度的比值小于门限2）
%   &
%   mean of boolean array {(mean_amplitude)/(envelope_amplitude) > THRESHOLD} < TOLERANCE
%  （注：平均幅度与包络幅度比值大于门限的点数占信号总点数中的比例小于容限）
%
% 这里平均幅度和包络幅度的定义与前面实数情况下类似
%
% IMF = EMD(X,...,'Option_name',Option_value,...) 设置特定参数（见选项）
%
% IMF = EMD(X,OPTS) 与前面等价，只是这里OPTS是一个结构体，其中每一个域名与相应的选项名称一致。
%
% [IMF,ORT,NB_ITERATIONS] = EMD(...) 返回正交指数
%                       ________
%         _  |IMF(i,:).*IMF(j,:)|
%   ORT = \ _____________________
%         /
%         -       || X ||^2        i~=j
%
% 和提取每一个IMF时进行的迭代次数。
%
%
%   选择
%
%
%  停止条件选项:
%
% STOP: 停止参数 [THRESHOLD,THRESHOLD2,TOLERANCE]
% 如果输入矢量长度小于 3, 只有第一个参数有效，其他参数采用默认值
% 默认值: [0.05,0.5,0.05]
%
% FIX (int): 取消默认的停止条件，进行  指定次数的迭代
%
% FIX_H (int): 取消默认的停止条件，进行  指定次数的迭代，仅仅保留 |#zeros-#extrema|<=1 的停止条件，参考 [4]
%
%  复 EMD 选项:
%
% COMPLEX_VERSION: 选择复 EMD 算法(参考[3])
% COMPLEX_VERSION = 1: "algorithm 1"
% COMPLEX_VERSION = 2: "algorithm 2" (default)
% 
% NDIRS: 包络计算的方向个数 (默认 4)
% rem: 实际方向个数 (根据 [3]) 是 2*NDIRS
% 
%  其他选项:
%
% T: 采样时刻 (线性矢量) (默认: 1:length(x))
%
% MAXITERATIONS: 提取每个IMF中，采用的最大迭代次数（默认：2000）
%
% MAXMODES: 提取IMFs的最大个数 (默认: Inf)
%
% DISPLAY: 如果等于1，每迭代一次自动暂停（pause）
% 如果等于2，迭代过程不暂停 (动画模式)
% rem: 当输入是复数的时候，演示过程自动取消
%
% INTERP: 插值方法 'linear', 'cubic', 'pchip' or 'spline' (默认)
% 详情见 interp1 文档
%
% MASK: 采用 masking 信号，参考 [5]
%
%
%   例子
%
%
% X = rand(1,512);
%
% IMF = emd(X);
%
% IMF = emd(X,'STOP',[0.1,0.5,0.05],'MAXITERATIONS',100);
%
% T = linspace(0,20,1e3);
% X = 2*exp(i*T)+exp(3*i*T)+.5*T;
% IMF = emd(X,'T',T);
%
% OPTIONS.DISLPAY = 1;
% OPTIONS.FIX = 10;
% OPTIONS.MAXMODES = 3;
% [IMF,ORT,NBITS] = emd(X,OPTIONS);
%
%
%   参考文献
%
%
% [1] N. E. Huang et al., "The empirical mode decomposition and the
% Hilbert spectrum for non-linear and non stationary time series analysis",
% Proc. Royal Soc. London A, Vol. 454, pp. 903-995, 1998
%
% [2] G. Rilling, P. Flandrin and P. Goncalves
% "On Empirical Mode Decomposition and its algorithms",
% IEEE-EURASIP Workshop on Nonlinear Signal and Image Processing
% NSIP-03, Grado (I), June 2003
%
% [3] G. Rilling, P. Flandrin, P. Goncalves and J. M. Lilly.,
% "Bivariate Empirical Mode Decomposition",
% Signal Processing Letters (submitted)
%
% [4] N. E. Huang et al., "A confidence limit for the Empirical Mode
% Decomposition and Hilbert spectral analysis",
% Proc. Royal Soc. London A, Vol. 459, pp. 2317-2345, 2003
%
% [5] R. Deering and J. F. Kaiser, "The use of a masking signal to improve 
% empirical mode decomposition", ICASSP 2005
%
%
% 也可以参考
%  emd_visu (visualization),
%  emdc, emdc_fix (fast implementations of EMD),
%  cemdc, cemdc_fix, cemdc2, cemdc2_fix (fast implementations of bivariate EMD),
%  hhspectrum (Hilbert-Huang spectrum)
%
%
% G. Rilling, 最后修改: 3.2007
% gabriel.rilling@ens-lyon.fr
% 
% 翻译：xray	11.2007

function [imf,ort,nbits] = emd(varargin)
% 采用可变参数输入

% 处理输入参数
[x,t,sd,sd2,tol,MODE_COMPLEX,ndirs,display_sifting,sdt,sd2t,r,imf,k,nbit,NbIt,MAXITERATIONS,FIXE,FIXE_H,MAXMODES,INTERP,mask] = init(varargin{:});
% 参数说明：
% x 信号
% t 时间矢量
% sd 门限
% sd2 门限2
% tol 容限值
% MODE_COMPLEX 是否处理复信号
% ndirs 方向个数
% display_sifting 是否演示迭代过程
% sdt 将门限扩展为跟信号长度一样的矢量
% sd2t 将门限2扩展为跟信号长度一样的矢量
% r 等于x
% imf 如果使用mask信号，此时IMF已经得到了
% k 记录已经提取的IMF个数
% nbit 记录提取每一个IMF时迭代的次数
% NbIt 记录迭代的总次数
% MAXITERATIONS 提取每个IMF时采用的最大迭代次数
% FIXE 进行指定次数的迭代
% FIXE_H 进行指定次数的迭代，且保留 |#zeros-#extrema|<=1 的停止条件
% MAXMODES 提取的最大IMF个数
% INTERP 插值方法
% mask mask信号

% 如果要求演示迭代过程，用 fig_h 保存当前图形窗口句柄
if display_sifting
  fig_h = figure;
end

% 主循环 : 至少要求存在3个极值点，如果采用mask信号，不进入主循环
while ~stop_EMD(r,MODE_COMPLEX,ndirs) && (k < MAXMODES+1 || MAXMODES == 0) && ~any(mask)

  % 当前模式
  m = r;

  % 前一次迭代的模式
  mp = m;

  % 计算均值和停止条件
  if FIXE % 如果设定了迭代次数
    [stop_sift,moyenne] = stop_sifting_fixe(t,m,INTERP,MODE_COMPLEX,ndirs);
  elseif FIXE_H % 如果设定了迭代次数，且保留停止条件|#zeros-#extrema|<=1
    stop_count = 0;
    [stop_sift,moyenne] = stop_sifting_fixe_h(t,m,INTERP,stop_count,FIXE_H,MODE_COMPLEX,ndirs);
  else % 采用默认停止条件
    [stop_sift,moyenne] = stop_sifting(m,t,sd,sd2,tol,INTERP,MODE_COMPLEX,ndirs);
  end

  % 当前模式幅度过小，机器精度就可能引起虚假极值点的出现
  if (max(abs(m))) < (1e-10)*(max(abs(x)))	% IMF的最大值小于信号最大值的1e-10
    if ~stop_sift % 如果筛过程没有停止
      warning('emd:warning','forced stop of EMD : too small amplitude')
    else
      disp('forced stop of EMD : too small amplitude')
    end
    break
  end


  % 筛循环
  while ~stop_sift && nbitMAXITERATIONS/5 && mod(nbit,floor(MAXITERATIONS/10))==0 && ~FIXE && nbit > 100)
      disp(['mode ',int2str(k),', iteration ',int2str(nbit)])
      if exist('s','var')
        disp(['stop parameter mean value : ',num2str(s)])
      end
      [im,iM] = extr(m);
      disp([int2str(sum(m(im) > 0)),' minima > 0; ',int2str(sum(m(iM) < 0)),' maxima < 0.'])
    end

    % 筛过程
    m = m - moyenne;

    % 计算均值和停止条件
    if FIXE
      [stop_sift,moyenne] = stop_sifting_fixe(t,m,INTERP,MODE_COMPLEX,ndirs);
    elseif FIXE_H
      [stop_sift,moyenne,stop_count] = stop_sifting_fixe_h(t,m,INTERP,stop_count,FIXE_H,MODE_COMPLEX,ndirs);
    else
      [stop_sift,moyenne,s] = stop_sifting(m,t,sd,sd2,tol,INTERP,MODE_COMPLEX,ndirs);
    end

    % 演示过程
    if display_sifting && ~MODE_COMPLEX
      NBSYM = 2;
      [indmin,indmax] = extr(mp);
      [tmin,tmax,mmin,mmax] = boundary_conditions(indmin,indmax,t,mp,mp,NBSYM);
      envminp = interp1(tmin,mmin,t,INTERP);
      envmaxp = interp1(tmax,mmax,t,INTERP);
      envmoyp = (envminp+envmaxp)/2;
      if FIXE || FIXE_H
        display_emd_fixe(t,m,mp,r,envminp,envmaxp,envmoyp,nbit,k,display_sifting)
      else
        sxp = 2*(abs(envmoyp))./(abs(envmaxp-envminp));
        sp = mean(sxp);
        display_emd(t,m,mp,r,envminp,envmaxp,envmoyp,s,sp,sxp,sdt,sd2t,nbit,k,display_sifting,stop_sift)
      end
    end

    mp = m;
    nbit = nbit+1;	% 单轮迭代计数
    NbIt = NbIt+1;	% 总体迭代计数

    if (nbit==(MAXITERATIONS-1) && ~FIXE && nbit > 100)
      if exist('s','var')
        warning('emd:warning',['forced stop of sifting : too many iterations... mode ',int2str(k),'. stop parameter mean value : ',num2str(s)])
      else
        warning('emd:warning',['forced stop of sifting : too many iterations... mode ',int2str(k),'.'])
      end
    end

  end % 筛循环
  
  imf(k,:) = m;
  if display_sifting
    disp(['mode ',int2str(k),' stored'])
  end
  nbits(k) = nbit;	% 记录每个IMF的迭代次数
  k = k+1;		% IMF计数


  r = r - m;		% 从原信号中减去提取的IMF
  nbit = 0;		% 单轮迭代次数清0


end % 主循环

% 计入残余信号
if any(r) && ~any(mask)
  imf(k,:) = r;
end

% 计数正交指数
ort = io(x,imf);

% 关闭图形
if display_sifting
  close
end

end

%---------------------------------------------------------------------------------------------------
% 测试是否存在足够的极值点（3个）进行分解，极值点个数小于3个则返回1，这是整体停止条件
function stop = stop_EMD(r,MODE_COMPLEX,ndirs)
if MODE_COMPLEX  % 复信号情况
  for k = 1:ndirs
    phi = (k-1)*pi/ndirs;
    [indmin,indmax] = extr(real(exp(i*phi)*r));
    ner(k) = length(indmin) + length(indmax);
  end
  stop = any(ner < 3);
else % 实信号情况
  [indmin,indmax] = extr(r);
  ner = length(indmin) + length(indmax);
  stop = ner < 3;
end
end

%---------------------------------------------------------------------------------------------------
% 计数包络均值和模式幅度估计值，返回包络均值
function [envmoy,nem,nzm,amp] = mean_and_amplitude(m,t,INTERP,MODE_COMPLEX,ndirs)
NBSYM = 2;	% 边界延拓点数
if MODE_COMPLEX		% 复信号情况
  switch MODE_COMPLEX
    case 1
      for k = 1:ndirs
        phi = (k-1)*pi/ndirs;
        y = real(exp(-i*phi)*m);
        [indmin,indmax,indzer] = extr(y);
        nem(k) = length(indmin)+length(indmax);
        nzm(k) = length(indzer);
        [tmin,tmax,zmin,zmax] = boundary_conditions(indmin,indmax,t,y,m,NBSYM);
        envmin(k,:) = interp1(tmin,zmin,t,INTERP);
        envmax(k,:) = interp1(tmax,zmax,t,INTERP);
      end
      envmoy = mean((envmin+envmax)/2,1);
      if nargout > 3
        amp = mean(abs(envmax-envmin),1)/2;
      end
    case 2
      for k = 1:ndirs
        phi = (k-1)*pi/ndirs;
        y = real(exp(-i*phi)*m);
        [indmin,indmax,indzer] = extr(y);
        nem(k) = length(indmin)+length(indmax);
        nzm(k) = length(indzer);
        [tmin,tmax,zmin,zmax] = boundary_conditions(indmin,indmax,t,y,y,NBSYM);
        envmin(k,:) = exp(i*phi)*interp1(tmin,zmin,t,INTERP);
        envmax(k,:) = exp(i*phi)*interp1(tmax,zmax,t,INTERP);
      end
      envmoy = mean((envmin+envmax),1);
      if nargout > 3
        amp = mean(abs(envmax-envmin),1)/2;
      end
  end
else	% 实信号情况
  [indmin,indmax,indzer] = extr(m);	% 计数最小值、最大值和过零点位置
  nem = length(indmin)+length(indmax);
  nzm = length(indzer);
  [tmin,tmax,mmin,mmax] = boundary_conditions(indmin,indmax,t,m,m,NBSYM);	% 边界延拓
  envmin = interp1(tmin,mmin,t,INTERP);
  envmax = interp1(tmax,mmax,t,INTERP);
  envmoy = (envmin+envmax)/2;
  if nargout > 3
    amp = mean(abs(envmax-envmin),1)/2;  	% 计算包络幅度
  end
end
end

%-------------------------------------------------------------------------------
% 默认停止条件，这是单轮迭代停止条件
function [stop,envmoy,s] = stop_sifting(m,t,sd,sd2,tol,INTERP,MODE_COMPLEX,ndirs)
try
  [envmoy,nem,nzm,amp] = mean_and_amplitude(m,t,INTERP,MODE_COMPLEX,ndirs);
  sx = abs(envmoy)./amp;
  s = mean(sx);
  stop = ~((mean(sx > sd) > tol | any(sx > sd2)) & (all(nem > 2)));  % 停止准则（增加了极值点个数大于2）
  if ~MODE_COMPLEX
    stop = stop && ~(abs(nzm-nem)>1);	% 对于实信号，要求极值点和过零点的个数相差1
  end
catch
  stop = 1;
  envmoy = zeros(1,length(m));
  s = NaN;
end
end

%-------------------------------------------------------------------------------
% 针对FIX选项的停止条件
function [stop,moyenne]= stop_sifting_fixe(t,m,INTERP,MODE_COMPLEX,ndirs)
try
  moyenne = mean_and_amplitude(m,t,INTERP,MODE_COMPLEX,ndirs);	% 正常情况下不会导致停止
  stop = 0;
catch
  moyenne = zeros(1,length(m));
  stop = 1;
end
end

%-------------------------------------------------------------------------------
% 针对FIX_H选项的停止条件
function [stop,moyenne,stop_count]= stop_sifting_fixe_h(t,m,INTERP,stop_count,FIXE_H,MODE_COMPLEX,ndirs)
try
  [moyenne,nem,nzm] = mean_and_amplitude(m,t,INTERP,MODE_COMPLEX,ndirs);
  if (all(abs(nzm-nem)>1))
    stop = 0;
    stop_count = 0;
  else	% 极值点与过零点个数相差1后，还要达到指定次数才停止
    stop_count = stop_count+1;
    stop = (stop_count == FIXE_H);
  end
catch
  moyenne = zeros(1,length(m));
  stop = 1;
end
end

%-------------------------------------------------------------------------------
% 演示分解过程（默认准则）
function display_emd(t,m,mp,r,envmin,envmax,envmoy,s,sb,sx,sdt,sd2t,nbit,k,display_sifting,stop_sift)

subplot(4,1,1)
plot(t,mp);hold on;
plot(t,envmax,'--k');plot(t,envmin,'--k');plot(t,envmoy,'r');
title(['IMF ',int2str(k),';   iteration ',int2str(nbit),' before sifting']);
set(gca,'XTick',[])
hold  off
subplot(4,1,2)
plot(t,sx)
hold on
plot(t,sdt,'--r')
plot(t,sd2t,':k')
title('stop parameter')
set(gca,'XTick',[])
hold off
subplot(4,1,3)
plot(t,m)
title(['IMF ',int2str(k),';   iteration ',int2str(nbit),' after sifting']);
set(gca,'XTick',[])
subplot(4,1,4);
plot(t,r-m)
title('residue');
disp(['stop parameter mean value : ',num2str(sb),' before sifting and ',num2str(s),' after'])
if stop_sift
  disp('last iteration for this mode')
end
if display_sifting == 2
  pause(0.01)
else
  pause
end
end

%---------------------------------------------------------------------------------------------------
% 演示分解过程（FIX和FIX_H停止准则）
function display_emd_fixe(t,m,mp,r,envmin,envmax,envmoy,nbit,k,display_sifting)
subplot(3,1,1)
plot(t,mp);hold on;
plot(t,envmax,'--k');plot(t,envmin,'--k');plot(t,envmoy,'r');
title(['IMF ',int2str(k),';   iteration ',int2str(nbit),' before sifting']);
set(gca,'XTick',[])
hold  off
subplot(3,1,2)
plot(t,m)
title(['IMF ',int2str(k),';   iteration ',int2str(nbit),' after sifting']);
set(gca,'XTick',[])
subplot(3,1,3);
plot(t,r-m)
title('residue');
if display_sifting == 2
  pause(0.01)
else
  pause
end
end

%---------------------------------------------------------------------------------------
% 处理边界条件（镜像法）
function [tmin,tmax,zmin,zmax] = boundary_conditions(indmin,indmax,t,x,z,nbsym)
% 实数情况下，x = z

lx = length(x);

% 判断极值点个数
if (length(indmin) + length(indmax) < 3)
  error('not enough extrema')
end

% 插值的边界条件
if indmax(1) < indmin(1)	% 第一个极值点是极大值
  if x(1) > x(indmin(1))	% 以第一个极大值为对称中心
    lmax = fliplr(indmax(2:min(end,nbsym+1)));
    lmin = fliplr(indmin(1:min(end,nbsym)));
    lsym = indmax(1);
  else	% 如果第一个采样值小于第一个极小值，则将认为该值是一个极小值，以该点为对称中心
    lmax = fliplr(indmax(1:min(end,nbsym)));
    lmin = [fliplr(indmin(1:min(end,nbsym-1))),1];
    lsym = 1;
  end
else
  if x(1) < x(indmax(1))	% 以第一个极小值为对称中心
    lmax = fliplr(indmax(1:min(end,nbsym)));
    lmin = fliplr(indmin(2:min(end,nbsym+1)));
    lsym = indmin(1);
  else  % 如果第一个采样值大于第一个极大值，则将认为该值是一个极大值，以该点为对称中心
    lmax = [fliplr(indmax(1:min(end,nbsym-1))),1];
    lmin = fliplr(indmin(1:min(end,nbsym)));
    lsym = 1;
  end
end

% 序列末尾情况与序列开头类似
if indmax(end) < indmin(end)
  if x(end) < x(indmax(end))
    rmax = fliplr(indmax(max(end-nbsym+1,1):end));
    rmin = fliplr(indmin(max(end-nbsym,1):end-1));
    rsym = indmin(end);
  else
    rmax = [lx,fliplr(indmax(max(end-nbsym+2,1):end))];
    rmin = fliplr(indmin(max(end-nbsym+1,1):end));
    rsym = lx;
  end
else
  if x(end) > x(indmin(end))
    rmax = fliplr(indmax(max(end-nbsym,1):end-1));
    rmin = fliplr(indmin(max(end-nbsym+1,1):end));
    rsym = indmax(end);
  else
    rmax = fliplr(indmax(max(end-nbsym+1,1):end));
    rmin = [lx,fliplr(indmin(max(end-nbsym+2,1):end))];
    rsym = lx;
  end
end
    
% 将序列根据对称中心，镜像到两边
tlmin = 2*t(lsym)-t(lmin);
tlmax = 2*t(lsym)-t(lmax);
trmin = 2*t(rsym)-t(rmin);
trmax = 2*t(rsym)-t(rmax);
    
% 如果对称的部分没有足够的极值点
if tlmin(1) > t(1) || tlmax(1) > t(1)	% 对折后的序列没有超出原序列的范围
  if lsym == indmax(1)
    lmax = fliplr(indmax(1:min(end,nbsym)));
  else
    lmin = fliplr(indmin(1:min(end,nbsym)));
  end
  if lsym == 1	% 这种情况不应该出现，程序直接中止
    error('bug')
  end
  lsym = 1;	% 直接关于第一采样点取镜像
  tlmin = 2*t(lsym)-t(lmin);
  tlmax = 2*t(lsym)-t(lmax);
end   
    
% 序列末尾情况与序列开头类似
if trmin(end) < t(lx) || trmax(end) < t(lx)
  if rsym == indmax(end)
    rmax = fliplr(indmax(max(end-nbsym+1,1):end));
  else
    rmin = fliplr(indmin(max(end-nbsym+1,1):end));
  end
  if rsym == lx
    error('bug')
  end
  rsym = lx;
  trmin = 2*t(rsym)-t(rmin);
  trmax = 2*t(rsym)-t(rmax);
end 

% 延拓点上的取值       
zlmax = z(lmax); 
zlmin = z(lmin);
zrmax = z(rmax); 
zrmin = z(rmin);
     
% 完成延拓
tmin = [tlmin t(indmin) trmin];
tmax = [tlmax t(indmax) trmax];
zmin = [zlmin z(indmin) zrmin];
zmax = [zlmax z(indmax) zrmax];

end
    
%---------------------------------------------------------------------------------------------------
% 极值点和过零点位置提取
function [indmin, indmax, indzer] = extr(x,t)

if(nargin==1)
  t = 1:length(x);
end

m = length(x);

if nargout > 2
  x1 = x(1:m-1);
  x2 = x(2:m);
  indzer = find(x1.*x2<0);	% 寻找信号符号发生变化的位置

  if any(x == 0)	% 考虑信号采样点恰好为0的位置
    iz = find( x==0 );  % 信号采样点恰好为0的位置
    indz = [];
    if any(diff(iz)==1) % 出现连0的情况
      zer = x == 0;	% x=0处为1，其它地方为0
      dz = diff([0 zer 0]);	% 寻找0与非0的过渡点
      debz = find(dz == 1);	% 0值起点
      finz = find(dz == -1)-1;  % 0值终点
      indz = round((debz+finz)/2);	% 选择中间点作为过零点
    else
      indz = iz;	% 若没有连0的情况，该点本身就是过零点
    end
    indzer = sort([indzer indz]);	% 全体过零点排序
  end
end

% 提取极值点
d = diff(x);
n = length(d);
d1 = d(1:n-1);
d2 = d(2:n);
indmin = find(d1.*d2<0 & d1<0)+1;	% 最小值
indmax = find(d1.*d2<0 & d1>0)+1;	% 最大值


% 当连续多个采样值相同时，把最中间的一个值作为极值点，处理方式与连0类似
if any(d==0)

  imax = [];
  imin = [];

  bad = (d==0);
  dd = diff([0 bad 0]);
  debs = find(dd == 1);
  fins = find(dd == -1);
  if debs(1) == 1	% 连续值出现在序列开头
    if length(debs) > 1
      debs = debs(2:end);
      fins = fins(2:end);
    else
      debs = [];
      fins = [];
    end
  end
  if length(debs) > 0
    if fins(end) == m	% 连续值出现在序列末尾
      if length(debs) > 1
        debs = debs(1:(end-1));
        fins = fins(1:(end-1));

      else
        debs = [];
        fins = [];
      end
    end
  end
  lc = length(debs);
  if lc > 0
    for k = 1:lc
      if d(debs(k)-1) > 0	% 取中间值
        if d(fins(k)) < 0
          imax = [imax round((fins(k)+debs(k))/2)];
        end
      else
        if d(fins(k)) > 0
          imin = [imin round((fins(k)+debs(k))/2)];
        end
      end
    end
  end

  if length(imax) > 0
    indmax = sort([indmax imax]);
  end

  if length(imin) > 0
    indmin = sort([indmin imin]);
  end

end
end

%---------------------------------------------------------------------------------------------------

function ort = io(x,imf)
% ort = IO(x,imf) 计算正交指数
%
% 输入 : - x    : 分析信号
%        - imf  : IMF信号

n = size(imf,1);

s = 0;
% 根据公式计算
for i = 1:n
  for j = 1:n
    if i ~= j
      s = s + abs(sum(imf(i,:).*conj(imf(j,:)))/sum(x.^2));
    end
  end
end

ort = 0.5*s;
end

%---------------------------------------------------------------------------------------------------
% 函数参数解析
function [x,t,sd,sd2,tol,MODE_COMPLEX,ndirs,display_sifting,sdt,sd2t,r,imf,k,nbit,NbIt,MAXITERATIONS,FIXE,FIXE_H,MAXMODES,INTERP,mask] = init(varargin)

x = varargin{1};
if nargin == 2
  if isstruct(varargin{2})
    inopts = varargin{2};
  else
    error('when using 2 arguments the first one is the analyzed signal X and the second one is a struct object describing the options')
  end
elseif nargin > 2
  try
    inopts = struct(varargin{2:end});
  catch
    error('bad argument syntax')
  end
end

% 默认停止条件
defstop = [0.05,0.5,0.05];

opt_fields = {'t','stop','display','maxiterations','fix','maxmodes','interp','fix_h','mask','ndirs','complex_version'};
% 时间序列，停止参数，是否演示，最大迭代次数，每一轮迭代次数，IMF个数，插值方法，每一轮迭代次数（带条件），mask信号，方向数，是否采用复数模式

defopts.stop = defstop;
defopts.display = 0;
defopts.t = 1:max(size(x));
defopts.maxiterations = 2000;
defopts.fix = 0;
defopts.maxmodes = 0;
defopts.interp = 'spline';
defopts.fix_h = 0;
defopts.mask = 0;
defopts.ndirs = 4;
defopts.complex_version = 2;

opts = defopts;

if(nargin==1)
  inopts = defopts;
elseif nargin == 0
  error('not enough arguments')
end

names = fieldnames(inopts);
for nom = names'
  if ~any(strcmpi(char(nom), opt_fields))
    error(['bad option field name: ',char(nom)])
  end
  if ~isempty(eval(['inopts.',char(nom)])) 
    eval(['opts.',lower(char(nom)),' = inopts.',char(nom),';'])
  end
end

t = opts.t;
stop = opts.stop;
display_sifting = opts.display;
MAXITERATIONS = opts.maxiterations;
FIXE = opts.fix;
MAXMODES = opts.maxmodes;
INTERP = opts.interp;
FIXE_H = opts.fix_h;
mask = opts.mask;
ndirs = opts.ndirs;
complex_version = opts.complex_version;

if ~isvector(x)
  error('X must have only one row or one column')
end

if size(x,1) > 1
  x = x.';
end

if ~isvector(t)
  error('option field T must have only one row or one column')
end

if ~isreal(t)
  error('time instants T must be a real vector')
end

if size(t,1) > 1
  t = t';
end

if (length(t)~=length(x))
  error('X and option field T must have the same length')
end

if ~isvector(stop) || length(stop) > 3
  error('option field STOP must have only one row or one column of max three elements')
end

if ~all(isfinite(x))
  error('data elements must be finite')
end

if size(stop,1) > 1
  stop = stop';
end

L = length(stop);
if L < 3
  stop(3) = defstop(3);
end

if L < 2
  stop(2) = defstop(2);
end

if ~ischar(INTERP) || ~any(strcmpi(INTERP,{'linear','cubic','spline'}))
  error('INTERP field must be ''linear'', ''cubic'', ''pchip'' or ''spline''')
end

% 使用mask信号时的特殊处理
if any(mask)
  if ~isvector(mask) || length(mask) ~= length(x)
    error('masking signal must have the same dimension as the analyzed signal X')
  end

  if size(mask,1) > 1
    mask = mask.';
  end
  opts.mask = 0;
  imf1 = emd(x+mask, opts);
  imf2 = emd(x-mask, opts);
  if size(imf1,1) ~= size(imf2,1)
    warning('emd:warning',['the two sets of IMFs have different sizes: ',int2str(size(imf1,1)),' and ',int2str(size(imf2,1)),' IMFs.'])
  end
  S1 = size(imf1,1);
  S2 = size(imf2,1);
  if S1 ~= S2	% 如果两个信号分解得到的IMF个数不一致，调整顺序
    if S1 < S2
      tmp = imf1;
      imf1 = imf2;
      imf2 = tmp;
    end
    imf2(max(S1,S2),1) = 0;	% 将短的那个补零，达到长度一致
  end
  imf = (imf1+imf2)/2;

end


sd = stop(1);
sd2 = stop(2);
tol = stop(3);

lx = length(x);

sdt = sd*ones(1,lx);
sd2t = sd2*ones(1,lx);

if FIXE
  MAXITERATIONS = FIXE;
  if FIXE_H
    error('cannot use both ''FIX'' and ''FIX_H'' modes')
  end
end

MODE_COMPLEX = ~isreal(x)*complex_version;
if MODE_COMPLEX && complex_version ~= 1 && complex_version ~= 2
  error('COMPLEX_VERSION parameter must equal 1 or 2')
end


% 极值点和过零点的个数
ner = lx;
nzr = lx;

r = x;

if ~any(mask) % 如果使用了mask信号，此时imf就已经计算得到了
  imf = [];
end
k = 1;

% 提取每个模式时迭代的次数
nbit = 0;

% 总体迭代次数
NbIt = 0;
end
%---------------------------------------------------------------------------------------------------