%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GainEstimator.m reads the metadata file and wherever that the gain was not
% given, tries to estimate a gain based on the SignalType and writes it to
% the metadata sheet and save.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. in 2020
% modified on July 6th 2021 and can be found at:
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

A=zeros(100,1);

for jk=1:sheetnum
    %   for jk=6
    disp(['Folder: ',sheets{jk}])
    %Read the metadata excel file
    MT=readtable('C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx','Sheet',sheets{jk});
    filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{jk},'\'];
    
    for i=1:size(MT,1)-7   %-7 because there are footnote commetns on all sheets
        % for i=3
        disp(MT.FileName{i})
        if isnan(MT.SignalGain(i))
            %             disp(num2str(i))
            fid=([filepath,MT.FileName{i},'.txt']);
            file=fopen(fid,'r');
            fgetl(file);
            for k=1:size(A,1)
                A(k)=str2double(fgetl(file));
            end
            if isempty(MT.SignalType{i})
                disp 'Unknown signal type'
                EG=100000;
                if mean(abs(A))/EG<1e-6
                    EG=20000;
                    if mean(abs(A))/EG<1e-6
                        EG=10000;
                        if mean(abs(A))/EG<1e-6
                            EG=3000;
                        end
                    end
                end
                disp(['Estimated Gain= ',num2str(EG)])
                writematrix(EG,MTfilepath,'Sheet',sheets{jk},'Range',['V',num2str(i+1)])
            elseif isequal(MT.SignalType{i},'LFP')
                disp LFP
                EG=100000;
                if mean(abs(A))/EG<1e-6
                    EG=20000;
                    if mean(abs(A))/EG<1e-6
                        EG=10000;
                    end
                end
                disp(['Estimated Gain= ',num2str(EG)])
                writematrix(EG,MTfilepath,'Sheet',sheets{jk},'Range',['V',num2str(i+1)])
            elseif isequal(MT.SignalType{i},'EEG')
                disp EEG
                EG=100000;
                if mean(abs(A))/EG<1e-6
                    EG=30000;
                    if mean(abs(A))/EG<1e-6
                        EG=10000;
                    end
                end
                disp(['Estimated Gain= ',num2str(EG)])
                writematrix(EG,MTfilepath,'Sheet',sheets{jk},'Range',['V',num2str(i+1)])
            elseif isequal(MT.SignalType{i},'EMG')
                disp EMG
                EG=10000;
                if mean(abs(A))/EG<1e-6
                    EG=3000;
                    if mean(abs(A))/EG<1e-6
                        EG=1000;
                    end
                end
                disp(['Estimated Gain= ',num2str(EG)])
                writematrix(EG,MTfilepath,'Sheet',sheets{jk},'Range',['V',num2str(i+1)])
            elseif isequal(MT.SignalType{i},'Constant')
                disp('skip')
            end
        end
    end
end