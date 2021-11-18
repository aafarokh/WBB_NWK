%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SignalUnit_calc.m calculates the unit of each signal summarized in the
% metadata file base don the given/estimated signal gain.
% The results will be written on the metadata file and saved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. on May 10th 2021
% and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
clearvars
MTfilepath='C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx';
sheets=cell(1,3);
sheets{1}='PD_Basal';
sheets{2}= 'PD_DBS_OffOnOff';
sheets{3} = 'PD_MED_DBS';
sheetnum=length(sheets); %number of sheets in the excel file
% SignalTime_sheet=zeros(1,sheetnum); %To calculate the total signal duratoin per each sheet

for j=1:sheetnum
% for j=1
    MT=readtable(MTfilepath,'Sheet',j);
    %open where the signal file is stored:
    directorypath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\'];
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)            
%     for i=45
        if ~isnan(MT{i,21})%check if SignalGain exists
            SigUnit=1/MT{i,21};
            disp([MT.FileName{i,1}, ' unit is ', num2str(SigUnit), '*V'])
            writematrix([num2str(SigUnit), '*V'],MTfilepath,'Sheet',j,'Range',['R',num2str(i+1)])
        elseif isnan(MT{i,21}) && ~isnan(MT{i,22}) %If not use the estimated gain value
            SigUnit=1/MT{i,22};
            disp([MT.FileName{i,1}, ' unit is estimated as ', num2str(SigUnit), '*V'])
            writematrix([num2str(SigUnit), '*V'],MTfilepath,'Sheet',j,'Range',['R',num2str(i+1)])
        end
    end
end