function writeResults(file, x,y,u,v,nu,rstr)

fid=fopen(file,'w');

fprintf(fid,[' hih1=   ',rstr,' Number of points = %4.0f\n'],size(x,1));
data=[x,y,u,v,nu];
fprintf(fid,' %17.9E %17.9E %17.9E %17.9E %17.9E\n',data');
fclose(fid);