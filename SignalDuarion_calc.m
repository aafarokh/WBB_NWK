%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SignalDuration_calc.m calculates the duration of each signal in the
% metadata file and finally adds them up to calculate the total recording
% time per sheet and overall.
% The results will be written on the metadata file and saved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. on May 4th 2021
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
SignalTime_sheet=zeros(1,sheetnum); %To calculate the total signal duratoin per each sheet

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    %open where the signal file is stored:
    directorypath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\'];
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)
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
    disp([sheets{j}, ' are ', num2str(SignalTime_sheet(1,j)), ' seconds'])
end

TotalDuration=sum(SignalTime_sheet);
disp(['There is ',num2str(TotalDuration),' seconds of signals in the data base'])
disp(['This is equivalant to ',num2str(TotalDuration/60),' minuets and ',num2str(TotalDuration/3600),' hours'])