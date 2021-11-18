%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GainEstimator.m reads the metadata file and wherever that the gain was not 
% given, tries to estimate a gain based on the SignalType and writes it to 
% the metadata sheet and save.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. in 2020 on a Windows
% 10 system and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
clearvars
MTfilepath='C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx';
MT=readtable(MTfilepath);
filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\';
A=zeros(100,1);

for i=417:size(MT,1)
    % for i=3
    if isnan(MT.SignalGain(i))
        disp(num2str(i))
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
            writematrix(EG,MTfilepath,'Sheet',1,'Range',['V',num2str(i+1)])
        elseif MT.SignalType{i}=='LFP'
            disp LFP
            EG=100000;
            if mean(abs(A))/EG<1e-6
                EG=20000;
                if mean(abs(A))/EG<1e-6
                    EG=10000;
                end
            end
            disp(['Estimated Gain= ',num2str(EG)])
            writematrix(EG,MTfilepath,'Sheet',1,'Range',['V',num2str(i+1)])
        elseif MT.SignalType{i}=='EEG'
            disp EEG
            EG=100000;
            if mean(abs(A))/EG<1e-6
                EG=30000;
                if mean(abs(A))/EG<1e-6
                    EG=10000;
                end
            end
            disp(['Estimated Gain= ',num2str(EG)])
            writematrix(EG,MTfilepath,'Sheet',1,'Range',['V',num2str(i+1)])
        elseif MT.SignalType{i}=='EMG'
            disp EMG
            EG=10000;
            if mean(abs(A))/EG<1e-6
                EG=3000;
                if mean(abs(A))/EG<1e-6
                    EG=1000;
                end
            end
            disp(['Estimated Gain= ',num2str(EG)])
            writematrix(EG,MTfilepath,'Sheet',1,'Range',['V',num2str(i+1)])
        end
    end
end
