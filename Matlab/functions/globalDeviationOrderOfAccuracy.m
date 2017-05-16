function [pstar, dp] = globalDeviationOrderOfAccuracy(f1, f2, f3, r12, r23, pformal)
% p = orderOfAccuracy(f1, f2, f3, r12, r23, pformal)
% all inputs must be the same size and shape.
% f1 = fine mesh solution
% f2 = medium mesh solution
% f3 = coarse mesh solution
% r12 = refinement factor between mesh h1 and h2
% r23 = refinement factor between mesh h2 and h3
%
% Function to compute the global deviation order of accuracy
p = orderOfAccuracy(f1, f2, f3, r12, r23);

N=numel(f1);
dploc = min( abs(pformal-p), 4*pformal );
dp = min( 1/N* sum(dploc), 0.75*pformal );
pstar = pformal - dp;
