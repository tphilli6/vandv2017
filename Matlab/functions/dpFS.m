function [FS] = dpFS(p,pf)
f0=3;
f1=1.1;
FS = f0 - (f0-f1)*(p/pf).^8;