# WBB_NWK

# Introduction

This repository contains Matlab script codes to clean up and categorize the data on Newronika WebBioBank data base. The codes can be used to clean and group any kind of biological and brain recording data bank, where big amount of data is stored and their manual selection and edit would be cumbersome. 

The matlab codes are applied on part of the WebBioBank (WBB) developed by Newronika S.p.A. This data set contains local field potential (LFP), Electroencephalographical (EEG), Electromyographical (EMG) and other types of recordings from patients with Parkinson's disease (PD) gathered over years from both male and female genders and different range of ages. The pateints were undergone deep brain stimulation (DBS) implantation surgery, by which the LFPs where recorded in different settings such as off/on DBS, off/on medication, rest/move etc.

A unique pateint ID (PID) is given to each patient name. Each signal is labeled by a signal ID (SID) that is unique. At the end, each old file is named by combining PID and SID so that the new file name is in the format of PIDxxxx_SIDxxxxx where x is an integer. 

In the next section the organization routine is presented step-by-step.

# The cleaning pipeline and data organization routine

In this section we summarize the data management routine that we have utilized on WBB dataset. The detailed explanation of each step follows in the next sections.
One needs to follow these steps one after the other (unless otherwise is mentioned).

1-	Enter the info in the metadata file as complete as possible by referring to the old format of the files and sparse information. 
a) FileName: Add as many as the columns of the old file dictates. The old text file contains different columns. The person must open the old file and check how many of these columns are related to recorded signal at different channels. 
b) If the recording date of the signal is missing, write down 00:00:00 in RecordingDate column. 
c) The most important factors to keep the signals and provide analysis on them are sampling frequency (Fs) and type of the signal (SignalType). 
d) By checking the names, the person needs to make sure if a subject name is not repeated in previous rows and sheets, otherwise the same PID should be used. 
e) The columns called EstimatedGain, SignalDuration and SignalUnit should be left blank as they will be filled out later automatically by the Matlab scripts. 
f) If stimulation is on, try to provide info for the last three columns of the sheets which are the stimulation frequency, amplitude and pulse width. 

2-	Run FileAdaptor.m to create the new files. This code should be run once the FileName columns in the metadata file and their corresponding Fs are fixed. 

3-	Run Gainestimator.m to estimate the missing gains in the metadata file.

4-	Run SignalUnit_calc.m to evaluate signals units.

5-	Run SignalDuration_calc.m to evaluate the duration of the signals in seconds.

6-	Run JsonAdaptor.m to create corresponding json files for each new file. Note that this step can be run only if the previous steps were run already. Also note that this step can be skipped in this routine without a problem to the whole concept.

7-	Run FileCleaner.m to place the files with given Fs and SignalType in a subdirectory for further spectral and statistical analysis.

8-	Run AutomatedDataCheck.m to make a folder for each sheet of the metadata file called Diagrams and plots the signal as a time series, computes its spectrogram and Power Spectral Density (PSD) and plot them in a figure specific to the signal.

9-	Run Signal_identifier_classifier.m to classify signals under classes 1 and 2.

10-	Run SingalsStatistics.m to evaluate different statistical aspects of WBB such as pie-plots distributions and box plots.

# Metadata file

The information of each recording and subject is gathered in a metadata file as a sheet, such as in Microsoft Office Excel format. Each row presents one of our signals with the corresponding filename PIDxxxx_SIDxxxxx and the columns gather the overall information of the subject and the recorded signal.

This is a part of the metadata file:

![metadata](https://user-images.githubusercontent.com/39968388/115378818-3dae4500-a1d1-11eb-92db-c38efe509403.png)

and:

![metadata2](https://user-images.githubusercontent.com/39968388/115378856-4a329d80-a1d1-11eb-8e0f-1c6fdf2d9f67.png)


The columns in the metadata file are explained in the original written order as below:

FileName : The new file name given to the old signal in the format PIDxxxx_SIDxxxxx, e.g. PID0047_SID00446

PatientID : The unique ID for each patient that is chosed arbitrarily, howver remains the same through the whole data bank, e.g. PID0032

SignalID : The unique ID of each signal, e.g. SID00129

SourceFile : The name of the old file in the data base.

FileLocation : The location of the old file in the data base.

SubjectType : Shows the type of the subject that the signals are recorded from e.g. patient or animal etc.

SubjectName : Name of the subject, in case of patients it is the name of the patient. 

SubjectGender : The gender of the subject

SubjectDoB : Subject date of birth

SubjectCondition : The subject's pathalogy, e.g. PD

SignalType : The type of signal such as LFP, EEG, EMG etc.

SignalContent : It identifies what type of time series the data is, time series or spectral content etc. 

Activity : The tyoe of sctivity of the subject i.e. rest, move, open eyes, closed eyes etc.

BodySite : The place in the body where the signal is recorded from

Channel : Indicates the channel of the recording electrode

Medication : ON/Off; If the subject was under medication during the recording or not

Stimulation : ON/Off; If the subject was under stimulation during the recording or not

SignalUnit : Unit of the signal e.g. microvolts, milivolts etc.

Number_Column_SourceFile : This collumn is used for the data conversion code and mentiones the column in the old file where the new file is constructed on

SignalFs : Samplig frequency of the signal

SignalGain : Gain of the signal

EstimatedGain : In case the gain was not reported in the old file and corresponding data base, we estimated the gain by other evidences (see section ... below) using matlab code ... .

SignalBandWidth : Bandwidth of the recorded signal

Notch : In case notch filter was used on the original signal or not

ReecordingDate : Date of the signal recording

RecordingHour : Hour of the signal recording
 
SignalDuration_s : Duration of the signal in seconds.

Comments : Any comments needed to mention.

LinkPaper : Mentions the paper where the data has been used/analyzed etc. 

BackupFolder : The folder where the backup of the old signal exists

StimFreq : If stimulation is on, this column indicates the stimulation frequency in Hz

StimAmp : If stimulation is on, this column indicates the stimulation amplitude in microampers

StimPulseDuaration_us : If stimulation is on, this column indicates the stimulation pulse duration in microseconds. 


# Converting old files to new ones; FileAdaptor.m

The objective of this data management is to read the old files in the data base, which contain different format of saving the signals and convert them to a one-column .txt file:

"Fs= " x

V(1)

V(2)

V(3)

V(4)

.

.

.

V(end)

where x is the sampling frequency of the signal in Hz and V is the value of the signal at a given time sample.

All signal files are in .txt format, either the old or the new versions. The files that contain different signals from different subjects in the old format could have different rows and columns such as:

    "Time"	"31 Keyboard"	"2 untitled"	"1 untitled"
    0.0000	 0.000000
    0.0004	 0.000000        0.62805       0.88745
    0.0008	 0.000000        1.20544       0.90698
    0.0012	 0.000000        0.89966       0.61035


The first column contains the time in most of the cases and the other rwos contain the signals. The signals could be different types of the same subject, such as LFP and EMG or different channels of LFP recording etc. 

Another format could be like this:

    "INFORMATION"
    "Prova2.smr"
    ""    
    ""    
    "SUMMARY"    
    "1"	"Waveform"	"untitled"	" volt"	256	255.754476	1	0    
    "31"	"Marker"	"Keyboard"    
    "CHANNEL"	"1"    
    "Waveform"    
    "No comment"    
    "untitled"    
    " volt"	256    
    "START"	0.00000	0.00391   
    -0.00565   
    -0.01022   
    -0.01175    
    -0.01297

and many other formats. So far we have identified 13 types of recording formats. The matlab script FileAdaptor.m reads the metadata file and converts the old format files for these 13 cases to the new file format such as below:

"Fs= " 512

1.928736

-0.182643

0.024379

1.283741

.

.

.

-0.374178  

and names it by the unique PIDxxxx_SIDxxxxx ID so that all the information about the signal and subject can be retrieved from the metadata file. The new file will be saved in the desired destination. The frist row indicates that the sampling frequency (Fs) is 512 Hz, and the rest of the rows contain the signal values at each time sample.

# Estimate the signal gain; GainEstimator.m

In some cases the gain of the signal i.e. the value that the recording device has used to record the signal was not known. However, we know that for example deviding the value of the signal by gain for LFPs should be in microvolts order of magnitude. Also in some cases it can be guessed by other existing values of the same subject. 

GainEstimator.m reads the metadata file and wherever that the gain was not given, tries to estimate a gain based on the SignalType and writes it to the metadata sheet and save.

# Evaluate the signal unit; SignalUnit_calc.m
SignalUnit_calc.m calculates the unit of each signal summarized in the metadata file based on the given/estimated signal gain. The results will be written in the SignalUnit column of the metadata file for each corresponding signal and saved.

# Evaluate signal durations; SignalDuration_calc.m
SignalDuration_calc.m calculates the duration of each signal in the metadata file and finally adds them up to calculate the total recording time per sheet and overall.

# Creat .json from the new files; JsonAdoptor.m

For web applications such as WBB, it is extremely handy to merge every signal with the corresponding information from the metadata file in one single filein .json format. 

The code JsonAdoptor.m is a script that megres these information and save each new signal in .json format in aprallel with .txt file that already exists. The code uses the function saveAsJSON.m bBased on the work of Lior Kirsch at: https://uk.mathworks.com/matlabcentral/fileexchange/50965-structure-to-json. This code helps researchers and web developers along with bioengineers to save any signal in .txt format along with its information as a .json file using matlab. 

One output example looks like this:

![json](https://user-images.githubusercontent.com/39968388/115379804-2ae84000-a1d2-11eb-91ba-23323dbf44f7.png)

# Clean up the data set; FileCleaner.m

There where some files in the data base with no given Fs and since this property is essential for any kind of data analysis, one might want to keep only the signals with given Fs. The other essnetial property of the signal that is required for data analysis is the SignalType, which indicates if it is LFP, EEG or any other type of biosignals.

In this regard, FileCleaner.m reads the metadata file, identifies those files that have at least both Fs and SignalType reported and save them in a new folder called Clean.
The corresponding .json files will be saved in the new folder as well.

# Data Identification & Categorization; Signal_identifier_classifier.m

We have categorized the signals on WBB based on two distinct classes.

* Class-1 collects signals to different "Types":  

                                                LFP-EEG-EMG (SignalType)
                                                 |   
                                                ----------------------------(BodySite)                
                                                |                          |
                                               STN                        GPi  
                                                |
                                   ---------------------------- (SubjectGender-Medicatioin-SubjectDoB-Stimulation)
                                   |          |       |       |
                                  Gender     Med     Age     DBS
                                  (M,F)    (on/off)   |    (on/off)
                                                      |
                             ---------------------------------------------------(age range)           
                            (bleow30,30-40,40-50,50-60,60-70,70-80,80-90,above90)


The hierarchy of class-1 follows: 

                                  SignalType-> BodySite-> SubjectGender-> M or F
                                  
                                  SignalType-> BodySite-> SubjectDoB-> age range
                                  
                                  SignalType-> BodySite-> Medication-> On or Off
                                  
                                  SignalType-> BodySite-> Stimulation-> On or Off
                                                                   
Part 1 of the code Signal_identifier_classifier.m constructs folders based on class-1 algorithm, copies the files from the parent folder and pastes to the child folder.

* Class-2 collects signals to different "Patients": 

                                                  name1-name2-..._nameN (SubjectName)
                                                    |     |         |
                                                    |  the same as name1
                                                    |
                                                ----------- (SignalType)
                                                LFP-EEG-EMG
                                                 |   
                                              ---------------------------- (BodySite)               
                                              |                          |
                                             STN                        GPi  
                                              |
                                  -------------------- (Channel-Medication-Stimulation)
                                  |        |         |       
                                 Side     Med       DBS
                                (L,R)  (on/off)  (on/off) 

The hierarchy of class-2 follows: 

                                  SubjectName-> SignalType-> BodySite-> Channel-> Right or Left
                                  
                                  SubjectName-> SignalType-> BodySite-> Medication-> On or Off
                                  
                                  SubjectName-> SignalType-> BodySite-> Stimulation-> On or Off         
                                                                   
Part 2 of the code Signal_identifier_classifier.m constructs folders based on class-2 algorithm, copies the files from the parent folder and pastes to the child folder.

The code can be edited easily based on one's need and is written such that any other classification of interest could be added. 

# Run some statistics using SignalsStatistics.m

SignalsStatistics.m computes the distribution of gender, age range, signal type etc. among the signals in the data bank.
The results will be shown in differnet pie diagrams and box plots.
