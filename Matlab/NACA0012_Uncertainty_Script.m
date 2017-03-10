% Script to process NACA 0012
% Case I, II, III : Corresponds to different angle of attack 
%                   alpha = 0 deg, 4 deg, 10 deg
Cases={'IV','V','VI'};
CaseNames={'alpha=0 deg','alpha=4 deg','alpha=10 deg'};

% CaseX a, b, c   : Corresponds to the turbulence model used. 
%                   a) SA 
%                   b) k-omega SST 
%                   c) k-sqrt(k)L
subCases={'a','b','c'};
subCaseNames={'Spalart-Allmaras', 'k-omega SST','k-sqrt(k)L'};

% CaseXY_set 1,2,...,5,6  : same number of nodes but differing node
%                           distribution in the y direction. 
%                           1=smallest near wall and largest growth factor
%                           6=largest near wakk and smallest growth factor
sets={'1','2','3','4','5','6'};

% Base data folder
folder1='Case';


% Formal order of accuracy
pf=2;


% Mesh size used in the file name
r=[1.000, 1.143, 1.333, 1.6, 2.0, 2.286, 2.667, 3.2, 4.0];%, 5.333, 8.0];

% Specifiy which meshes to use to estimate the uncertainty. Size=[Nest x 3]
% Value is the index corresponding to the appropriate mesh size in r
Uest=[1,5,9
      5,7,9];
%       5,9,11];




nC=1; nSC=1; ns=1;
[~,~,~] = mkdir('Results');
for nC = 2:numel(Cases)
   for nSC = 1:numel(subCases) 
       fprintf(['Processing: ',folder1,Cases{nC},subCases{nSC}]);
       
       [~,~,~] = mkdir(['Results/Case',Cases{nC},subCases{nSC}]);
             
       fid=fopen(['Reliability-Case',Cases{nC},subCases{nSC},'.txt'],'w'); 
       fprintf(fid, ['Summary of Uncertainty Estimate Reliability for NACA 0012 ',CaseNames{nC},', ',subCaseNames{nSC},'\n\n']);
      
       for ns = 1:numel(sets)
            fprintf(fid,['Reliability of uncertainty estimates: ',folder,'\n']);
            fprintf(fid,'|---------------------------------------------------------------------------------------------------------|\n');
            fprintf(fid,'|         |                             p*                                                                |\n');
            fprintf(fid,'|---------------------------------------------------------------------------------------------------------|\n');
            fprintf(fid,'|  Mesh   |     u     |     v     |     nu    |     cd    |    cf_l   |    cf_u   |    cp_l   |    cp_u   |\n');
            fprintf(fid,'|---------------------------------------------------------------------------------------------------------|\n');
           
            [~,~,~] = mkdir(['Results/Case',Cases{nC},subCases{nSC},'/set',sets{ns}]);
            fprintf('.');
            folder=[folder1,Cases{nC},subCases{nSC},'/set',sets{ns}];

            processSetUncertainty(folder, pf, r, Uest, fid, 2);
       
         
            fprintf(fid,'|---------------------------------------------------------------------------------------------------------|\n');
            
       end
       
        fclose(fid);
       
       fprintf('\n');
   end
end

