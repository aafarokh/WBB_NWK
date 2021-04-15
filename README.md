# WBB_NWK

# Introduction

This repository contains Matlab script codes to clean up and categorize the data set on Newronika WebBioBank. The codes can be used to clean and group any kind of biological and brain recording data bank, where big amount of data is stored and their manual selection and edit would be cumbersome. 

The matlab codes are applied on part of the WebBioBank (WBB) developed by Newronika S.p.A. This data set contains local field potential (LFP), Electroencephalographical (EEG), Electromyographical (EMG) and other types of recordings from patients with Parkinson's disease (PD) gathered over years from both male and female genders and different range of ages. The pateints were undergone deep brain stimulation (DBS) implantation surgery, by which the LFPs where recorded in different settings such as off/on DBS, off/on medication, rest/move etc.

A unique pateint ID (PID) is given to each patient name. Each signal is labeled by a signal ID (SID) that is unique. At the end, each old file is named by combining PID and SID so that the new file name is in the format of PIDxxxx_SIDxxxxx where x is an integer. 

# Metadata file

The information of each recording is gathered in a metadata file as a sheet, such as in Microsoft Office Excel format. More detail of each signal file is stored in the metadata file, where each row presents one of our signals with the corresponding filename PIDxxxx_SIDxxxxx. 

This is a part of the metadata file:
 ![metadata](https://user-images.githubusercontent.com/39968388/114931931-308f0000-9e37-11eb-83d5-0162aee3c591.png)

The columns in the metadata file are explained in the original written order as below:

FileName : The new file name given to the old signal in the format PIDxxxx_SIDxxxxx, e.g. PID0047_SID00446

PatientID : The unique ID for each patient that is chosed arbitrarily, howver remains the same through the whole data bank, e.g. PID0032

SignalID : The unique ID of each signal, e.g. SID00129

SourceFile

FileLocation

SubjectType

SubjectName

SubjectGender

SubjectDoB

SubjectCondition

SignalType

SignalContent

Activity

BodySite

Channel

Medication

Stimulation

SignalUnit

Number_Column_SourceFile

SignalFs

SignalGain

EstimatedGain

SignalBandWidth

Notch

ReecordingDate

RecordingHour

SignalDuration_s

Comments

LinkPaper

BackupFolder

StimFreq

StimAmp

StimPulseDuaration_us



