tic
clearvars
%%%choose which sheet of the metadata file to read:
sheets=cell(1,7);
sheets{1} = 'PD_Basal';
sheets{2} = 'PD_MED_DBS';
sheets{3} = 'PD_Hyperchronic_Acute';
sheets{4} = 'PD_Chronic';
sheets{5} = 'PD_ObservedMovements';
sheets{6} = 'Tourette';
sheets{7} = 'PD_8h_cDBS_aDBS';
sheetnum=length(sheets); %number of sheets in the excel file

% for j=6:sheetnum
 for j=7
    directorypath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\Clean_',sheets{j},'\'];
    files=dir([directorypath,'/*.txt']);
    filenames={files.name};
    if ~exist([directorypath,'Diagrams'],'dir')
        mkdir(directorypath,'Diagrams')
    end
    savingpath=[directorypath,'Diagrams\'];
    
    MT=readtable('C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx','Sheet',sheets{j});
    
    for i=1:length(filenames)
        disp(filenames{i}(1:end-4))
        signal=textread([directorypath,filenames{i}],'%f','headerlines',1); %Read the signal from the file
        [samplingfreq, Fs]=textread([directorypath,filenames{i}],'%s%f',1);    %Read the sampling frequency
        if ~isnan(Fs)
            Ts=1/Fs;
            t=Ts:Ts:length(signal)*Ts;
            signal=signal-mean(signal); %take off the mean of the signal
            %%select part of the signal:
            %chopTime=10*Fs:20*Fs-1;    %10 seconds of the signal
            %signal=signal(chopTime);
            %%%Spectrogram of the signal
            disp('computing the spectrogram...')
            [S,tt,f]=spec_gram(signal,Fs);
            %%%PSD of DBS on state
            disp('computing the PSD...')
            [p0,f0]=pwelch(signal,Fs,Fs/2,[],Fs);
            %Plot the signal, corresponding spectrogram and PSD:
            disp('plotting and saving...')
            figtitle=[filenames{i}(1:end-4),': ',MT.SubjectName{i},', ',...
                MT.SignalType{i},', ',...
                MT.BodySite{i},', ',...
                MT.Channel{i}];
            figure;
            ax1=subplot(3,1,1); title(figtitle,'Interpreter','none'); hold on
            %%Use this for chopped signal:
            %plot(t(chopTime),signal); zoom xon;  xlim([chopTime(1)/Fs chopTime(end)/Fs]);
            plot(t,signal); zoom xon;  xlim([t(1) t(end)]);
            set(gca,'FontSize',10,'FontWeight','bold')
            ax2=subplot(3,1,2);
            plot_matrix(S,tt,f); zoom xon; colorbar off; colormap parula; xlabel('Time (s)')
            set(gca,'FontSize',10,'FontWeight','bold')
            ax3=subplot(3,1,3);
            plot(f0,p0,'LineWidth',1); xlim([0 200]); zoom xon
            xlabel('Frequency (Hz)'); ylabel('PSD')
            set(gca,'FontSize',10,'FontWeight','bold')
            saveas(gcf,[savingpath,filenames{i}(1:end-4)],'jpg')
            %saveas(gcf,savingPath,'fig')
            close
        elseif isnan(Fs)
            disp('No sampling frequency; skipped')
        end
    end
end
toc