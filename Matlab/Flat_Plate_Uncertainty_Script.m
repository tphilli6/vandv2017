% Script to process the Flat plate
% Case I, II, III : Corresponds to different Reynolds numbers 
%                   Re = 10^7, 10^8, 10^9
Cases={'I','II','III'};
CaseNames={'Re=10^7','Re=10^8','Re=10^9'};

% CaseX a, b, c   : Corresponds to the turbulence model used. 
%                   a) SA 
%                   b) k-omega SST 
%                   c) k-sqrt(k)L
subCases={'a','b','c'};
subCaseNames={'Spalart-Allmaras', 'k-omega SST','k-sqrt(k)L'};

% CaseXY_set 1,2,...,9,10 : same number of nodes but differing node
%                           distribution in the y direction. 
%                           1=smallest near wall and largest growth factor
%                           10=largest near wakk and smallest growth factor
sets={'1','2','3','4','5','6','7','8','9','10'};

% Base data folder
folder1='Case';




% Formal order of accuracy
pf=2;


% Mesh size used in the file name
r=[1.000,1.231,1.455,1.6,2.0,2.462,2.909,3.2,4.0,4.923,5.818,6.4,8.0];

% Specifiy which meshes to use to estimate the uncertainty. Size=[Nest x 3]
% Value is the index corresponding to the appropriate mesh size in r
Uest=[1,5,9
      5,9,13
      9,11,13];

UestGlobal=[1,3,5
            5,7,9
            9,11,13];

UestGlobal=Uest;



[~,~,~] = mkdir('Results');
for nC = 1:numel(Cases)
   for nSC = 1:numel(subCases) 
       fprintf(['Processing: ',folder1,Cases{nC},subCases{nSC}]);
       
       [~,~,~] = mkdir(['Results/Case',Cases{nC},subCases{nSC}]);
             
       fid=fopen(['Reliability-Case',Cases{nC},subCases{nSC},'.txt'],'w'); 
       fprintf(fid, ['Summary of Uncertainty Estimate Reliability for Flat Plate ',CaseNames{nC},', ',subCaseNames{nSC},'\n\n']);
       
       for ns = 1:numel(sets)
            fprintf(fid,['Reliability of uncertainty estimates: Case',Cases{nC},subCases{nSC},'/set',num2str(ns),'\n']);
            fprintf(fid,'|---------------------------------------------------------------------|\n');
            fprintf(fid,'|         |                             p*                            |\n');
            fprintf(fid,'|---------------------------------------------------------------------|\n');
            fprintf(fid,'|  Mesh   |     u     |     v     |     nu    |     cd    | skin fric |\n');
            fprintf(fid,'|---------------------------------------------------------------------|\n');
           
            
            [~,~,~] = mkdir(['Results/Case',Cases{nC},subCases{nSC},'/set',sets{ns}]);
            fprintf('.');
            folder=[folder1,Cases{nC},subCases{nSC},'/set',sets{ns}];

            processSetUncertainty(folder, pf, r, Uest, UestGlobal, fid, 1);

            fprintf(fid,'|---------------------------------------------------------------------|\n\n\n');

       end
       
       fclose(fid);
       fprintf('\n');
   end
end

