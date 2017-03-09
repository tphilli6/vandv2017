%% script for set1
clc
clear all


pf=2;

%indexing taken from r
Uest=[1,5,9
      5,9,13
      9,11,13];

r=[1.000,1.231,1.455,1.6,2.0,2.462,2.909,3.2,4.0,4.923,5.818,6.4,8.0];
% r=[1,2,4,8];
rstr=num2str(r,'%5.3f'); 
rstr=reshape(rstr,[5,numel(r)])';

% Read field data from file
for i = 1:numel(r);
    file=['field_points_r',rstr(i,:),'.dat'];
    [x,y,u(:,i),v(:,i),nu(:,i)] = importDataSet(['set1/',file]);
end


fid=fopen('Reliability.txt','a');
fprintf(fid,'Reliability of uncertainty estimates\n')
fprintf(fid,'|---------------------------------------------|\n')
fprintf(fid,'|         |                 p*                |\n')
fprintf(fid,'|---------------------------------------------|\n')
fprintf(fid,'|  Mesh   |     u     |     v     |     nu    |\n')
fprintf(fid,'|---------------------------------------------|\n')

for i = 1:size(Uest,2);
    f=Uest(i,:);
    [uUncert(:,i),pstarU(i)]   = globalDeviationUncertainty(u(:,f(1)),u(:,f(2)),u(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
    [vUncert(:,i),pstarV(i)]   = globalDeviationUncertainty(v(:,f(1)),v(:,f(2)),v(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
    [nuUncert(:,i),pstarNu(i)] = globalDeviationUncertainty(nu(:,f(1)),nu(:,f(2)),nu(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
    
    fprintf(fid,'|   %2.0f    |    %4.2f   |    %4.2f   |    %4.2f   |\n', r(f(1)), pstarU(i), pstarV(i), pstarNu(i));
end

fprintf(fid,'|---------------------------------------------|\n')
fid=fclose(fid);


i=1;
X=reshape(x,[13,10]);
Y=reshape(y,[13,10]);
U=reshape(uUncert(:,i),[13,10]);
uu=reshape(u(:,i),[13,10]);
V=reshape(vUncert(:,i),[13,10]);
NU=reshape(nuUncert(:,i),[13,10]);

surf(X,Y,U./uu);
view([0,0,90])