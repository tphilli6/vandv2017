function processSetUncertainty(folder, pf, r, Uest, fid, application)


rstr=num2str(r,'%5.3f'); 
rstr=reshape(rstr,[5,numel(r)])';

% Read field data from file 
% (local data)
for i = 1:numel(r);
    file=['field_points_r',rstr(i,:),'.dat'];
    [x,y,u(:,i),v(:,i),nu(:,i)] = importDataSet(['Data/',folder,'/',file]);
end
% (skin friction data)
datacd=flipud(importdata(['Data/',folder,'/conv_data_cd.dat']))'; cd=datacd(2,:);
if application==1 %flat plate
    datasf=flipud(importdata(['Data/',folder,'/conv_surface.dat']))'; sf=datasf(2:end,:);

elseif application==2 % NACA 0012
    datacflo=flipud(importdata(['Data/',folder,'/conv_surface_cflo.dat']))'; sf_cflo=datacflo(2:end,:);    
    datacplo=flipud(importdata(['Data/',folder,'/conv_surface_cplo.dat']))'; sf_cplo=datacplo(2:end,:);    
    datacfup=flipud(importdata(['Data/',folder,'/conv_surface_cfup.dat']))'; sf_cfup=datacfup(2:end,:);    
    datacpup=flipud(importdata(['Data/',folder,'/conv_surface_cpup.dat']))'; sf_cpup=datacpup(2:end,:);    
end

% Since this is computed using an incompressible code, I need pressure for
% Cd estimation so


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




for i = 1:size(Uest,1);
    f=Uest(i,:);
    [uUncert(:,1),pstarU]   = globalDeviationUncertainty(u(:,f(1)),u(:,f(2)),u(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
    [vUncert(:,1),pstarV]   = globalDeviationUncertainty(v(:,f(1)),v(:,f(2)),v(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
    [nuUncert(:,1),pstarNu] = globalDeviationUncertainty(nu(:,f(1)),nu(:,f(2)),nu(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
    [cdUncert1(:,i),pstarCD1] = globalDeviationUncertainty(cd(:,f(1)),cd(:,f(2)),cd(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
    
    if application==1;
        [sfUncert(:,i),pstarSF] = globalDeviationUncertainty(sf(:,f(1)),sf(:,f(2)),sf(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
        fprintf(fid,'|   %2.0f    |    %4.2f   |    %4.2f   |    %4.2f   |    %4.2f   |    %4.2f   |\n', r(f(1)), pstarU, pstarV, pstarNu, pstarCD1, pstarSF );
    
    elseif application==2;
        [sf_cfloUncert(:,i),pstarSF_cflo] = globalDeviationUncertainty(sf_cflo(:,f(1)),sf_cflo(:,f(2)),sf_cflo(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
        [sf_cfupUncert(:,i),pstarSF_cfup] = globalDeviationUncertainty(sf_cfup(:,f(1)),sf_cfup(:,f(2)),sf_cfup(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
        [sf_cploUncert(:,i),pstarSF_cplo] = globalDeviationUncertainty(sf_cplo(:,f(1)),sf_cplo(:,f(2)),sf_cplo(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);
        [sf_cpupUncert(:,i),pstarSF_cpup] = globalDeviationUncertainty(sf_cpup(:,f(1)),sf_cpup(:,f(2)),sf_cpup(:,f(3)),r(f(2))/r(f(1)),r(f(3))/r(f(2)),pf);

        fprintf(fid,'|   %2.0f    |    %4.2f   |    %4.2f   |    %4.2f   |    %4.2f   |    %4.2f   |    %4.2f   |    %4.2f   |    %4.2f   |\n', r(f(1)), pstarU, pstarV, pstarNu, pstarCD1, pstarSF_cflo, pstarSF_cfup, pstarSF_cplo, pstarSF_cpup );
    
    end
    

    writeResults(['Results/',folder,'/field_points_r',rstr(f(1),:),'.dat'], x, y, uUncert, vUncert, nuUncert, rstr(f(1),:) );
end

write_surface_data(['Results/',folder,'/conv_data_cd.dat'], r(Uest(:,1)), cdUncert1)

if application==1
    write_surface_data(['Results/',folder,'/conv_surface.dat'], r(Uest(:,1)), sfUncert)
elseif application==2
    write_surface_data(['Results/',folder,'/conv_surface_cflo.dat'], r(Uest(:,1)), sf_cfloUncert)
    write_surface_data(['Results/',folder,'/conv_surface_cfup.dat'], r(Uest(:,1)), sf_cfupUncert)
    write_surface_data(['Results/',folder,'/conv_surface_cplo.dat'], r(Uest(:,1)), sf_cploUncert)
    write_surface_data(['Results/',folder,'/conv_surface_cpup.dat'], r(Uest(:,1)), sf_cpupUncert)

end



function write_surface_data(file, r, U)

fid = fopen(file,'w');
for i = 1:numel(r)
    fprintf(fid,'%8.3f', r(end-i+1));
    fprintf(fid,'%12.6f',U(:,end-i+1));
    fprintf(fid,'\n');
end
fclose(fid);

