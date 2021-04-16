# WBB_NWK

# Introduction

This repository contains Matlab script codes to clean up and categorize the data set on Newronika WebBioBank. The codes can be used to clean and group any kind of biological and brain recording data bank, where big amount of data is stored and their manual selection and edit would be cumbersome. 

The matlab codes are applied on part of the WebBioBank (WBB) developed by Newronika S.p.A. This data set contains local field potential (LFP), Electroencephalographical (EEG), Electromyographical (EMG) and other types of recordings from patients with Parkinson's disease (PD) gathered over years from both male and female genders and different range of ages. The pateints were undergone deep brain stimulation (DBS) implantation surgery, by which the LFPs where recorded in different settings such as off/on DBS, off/on medication, rest/move etc.

A unique pateint ID (PID) is given to each patient name. Each signal is labeled by a signal ID (SID) that is unique. At the end, each old file is named by combining PID and SID so that the new file name is in the format of PIDxxxx_SIDxxxxx where x is an integer. 

The objective of this data management is to read the old files in the data base, which contain different foramt of saving the signals and convert them to the new files with new structure tha is just one column (need to edit this sentence).

# Metadata file

The information of each recording and subject is gathered in a metadata file as a sheet, such as in Microsoft Office Excel format. Each row presents one of our signals with the corresponding filename PIDxxxx_SIDxxxxx and the columns gather the overall information of the subject and the recorded signal.

This is a part of the metadata file:
 ![metadata](https://user-images.githubusercontent.com/39968388/114931931-308f0000-9e37-11eb-83d5-0162aee3c591.png)

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


# Converting old files to new files

All signal files a re in .txt format, either the old or the new versions. The files that contain different signals from different subjects in the old format could have different rows and columns such as:

"Time"	 "31 Keyboard"	"2 untitled"	"1 untitled"

0.0000	  0.000000

0.0004	  0.000000        0.62805      0.88745

0.0008	  0.000000        1.20544      0.90698

0.0012	  0.000000        0.89966      0.61035

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
