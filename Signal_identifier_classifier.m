%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal_identifier_classifier.m collects the data base signals in 
% arbitrary groups explained below as in class-1 and class-2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. in 2020 
% and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars
MT=readtable('C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx','Sheet','PD_Basal');
filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\';
%% Part 1 (class-1)
%%%Class 1 collects signals to different "Types":  LFP-EEG-EMG
%                                                   |   
%                                                ----------------------------                
%                                                |                          |
%                                               STN                        GPi  
%                                                |
%                                   ----------------------------
%                                   |          |       |       |
%                                  Gender     Med     Age     DBS
%                                  (M,F)    (on/off)   |    (on/off)
%                                                      |
%                             ---------------------------------------------------           
%                            (bleow30,30-40,40-50,50-60,60-70,70-80,80-90,above90)
% 
% 
if ~exist([filepath,'Types'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal Types
end
if ~exist([filepath,'Types\','LFP'],'dir') %check if a folder exist to contain LFPs
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\ LFP
end
if ~exist([filepath,'Types\','LFP\','STN'],'dir') %check if a folder exist to contain LFPs from STN
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\ STN
end
if ~exist([filepath,'Types\','LFP\','GPi'],'dir') %check if a folder exist to contain LFPs from GPi
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\ GPi
end
if ~exist([filepath,'Types\','EEG'],'dir') %check if a folder exist to contain EEGs
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\ EEG
end
if ~exist([filepath,'Types\','EMG'],'dir') %check if a folder exist to contain EMGs
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\ EMG
end
if ~exist([filepath,'Types\LFP\STN\','Genders'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN Genders
end
if ~exist([filepath,'Types\LFP\STN\Genders\','M'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Genders M
end
if ~exist([filepath,'Types\LFP\STN\Genders\','F'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Genders F
end
if ~exist([filepath,'Types\LFP\STN\','Medication'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN Medication
end
if ~exist([filepath,'Types\LFP\STN\Medication\','On'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Medication On
end
if ~exist([filepath,'Types\LFP\STN\Medication\','Off'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Medication Off
end
if ~exist([filepath,'Types\LFP\STN\','Age'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN Age
end
if ~exist([filepath,'Types\LFP\STN\Age\','below30'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age below30
end
if ~exist([filepath,'Types\LFP\STN\Age\','30-40'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age 30-40
end
if ~exist([filepath,'Types\LFP\STN\Age\','40-50'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age 40-50
end
if ~exist([filepath,'Types\LFP\STN\Age\','50-60'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age 50-60
end
if ~exist([filepath,'Types\LFP\STN\Age\','60-70'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age 60-70
end
if ~exist([filepath,'Types\LFP\STN\Age\','70-80'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age 70-80
end
if ~exist([filepath,'Types\LFP\STN\Age\','80-90'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age 80-90
end
if ~exist([filepath,'Types\LFP\STN\Age\','above90'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age above90
end
if ~exist([filepath,'Types\LFP\STN\','DBS'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN DBS
end
if ~exist([filepath,'Types\LFP\STN\DBS\','On'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\DBS On
end
if ~exist([filepath,'Types\LFP\STN\DBS\','Off'],'dir') %check if a folder exist to contain different types of signals
mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\DBS Off
end

% xx=dir(filepath);   %Go to the new directory to find the last file
%TO DO:(expand the line above to start from the last file I worked on)


% for i=1
for i=1:size(MT,1)
    disp(MT.SignalType{i})
%%%%%Under class1, in types, collect based on the type of signal: LFP;EEG:EMG...    
    if ~isempty(MT.SignalType{i}) && isequal(MT.SignalType{i},'LFP')
        if isequal(MT.BodySite{i},'STN')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('STN LFP copied to LFP sites')
        elseif isequal(MT.BodySite{i},'GPi')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\GPi';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('GPi LFP copied to LFP sites')
        end
    end
    if ~isempty(MT.SignalType{i}) && isequal(MT.SignalType{i},'EEG')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\EEG';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('EEG copied to signal types')
    end
    if ~isempty(MT.SignalType{i}) && isequal(MT.SignalType{i},'EMG')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\EMG';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('EMG copied to signal types')
    end
%%%%%Under the same Class 1, within STN LFPs, collect based on gender: M or F
    if ~isempty(MT.SubjectGender{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.SubjectGender{i},'M')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Genders\M';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Male gender copied to STN LFP Gender')
    elseif ~isempty(MT.SubjectGender{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.SubjectGender{i},'F')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Genders\F';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Female gender copied to STN LFP Gender')
    end
%%%%%Under the same Class 1, within STN LFPs, collect based on medication: On\Off
    if ~isempty(MT.Medication{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.Medication{i},'on')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Medication\On';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Medication on copied to STN LFP Medication state')
    elseif ~isempty(MT.Medication{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.Medication{i},'off')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Medication\Off';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Medication off copied to STN LFP Medication state')
    end
%%%%%Under the same Class 1, within STN LFPs, collect based on Age range: (bleow30,30-40,40-50,50-60,60-70,70-80,80-90,above90)
    if ~isempty(MT.SubjectDoB{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') 
        dob=MT.SubjectDoB{i}; yob=dob(7:end); dor=MT.RecordingDate{i}; yor=dor(7:end); age=str2double(yor)-str2double(yob); %detrmine the age of the patient at the time of recording
        if lt(age,30)
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age\below30';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Age below 30 copied to STN LFP Age range')        
        elseif gt(age,30) && lt(age,40)
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age\30-40';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Age 30-40 copied to STN LFP Age range')
        elseif gt(age,40) && lt(age,50)
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age\40-50';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Age 40-50 copied to STN LFP Age range')
        elseif gt(age,50) && lt(age,60)
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age\50-60';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Age 50-60 copied to STN LFP Age range')
        elseif gt(age,60) && lt(age,70)
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age\60-70';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Age 60-70 copied to STN LFP Age range')
        elseif gt(age,70) && lt(age,80)
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age\70-80';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Age 70-80 copied to STN LFP Age range')
        elseif gt(age,80) && lt(age,90)
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age\80-90';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Age 80-90 copied to STN LFP Age range')        
        elseif gt(age,90)
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\Age\above90';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Age above 90 copied to STN LFP Age range')        
        end    
    end
%%%%%Under the same Class 1, within STN LFPs, collect based on DBS state: On\Off
    if ~isempty(MT.Stimulation{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.Stimulation{i},'on')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\DBS\On';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('DBS on copied to STN LFP Stimulation state')
    elseif ~isempty(MT.Stimulation{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.Stimulation{i},'off')
        new_filepath='C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Types\LFP\STN\DBS\Off';
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('DBS off copied to STN LFP Stimulation state')
    end
end
%% Part 2 (class-2)
%%%Class 2 collects signals to different "Patients": name1-name2-..._nameN
%                                                      |     |         |
%                                                      |  the same as name1
%                                                    Types
%                                                 -----------
%                                                 LFP-EEG-EMG
%                                                  |   
%                                                ----------------------------                
%                                                |                          |
%                                               STN                        GPi  
%                                                |
%                                   --------------------
%                                   |        |         |    
%                                  Side     Med       DBS
%                                  (L,R)  (on/off)  (on/off) 
% 
%
if ~exist([filepath,'Patients'],'dir') %check if a folder exist to contain different types of signals
   mkdir C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal Patients
end
% for i=1
for i=1:size(MT,1)
    disp(MT.SubjectName{i}) 
    %condition for collecting the same patient names:
    if ~isempty(MT.SubjectName{i})
        prepath=MT.SubjectName{i};
    elseif ~isempty(MT.SourceFile{i})
        prepath=MT.SourceFile{i}(1:3);
    end
if ~exist([filepath,'Patients\',prepath],'dir') %check if a folder exist to contain different types of signals
   mkdir('C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients',prepath)
end
if ~exist([filepath,'Patients\',prepath,'\LFP'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\'],'LFP')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\'],'STN')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\GPi'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\'],'GPi')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN\R'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\'],'R')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN\L'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\'],'L')
end
if ~exist([filepath,'Patients\',prepath,'\EEG'],'dir') %check if a folder exist to contain EEGs
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\'],'EEG')
end
if ~exist([filepath,'Patients\',prepath,'\EMG'],'dir') %check if a folder exist to contain EMGs
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\'],'EMG')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN\DBS'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\'],'DBS')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN\DBS\On'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\DBS\'],'On')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN\DBS\Off'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\DBS\'],'Off')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN\Medication'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\'],'Medication')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN\Medication\On'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\Medication\'],'On')
end
if ~exist([filepath,'Patients\',prepath,'\LFP\STN\Medication\Off'],'dir') %check if a folder exist to contain different types of signals
   mkdir(['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\Medication\'],'Off')
end
%%%%%Under class2, in Patients, collect based on the type of signal: LFP;EEG:EMG; in LFP collect based on the site and on the site collect in either R or L   
    if ~isempty(MT.SubjectName{i}) && isequal(MT.SignalType{i},'LFP')
        if isequal(MT.BodySite{i},'STN')
        new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN'];
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('STN LFP copied to LFP sites')
            if ~isempty(MT.Channel{i}) && isequal(MT.Channel{i}(1),'R') 
                new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\R'];
                copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
                copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
                disp('Right channel STN LFP copied to LFP channel')
            elseif ~isempty(MT.Channel{i}) && isequal(MT.Channel{i}(1),'L') 
                new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\L'];
                copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
                copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
                disp('Left channel STN LFP copied to LFP channel')
            end
        elseif isequal(MT.BodySite{i},'GPi')
        new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\GPi'];
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('GPi LFP copied to LFP sites')
        end
    end    
    if ~isempty(MT.SubjectName{i}) && isequal(MT.SignalType{i},'EEG')
        new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\EEG'];
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('EEG copied to signal names')
    end
    if ~isempty(MT.SubjectName{i}) && isequal(MT.SignalType{i},'EMG')
        new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\EMG'];
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('EMG copied to signal names')
    end
%%%%%Under the same Class 2, within STN LFPs, collect based on medication: On\Off
    if ~isempty(MT.Medication{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.Medication{i},'on')
        new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\Medication\On'];
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Medication on copied to STN LFP Medication state')
    elseif ~isempty(MT.Medication{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.Medication{i},'off')
        new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\Medication\Off'];
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('Medication off copied to STN LFP Medication state')
    end
%%%%%Under the same Class 2, within STN LFPs, collect based on DBS state: On\Off
    if ~isempty(MT.Stimulation{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.Stimulation{i},'on')
        new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\DBS\On'];
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('DBS on copied to STN LFP Stimulation state')
    elseif ~isempty(MT.Stimulation{i}) && ~isempty(MT.SignalType{i}) &&  isequal(MT.SignalType{i},'LFP')  && isequal(MT.BodySite{i},'STN') && isequal(MT.Stimulation{i},'off')
        new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\PD_Basal\Clean_PD_Basal\Patients\',prepath,'\LFP\STN\DBS\Off'];
        copyfile([filepath,MT.FileName{i},'.txt'],new_filepath)
        copyfile([filepath,MT.FileName{i},'.json'],new_filepath)
        disp('DBS off copied to STN LFP Stimulation state')
    end
end
