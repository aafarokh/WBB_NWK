%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SignalDuration_calc.m calculates the duration of each signal in the
% metadata file and finally adds them up to calculate the total recording
% time per sheet and overall.
% The results will be written on the metadata file and saved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. on May 4th 2021
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
SignalTime_sheet=zeros(1,sheetnum); %To calculate the total signal duratoin per each sheet

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    %open where the signal file is stored:
    directorypath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\'];
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7   %-7 because there are footnote commetns on all sheets
        if ~isnan(MT{i,20})%check if Fs exist
            signal=importdata([directorypath,MT.FileName{i,1},'.txt']);
            SigDuration=round((length(signal.textdata)-1)/MT{i,20});
            disp([MT.FileName{i,1}, ' is ', num2str(SigDuration), ' seconds'])
            writematrix(SigDuration,MTfilepath,'Sheet',j,'Range',['AA',num2str(i+1)])
            SignalTime_sheet(1,j)=SignalTime_sheet(1,j)+SigDuration;
        elseif isnan(MT{i,20})
            disp([MT.FileName{i,1},' signal duration cannot be evaluated, Fs does not exist'])
        end
    end
    disp([sheets{j}, ' contains ', num2str(SignalTime_sheet(1,j)), ' seconds of signals.'])
end

TotalDuration=sum(SignalTime_sheet);
disp(['There is ',num2str(TotalDuration),' seconds of signals in the data base'])
disp(['This is equivalant to ',num2str(TotalDuration/60),' minuets and ',num2str(TotalDuration/3600),' hours'])