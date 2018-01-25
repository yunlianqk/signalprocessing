%
% pra_4_1 
clear all; clc; close all;

load dpstp_tmpdata1.mat
ixd=length(Pamtmp);
Pam=Pamtmp;
   bpseg=findSegment(pindex);        % 计算置信区间内的数据分段信息
   bpl=length(bpseg);                % 将置信区间内的数据分成几段 
   bdb=bpseg(1).begin;               % 置信区间内第一段的开始位置
   if bdb~=1                         % 如果置信区间内第一段开始位置不为1
       Ptb=Pamtmp(bdb);              % 置信区间内第一段开始位置的基音周期
       Ptbp=Pamtmp(bdb+1);
       pdb=ztcont11(Ptk,bdb,Ptb,Ptbp,c1);% 将调用ztcont11
       Pam(1:bdb-1)=pdb;             % 把处理后的数据放入Pam中
   end
   if bpl>=2
       for k=1 : bpl-1               % 如果中间有数据在置信区间外
           pdb=bpseg(k).end;
           pde=bpseg(k+1).begin;
           Ptb=Pamtmp(pdb);
           Pte=Pamtmp(pde);
           pdm=ztcont21(Ptk,pdb,pde,Ptb,Pte,c1);% 调用ztcont21
           Pam(pdb+1:pde-1)=pdm;     % 把处理后的数据放入Pam中
       end
   end
   Pam2=ones(1,ixd)*nan;             % 为了能画出处理后中间数据的曲线
   Pam2(pdb+1:pde-1)=pdm;            % 设置了Pam2
   Pam2(pdb)=Ptb; Pam2(pde)=Pte;
   bde=bpseg(bpl).end;
   Pte=Pamtmp(bde);
   Pten=Pamtmp(bde-1);
   if bde~=ixd                       % 如果置信区间内最后一段开始位置不为kl
% 以下是由函数ztcont31的内容编制而来的
       fn=size(Ptk,2);               % 取来Ptk有多少列
       kl=fn-bde;                    % 取得在置信区间外有多少个数据点
       T0=Pte;                       % 置信区间内最后一段最后一个数据点的基音周期值
       T1=Pten;                      % 置信区间内最后一段最后第二个数据点的基音周期值
       pde=zeros(1,kl);              % 初始化pde
       for k=1:kl                    % 循环
           j=k+bde;
           [mv,ml]=min(abs(T0-Ptk(:,j)));  % 按式(8-6-5)寻找最小差值
           pde(k)=Ptk(ml,j);               % 找到ml;
           fprintf('k=%4d   %4d   ',k,pde(k));
           TT=Ptk(ml,j);
           if abs(T0-TT)>c1                % 如果不满足式(8-6-6)
               TT=2*T0-T1;                 % 向后外推延伸
               pde(k)=TT;
               fprintf('外延为 %4d',pde(k));
           end
           fprintf('\n');
           T1=T0;
           T0=TT;
       end
% 函数ztcont31结束
       Pam(bde+1:ixd)=pde;           % 把处理后的数据放入Pam中
       Pam3=ones(1,ixd)*nan;         % 为了能画出处理后尾部数据的曲线
       Pam3(bde+1:ixd)=pde;          % 设置了Pam3
       Pam3(bde)=Pte;
   end
figure(1)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-200)]);
plot(1:ixd,Ptk(1,:),'kO','linewidth',3); hold on   
plot(1:ixd,Pamtmp,'k','linewidth',3);
line([0 ixd],[meanx meanx],'color',[.6 .6 .6],'lineStyle','-');
line([0 ixd],[mt1 mt1],'color',[.6 .6 .6],'lineStyle','--');
line([0 ixd],[mt2 mt2],'color',[.6 .6 .6],'lineStyle','--');
line([1:ixd],[Pam2(1:ixd)],'color',[.6 .6 .6],'linewidth',3,'lineStyle','-');
line([1:ixd],[Pam3(1:ixd)],'color',[.6 .6 .6],'linewidth',3,'lineStyle','--');
xlabel('样点值'); ylabel('基音周期');
