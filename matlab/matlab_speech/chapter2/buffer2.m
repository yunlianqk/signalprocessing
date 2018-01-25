function out = buffer2(y, frameSize, overlap)
% buffer2: Frame blocking
%	Usage: out = buffer2(y, frameSize, overlap)
%	This is almost the same as "buffer" except that there is no leading/trailing zeros

%	Roger Jang, 20010908

if nargin<3, overlap=0; end
if nargin<2, frameSize=256; end

y = y(:);
step = frameSize-overlap;
frameCount = floor((length(y)-overlap)/step);

out = zeros(frameSize, frameCount);
for i=1:frameCount,
	startIndex = (i-1)*step+1;
	out(:, i) = y(startIndex:(startIndex+frameSize-1));
end