function processUncertaintySkinFriction(folder, pf, r, Uest)


rstr=num2str(r,'%5.3f'); 
rstr=reshape(rstr,[5,numel(r)])';

% Read field data from file
data=flipud(importdata(['Data/',folder,'/conv_surface.dat']))'; sf=data(2:end,:);


% Spot check data, plots grid size versus data for a given mesh node
% for i=1:size(x,1)
%    subplot(3,2,1)
%    semilogx(r,u(i,:),'k-o') 
%    subplot(3,2,2)
%    semilogx(r(1:end-2),(u(i,3:end)-u(i,2:end-1))./(u(i,2:end-1)-u(i,1:end-2)),'k-o') 
%    
%    subplot(3,2,3)
%    semilogx(r,v(i,:),'k-o') 
%    subplot(3,2,4)
%    semilogx(r(1:end-2),(v(i,3:end)-v(i,2:end-1))./(v(i,2:end-1)-v(i,1:end-2)),'k-o') 
%    
%    subplot(3,2,5)
%    semilogx(r,nu(i,:),'k-o') 
%    subplot(3,2,6)
%    semilogx(r(1:end-2),(nu(i,3:end)-nu(i,2:end-1))./(nu(i,2:end-1)-nu(i,1:end-2)),'k-o') 
% end


I=find(folder=='/');
fid=fopen(['Reliability-',folder(1:I-1),'.txt'],'a');
fprintf(fid,['Reliability of uncertainty estimates: ',folder,'\n']);
fprintf(fid,'|---------------------------------------------|\n');
fprintf(fid,'|         |                 p*                |\n');
fprintf(fid,'|---------------------------------------------|\n');
fprintf(fid,'|  Mesh   |     u     |     v     |     nu    |\n');
fprintf(fid,'|---------------------------------------------|\n');

for i = 1:size(Uest,1);
    f=Uest(i,:);
    [sfUncert(:,1),pstarU]   = globalDeviationUncertainty(sf(:,f(1)),sf(:,f(2)),sf(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);

    fprintf(fid,'|   %2.0f    |    %4.2f   |    %4.2f   |    %4.2f   |\n', r(f(1)), pstarU, pstarV, pstarNu);
    
    writeResults(['Results/',folder,'/field_points_r',rstr(f(1),:),'.dat'], x, y, uUncert, vUncert, nuUncert, rstr(f(1),:) );
end

fprintf(fid,'|---------------------------------------------|\n\n\n');
fid=fclose(fid);


% i=1;
% X=reshape(x,[13,10]);
% Y=reshape(y,[13,10]);
% U=reshape(uUncert(:,i),[13,10]);
% uu=reshape(u(:,i),[13,10]);
% V=reshape(vUncert(:,i),[13,10]);
% NU=reshape(nuUncert(:,i),[13,10]);
% 
% surf(X,Y,U./uu);
% view([0,0,90])