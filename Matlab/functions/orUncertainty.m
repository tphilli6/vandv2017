function [U,pmean] = orUncertainty(f1,f2,f3,r12,r23,pformal)

for i=1:numel(f1)
    p(i) = orderOfAccuracyOriginal(f1(i), f2(i), f3(i), r12, r23);
end
pmean=mean(p); %mean of order of accuracy, includes oscillatory and divergent cases as well

for i = 1:numel(p)
    if p==-1
        fprintf('Entry %4.0f is divergent\n',i);
        FS=3;
        pU=0.5;
        
    elseif p==0
        fprintf('Entry %4.0f is oscillatory\n',i);
        FS=3;
        pU=0.5;
        
    elseif abs(p-pformal)/pformal > 0.1
        FS=3;
        pU=min( max(0.5, p), pf );
        
    else
        FS=1.25;
        pU=pformal;
        
    end

    U = FS*abs(f2-f1)./(r12^pU - 1);

end