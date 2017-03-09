function [U,pstar] = globalDeviationUncertainty(f1,f2,f3,r12,r23,pformal)


pstar = globalDeviationOrderOfAccuracy(f1, f2, f3, r12, r23, pformal);
FS = dpFS(pstar,pformal);

U = FS*abs(f2-f1)./(r12^pstar - 1);