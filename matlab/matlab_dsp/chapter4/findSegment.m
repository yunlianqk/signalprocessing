function vSegment=findSegment(express)
if express(1)==0                          % 判断express是数字还是表达式
    vIndex=find(express);                 % 是表达式
else
    vIndex=express;                       % 是数字
end

vSegment = [];
k = 1;
vSegment(k).begin = vIndex(1);            % 设置第一组有话段的起始位置
for i=1:length(vIndex)-1,
	if vIndex(i+1)-vIndex(i)>1,           % 本组有话段结束
		vSegment(k).end = vIndex(i);      % 设置本组有话段的结束位置
		vSegment(k+1).begin = vIndex(i+1);% 设置下一组有话段的起始位置  
		k = k+1;
	end
end
vSegment(k).end = vIndex(end);            % 最后一组有话段的结束位置
% 计算每组有话段的长度
for i=1 :k
    vSegment(i).duration=vSegment(i).end-vSegment(i).begin+1;
end
