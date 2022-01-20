%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SignalUnit_calc.m calculates the unit of each signal summarized in the
% metadata file based on the given/estimated signal gain.
% The results will be written on the metadata file and saved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. on May 10th 2021
% modified on July 6th 2021 and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
clearvars
MTfilepath='C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx';
%%%choose which sheet of the metadata file to read:
sheets=cell(1,7);
sheets{1}='PD_Basal';
sheets{2}= 'PD_MED_DBS';
sheets{3} = 'PD_Hyperchronic_Acute';
sheets{4} = 'PD_Chronic';
sheets{5} = 'PD_ObservedMovements';
sheets{6} = 'Tourette';
sheets{7} = 'PD_8h_cDBS_aDBS';
sheetnum=length(sheets); %number of sheets in the excel file

for j=1:sheetnum
% for j=1
    MT=readtable(MTfilepath,'Sheet',j);
    %open where the signal file is stored:
    directorypath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\'];
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7   %-7 because there are footnote commetns on all sheets            
%     for i=45
        if ~isnan(MT{i,21})%check if SignalGain exists
            SigUnit=1/MT{i,21};
            disp([MT.FileName{i,1}, ' unit is ', num2str(SigUnit), '*V'])
            writematrix([num2str(SigUnit), '*V'],MTfilepath,'Sheet',j,'Range',['R',num2str(i+1)])
        elseif isnan(MT{i,21}) && ~isnan(MT{i,22}) %If SignalGain does not exist, use the estimated gain value
            SigUnit=1/MT{i,22};
            disp([MT.FileName{i,1}, ' unit is estimated as ', num2str(SigUnit), '*V'])
            writematrix([num2str(SigUnit), '*V'],MTfilepath,'Sheet',j,'Range',['R',num2str(i+1)])
        end
    end
end