 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SignalsStatistics.m computes the distribution of gender, age range,
% signal type etc. among the signals in the data bank.
% The results will be drawn in differnet diagrams.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. on May 10th-12th 2021
% and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NOTE: The algorithms written such that the existence of Fs is ignored and
%the metadata file is read regardless of Fs exists or not. One can reduce
%the signals to ones with given Fs and adopt the code to use later.
tic
clearvars
MTfilepath='C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx';
SavingPath='C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Results_Distributions\';
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

%% To evalaute gender statistics: How many signals are from male, female and
%%unknown subject and in what percentage, draw a pie diagram
MaleSigs_sheet=zeros(1,sheetnum);   %To count males per each sheet
FemaleSigs_sheet=zeros(1,sheetnum); %To count females per each sheet
UnknownSigs_sheet=zeros(1,sheetnum); %To count unknown genders per each sheet

TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if ~isempty(MT{i,8}{1,1}) && isequal(MT{i,8}{1,1},'M') %check if gender exists and the signal is from a male subject
            disp([MT.FileName{i,1}, ' is Male'])
            MaleSigs_sheet(1,j)=MaleSigs_sheet(1,j)+1;
        elseif ~isempty(MT{i,8}{1,1}) && isequal(MT{i,8}{1,1},'F') %check if gender exists and the signal is from a female subject
            disp([MT.FileName{i,1},' is Female'])
            FemaleSigs_sheet(1,j)=FemaleSigs_sheet(1,j)+1;
        elseif isempty(MT{i,8}{1,1}) %if gender is not specirfied for the signal
            disp([MT.FileName{i,1}, ' gender data is missing'])
            UnknownSigs_sheet(1,j)=UnknownSigs_sheet(1,j)+1;
        end
    end
    disp(['There are ',  num2str(MaleSigs_sheet(1,j)), ' signals from male subjects, ',...
        num2str(FemaleSigs_sheet(1,j)), ' signals from females subjects and ',...
        num2str(UnknownSigs_sheet(1,j)), ' signals from subjects with no gender specified in ',sheets{j}])
    TotalSigs=TotalSigs+size(MT,1);
end

TotalMale=sum(MaleSigs_sheet); TotalFemale=sum(FemaleSigs_sheet); TotalUnknown=sum(UnknownSigs_sheet);
TMpercent=(TotalMale/TotalSigs)*100; TFpercent=(TotalFemale/TotalSigs)*100; TUpercent=(TotalUnknown/TotalSigs)*100;

disp(['There are ',num2str(TotalMale),' signals from male subjects, ',...
    num2str(TotalFemale),' signals from female subjects and ',...
    num2str(TotalUnknown),' signals from unknown genders in the data bank.'])
disp(['In other words ',num2str(TMpercent),'% of the signals are from males',...
    num2str(TFpercent),'% of the signals are from females and '...
    num2str(TUpercent),'% of the signals are with missing gender info.'])

figure; %title('Gender Distribution among Signlas'); hold on
ay=subplot(2,1,1);
X = [TMpercent TFpercent TUpercent];
labels = {'Signals from Male subjects','Signals from Female subjects','Missing info'};
explode=[1 1 1];
pie(X,explode)
% Create legend
lgd = legend(labels);
lgd.Location = 'northeastout';
ay.Position=[0.4300 0.5838 0.4792 0.3412];
ax=subplot(2,1,2);
annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
    [num2str(TotalMale),' out of ', num2str(TotalSigs),' signals are from Males.'])
annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
    [num2str(TotalFemale),' out of ', num2str(TotalSigs),' signals are from Females.'])
annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
    [num2str(TotalUnknown),' out of ', num2str(TotalSigs),' signals are from unspecified gender.'])

ax.Visible='off';
set(gcf,'WindowState','maximized')
savefig([SavingPath,'SignalsGender_Distribution.fig'])
saveas(gcf,[SavingPath,'SignalsGender_Distribution.jpg'])
close 
%% To evalaute gender statistics: How many subjects are male, female and
%%unknown, in what percentage, draw a pie diagram
Males_sheet=zeros(1,sheetnum);   %To count males per each sheet
Females_sheet=zeros(1,sheetnum); %To count females per each sheet
Unknown_sheet=zeros(1,sheetnum); %To count unknown genders per each sheet
PID='PID0000';

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if contains(PID,MT{i,2}{1,1}) %skip repeated patients
            continue
        else
            if  ~isempty(MT{i,8}{1,1}) && isequal(MT{i,8}{1,1},'M') %check if gender exists and male subject
                disp([MT.PatientID{i,1}, ' is Male'])
                Males_sheet(1,j)=Males_sheet(1,j)+1;
            elseif ~isempty(MT{i,8}{1,1}) && isequal(MT{i,8}{1,1},'F') %check if gender exists and female subject
                disp([MT.PatientID{i,1},' is Female'])
                Females_sheet(1,j)=Females_sheet(1,j)+1;
            elseif isempty(MT{i,8}{1,1}) %unknown gender
                disp([MT.PatientID{i,1}, ' gender info is not provided'])
                Unknown_sheet(1,j)=Unknown_sheet(1,j)+1;
            end
        end
        newPID=MT{i,2}{1,1};
        PID=[PID, newPID];
    end
    disp(['There are ',  num2str(Males_sheet(1,j)), ' male subjects, ',...
        num2str(Females_sheet(1,j)), ' females subjects and ',...
        num2str(Unknown_sheet(1,j)), ' subject with missing gender info in ',sheets{j}])
end

TotalMale=sum(Males_sheet); TotalFemale=sum(Females_sheet); TotalUnknown=sum(Unknown_sheet);
TotalSubs=TotalMale+TotalFemale+TotalUnknown;
TMpercent=(TotalMale/TotalSubs)*100; TFpercent=(TotalFemale/TotalSubs)*100; TUpercent=(TotalUnknown/TotalSubs)*100;

disp(['There are ',num2str(TotalMale),' male , ',...
    num2str(TotalFemale),' female and ',...
    num2str(TotalUnknown),' subjects with missing gender info in the data bank.'])
disp(['In other words ',num2str(TMpercent),'% of the patients are male, ',...
    num2str(TFpercent),'% of the patients are female and ', ...
    num2str(TUpercent),'% of the patients are with missing gender info.'])

figure;
ay=subplot(2,1,1);
X = [TMpercent TFpercent TUpercent];
labels = {'Male subjects','Female subjects','Missing info'};
ex=[1 1 1];
pie(X,ex)
% Create legend
lgd = legend(labels);
lgd.Location = 'northeastout';
ay.Position=[0.4300 0.5838 0.4792 0.3412];
ax=sbplot(2,1,2);
annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
    [num2str(TotalMale),' out of ', num2str(TotalSubs),' subjects are Male.'])
annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
    [num2str(TotalFemale),' out of ', num2str(TotalSubs),' subjects are Female.'])
annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
    [num2str(TotalUnknown),' out of ', num2str(TotalSubs),' subjects are with unspecified gender.'])
ax.Visible='off';
set(gcf,'WindowState','maximized')
savefig([SavingPath,'PatientsGender_Distribution'])
saveas(gcf,[SavingPath,'PatientsGender_Distribution.jpg'])
close 
%% To evalaute signal types statistics: How many signals are STN LFP, GPi LFP, EEG ,EMG, ECG
%and unknown; in what percentage and draw a pie diagram
STNsigs_sheet=zeros(1,sheetnum); %To count STN LFPs per each sheet
GPisigs_sheet=zeros(1,sheetnum); %To count GPi LFPs per each sheet
EEGsigs_sheet=zeros(1,sheetnum); %To count EEG signals per each sheet
EMGsigs_sheet=zeros(1,sheetnum); %To count EMG signals per each sheet
ECGsigs_sheet=zeros(1,sheetnum); %To count ECG signals per each sheet
UnkSigs_sheet=zeros(1,sheetnum); %To count unknown signals per each sheet

TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if ~isempty(MT{i,11}{1,1}) && isequal(MT{i,11}{1,1},'LFP')...
                && isequal(MT{i,14}{1,1},'STN') %check if signal type exists and is STN LFP
            disp([MT.FileName{i,1}, ' is STN LFP'])
            STNsigs_sheet(1,j)=STNsigs_sheet(1,j)+1;
        elseif ~isempty(MT{i,11}{1,1}) && isequal(MT{i,11}{1,1},'LFP')...
                && isequal(MT{i,14}{1,1},'GPi') %check if signal type exists and is GPi LFP
            disp([MT.FileName{i,1}, ' is GPi LFP'])
            GPisigs_sheet(1,j)=GPisigs_sheet(1,j)+1;
        elseif ~isempty(MT{i,11}{1,1}) && isequal(MT{i,11}{1,1},'EEG') %check if signal type exists and is EEG
            disp([MT.FileName{i,1}, ' is EEG'])
            EEGsigs_sheet(1,j)=EEGsigs_sheet(1,j)+1;
        elseif ~isempty(MT{i,11}{1,1}) && isequal(MT{i,11}{1,1},'EMG') %check if signal type exists and is EMG
            disp([MT.FileName{i,1}, ' is EMG'])
            EMGsigs_sheet(1,j)=EMGsigs_sheet(1,j)+1;
        elseif ~isempty(MT{i,11}{1,1}) && isequal(MT{i,11}{1,1},'ECG') %check if signal type exists and is ECG
            disp([MT.FileName{i,1}, ' is ECG'])
            ECGsigs_sheet(1,j)=ECGsigs_sheet(1,j)+1;
        elseif isempty(MT{i,11}{1,1}) %check if signal type is unknown
            disp([MT.FileName{i,1}, ' is unknown'])
            UnkSigs_sheet(1,j)=UnkSigs_sheet(1,j)+1;
        end
    end
    disp(['There are ',  num2str(STNsigs_sheet(1,j)), ' STN LFP signals, ',...
        num2str(GPisigs_sheet(1,j)), ' GPi LFP signals, ',...
        num2str(EEGsigs_sheet(1,j)), ' EEG signals, ',...
        num2str(EMGsigs_sheet(1,j)), ' EMG signals, ',...
        num2str(ECGsigs_sheet(1,j)), ' ECG signals and ',...
        num2str(UnkSigs_sheet(1,j)), ' unknown signal types in ',sheets{j}])
    TotalSigs=TotalSigs+size(MT,1);
end

TotalSTN=sum(STNsigs_sheet); TotalGPi=sum(GPisigs_sheet); TotalUnknown=sum(UnkSigs_sheet);
TotalEEG=sum(EEGsigs_sheet); TotalEMG=sum(EMGsigs_sheet); TotalECG=sum(ECGsigs_sheet);

TSpercent=(TotalSTN/TotalSigs)*100; TGpercent=(TotalGPi/TotalSigs)*100; TUpercent=(TotalUnknown/TotalSigs)*100;
TEGpercent=(TotalEEG/TotalSigs)*100; TMGpercent=(TotalEMG/TotalSigs)*100; TCGpercent=(TotalECG/TotalSigs)*100;

disp(['There are ',num2str(TotalSTN),' STN LFP signals, ',...
    num2str(TotalGPi),' GPi LFP signals ',...
    num2str(TotalEEG),' EEG signals ',...
    num2str(TotalEMG),' EMG signals ',...
    num2str(TotalECG),' ECG signals ',...
    num2str(TotalUnknown),' unknown signals in the data bank.'])
% disp(['In other words ',num2str(TMpercent),'% of the signals are from males',...
%         num2str(TFpercent),'% of the signals are from females and '...
%         num2str(TUpercent),'% of the signals are with unknown gender.'])

figure; %title('Gender Distribution among Signlas'); hold on
ay=subplot(2,1,1);
X = [TSpercent TGpercent TEGpercent TMGpercent TCGpercent TUpercent];
labels = {'STN LFP','GPi LFP','EEG','EMG','ECG','Unknown'};
explode=[1 1 1 1 1 1];
pie(X,explode)
% Create legend
lgd = legend(labels);
lgd.Location = 'northeastout';
ay.Position=[0.4300 0.5838 0.4792 0.3412];
ax=subplot(2,1,2);
annotation('textbox', [0.2, 0.5, 0.1, 0.1], 'String',...
    [num2str(TotalSTN),' / ', num2str(TotalSigs),' signals are STN LFP.'])
annotation('textbox', [0.2, 0.4, 0.1, 0.1], 'String',...
    [num2str(TotalGPi),' / ', num2str(TotalSigs),' signals are GPi LFP.'])
annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
    [num2str(TotalEEG),' / ', num2str(TotalSigs),' signals are EEG.'])
annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
    [num2str(TotalEMG),' / ', num2str(TotalSigs),' signals are EMG.'])
if TotalECG==1
    annotation('textbox', [0.27, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalECG),' / ', num2str(TotalSigs),' signals is ECG.'])
else
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalECG),' / ', num2str(TotalSigs),' signals are ECG.'])
end
annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
    [num2str(TotalUnknown),' / ', num2str(TotalSigs),' signals are unknwon.'])
ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'SignalTypes_Distribution.jpg'])
savefig([SavingPath,'SignalTypes_Distribution.fig'])
close 

%% To evalaute medication and stimulation statistics:
% How many signals are distributed based on their medication and stimulation on/off states
% and mixed and unknown; in what percentage and draw a pie diagram
MoffSoff_sheet=zeros(1,sheetnum);   %To count MedOff-StimOff per each sheet
MoffSon_sheet=zeros(1,sheetnum); %To count MedOff-StimOn per each sheet
MonSon_sheet=zeros(1,sheetnum);  %To count MedOn-StimOn per each sheet
MonSoff_sheet=zeros(1,sheetnum); %To count MedOn-StimOff per each sheet
unknown_sheet=zeros(1,sheetnum); %To count unknown states per each sheet
mixed_sheet=zeros(1,sheetnum); %To count mixed states od Med and/or Stim per each sheet
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: off, stim: off
            disp([MT.FileName{i,1}, ': Medication is off, Stimulation is off'])
            MoffSoff_sheet(1,j)=MoffSoff_sheet(1,j)+1;
        elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: off, stim: on
            disp([MT.FileName{i,1}, ': Medication is off, Stimulation is on'])
            MoffSon_sheet(1,j)=MoffSon_sheet(1,j)+1;
        elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: on, stim: on
            disp([MT.FileName{i,1}, ': Medication is on, Stimulation is on'])
            MonSon_sheet(1,j)=MonSon_sheet(1,j)+1;
        elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: on, stim: off
            disp([MT.FileName{i,1}, ': Medication is on, Stimulation is off'])
            MonSoff_sheet(1,j)=MonSoff_sheet(1,j)+1;
        elseif isempty(MT{i,16}{1,1}) || isempty(MT{i,17}{1,1}) %if Med or Stim info are not available
            disp([MT.FileName{i,1}, ': Medication and/or Stimulation info is (are) absent'])
            unknown_sheet(1,j)=unknown_sheet(1,j)+1;
        else
            disp([MT.FileName{i,1}, ': Mixed on-off state of either/both Medication and Stimulation'])
            mixed_sheet(1,j)=mixed_sheet(1,j)+1;
        end
    end
    disp(['There are ',  num2str(MoffSoff_sheet(1,j)), ' signals with Med OFF and Stim OFF, ',...
        num2str(MoffSon_sheet(1,j)), ' signals with Med OFF and Stim ON, ',...
        num2str(MonSon_sheet(1,j)), ' signals with Med ON and Stim ON, ',...
        num2str(MonSoff_sheet(1,j)), ' signals with Med ON and Stim OFF, ',...
        num2str(mixed_sheet(1,j)), ' signals with mixed states and ',...
        num2str(unknown_sheet(1,j)), ' signals with unknown medication and/or stimlation status in ',sheets{j}])
    TotalSigs=TotalSigs+size(MT,1);
end

TotalMoffSoff=sum(MoffSoff_sheet); TotalMoffSon=sum(MoffSon_sheet);
TotalMonSon=sum(MonSon_sheet); TotalMonSoff=sum(MonSoff_sheet);
TotalUnknown=sum(unknown_sheet); TotalMixed=sum(mixed_sheet);

TMoffSoffpercent=(TotalMoffSoff/TotalSigs)*100; TMoffSonpercent=(TotalMoffSon/TotalSigs)*100;
TMonSonpercent=(TotalMonSon/TotalSigs)*100; TMonSoffpercent=(TotalMonSoff/TotalSigs)*100;
TUpercent=(TotalUnknown/TotalSigs)*100; TMpercent=(TotalMixed/TotalSigs)*100;

disp(['There are ',  num2str(TotalMoffSoff), ' signals with Med OFF and Stim OFF, ',...
    num2str(TotalMoffSon), ' signals with Med OFF and Stim ON, ',...
    num2str(TotalMonSon), ' signals with Med ON and Stim ON, ',...
    num2str(TotalMonSoff), ' signals with Med ON and Stim OFF, ',...
    num2str(TotalMixed), ' signals with mixed states and ',...
    num2str(TotalUnknown), ' signals with unknown medication and/or stimlation status in the data bank.'])
disp(['In other words ',num2str(TMoffSoffpercent),'% of the signals are from Medicatoin off and Stimulation off status',...
    num2str(TMoffSonpercent),'% of the signals are from Medicatoin off and Stimulation on status',...
    num2str(TMonSonpercent),'% of the signals are from Medicatoin off and Stimulation on status',...
    num2str(TMonSoffpercent),'% of the signals are from Medicatoin on and Stimulation off status,',...
    num2str(TMpercent),'% of the signals are with mixed status and',...
    num2str(TUpercent),'% of the signals are with unknown Medication and/or Stimulation status in the data bank.'])

figure;
ay=subplot(2,1,1);
X = [TMoffSoffpercent TMoffSonpercent TMonSonpercent TMonSoffpercent TMpercent TUpercent];
labels = {'Med: OFF, Stim: OFF','Med: OFF, Stim: ON','Med: ON, Stim: ON','Med: ON, Stim: OFF','Mixed','Unknown'};
explode=[1 1 1 1 1 1];
pie(X,explode)
% Create legend
lgd = legend(labels);
lgd.Location = 'northeastout';
ay.Position=[0.4300 0.5838 0.4792 0.3412];
ax=subplot(2,1,2);
annotation('textbox', [0.2, 0.5, 0.1, 0.1], 'String',...
    [num2str(TotalMoffSoff),' / ', num2str(TotalSigs),' signals are with Med: OFF and Stim: OFF.'])
annotation('textbox', [0.2, 0.4, 0.1, 0.1], 'String',...
    [num2str(TotalMoffSon),' / ', num2str(TotalSigs),' signals are with Med: OFF and Stim: ON.'])
annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
    [num2str(TotalMonSon),' / ', num2str(TotalSigs),' signals are with Med: ON and Stim: ON.'])
annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
    [num2str(TotalMonSoff),' / ', num2str(TotalSigs),' signals are with Med: ON and Stim: OFF.'])
annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
    [num2str(TotalMixed),' / ', num2str(TotalSigs),' signals are with mixed Med and Stim states.'])
annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
    [num2str(TotalUnknown),' / ', num2str(TotalSigs),' signals have unspecified Med and/or Stim status.'])
ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'SignalsMedStim_Distribution.jpg'])
savefig([SavingPath,'SignalsMedStim_Distribution.fig'])
close 

%% med off/on all signals: If medication is on or off checking all signals.
Moff_sheet=zeros(1,sheetnum);%To count MedOff per each sheet
Mon_sheet=zeros(1,sheetnum);  %To count MedOn per each sheet
unknown_sheet=zeros(1,sheetnum); %To count unknown states per each sheet
mixed_sheet=zeros(1,sheetnum);   %To count mixed states of Med per each sheet
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if ~isempty(MT{i,16}{1,1}) && isequal(MT{i,16}{1,1},'off')  %check if med info exists and med: off
            disp([MT.FileName{i,1}, ': Medication is off'])
            Moff_sheet(1,j)=Moff_sheet(1,j)+1;
        elseif ~isempty(MT{i,16}{1,1}) && isequal(MT{i,16}{1,1},'on')  %check if med exists and med: on
            disp([MT.FileName{i,1}, ': Medication is on'])
            Mon_sheet(1,j)=Mon_sheet(1,j)+1;
        elseif isempty(MT{i,16}{1,1}) %if Med info is not available
            disp([MT.FileName{i,1}, ': Medication info is absent'])
            unknown_sheet(1,j)=unknown_sheet(1,j)+1;
        else
            disp([MT.FileName{i,1}, ': Mixed on-off state of Medication'])
            mixed_sheet(1,j)=mixed_sheet(1,j)+1;
        end
    end
    disp(['There are ',  num2str(Moff_sheet(1,j)), ' signals with Med OFF, ',...
        num2str(Mon_sheet(1,j)), ' signals with Med ON, ',...
        num2str(mixed_sheet(1,j)), ' signals with mixed states and ',...
        num2str(unknown_sheet(1,j)), ' signals with unknown medication status in ',sheets{j}])
    TotalSigs=TotalSigs+size(MT,1);
end

TotalMoff=sum(Moff_sheet);TotalMon=sum(Mon_sheet);
TotalUnknown=sum(unknown_sheet); TotalMixed=sum(mixed_sheet);

TMoffpercent=(TotalMoff/TotalSigs)*100; TMonpercent=(TotalMon/TotalSigs)*100;
TUpercent=(TotalUnknown/TotalSigs)*100; TMpercent=(TotalMixed/TotalSigs)*100;

disp(['There are ',  num2str(TotalMoff), ' signals with Med OFF, ',...
    num2str(TotalMon), ' signals with Med ON, ',...
    num2str(TotalMixed), ' signals with mixed states and ',...
    num2str(TotalUnknown), ' signals with unknown medication status in the data bank.'])
disp(['In other words ',num2str(TMoffpercent),'% of the signals are from Medicatoin off',...
    num2str(TMonpercent),'% of the signals are from Medicatoin on status',...
    num2str(TMpercent),'% of the signals are with mixed status and',...
    num2str(TUpercent),'% of the signals are with unknown Medication status in the data bank.'])

figure;
ay=subplot(2,1,1);
X = [TMoffSoffpercent TMonpercent TMpercent TUpercent];
labels = {'Med: OFF','Med: ON','Mixed','Unknown'};
explode=[1 1 1 1];
pie(X,explode)
% Create legend
lgd = legend(labels);
lgd.Location = 'northeastout';
ay.Position=[0.4300 0.5838 0.4792 0.3412];
ax=subplot(2,1,2);
annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
    [num2str(TotalMoff),' / ', num2str(TotalSigs),' signals are with Med: OFF.'])
annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
    [num2str(TotalMon),' / ', num2str(TotalSigs),' signals are with Med: ON.'])
annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
    [num2str(TotalMixed),' / ', num2str(TotalSigs),' signals are with mixed Med states.'])
annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
    [num2str(TotalUnknown),' / ', num2str(TotalSigs),' signals have unspecified Med status.'])
ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'SignalsMed_Distribution.jpg'])
savefig([SavingPath,'SignalsMed_Distribution.fig'])
close 
%% stim on\off all signals: If stimulation is on\off checking all signal
Soff_sheet=zeros(1,sheetnum);%To count StimOff per each sheet
Son_sheet=zeros(1,sheetnum);  %To count StimOn per each sheet
unknown_sheet=zeros(1,sheetnum); %To count unknown states per each sheet
mixed_sheet=zeros(1,sheetnum);   %To count mixed states of Med per each sheet
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if ~isempty(MT{i,17}{1,1}) && isequal(MT{i,17}{1,1},'off')  %check if stim info exists and med: off
            disp([MT.FileName{i,1}, ': Stimulation is off'])
            Soff_sheet(1,j)=Soff_sheet(1,j)+1;
        elseif ~isempty(MT{i,17}{1,1}) && isequal(MT{i,17}{1,1},'on')  %check if stim exists and med: on
            disp([MT.FileName{i,1}, ': Stimulation is on'])
            Son_sheet(1,j)=Son_sheet(1,j)+1;
        elseif isempty(MT{i,17}{1,1}) %if stim info is not available
            disp([MT.FileName{i,1}, ': Stimulation info is absent'])
            unknown_sheet(1,j)=unknown_sheet(1,j)+1;
        else
            disp([MT.FileName{i,1}, ': Mixed on-off state of Stimulation'])
            mixed_sheet(1,j)=mixed_sheet(1,j)+1;
        end
    end
    disp(['There are ',  num2str(Soff_sheet(1,j)), ' signals with Stim OFF, ',...
        num2str(Son_sheet(1,j)), ' signals with Stim ON, ',...
        num2str(mixed_sheet(1,j)), ' signals with mixed states and ',...
        num2str(unknown_sheet(1,j)), ' signals with unknown Stimulation status in ',sheets{j}])
    TotalSigs=TotalSigs+size(MT,1);
end

TotalSoff=sum(Soff_sheet);TotalSon=sum(Son_sheet);
TotalUnknown=sum(unknown_sheet); TotalMixed=sum(mixed_sheet);

TSoffpercent=(TotalSoff/TotalSigs)*100; TSonpercent=(TotalSon/TotalSigs)*100;
TUpercent=(TotalUnknown/TotalSigs)*100; TMpercent=(TotalMixed/TotalSigs)*100;

disp(['There are ',  num2str(TotalSoff), ' signals with Stim OFF, ',...
    num2str(TotalSon), ' signals with Stim ON, ',...
    num2str(TotalMixed), ' signals with mixed states and ',...
    num2str(TotalUnknown), ' signals with unknown stimulation status in the data bank.'])
disp(['In other words ',num2str(TSoffpercent),'% of the signals are from Stimulation off ',...
    num2str(TSonpercent),'% of the signals are from Stimulation on status ',...
    num2str(TMpercent),'% of the signals are with mixed status and ',...
    num2str(TUpercent),'% of the signals are with unknown Stimulation status in the data bank.'])

if TUpercent==0
    figure;
    ay=subplot(2,1,1);
    X = [TSoffpercent TSonpercent TMpercent];
    labels = {'Stim: OFF','Stim: ON','Mixed'};
    explode=[1 1 1];
    pie(X,explode)
    % Create legend
    lgd = legend(labels);
    lgd.Location = 'northeastout';
    ay.Position=[0.4300 0.5838 0.4792 0.3412];
    ax=subplot(2,1,2);
    annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
        [num2str(TotalSoff),' / ', num2str(TotalSigs),' signals are with Stim: OFF.'])
    annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
        [num2str(TotalSon),' / ', num2str(TotalSigs),' signals are with Stim: ON.'])
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalMixed),' / ', num2str(TotalSigs),' signals are with mixed Stim states.'])
else
    figure;
    ay=subplot(2,1,1);
    X = [TSoffpercent TSonpercent TMpercent TUpercent];
    labels = {'Stim: OFF','Stim: ON','Mixed','Unknown'};
    explode=[1 1 1 1];
    pie(X,explode)
    % Create legend
    lgd = legend(labels);
    lgd.Location = 'northeastout';
    ay.Position=[0.4300 0.5838 0.4792 0.3412];
    ax=subplot(2,1,2);
    annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
        [num2str(TotalSoff),' / ', num2str(TotalSigs),' signals are with Stim: OFF.'])
    annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
        [num2str(TotalSon),' / ', num2str(TotalSigs),' signals are with Stim: ON.'])
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalMixed),' / ', num2str(TotalSigs),' signals are with mixed Stim states.'])
    annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
        [num2str(TotalUnknown),' / ', num2str(TotalSigs),' signals have unspecified Stim status.'])
end
ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'SignalsStim_Distribution.jpg'])
savefig([SavingPath,'SignalsStim_Distribution.fig'])
close 
%% To evalaute medication and stimulation statistics:
% How many STN LFPs are recorded during medication and stimulation on/off states
% and mixed and unknown; in what percentage and draw a pie diagram
MoffSoff_sheet=zeros(1,sheetnum);   %To count MedOff-StimOff per each sheet
MoffSon_sheet=zeros(1,sheetnum); %To count MedOff-StimOn per each sheet
MonSon_sheet=zeros(1,sheetnum);  %To count MedOn-StimOn per each sheet
MonSoff_sheet=zeros(1,sheetnum); %To count MedOn-StimOff per each sheet
unknown_sheet=zeros(1,sheetnum); %To count unknown states per each sheet
mixed_sheet=zeros(1,sheetnum); %To count mixed states od Med and/or Stim per each sheet
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN') %check if signal type exists and is STN LFP
                TotalSigs=TotalSigs+1;
            if ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: off, stim: off
                disp([MT.FileName{i,1}, ': Medication is off, Stimulation is off'])
                MoffSoff_sheet(1,j)=MoffSoff_sheet(1,j)+1;
            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: off, stim: on
                disp([MT.FileName{i,1}, ': Medication is off, Stimulation is on'])
                MoffSon_sheet(1,j)=MoffSon_sheet(1,j)+1;
            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: on, stim: on
                disp([MT.FileName{i,1}, ': Medication is on, Stimulation is on'])
                MonSon_sheet(1,j)=MonSon_sheet(1,j)+1;
            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: on, stim: off
                disp([MT.FileName{i,1}, ': Medication is on, Stimulation is off'])
                MonSoff_sheet(1,j)=MonSoff_sheet(1,j)+1;
            elseif isempty(MT{i,16}{1,1}) || isempty(MT{i,17}{1,1}) %if Med or Stim info are not available
                disp([MT.FileName{i,1}, ': Medication or Stimulation info is (are) absent'])
                unknown_sheet(1,j)=unknown_sheet(1,j)+1;
            else
                disp([MT.FileName{i,1}, ': Mixed on-off state of either/both Medication and Stimulation'])
                mixed_sheet(1,j)=mixed_sheet(1,j)+1;
            end
        end
    end
    disp(['There are ',  num2str(MoffSoff_sheet(1,j)), ' signals with Med OFF and Stim OFF, ',...
        num2str(MoffSon_sheet(1,j)), ' signals with Med OFF and Stim ON, ',...
        num2str(MonSon_sheet(1,j)), ' signals with Med ON and Stim ON, ',...
        num2str(MonSoff_sheet(1,j)), ' signals with Med ON and Stim OFF, ',...
        num2str(mixed_sheet(1,j)), ' signals with mixed states and ',...
        num2str(unknown_sheet(1,j)), ' signals with unknown medication and/or stimlation status in ',sheets{j}])
end

TotalMoffSoff=sum(MoffSoff_sheet); TotalMoffSon=sum(MoffSon_sheet);
TotalMonSon=sum(MonSon_sheet); TotalMonSoff=sum(MonSoff_sheet);
TotalUnknown=sum(unknown_sheet); TotalMixed=sum(mixed_sheet);

TMoffSoffpercent=(TotalMoffSoff/TotalSigs)*100; TMoffSonpercent=(TotalMoffSon/TotalSigs)*100;
TMonSonpercent=(TotalMonSon/TotalSigs)*100; TMonSoffpercent=(TotalMonSoff/TotalSigs)*100;
TUpercent=(TotalUnknown/TotalSigs)*100; TMpercent=(TotalMixed/TotalSigs)*100;

disp(['There are ',  num2str(TotalMoffSoff), ' signals with Med OFF and Stim OFF, ',...
    num2str(TotalMoffSon), ' signals with Med OFF and Stim ON, ',...
    num2str(TotalMonSon), ' signals with Med ON and Stim ON, ',...
    num2str(TotalMonSoff), ' signals with Med ON and Stim OFF, ',...
    num2str(TotalMixed), ' signals with mixed states and ',...
    num2str(TotalUnknown), ' signals with unknown medication and/or stimlation status in the data bank.'])
disp(['In other words ',num2str(TMoffSoffpercent),'% of the signals are from Medicatoin off and Stimulation off status',...
    num2str(TMoffSonpercent),'% of the signals are from Medicatoin off and Stimulation on status',...
    num2str(TMonSonpercent),'% of the signals are from Medicatoin off and Stimulation on status',...
    num2str(TMonSoffpercent),'% of the signals are from Medicatoin on and Stimulation off status,',...
    num2str(TMpercent),'% of the signals are with mixed status and',...
    num2str(TUpercent),'% of the signals are with unknown Medication and/or Stimulation status in the data bank.'])

if TUpercent==0
    figure;
    ay=subplot(2,1,1);
    X = [TMoffSoffpercent TMoffSonpercent TMonSonpercent TMonSoffpercent TMpercent];
    labels = {'Med: OFF, Stim: OFF','Med: OFF, Stim: ON','Med: ON, Stim: ON','Med: ON, Stim: OFF','Mixed'};
    explode=[1 1 1 1 1];
    pie(X,explode)
    % Create legend
    lgd = legend(labels);
    lgd.Location = 'northeastout';
    ay.Position=[0.4300 0.5838 0.4792 0.3412];
    ax=subplot(2,1,2);
    annotation('textbox', [0.2, 0.5, 0.1, 0.1], 'String',...
        [num2str(TotalMoffSoff),' / ', num2str(TotalSigs),' STN LFPs are with Med: OFF and Stim: OFF.'])
    annotation('textbox', [0.2, 0.4, 0.1, 0.1], 'String',...
        [num2str(TotalMoffSon),' / ', num2str(TotalSigs),' STN LFPs are with Med: OFF and Stim: ON.'])
    annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
        [num2str(TotalMonSon),' / ', num2str(TotalSigs),' STN LFPs are with Med: ON and Stim: ON.'])
    annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
        [num2str(TotalMonSoff),' / ', num2str(TotalSigs),' STN LFPs are with Med: ON and Stim: OFF.'])
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalMixed),' / ', num2str(TotalSigs),' STN LFPs are with mixed Med and Stim states.'])
else
    figure;
    ay=subplot(2,1,1);
    X = [TMoffSoffpercent TMoffSonpercent TMonSonpercent TMonSoffpercent TMpercent TUpercent];
    labels = {'Med: OFF, Stim: OFF','Med: OFF, Stim: ON','Med: ON, Stim: ON','Med: ON, Stim: OFF','Mixed','Unknown'};
    explode=[1 1 1 1 1 1];
    pie(X,explode)
    % Create legend
    lgd = legend(labels);
    lgd.Location = 'northeastout';
    ay.Position=[0.4300 0.5838 0.4792 0.3412];
    ax=subplot(2,1,2);
    annotation('textbox', [0.2, 0.5, 0.1, 0.1], 'String',...
        [num2str(TotalMoffSoff),' / ', num2str(TotalSigs),' STN LFPs are with Med: OFF and Stim: OFF.'])
    annotation('textbox', [0.2, 0.4, 0.1, 0.1], 'String',...
        [num2str(TotalMoffSon),' / ', num2str(TotalSigs),' STN LFPs are with Med: OFF and Stim: ON.'])
    annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
        [num2str(TotalMonSon),' / ', num2str(TotalSigs),' STN LFPs are with Med: ON and Stim: ON.'])
    annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
        [num2str(TotalMonSoff),' / ', num2str(TotalSigs),' STN LFPs are with Med: ON and Stim: OFF.'])
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalMixed),' / ', num2str(TotalSigs),' STN LFPs are with mixed Med and Stim states.'])
    annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
        [num2str(TotalUnknown),' / ', num2str(TotalSigs),' STN LFPs have unspecified Med and/or Stim status.'])
end
ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'STN_LFPsMedStim_Distribution.jpg'])
savefig([SavingPath,'STN_LFPsMedStim_Distribution.fig'])
close 
%% med off/on STN LFP signals> check medication status only on STN LFPS
Moff_sheet=zeros(1,sheetnum);%To count MedOff per each sheet
Mon_sheet=zeros(1,sheetnum);  %To count MedOn per each sheet
unknown_sheet=zeros(1,sheetnum); %To count unknown states per each sheet
mixed_sheet=zeros(1,sheetnum);   %To count mixed states of Med per each sheet
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if signal type exists and is STN LFP
                TotalSigs=TotalSigs+1;           
            if ~isempty(MT{i,16}{1,1}) && isequal(MT{i,16}{1,1},'off')  %check if med info exists and med: off
                disp([MT.FileName{i,1}, ': Medication is off'])
                Moff_sheet(1,j)=Moff_sheet(1,j)+1;
            elseif ~isempty(MT{i,16}{1,1}) && isequal(MT{i,16}{1,1},'on')  %check if med exists and med: on
                disp([MT.FileName{i,1}, ': Medication is on'])
                Mon_sheet(1,j)=Mon_sheet(1,j)+1;
            elseif isempty(MT{i,16}{1,1}) %if Med info is not available
                disp([MT.FileName{i,1}, ': Medication info is absent'])
                unknown_sheet(1,j)=unknown_sheet(1,j)+1;
            else
                disp([MT.FileName{i,1}, ': Mixed on-off state of Medication'])
                mixed_sheet(1,j)=mixed_sheet(1,j)+1;
            end
        end
    end
    disp(['There are ',  num2str(Moff_sheet(1,j)), ' signals with Med OFF, ',...
        num2str(Mon_sheet(1,j)), ' signals with Med ON, ',...
        num2str(mixed_sheet(1,j)), ' signals with mixed states and ',...
        num2str(unknown_sheet(1,j)), ' signals with unknown medication status in ',sheets{j}])
end

TotalMoff=sum(Moff_sheet);TotalMon=sum(Mon_sheet);
TotalUnknown=sum(unknown_sheet); TotalMixed=sum(mixed_sheet);

TMoffpercent=(TotalMoff/TotalSigs)*100; TMonpercent=(TotalMon/TotalSigs)*100;
TUpercent=(TotalUnknown/TotalSigs)*100; TMpercent=(TotalMixed/TotalSigs)*100;

disp(['There are ',  num2str(TotalMoff), ' signals with Med OFF, ',...
    num2str(TotalMon), ' signals with Med ON, ',...
    num2str(TotalMixed), ' signals with mixed states and ',...
    num2str(TotalUnknown), ' signals with unknown medication status in the data bank.'])
disp(['In other words ',num2str(TMoffpercent),'% of the signals are from Medicatoin off',...
    num2str(TMonpercent),'% of the signals are from Medicatoin on status',...
    num2str(TMpercent),'% of the signals are with mixed status and',...
    num2str(TUpercent),'% of the signals are with unknown Medication status in the data bank.'])

if TUpercent==0
    figure;
    ay=subplot(2,1,1);
    X = [TMoffpercent TMonpercent TMpercent];
    labels = {'Med: OFF','Med: ON','Mixed'};
    explode=[1 1 1];
    pie(X,explode)
    % Create legend
    lgd = legend(labels);
    lgd.Location = 'northeastout';
    ay.Position=[0.4300 0.5838 0.4792 0.3412];
    ax=subplot(2,1,2);
    annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
        [num2str(TotalMoff),' / ', num2str(TotalSigs),' signals are with Med: OFF.'])
    annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
        [num2str(TotalMon),' / ', num2str(TotalSigs),' signals are with Med: ON.'])
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalMixed),' / ', num2str(TotalSigs),' signals are with mixed Med states.'])
else
    figure;
    ay=subplot(2,1,1);
    X = [TMoffpercent TMonpercent TMpercent TUpercent];
    labels = {'Med: OFF','Med: ON','Mixed','Unknown'};
    explode=[1 1 1 1];
    pie(X,explode)
    % Create legend
    lgd = legend(labels);
    lgd.Location = 'northeastout';
    ay.Position=[0.4300 0.5838 0.4792 0.3412];
    ax=subplot(2,1,2);
    annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
        [num2str(TotalMoff),' / ', num2str(TotalSigs),' signals are with Med: OFF.'])
    annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
        [num2str(TotalMon),' / ', num2str(TotalSigs),' signals are with Med: ON.'])
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalMixed),' / ', num2str(TotalSigs),' signals are with mixed Med states.'])
    annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
        [num2str(TotalUnknown),' / ', num2str(TotalSigs),' signals have unspecified Med status.'])
end
ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'STN_LFPsMed_Distribution.jpg'])
savefig([SavingPath,'STN_LFPsMed_Distribution.fig'])
close

%% stim on/off STN LFP signals> check stimulation status only on STN LFPs
Soff_sheet=zeros(1,sheetnum);%To count StimOff per each sheet
Son_sheet=zeros(1,sheetnum);  %To count StimOn per each sheet
unknown_sheet=zeros(1,sheetnum); %To count unknown states per each sheet
mixed_sheet=zeros(1,sheetnum);   %To count mixed states of Med per each sheet
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if signal type exists and is STN LFP
                TotalSigs=TotalSigs+1;
            if ~isempty(MT{i,17}{1,1}) && isequal(MT{i,17}{1,1},'off')  %check if stim info exists and med: off
                disp([MT.FileName{i,1}, ': Stimulation is off'])
                Soff_sheet(1,j)=Soff_sheet(1,j)+1;
            elseif ~isempty(MT{i,17}{1,1}) && isequal(MT{i,17}{1,1},'on')  %check if stim exists and med: on
                disp([MT.FileName{i,1}, ': Stimulation is on'])
                Son_sheet(1,j)=Son_sheet(1,j)+1;
            elseif isempty(MT{i,17}{1,1}) %if stim info is not available
                disp([MT.FileName{i,1}, ': Stimulation info is absent'])
                unknown_sheet(1,j)=unknown_sheet(1,j)+1;
            else
                disp([MT.FileName{i,1}, ': Mixed on-off state of Stimulation'])
                mixed_sheet(1,j)=mixed_sheet(1,j)+1;
            end
        end
    end
    disp(['There are ',  num2str(Soff_sheet(1,j)), ' signals with Stim OFF, ',...
        num2str(Son_sheet(1,j)), ' signals with Stim ON, ',...
        num2str(mixed_sheet(1,j)), ' signals with mixed states and ',...
        num2str(unknown_sheet(1,j)), ' signals with unknown Stimulation status in ',sheets{j}])
end

TotalSoff=sum(Soff_sheet);TotalSon=sum(Son_sheet);
TotalUnknown=sum(unknown_sheet); TotalMixed=sum(mixed_sheet);

TSoffpercent=(TotalSoff/TotalSigs)*100; TSonpercent=(TotalSon/TotalSigs)*100;
TUpercent=(TotalUnknown/TotalSigs)*100; TMpercent=(TotalMixed/TotalSigs)*100;

disp(['There are ',  num2str(TotalSoff), ' signals with Stim OFF, ',...
    num2str(TotalSon), ' signals with Stim ON, ',...
    num2str(TotalMixed), ' signals with mixed states and ',...
    num2str(TotalUnknown), ' signals with unknown stimulation status in the data bank.'])
disp(['In other words ',num2str(TSoffpercent),'% of the signals are from Stimulation off ',...
    num2str(TSonpercent),'% of the signals are from Stimulation on status ',...
    num2str(TMpercent),'% of the signals are with mixed status and ',...
    num2str(TUpercent),'% of the signals are with unknown Stimulation status in the data bank.'])

if TUpercent==0
    figure;
    ay=subplot(2,1,1);
    X = [TSoffpercent TSonpercent TMpercent];
    labels = {'Stim: OFF','Stim: ON','Mixed'};
    explode=[1 1 1];
    pie(X,explode)
    % Create legend
    lgd = legend(labels);
    lgd.Location = 'northeastout';
    ay.Position=[0.4300 0.5838 0.4792 0.3412];
    ax=subplot(2,1,2);
    annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
        [num2str(TotalSoff),' / ', num2str(TotalSigs),' signals are with Stim: OFF.'])
    annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
        [num2str(TotalSon),' / ', num2str(TotalSigs),' signals are with Stim: ON.'])
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalMixed),' / ', num2str(TotalSigs),' signals are with mixed Stim states.'])
else
    figure;
    ay=subplot(2,1,1);
    X = [TSoffpercent TSonpercent TMpercent TUpercent];
    labels = {'Stim: OFF','Stim: ON','Mixed','Unknown'};
    explode=[1 1 1 1];
    pie(X,explode)
    % Create legend
    lgd = legend(labels);
    lgd.Location = 'northeastout';
    ay.Position=[0.4300 0.5838 0.4792 0.3412];
    ax=subplot(2,1,2);
    annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
        [num2str(TotalSoff),' / ', num2str(TotalSigs),' signals are with Stim: OFF.'])
    annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
        [num2str(TotalSon),' / ', num2str(TotalSigs),' signals are with Stim: ON.'])
    annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
        [num2str(TotalMixed),' / ', num2str(TotalSigs),' signals are with mixed Stim states.'])
    annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
        [num2str(TotalUnknown),' / ', num2str(TotalSigs),' signals have unspecified Stim status.'])
end
ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'STN_LFPsStim_Distribution.jpg'])
savefig([SavingPath,'STN_LFPsStim_Distribution.fig'])
close

%% To compute the beta power of LFP signals in on/off medication and stimulation
% %  > Box plots
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if MT.SignalDuration_s(i)>=10 %Evaluate beta power for signals longer than 10 seconds
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if Fs exists and it is STN LFP
                && ~isnan(MT.SignalFs(i)) 
            
           TotalSigs=TotalSigs+1;
           
            if ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: off, stim: off
                
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,1)=read_PSD_betaPower(filepath_name,unit);                  
                disp([MT.FileName{i,1}, ': Medication is off, Stimulation is off. The beta power is ',num2str(B(TotalSigs,1)),' (microV^2/Hz).'])
              
            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: off, stim: on
                
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,2)=read_PSD_betaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is off, Stimulation is on. The beta power is ',num2str(B(TotalSigs,2)),' (microV^2/Hz).'])

            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: on, stim: on

                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,3)=read_PSD_betaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is on, Stimulation is on. The beta power is ',num2str(B(TotalSigs,3)),' (microV^2/Hz).'])

            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: on, stim: off

                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,4)=read_PSD_betaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is on, Stimulation is off. The beta power is ',num2str(B(TotalSigs,4)),' (microV^2/Hz).'])

            end
        end
        end
    end
end

%Remove the zeros:
BP1=B(B(:,1)~=0,1); BP2=B(B(:,2)~=0,2); BP3=B(B(:,3)~=0,3); BP4=B(B(:,4)~=0,4);
BP=[BP1; BP2; BP3; BP4];
g1 = repmat({['Med OFF - Stim OFF (',num2str(length(BP1)),' signals)']},length(BP1),1);
g2 = repmat({['Med OFF - Stim ON (',num2str(length(BP2)),' signals)']},length(BP2),1);
g3 = repmat({['Med ON - Stim ON (',num2str(length(BP3)),' signals)']},length(BP3),1);
g4 = repmat({['Med ON - Stim OFF (',num2str(length(BP4)),' signals)']},length(BP4),1);
g = [g1; g2; g3; g4];

figure; title('Distribution of STN LFP beta power among different MED and STIM states'); hold on
boxplot(BP,g)
ylim([0 7])
ylabel('Beta power (\muV^2/Hz)')
set(gcf,'WindowState','maximized')

savefig([SavingPath,'BetaPower_Med_Stim.fig'])
saveas(gcf,[SavingPath,'BetaPower_Med_Stim.jpg'])
close

%% To compute the low-beta power of LFP signals in on/off medication and stimulation
% % >Box Plots
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if MT.SignalDuration_s(i)>=10 %Evaluate beta power for signals longer than 10 seconds
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if Fs exists and it is STN LFP
                && ~isnan(MT.SignalFs(i)) 
            
           TotalSigs=TotalSigs+1;
           
            if ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: off, stim: off
                
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,1)=read_PSD_LowBetaPower(filepath_name,unit);                  
                disp([MT.FileName{i,1}, ': Medication is off, Stimulation is off. The beta power is ',num2str(B(TotalSigs,1)),' (microV^2/Hz).'])
              
            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: off, stim: on
                
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,2)=read_PSD_LowBetaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is off, Stimulation is on. The beta power is ',num2str(B(TotalSigs,2)),' (microV^2/Hz).'])

            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: on, stim: on

                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,3)=read_PSD_LowBetaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is on, Stimulation is on. The beta power is ',num2str(B(TotalSigs,3)),' (microV^2/Hz).'])

            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: on, stim: off

                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,4)=read_PSD_LowBetaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is on, Stimulation is off. The beta power is ',num2str(B(TotalSigs,4)),' (microV^2/Hz).'])

            end
        end
        end
    end
end

%Remove the zeros:
BP1=B(B(:,1)~=0,1); BP2=B(B(:,2)~=0,2); BP3=B(B(:,3)~=0,3); BP4=B(B(:,4)~=0,4);
BP=[BP1; BP2; BP3; BP4];
g1 = repmat({['Med OFF - Stim OFF (',num2str(length(BP1)),' signals)']},length(BP1),1);
g2 = repmat({['Med OFF - Stim ON (',num2str(length(BP2)),' signals)']},length(BP2),1);
g3 = repmat({['Med ON - Stim ON (',num2str(length(BP3)),' signals)']},length(BP3),1);
g4 = repmat({['Med ON - Stim OFF (',num2str(length(BP4)),' signals)']},length(BP4),1);
g = [g1; g2; g3; g4];

figure; title('Distribution of STN LFP low-beta power among different MED and STIM states'); hold on
boxplot(BP,g)
ylim([0 7])
ylabel('Low-Beta power (\muV^2/Hz)')
set(gcf,'WindowState','maximized')

savefig([SavingPath,'LowBetaPower_Med_Stim.fig'])
saveas(gcf,[SavingPath,'LowBetaPower_Med_Stim.jpg'])
close

%% To compute the high-beta power of LFP signals in on/off medication and stimulation
% % >box plots
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if MT.SignalDuration_s(i)>=10 %Evaluate beta power for signals longer than 10 seconds
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if Fs exists and it is STN LFP
                && ~isnan(MT.SignalFs(i)) 
            
           TotalSigs=TotalSigs+1;
           
            if ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: off, stim: off
                
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,1)=read_PSD_HighBetaPower(filepath_name,unit);                  
                disp([MT.FileName{i,1}, ': Medication is off, Stimulation is off. The beta power is ',num2str(B(TotalSigs,1)),' (microV^2/Hz).'])
              
            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: off, stim: on
                
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,2)=read_PSD_HighBetaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is off, Stimulation is on. The beta power is ',num2str(B(TotalSigs,2)),' (microV^2/Hz).'])

            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'on') %check if med and stim info exist and med: on, stim: on

                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,3)=read_PSD_HighBetaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is on, Stimulation is on. The beta power is ',num2str(B(TotalSigs,3)),' (microV^2/Hz).'])

            elseif ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'on') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: on, stim: off

                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,4)=read_PSD_HighBetaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': Medication is on, Stimulation is off. The beta power is ',num2str(B(TotalSigs,4)),' (microV^2/Hz).'])

            end
        end
        end
    end
end

%Remove the zeros:
BP1=B(B(:,1)~=0,1); BP2=B(B(:,2)~=0,2); BP3=B(B(:,3)~=0,3); BP4=B(B(:,4)~=0,4);
BP=[BP1; BP2; BP3; BP4];
g1 = repmat({['Med OFF - Stim OFF (',num2str(length(BP1)),' signals)']},length(BP1),1);
g2 = repmat({['Med OFF - Stim ON (',num2str(length(BP2)),' signals)']},length(BP2),1);
g3 = repmat({['Med ON - Stim ON (',num2str(length(BP3)),' signals)']},length(BP3),1);
g4 = repmat({['Med ON - Stim OFF (',num2str(length(BP4)),' signals)']},length(BP4),1);
g = [g1; g2; g3; g4];

figure; title('Distribution of STN LFP high-beta power among different MED and STIM states'); hold on
boxplot(BP,g)
ylim([0 7])
ylabel('High-Beta power (\muV^2/Hz)')
set(gcf,'WindowState','maximized')

savefig([SavingPath,'HighBetaPower_Med_Stim.fig'])
saveas(gcf,[SavingPath,'HighBetaPower_Med_Stim.jpg'])
close
%% During Med off Stim off find the beta power distribution among genders > Box pltos
TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if MT.SignalDuration_s(i)>=10 %Evaluate beta power for signals longer than 10 seconds
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if Fs exists and it is STN LFP
           && ~isnan(MT.SignalFs(i))...
           && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: off, stim: off
           
           TotalSigs=TotalSigs+1;    
           
           if isequal(MT.SubjectGender{i},'M')
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,1)=read_PSD_betaPower(filepath_name,unit);                  
                disp([MT.FileName{i,1}, ': is Male. The beta power is ',num2str(B(TotalSigs,1)),' (microV^2/Hz).'])
              
            elseif isequal(MT.SubjectGender{i},'F')
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,2)=read_PSD_betaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': is Female. The beta power is ',num2str(B(TotalSigs,2)),' (microV^2/Hz).'])

            end
        end
        end
    end
end

%Remove the zeros:
BP1=B(B(:,1)~=0,1); BP2=B(B(:,2)~=0,2);
BP=[BP1; BP2];
g1 = repmat({['Male (',num2str(length(BP1)),' signals)']},length(BP1),1);
g2 = repmat({['Female (',num2str(length(BP2)),' signals)']},length(BP2),1);
g = [g1; g2];

figure; title('Distribution of STN LFP beta power among genders during Med OFF - Stim OFF'); hold on
boxplot(BP,g)
ylim([0 15])
ylabel('Beta power (\muV^2/Hz)')
set(gcf,'WindowState','maximized')

savefig([SavingPath,'BetaPower_Gender_MedOffStimOff.fig'])
saveas(gcf,[SavingPath,'BetaPower_Gender_MedOffStimOff.jpg'])
close
%% Evaluate low beta power among genders during Med Off Stim Off >Box plots

TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if MT.SignalDuration_s(i)>=10 %Evaluate beta power for signals longer than 10 seconds
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if Fs exists and it is STN LFP
           && ~isnan(MT.SignalFs(i))...
           && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: off, stim: off
           
           TotalSigs=TotalSigs+1;    
           
           if isequal(MT.SubjectGender{i},'M')
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,1)=read_PSD_LowBetaPower(filepath_name,unit);                  
                disp([MT.FileName{i,1}, ': is Male. The beta power is ',num2str(B(TotalSigs,1)),' (microV^2/Hz).'])
              
            elseif isequal(MT.SubjectGender{i},'F')
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,2)=read_PSD_LowBetaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': is Female. The beta power is ',num2str(B(TotalSigs,2)),' (microV^2/Hz).'])

            end
        end
        end
    end
end

%Remove the zeros:
BP1=B(B(:,1)~=0,1); BP2=B(B(:,2)~=0,2);
BP=[BP1; BP2];
g1 = repmat({['Male (',num2str(length(BP1)),' signals)']},length(BP1),1);
g2 = repmat({['Female (',num2str(length(BP2)),' signals)']},length(BP2),1);
g = [g1; g2];

figure; title('Distribution of STN LFP low-beta power among genders during Med OFF - Stim OFF'); hold on
boxplot(BP,g)
ylim([0 10])
ylabel('Low-Beta power (\muV^2/Hz)')
set(gcf,'WindowState','maximized')

savefig([SavingPath,'LowBetaPower_Gender_MedOffStimOff.fig'])
saveas(gcf,[SavingPath,'LowBetaPower_Gender_MedOffStimOff.jpg'])
close

%% Evaluate high beta power and the distribution of genders during Med Off Stim Off >Box plots

TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if MT.SignalDuration_s(i)>=10 %Evaluate beta power for signals longer than 10 seconds
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if Fs exists and it is STN LFP
           && ~isnan(MT.SignalFs(i))...
           && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off') %check if med and stim info exist and med: off, stim: off
           
           TotalSigs=TotalSigs+1;    
           
           if isequal(MT.SubjectGender{i},'M')
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,1)=read_PSD_HighBetaPower(filepath_name,unit);                  
                disp([MT.FileName{i,1}, ': is Male. The beta power is ',num2str(B(TotalSigs,1)),' (microV^2/Hz).'])
              
            elseif isequal(MT.SubjectGender{i},'F')
                filename=MT.FileName{i}; %to compute the beta power of this signal
                filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                unit=str2double(MT.SignalUnit{i}(1:end-2));
                B(TotalSigs,2)=read_PSD_HighBetaPower(filepath_name,unit);   
                disp([MT.FileName{i,1}, ': is Female. The beta power is ',num2str(B(TotalSigs,2)),' (microV^2/Hz).'])

            end
        end
        end
    end
end

%Remove the zeros:
BP1=B(B(:,1)~=0,1); BP2=B(B(:,2)~=0,2);
BP=[BP1; BP2];
g1 = repmat({['Male (',num2str(length(BP1)),' signals)']},length(BP1),1);
g2 = repmat({['Female (',num2str(length(BP2)),' signals)']},length(BP2),1);
g = [g1; g2];

figure; title('Distribution of STN LFP high-beta power among genders during Med OFF - Stim OFF'); hold on
boxplot(BP,g)
ylim([0 10])
ylabel('High-Beta power (\muV^2/Hz)')
set(gcf,'WindowState','maximized')

savefig([SavingPath,'HighBetaPower_Gender_MedOffStimOff.fig'])
saveas(gcf,[SavingPath,'HighBetaPower_Gender_MedOffStimOff.jpg'])
close

%% To evalaute AGE statistics: How many subjects are within specific age range and
%%unknown, in what percentage, draw a pie diagram
belowThirty_sheet=zeros(1,sheetnum);   %To count under 30s per each sheet
ThirtyFourty_sheet=zeros(1,sheetnum); %To count 30-40s per each sheet
FourtyFifty_sheet=zeros(1,sheetnum); %To count 40-50s per each sheet
FiftySixty_sheet=zeros(1,sheetnum); %To count 50-60s per each sheet
SixtySeventy_sheet=zeros(1,sheetnum); %To count 60-70s per each sheet
SeventyEighty_sheet=zeros(1,sheetnum); %To count 70-80s per each sheet
EightyNinty_sheet=zeros(1,sheetnum); %To count 80-90s per each sheet
aboveNinty_sheet=zeros(1,sheetnum); %To count above 90s per each sheet
Unknown_sheet=zeros(1,sheetnum); %To count unknown ages per each sheet
PID='PID0000';

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if contains(PID,MT{i,2}{1,1}) %skip repeated patients
            continue
        else
            if ~isempty(MT{i,9}{1,1}) && ~isempty(MT.RecordingDate{i}) && ~isequal(MT.RecordingDate{i},'00-00-0000')%check if DoB and date of recording exist
                dob=MT.SubjectDoB{i}; yob=dob(7:end); dor=MT.RecordingDate{i}; yor=dor(7:end); age=str2double(yor)-str2double(yob); %detrmine the age of the patient at the time of recording
                if lt(age,30) %If age is below 30
                    disp([MT.PatientID{i,1}, ' age is below 30'])
                    belowThirty_sheet(1,j)=belowThirty_sheet(1,j)+1;
                elseif isequal(age,30) || gt(age,30) && lt(age,40) %If age is between 30 and 40
                    disp([MT.PatientID{i,1}, ' age is between 30-40'])
                    ThirtyFourty_sheet(1,j)=ThirtyFourty_sheet(1,j)+1;
                elseif isequal(age,40) || gt(age,40) && lt(age,50) %If age is between 40 and 50
                    disp([MT.PatientID{i,1}, ' age is between 40-50'])
                    FourtyFifty_sheet(1,j)=FourtyFifty_sheet(1,j)+1;
                elseif isequal(age,50) || gt(age,50) && lt(age,60) %If age is between 50 and 60
                    disp([MT.PatientID{i,1}, ' age is between 50-60'])
                    FiftySixty_sheet(1,j)=FiftySixty_sheet(1,j)+1;
                elseif isequal(age,60) || gt(age,60) && lt(age,70) %If age is between 60 and 70
                    disp([MT.PatientID{i,1}, ' age is between 60-70'])
                    SixtySeventy_sheet(1,j)=SixtySeventy_sheet(1,j)+1;
                elseif isequal(age,70) || gt(age,70) && lt(age,80) %If age is between 70 and 80
                    disp([MT.PatientID{i,1}, ' age is between 70-80'])
                    SeventyEighty_sheet(1,j)=SeventyEighty_sheet(1,j)+1;
                elseif isequal(age,80) || gt(age,80) && lt(age,90) %If age is between 80 and 90
                    disp([MT.PatientID{i,1}, ' age is between 80-90'])
                    EightyNinty_sheet(1,j)=EightyNinty_sheet(1,j)+1;
                elseif isequal(age,90) || gt(age,90) %If age is above 90
                    disp([MT.PatientID{i,1}, ' age is above 90'])
                    aboveNinty_sheet(1,j)=aboveNinty_sheet(1,j)+1;
                end
            elseif ~isempty(MT{i,9}{1,1}) && isequal(MT.RecordingDate{i},'00-00-0000') %check if date of recording does not exist and is in 00-00-0000 format
                disp([MT.PatientID{i,1}, ' age is not provided'])
                Unknown_sheet(1,j)=Unknown_sheet(1,j)+1;
            elseif ~isempty(MT{i,9}{1,1}) && isempty(MT.RecordingDate{i}) %check if date of recording does not exist
                disp([MT.PatientID{i,1}, ' age is not provided'])
                Unknown_sheet(1,j)=Unknown_sheet(1,j)+1;
            elseif isempty(MT{i,9}{1,1}) %check if date of birth does not exists
                disp([MT.PatientID{i,1}, ' age is not provided'])
                Unknown_sheet(1,j)=Unknown_sheet(1,j)+1;
            end
        end
        newPID=MT{i,2}{1,1};
        PID=[PID, newPID];
    end
    disp(['There are ',  num2str(belowThirty_sheet(1,j)), ' patients below 30 y.o., ',...
        num2str(ThirtyFourty_sheet(1,j)), ' patients between 30 and 40 y.o., ',...
        num2str(FourtyFifty_sheet(1,j)), ' patients between 40 and 50 y.o., ',...
        num2str(FiftySixty_sheet(1,j)), ' patients between 50 and 60 y.o., ',...
        num2str(SixtySeventy_sheet(1,j)), ' patients between 60 and 70 y.o., ',...
        num2str(SeventyEighty_sheet(1,j)), ' patients between 70 and 80 y.o., ',...
        num2str(EightyNinty_sheet(1,j)), ' patients between 80 and 90 y.o., ',...
        num2str(aboveNinty_sheet(1,j)), ' patients above 90 y.o. and ',...
        num2str(Unknown_sheet(1,j)), ' patients with missing age info in ',sheets{j}])
end

TotalBthirty=sum(belowThirty_sheet); TotalTF=sum(ThirtyFourty_sheet); TotalFF=sum(FourtyFifty_sheet);
TotalFS=sum(FiftySixty_sheet); TotalSS=sum(SixtySeventy_sheet); TotalSE=sum(SeventyEighty_sheet);
TotalEN=sum(EightyNinty_sheet); TotalAninty=sum(aboveNinty_sheet);TotalUnknown=sum(Unknown_sheet);
TotalSubs=TotalBthirty+TotalTF+TotalFF+TotalFS+TotalSS+TotalSE+TotalEN+TotalAninty+TotalUnknown;
TbTpercent=(TotalBthirty/TotalSubs)*100; TTFpercent=(TotalTF/TotalSubs)*100; TFFpercent=(TotalFF/TotalSubs)*100;
TFSpercent=(TotalFS/TotalSubs)*100; TSSpercent=(TotalSS/TotalSubs)*100; TSEpercent=(TotalSE/TotalSubs)*100;
TENpercent=(TotalEN/TotalSubs)*100; TaNpercent=(TotalAninty/TotalSubs)*100; TUpercent=(TotalUnknown/TotalSubs)*100;

disp(['There are ',num2str(TotalBthirty),' patients below 30 y.o., ',...
    num2str(TotalTF),' patients between 30 to 40 y.o., ',...
    num2str(TotalFF),' patients between 40 to 50 y.o., ',...
    num2str(TotalFS),' patients between 50 to 60 y.o., ',...
    num2str(TotalSS),' patients between 60 to 70 y.o., ',...
    num2str(TotalSE),' patients between 70 to 80 y.o., ',...
    num2str(TotalEN),' patients between 80 to 90 y.o., ',...
    num2str(TotalAninty),' patients above 90 y.o. and ',...
    num2str(TotalUnknown),' patients with missing age info in the data bank.'])
disp(['In other words ',num2str(TbTpercent),'% of the patients are below 30 y.o., ',...
    num2str(TTFpercent),'% of the patients are between 30 to 40 y.o., ',...
    num2str(TFFpercent),'% of the patients are between 40 to 50 y.o., ',...
    num2str(TFSpercent),'% of the patients are between 50 to 60 y.o., ',...
    num2str(TSSpercent),'% of the patients are between 60 to 70 y.o., ',...
    num2str(TSEpercent),'% of the patients are between 70 to 80 y.o., ',...
    num2str(TENpercent),'% of the patients are between 80 to 90 y.o., ',...
    num2str(TaNpercent),'% of the patients are above 90 y.o. and ',...
    num2str(TUpercent),'% of the patients are with missing age info in the data bank.'])

figure;
ay=subplot(2,1,1);
X = [TbTpercent TTFpercent TFFpercent TFSpercent TSSpercent TSEpercent TENpercent TaNpercent TUpercent];
labels = {'below 30 y.o.','30-40 y.o.','40-50 y.o.','50-60 y.o.','60-70 y.o.','70-80 y.o.','80-90 y.o.','above 90 y.o.','Missing info'};
ex=[1 1 1 1 1 1 1 1 1];
pie(X,ex)
% Create legend
lgd = legend(labels);
lgd.Location = 'northeastout';
ay.Position=[0.4300 0.5838 0.4792 0.3412];
ax=subplot(2,1,2);
annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String',...
    [num2str(TotalBthirty),' / ', num2str(TotalSubs),' patients are below 30 y.o.'])
annotation('textbox', [0.2, 0.7, 0.1, 0.1], 'String',...
    [num2str(TotalTF),' / ', num2str(TotalSubs),' patients are between 30-40 y.o.'])
annotation('textbox', [0.2, 0.6, 0.1, 0.1], 'String',...
    [num2str(TotalFF),' / ', num2str(TotalSubs),' patients are between 40-50 y.o.'])
annotation('textbox', [0.2, 0.5, 0.1, 0.1], 'String',...
    [num2str(TotalFS),' / ', num2str(TotalSubs),' patients are between 50-60 y.o.'])
annotation('textbox', [0.2, 0.4, 0.1, 0.1], 'String',...
    [num2str(TotalSS),' / ', num2str(TotalSubs),' patients are between 60-70 y.o.'])
annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
    [num2str(TotalSE),' / ', num2str(TotalSubs),' patients are between 70-80 y.o.'])
annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
    [num2str(TotalEN),' / ', num2str(TotalSubs),' patients are between 80-90 y.o.'])
annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
    [num2str(TotalAninty),' / ', num2str(TotalSubs),' patients are above 90 y.o.'])
annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
    [num2str(TotalUnknown),' out of ', num2str(TotalSubs),' subjects are with unspecified age.'])

ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'PatientsAge_Distribution.jpg'])
savefig([SavingPath,'PatientsAge_Distribution.fig'])
close

%% To evalaute signal age statistics: How many STN LFP signals are from 
% patinet with specific age range and unknown, in what percentage, draw a pie diagram
belowThirty_sheet=zeros(1,sheetnum);   %To count under 30s per each sheet
ThirtyFourty_sheet=zeros(1,sheetnum); %To count 30-40s per each sheet
FourtyFifty_sheet=zeros(1,sheetnum); %To count 40-50s per each sheet
FiftySixty_sheet=zeros(1,sheetnum); %To count 50-60s per each sheet
SixtySeventy_sheet=zeros(1,sheetnum); %To count 60-70s per each sheet
SeventyEighty_sheet=zeros(1,sheetnum); %To count 70-80s per each sheet
EightyNinty_sheet=zeros(1,sheetnum); %To count 80-90s per each sheet
aboveNinty_sheet=zeros(1,sheetnum); %To count above 90s per each sheet
Unknown_sheet=zeros(1,sheetnum); %To count unknown ages per each sheet

TotalSigs=0;

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN') %check if signal type exists and is STN LFP
            TotalSigs=TotalSigs+1;
            if ~isempty(MT{i,9}{1,1}) && ~isempty(MT.RecordingDate{i}) && ~isequal(MT.RecordingDate{i},'00-00-0000')%check if DoB and date of recording exist
                dob=MT.SubjectDoB{i}; yob=dob(7:end); dor=MT.RecordingDate{i}; yor=dor(7:end); age=str2double(yor)-str2double(yob); %determine the age of the patient at the time of recording
                if lt(age,30) %If age is below 30
                    disp([MT.SignalID{i,1}, ' is recorded from a patient below 30 y.o.'])
                    belowThirty_sheet(1,j)=belowThirty_sheet(1,j)+1;
                elseif isequal(age,30) || gt(age,30) && lt(age,40) %If age is between 30 and 40
                    disp([MT.SignalID{i,1}, ' is recorded from a patient between 30-40 y.o.'])
                    ThirtyFourty_sheet(1,j)=ThirtyFourty_sheet(1,j)+1;
                elseif isequal(age,40) || gt(age,40) && lt(age,50) %If age is between 40 and 50
                    disp([MT.SignalID{i,1}, ' is recorded from a patient between 40-50 y.o.'])
                    FourtyFifty_sheet(1,j)=FourtyFifty_sheet(1,j)+1;
                elseif isequal(age,50) || gt(age,50) && lt(age,60) %If age is between 50 and 60
                    disp([MT.SignalID{i,1}, ' is recorded from a patient between 50-60 y.o.'])
                    FiftySixty_sheet(1,j)=FiftySixty_sheet(1,j)+1;
                elseif isequal(age,60) || gt(age,60) && lt(age,70) %If age is between 60 and 70
                    disp([MT.SignalID{i,1}, ' is recorded from a patient between 60-70 y.o.'])
                    SixtySeventy_sheet(1,j)=SixtySeventy_sheet(1,j)+1;
                elseif isequal(age,70) || gt(age,70) && lt(age,80) %If age is between 70 and 80
                    disp([MT.SignalID{i,1}, ' is recorded from a patient between 70-80 y.o.'])
                    SeventyEighty_sheet(1,j)=SeventyEighty_sheet(1,j)+1;
                elseif isequal(age,80) || gt(age,80) && lt(age,90) %If age is between 80 and 90
                    disp([MT.SignalID{i,1}, ' is recorded from a patient between 80-90 y.o.'])
                    EightyNinty_sheet(1,j)=EightyNinty_sheet(1,j)+1;
                elseif isequal(age,90) || gt(age,90) %If age is above 90
                    disp([MT.SignalID{i,1}, ' is recorded from a patient above 90 y.o.'])
                    aboveNinty_sheet(1,j)=aboveNinty_sheet(1,j)+1;
                end
            elseif ~isempty(MT{i,9}{1,1}) && isequal(MT.RecordingDate{i},'00-00-0000') %check if date of recording does not exist and is in 00-00-0000 format
                disp([MT.SignalID{i,1}, ' age is not provided'])
                Unknown_sheet(1,j)=Unknown_sheet(1,j)+1;
            elseif ~isempty(MT{i,9}{1,1}) && isempty(MT.RecordingDate{i}) %check if date of recording does not exist
                disp([MT.SignalID{i,1}, ' age is not provided'])
                Unknown_sheet(1,j)=Unknown_sheet(1,j)+1;
            elseif isempty(MT{i,9}{1,1}) %check if date of birth does not exists
                disp([MT.SignalID{i,1}, ' age is not provided'])
                Unknown_sheet(1,j)=Unknown_sheet(1,j)+1;
            end
        end
    end
    disp(['There are ',  num2str(belowThirty_sheet(1,j)), ' signals from patients below 30 y.o., ',...
        num2str(ThirtyFourty_sheet(1,j)), ' signals from patients between 30 and 40 y.o., ',...
        num2str(FourtyFifty_sheet(1,j)), ' signals from patients between 40 and 50 y.o., ',...
        num2str(FiftySixty_sheet(1,j)), ' signals from patients between 50 and 60 y.o., ',...
        num2str(SixtySeventy_sheet(1,j)), ' signals from patients between 60 and 70 y.o., ',...
        num2str(SeventyEighty_sheet(1,j)), ' signals from patients between 70 and 80 y.o., ',...
        num2str(EightyNinty_sheet(1,j)), ' signals from patients between 80 and 90 y.o., ',...
        num2str(aboveNinty_sheet(1,j)), ' signals from patients above 90 y.o. and ',...
        num2str(Unknown_sheet(1,j)), ' signals from patients with missing age info in ',sheets{j}])
end

TotalBthirty=sum(belowThirty_sheet); TotalTF=sum(ThirtyFourty_sheet); TotalFF=sum(FourtyFifty_sheet);
TotalFS=sum(FiftySixty_sheet); TotalSS=sum(SixtySeventy_sheet); TotalSE=sum(SeventyEighty_sheet);
TotalEN=sum(EightyNinty_sheet); TotalAninty=sum(aboveNinty_sheet);TotalUnknown=sum(Unknown_sheet);
TbTpercent=(TotalBthirty/TotalSigs)*100; TTFpercent=(TotalTF/TotalSigs)*100; TFFpercent=(TotalFF/TotalSigs)*100;
TFSpercent=(TotalFS/TotalSigs)*100; TSSpercent=(TotalSS/TotalSigs)*100; TSEpercent=(TotalSE/TotalSigs)*100;
TENpercent=(TotalEN/TotalSigs)*100; TaNpercent=(TotalAninty/TotalSigs)*100; TUpercent=(TotalUnknown/TotalSigs)*100;

disp(['There are ',num2str(TotalBthirty),' signals from patients below 30 y.o., ',...
    num2str(TotalTF),' signals from patients between 30 to 40 y.o., ',...
    num2str(TotalFF),' signals from patients between 40 to 50 y.o., ',...
    num2str(TotalFS),' signals from patients between 50 to 60 y.o., ',...
    num2str(TotalSS),' signals from patients between 60 to 70 y.o., ',...
    num2str(TotalSE),' signals from patients between 70 to 80 y.o., ',...
    num2str(TotalEN),' signals from patients between 80 to 90 y.o., ',...
    num2str(TotalAninty),' signals from patients above 90 y.o. and ',...
    num2str(TotalUnknown),' signals from patients with missing age info in the data bank.'])
disp(['In other words ',num2str(TbTpercent),'% of the signals are from below 30 y.o. patients, ',...
    num2str(TTFpercent),'% of the signals are from 30 to 40 y.o. patients, ',...
    num2str(TFFpercent),'% of the signals are from 40 to 50 y.o. pateints, ',...
    num2str(TFSpercent),'% of the signals are from 50 to 60 y.o. pateints, ',...
    num2str(TSSpercent),'% of the signals are from 60 to 70 y.o. pateints, ',...
    num2str(TSEpercent),'% of the signals are from 70 to 80 y.o. pateints, ',...
    num2str(TENpercent),'% of the signals are from 80 to 90 y.o. pateints, ',...
    num2str(TaNpercent),'% of the signals are from patients above 90 y.o. and ',...
    num2str(TUpercent),'% of the signals are with missing age info in the data bank.'])

figure;
ay=subplot(2,1,1);
X = [TbTpercent TTFpercent TFFpercent TFSpercent TSSpercent TSEpercent TENpercent TaNpercent TUpercent];
labels = {'below 30 y.o.','30-40 y.o.','40-50 y.o.','50-60 y.o.','60-70 y.o.','70-80 y.o.','80-90 y.o.','above 90 y.o.','Missing info'};
ex=[1 1 1 1 1 1 1 1 1];
pie(X,ex)
% Create legend
lgd = legend(labels);
lgd.Location = 'northeastout';
ay.Position=[0.4300 0.5838 0.4792 0.3412];
ax=subplot(2,1,2);
annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String',...
    [num2str(TotalBthirty),' / ', num2str(TotalSigs),' STN LFPs are recorded from patients below 30 y.o.'])
annotation('textbox', [0.2, 0.7, 0.1, 0.1], 'String',...
    [num2str(TotalTF),' / ', num2str(TotalSigs),' STN LFPs are recorded from patients between 30-40 y.o.'])
annotation('textbox', [0.2, 0.6, 0.1, 0.1], 'String',...
    [num2str(TotalFF),' / ', num2str(TotalSigs),' STN LFPs are recorded from patients between 40-50 y.o.'])
annotation('textbox', [0.2, 0.5, 0.1, 0.1], 'String',...
    [num2str(TotalFS),' / ', num2str(TotalSigs),' STN LFPs are recorded from patients between 50-60 y.o.'])
annotation('textbox', [0.2, 0.4, 0.1, 0.1], 'String',...
    [num2str(TotalSS),' / ', num2str(TotalSigs),' STN LFPs are recorded from patients between 60-70 y.o.'])
annotation('textbox', [0.2, 0.3, 0.1, 0.1], 'String',...
    [num2str(TotalSE),' / ', num2str(TotalSigs),' STN LFPs are recorded from patietns between 70-80 y.o.'])
annotation('textbox', [0.2, 0.2, 0.1, 0.1], 'String',...
    [num2str(TotalEN),' / ', num2str(TotalSigs),' STN LFPs are recorded from patients between 80-90 y.o.'])
annotation('textbox', [0.2, 0.1, 0.1, 0.1], 'String',...
    [num2str(TotalAninty),' / ', num2str(TotalSigs),' STN LFPs are recorded from patients above 90 y.o.'])
annotation('textbox', [0.2, 0.0, 0.1, 0.1], 'String',...
    [num2str(TotalUnknown),' out of ', num2str(TotalSigs),' STN LFPs are with unspecified age.'])

ax.Visible='off';
set(gcf,'WindowState','maximized')
saveas(gcf,[SavingPath,'STN_SignalsAge_Distribution.jpg'])
savefig([SavingPath,'STN_SignalsAge_Distribution.fig'])
close

%% To compute the beta power of STN LFP signals during off-off medication and stimulation states
% % and find the distribution within different age groups > Box plots
TotalSigs=0;
PID='PID0000';

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if contains(PID,MT{i,2}{1,1}) %skip repeated patients
            continue
        else
            if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if Fs exists and it is STN LFP
                    && ~isnan(MT.SignalFs(i)) && ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off')... %check if med and stim info exist and med: off, stim: off
                    && ~isempty(MT{i,9}{1,1}) && ~isempty(MT.RecordingDate{i}) && ~isequal(MT.RecordingDate{i},'00-00-0000')%check if DoB and date of recording exist
                dob=MT.SubjectDoB{i}; yob=dob(7:end); dor=MT.RecordingDate{i}; yor=dor(7:end); age=str2double(yor)-str2double(yob); %determine the age of the patient at the time of recording
                
                TotalSigs=TotalSigs+1;
            end
        end
            newPID=MT{i,2}{1,1};
            PID=[PID, newPID];
    end
end
BPow=zeros(TotalSigs,8); %becuase there are 8 age groups
TotalSigs=0;
PID='PID0000';

for j=1:sheetnum
    MT=readtable(MTfilepath,'Sheet',j);
    disp(['Folder: ',sheets{j}])
    for i=1:size(MT,1)-7 %-7 because there are footnote commetns on all sheets
        if contains(PID,MT{i,2}{1,1}) %skip repeated patients
            continue
        else
          if MT.SignalDuration_s(i)>=10 %Evaluate beta power for signals longer than 10 seconds
            if isequal(MT{i,11}{1,1},'LFP') && isequal(MT{i,14}{1,1},'STN')... %check if Fs exists and it is STN LFP
                    && ~isnan(MT.SignalFs(i)) && ~isempty(MT{i,16}{1,1}) && ~isempty(MT{i,17}{1,1})...
                    && isequal(MT{i,16}{1,1},'off') && isequal(MT{i,17}{1,1},'off')... %check if med and stim info exist and med: off, stim: off
                    && ~isempty(MT{i,9}{1,1}) && ~isempty(MT.RecordingDate{i}) && ~isequal(MT.RecordingDate{i},'00-00-0000')%check if DoB and date of recording exist
                dob=MT.SubjectDoB{i}; yob=dob(7:end); dor=MT.RecordingDate{i}; yor=dor(7:end); age=str2double(yor)-str2double(yob); %determine the age of the patient at the time of recording
                
                TotalSigs=TotalSigs+1;
                
                if lt(age,30) %If age is below 30
                    filename=MT.FileName{i}; %to compute the beta power of this signal
                    filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                    unit=str2double(MT.SignalUnit{i}(1:end-2));
                    BPow(TotalSigs,1)=read_PSD_betaPower(filepath_name,unit);
                    disp([MT.FileName{i,1}, ': Age is below 30. The beta power is ',num2str(BPow(TotalSigs,1)),' (microV^2/Hz).'])
                elseif isequal(age,30) || gt(age,30) && lt(age,40) %If age is between 30 and 40
                    filename=MT.FileName{i}; %to compute the beta power of this signal
                    filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                    unit=str2double(MT.SignalUnit{i}(1:end-2));
                    BPow(TotalSigs,2)=read_PSD_betaPower(filepath_name,unit);
                    disp([MT.FileName{i,1}, ': Age is between 30-40. The beta power is ',num2str(BPow(TotalSigs,2)),' (microV^2/Hz).'])
                elseif isequal(age,40) || gt(age,40) && lt(age,50)
                    filename=MT.FileName{i}; %to compute the beta power of this signal
                    filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                    unit=str2double(MT.SignalUnit{i}(1:end-2));
                    BPow(TotalSigs,3)=read_PSD_betaPower(filepath_name,unit);
                    disp([MT.FileName{i,1}, ': Age is between 40-50. The beta power is ',num2str(BPow(TotalSigs,3)),' (microV^2/Hz).'])
                elseif isequal(age,50) || gt(age,50) && lt(age,60)
                    filename=MT.FileName{i}; %to compute the beta power of this signal
                    filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                    unit=str2double(MT.SignalUnit{i}(1:end-2));
                    BPow(TotalSigs,4)=read_PSD_betaPower(filepath_name,unit);
                    disp([MT.FileName{i,1}, ': Age is between 50-60. The beta power is ',num2str(BPow(TotalSigs,4)),' (microV^2/Hz).'])
                elseif isequal(age,60) || gt(age,60) && lt(age,70)
                    filename=MT.FileName{i}; %to compute the beta power of this signal
                    filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                    unit=str2double(MT.SignalUnit{i}(1:end-2));
                    BPow(TotalSigs,5)=read_PSD_betaPower(filepath_name,unit);
                    disp([MT.FileName{i,1}, ': Age is between 60-70. The beta power is ',num2str(BPow(TotalSigs,5)),' (microV^2/Hz).'])
                elseif isequal(age,70) || gt(age,70) && lt(age,80)
                    filename=MT.FileName{i}; %to compute the beta power of this signal
                    filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                    unit=str2double(MT.SignalUnit{i}(1:end-2));
                    BPow(TotalSigs,6)=read_PSD_betaPower(filepath_name,unit);
                    disp([MT.FileName{i,1}, ': Age is between 70-80. The beta power is ',num2str(BPow(TotalSigs,6)),' (microV^2/Hz).'])
                elseif isequal(age,80) || gt(age,80) && lt(age,90)
                    filename=MT.FileName{i}; %to compute the beta power of this signal
                    filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                    unit=str2double(MT.SignalUnit{i}(1:end-2));
                    BPow(TotalSigs,7)=read_PSD_betaPower(filepath_name,unit);
                    disp([MT.FileName{i,1}, ': Age is between 80-90. The beta power is ',num2str(BPow(TotalSigs,7)),' (microV^2/Hz).'])
                elseif isequal(age,90) || gt(age,90)
                    filename=MT.FileName{i}; %to compute the beta power of this signal
                    filepath_name=(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',sheets{j},'\',filename,'.txt']);
                    unit=str2double(MT.SignalUnit{i}(1:end-2));
                    BPow(TotalSigs,8)=read_PSD_betaPower(filepath_name,unit);
                    disp([MT.FileName{i,1}, ': Age is above 90. The beta power is ',num2str(BPow(TotalSigs,8)),' (microV^2/Hz).'])
                end
            end
            newPID=MT{i,2}{1,1};
            PID=[PID, newPID];
          end
        end
    end
end

%Remove the zeros:
BP1=BPow(BPow(:,1)~=0,1); BP2=BPow(BPow(:,2)~=0,2); BP3=BPow(BPow(:,3)~=0,3); BP4=BPow(BPow(:,4)~=0,4);
BP5=BPow(BPow(:,5)~=0,5); BP6=BPow(BPow(:,6)~=0,6); BP7=BPow(BPow(:,7)~=0,7); BP8=BPow(BPow(:,8)~=0,8);

BP=[BP1; BP2; BP3; BP4; BP5; BP6; BP7; BP8];
g1 = repmat({['below 30 (',num2str(length(BP1)),' signals)']},length(BP1),1);
g2 = repmat({['30-40 (',num2str(length(BP2)),' signals)']},length(BP2),1);
g3 = repmat({['40-50 (',num2str(length(BP3)),' signals)']},length(BP3),1);
g4 = repmat({['50-60 (',num2str(length(BP4)),' signals)']},length(BP4),1);
g5 = repmat({['60-70 (',num2str(length(BP5)),' signals)']},length(BP5),1);
g6 = repmat({['70-80 (',num2str(length(BP6)),' signals)']},length(BP6),1);
g7 = repmat({['80-90 (',num2str(length(BP7)),' signals)']},length(BP7),1);
g8 = repmat({['above 90 (',num2str(length(BP8)),' signals)']},length(BP8),1);

g = [g1; g2; g3; g4; g5; g6; g7; g8];

figure; title('Distribution of STN LFP beta power among age groups, Med:Off-Stim:Off'); hold on
boxplot(BP,g)
ylim([0 20])
ylabel('Beta power (\muV^2/Hz)')

set(gcf,'WindowState','maximized')
savefig([SavingPath,'BetaPower_Age.fig'])
saveas(gcf,[SavingPath,'BetaPower_Age.jpg'])
close
