%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FileCleaner.m reads the metadata file, identifies those files that have
% at least both Fs and SignalType reported and save them in a new folder.
% The corresponding .json files will be saved in the new folder as well.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. in 2020 and modified
% on May-20th-2021
% and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
clearvars
MTfilepath='C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx';
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
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\'];
    if ~exist([filepath,'Clean_',sheets{j}],'dir') %check if a cleaned up folder exists
        mkdir([filepath,'Clean_',sheets{j}])
    end
    new_filepath=[filepath,'Clean_',sheets{j},'\'];
    % xx=dir(filepath);   %Go to the new directory to find the last file
    
    % for i=1
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        disp(MT.FileName{i})
        if ~isempty(MT.SignalType{i}) && ~isempty(MT.SignalFs(i))
            copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
%             copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
            disp('complete Fs and SignalType info')
        else
            disp('missing Fs and/or signalType info')
        end
    end
end

disp('All files moved to the clean folders successfully!')