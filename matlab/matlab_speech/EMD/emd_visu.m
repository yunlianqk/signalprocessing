% EMD_VISU.M 
%
% P. Flandrin, Mar. 13, 2003
%
% displays EMD and partial reconstructions (fine to coarse & coarse to fine)
%
% inputs :   - x : analyzed signal
%            - t : time instants
%            - imf : output of emd.m
%            - i (optional) : figure number for display
%
% outputs :  - f2c : fine to coarse reconstruction
%            - c2f : coarse to fine reconstruction

function varargout = emd_visu(x,t,imf,i);

if sum(size(t)>1)>1
	imf = t;
	t = 1:length(x);
	
	if(nargin==3)
	  figure(i)
	else
	  figure
	end
else
	if(nargin==4)
	  figure(i)
	else
	  figure
	end

end




mx = min(x);
Mx = max(x);

s = size(imf);
k = s(1);

M = max(max(abs(imf(1:k-1,:))));

subplot(k+1,1,1)
plot(t,x)
axis([t(1) t(s(2)) mx Mx])
set(gca,'YTick',[])
set(gca,'XTick',[])
ylabel(['signal'])

for j = 1:k-1
        subplot(k+1,1,j+1)
        plot(t,imf(j,:))
        axis([t(1) t(s(2)) -M M])
        set(gca,'YTick',[])
        set(gca,'XTick',[])
        ylabel(['imf',int2str(j)])
end
subplot(k+1,1,1)
title('Empirical Mode Decomposition')

subplot(k+1,1,k+1)
plot(t,imf(k,:),'r')
% mr = min(imf(k,:));
% Mr = max(imf(k,:));
% axis([t(1) t(s(2)) mr Mr])
% axis([t(1) t(s(2)) -M M])
axis('tight')
set(gca,'YTick',[])
set(gca,'XTick',[])
ylabel('res.')

f2c = [];
f2c(1,:) = imf(1,:);

c2f = [];
c2f(1,:) = imf(k,:);

for j = 2:k
	f2c(j,:) = f2c(j-1,:) + imf(j,:);
	c2f(j,:) = c2f(j-1,:) + imf(k+1-j,:);
end

if(nargin==4)
    figure(i+1)
else
  figure
end

mx = min(x);
Mx = max(x);

s = size(f2c);
k = s(1);

M = max(max(abs(f2c(1:k-1,:))));

subplot(k+1,1,1)
plot(t,x)
axis([t(1) t(s(2)) mx Mx])
set(gca,'YTick',[])
set(gca,'XTick',[])
ylabel(['signal'])

for j = 1:k-1
        subplot(k+1,1,j+1)
        plot(t,f2c(j,:))
        axis([t(1) t(s(2)) -M M])
        set(gca,'YTick',[])
        set(gca,'XTick',[])
        ylabel(['f2c',int2str(j)])
end
subplot(k+1,1,1)
title('f2c')

subplot(k+1,1,k+1)
plot(t,f2c(k,:),'r')
mr = min(f2c(k,:));
Mr = max(f2c(k,:));
axis([t(1) t(s(2)) mr Mr])
set(gca,'YTick',[])
set(gca,'XTick',[])
ylabel('signal')

if(nargin==4)
    figure(i+2)
else
  figure
end

mx = min(x);
Mx = max(x);

s = size(c2f);
k = s(1);

M = max(max(abs(c2f(1:k-1,:)-mean(x))));

subplot(k+1,1,1)
plot(t,x)
axis([t(1) t(s(2)) mx Mx])
set(gca,'YTick',[])
set(gca,'XTick',[])
ylabel(['signal'])

for j = 1:k-1
        subplot(k+1,1,j+1)
%modification G.R. on enlève la moyenne pour les cas où elle est globalement non nulle.
		plot(t,c2f(j,:)-mean(x))
        axis([t(1) t(s(2)) -M M])
        set(gca,'YTick',[])
        set(gca,'XTick',[])
        ylabel(['c2f',int2str(j)])
end
subplot(k+1,1,1)
title('c2f')

subplot(k+1,1,k+1)
plot(t,c2f(k,:),'r')
mr = min(c2f(k,:));
Mr = max(c2f(k,:));
axis([t(1) t(s(2)) mr Mr])
set(gca,'YTick',[])
set(gca,'XTick',[])
ylabel('signal')

if nargout > 0
	varargout = {f2c,c2f};
end
