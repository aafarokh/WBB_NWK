%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FileCleaner.m reads the metadata file, identifies those files that have 
% at least both Fs and SignalType reported and save them in a new folder. 
% The corresponding .json files will be saved in the new folder as well.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. in 2020 on a Windows
% 10 system and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
clearvars
selectsheet='PD_Basal';
% selectsheet = 'PD_DBS_OffOnOff';
% selectsheet = 'PD_MED_DBS';
MT=readtable('C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx','Sheet',selectsheet);
filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',selectsheet,'\'];
new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',selectsheet,'\Clean_',selectsheet,'\'];
% xx=dir(filepath);   %Go to the new directory to find the last file

% for i=1
for i=1:size(MT,1)
    disp(MT.FileName{i})
    if ~isempty(MT.SignalType{i}) && ~isempty(MT.SignalFs(i)) 
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('complete info')
    else
        disp('missed info')
    end
end
 