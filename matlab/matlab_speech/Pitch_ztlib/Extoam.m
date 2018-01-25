function [Extseg,Dlong]=Extoam(voiceseg,vseg,vosl,vsl,Bth)
% 根据以上四种情况编制而成
for j=1 : vsl
    if j~=1 & j~=vsl & Bth(j)==Bth(j-1) & Bth(j)==Bth(j+1)
        Extseg(j).begin=vseg(j).begin;
        Extseg(j).end=vseg(j+1).begin;
        Dlong(j,1)=0;
        Dlong(j,2)=Extseg(j).end-vseg(j).end;
        Extseg(j).duration=Extseg(j).end-Extseg(j).begin+1;
        
    elseif j~=1 & Bth(j)==Bth(j-1)
        Extseg(j).begin=vseg(j).begin;
        Extseg(j).end=voiceseg(Bth(j)).end;
        Dlong(j,1)=0;
        Dlong(j,2)=Extseg(j).end-vseg(j).end;
        Extseg(j).duration=Extseg(j).end-Extseg(j).begin+1;
    elseif j~=vsl & Bth(j)==Bth(j+1)
        Extseg(j).begin=voiceseg(Bth(j)).begin;
        Extseg(j).end=vseg(j+1).begin;
        Dlong(j,1)=vseg(j).begin-Extseg(j).begin;
        Dlong(j,2)=Extseg(j).end-vseg(j).end;
        Extseg(j).duration=Extseg(j).end-Extseg(j).begin+1;
       
    else
        Extseg(j).begin=voiceseg(Bth(j)).begin;
        Extseg(j).end=voiceseg(Bth(j)).end;
        Dlong(j,1)=vseg(j).begin-Extseg(j).begin;
        Dlong(j,2)=Extseg(j).end-vseg(j).end;
        Extseg(j).duration=Extseg(j).end-Extseg(j).begin+1;
    end
end
