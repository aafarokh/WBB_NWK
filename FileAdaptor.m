%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FileAdaptor.m reads the metadata file and converts the old format
% files for 13 different cases to the new file format such as below:
% "Fs= " 512
% 1.928736
% -0.182643
% 0.024379
% 1.283741
% .
% .
% .
% -0.374178
% and names it by the unique PIDxxxx_SIDxxxxx ID so that all the information 
% about the signal and subject can be retrieved from the metadata file. 
% The new file will be saved in the desired destination. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. on a Windows 10 system 
% in 2020 and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
clearvars
%%%choose which sheet of the metadata file to read:
% selectsheet = 'PD_Basal';
selectsheet = 'PD_MED_DBS';
MT=readtable('C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx','Sheet',selectsheet);
new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',selectsheet,'\'];
%%%In case of starting from the last file to continue the conversion we need these three lines:
xx=dir(new_filepath);   %Go to the new directory to find the last file
cc=xx(end).name;        %Find the name of the last file in the new folder
lastone=str2double(cc(12:end-4)); %Convert it to the row number in MT

%%%%Uncomment the line below for the total files evaluation
for i=1:size(MT,1)
    %%%Uncomment the first two lines below for the selceted files evaluation
    %     for i=223:246
    
    %%%%Uncomment the first two lines below for new files evaluation starting
    %%%%from the last converted file in the folder
    %     for i=lastone+1:size(MT,1)
    
    %%%The loops starting above share the text below anyways:
    disp(num2str(i))
    location=MT.FileLocation{i};
    if i>=177 && i<=245
        filename=MT.SourceFile{i}(5:end);
    else
        filename=MT.SourceFile{i};
    end
    filepath=[location,'\',filename,'.txt'];
    format long g
    OriginalSignal=importdata(filepath);
    if isfield(OriginalSignal,'data')
        numeric_columns=OriginalSignal.data;
    end
    
    %for those types of files with headers and 3 columns, where:
    % "Time"	"31 Keyboard"	"1 untitled"
    % 0.000000      0             -0.00427
    % 0.003906      0             -0.01540
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'colheaders') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.data,2)==3 &&...
            sum(numeric_columns(3:6,2))==0
        disp case1
        index_v=size(numeric_columns,2);
        format long g
        v=numeric_columns(:,index_v);
        t1=numeric_columns(1,1); t2=numeric_columns(2,1);
        dt=t2-t1;
        fs=1/dt;
        fileID = fopen([new_filepath,MT.FileName{i},'.txt'],'w');
        fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
        fprintf(fileID,'%5.5f\n',v);
        fclose(fileID);
    end
    
    %for those types of files with no headers and 4 columns, where:
    % -0.58594	-1.18896	0.64209	-0.01221
    % -0.44189	-0.85449	0.63477	-0.06348
    % -0.55176	-0.84473	0.62500	-0.03906
    if ismatrix(OriginalSignal) && size(OriginalSignal,2)==4
        disp case2
        for j=1:4
            v=OriginalSignal(:,j);
            fs=MT.SignalFs(i);
            if      isequal(MT.SourceFile{i+1},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+2},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+3},MT.SourceFile{i})
                fileID = fopen([new_filepath,MT.FileName{i+j-1},'.txt'],'w');
                fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
                fprintf(fileID,'%5.5f\n',v);
                fclose(fileID);
            else
                break
            end
        end
    end
    
    %for those types of files with no headers and 6 columns, where:
    % -0.58594	-1.18896	0.64209	-0.01221 -0.58594	-1.18896
    %0.64209	-0.01221    -0.44189-0.85449 -0.44189	-0.85449
    %0.63477	-0.06348    -0.55176-0.84473  0.62500	-0.03906
    if ismatrix(OriginalSignal) && size(OriginalSignal,2)==6
        disp case3
        for j=1:6
            v=OriginalSignal(:,j);
            fs=MT.SignalFs(i);
            if      isequal(MT.SourceFile{i+1},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+2},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+3},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+4},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+5},MT.SourceFile{i})
                fileID = fopen([new_filepath,MT.FileName{i+j-1},'.txt'],'w');
                fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
                fprintf(fileID,'%5.5f\n',v);
                fclose(fileID);
            else
                break
            end
        end
    end
    
    %for those types of files with headers and 1 column, where:
    % channel names:
    % MontanaroDxOFFlevo - Voltage - Dev1_ai0
    % start times:
    % 8/30/2010 12:52:04.939500
    % dt:
    % 0.002000
    % data:
    % -7.575932E-2
    % -5.610331E-2
    % -3.193608E-2
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.textdata,2)==1 &&...
            size(OriginalSignal.data,2)>1
        disp case4
        column=OriginalSignal.textdata;
        v=zeros(length(column),1);
        for j=8:length(v)
            format long g
            v(j)=str2double(column{j});
        end
        v=v(8:end);
        dt=str2double(column{6});
        fs=1/dt;
        fileID = fopen([new_filepath,MT.FileName{i},'.txt'],'w');
        fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
        fprintf(fileID,'%5.8f\n',v);
        fclose(fileID);
    end
    
    %for those types of files with headers and 6 columns, where:
    % "Time"	"31 Keyboard"	"4 ADC3"	"3 ADC2"	"2 ADC1"	"1 ADC0"
    % 0.0000	0.000000                                            -0.23438
    % 0.0004	0.000000        0.62805     0.88745     0.14526     -0.13916
    % 0.0008	0.000000        1.20544     0.90698     0.08972     0.03906
    % 0.0012	0.000000        0.89966     0.61035     -0.01099	0.19531
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'colheaders') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.data,2)==6
        disp case5
        t1=numeric_columns(2,1); t2=numeric_columns(3,1);
        dt=t2-t1;
        fs=1/dt;
        for j=3:6
            v=numeric_columns(2:end,j);
            if      isequal(MT.SourceFile{i+1},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+2},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+3},MT.SourceFile{i})
                fileID = fopen([new_filepath,MT.FileName{i+j-3},'.txt'],'w');
                fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
                fprintf(fileID,'%5.5f\n',v);
                fclose(fileID);
            else
                break
            end
        end
    end
    
    %for those types of files with headers and 1 column, where:
    % "INFORMATION"
    % "Prova2.smr"
    % ""
    % ""
    % ""
    % ""
    % ""
    %
    % "SUMMARY"
    % "1"	"Waveform"	"untitled"	" volt"	256	255.754476	1	0
    % "31"	"Marker"	"Keyboard"
    %
    % "CHANNEL"	"1"
    % "Waveform"
    % "No comment"
    % "untitled"
    %
    % " volt"	256
    % "START"	0.00000	0.00391
    % -0.00565
    % -0.01022
    % -0.01175
    % -0.01297
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.textdata,2)==4 &&...
            size(numeric_columns,1)==1
        disp case6
        column=OriginalSignal.textdata;
        v=zeros(length(column),1);
        for j=8:length(v)
            format long g
            v(j)=str2double(column{j});
        end
        v=v(17:end-4);
        fs=MT.SignalFs(i);
        fileID = fopen([new_filepath,MT.FileName{i},'.txt'],'w');
        fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
        fprintf(fileID,'%5.5f\n',v);
        fclose(fileID);
    end
    
    %for those types of files with headers and 4 columns, where:
    % "Time"	"31 Keyboard"	"2 untitled"	"1 untitled"
    % 0.0000	0.000000
    % 0.0004	0.000000        0.62805          0.88745
    % 0.0008	0.000000        1.20544          0.90698
    % 0.0012	0.000000        0.89966          0.61035
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'colheaders') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.data,2)==4 &&...
            size(numeric_columns,1)>1
        disp case7
        t1=numeric_columns(2,1); t2=numeric_columns(3,1);
        dt=t2-t1;
        fs=1/dt;
        for j=3:4
            v=numeric_columns(2:end,j);
            if      isequal(MT.SourceFile{i+1},MT.SourceFile{i})
                fileID = fopen([new_filepath,MT.FileName{i+j-3},'.txt'],'w');
                fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
                fprintf(fileID,'%5.5f\n',v);
                fclose(fileID);
            else
                break
            end
        end
    end
    
    %for those types of files with no headers and 1 column, where:
    % -0.58594
    % -0.44189
    % -0.55176
    if ismatrix(OriginalSignal) && ~isfield(OriginalSignal,'data') &&...
            size(OriginalSignal,2)==1
        disp case8
        v=OriginalSignal(:,1);
        fs=MT.SignalFs(i);
        fileID = fopen([new_filepath,MT.FileName{i},'.txt'],'w');
        fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
        fprintf(fileID,'%5.5f\n',v);
        fclose(fileID);
    end
    
    %for those types of files with a header and 1 column, where:
    % data=[
    % 0.04395
    % 0.04379
    % 0.03571
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'colheaders') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.textdata,2)==1 &&...
            size(OriginalSignal.colheaders,2)==1
        disp case9
        v=OriginalSignal.data(:,1);
        fs=MT.SignalFs(i);
        fileID = fopen([new_filepath,MT.FileName{i},'.txt'],'w');
        fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
        fprintf(fileID,'%5.5f\n',v);
        fclose(fileID);
    end
    
    %for those types of files with headers and 2 columns, where:
    % "Time"	"1 untitled"
    % 0.000000    -0.00427
    % 0.003906    -0.01540
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'colheaders') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.data,2)==2
        disp case10
        index_v=size(numeric_columns,2);
        format long g
        v=numeric_columns(:,index_v);
        t1=numeric_columns(1,1); t2=numeric_columns(2,1);
        dt=t2-t1;
        fs=1/dt;
        fileID = fopen([new_filepath,MT.FileName{i},'.txt'],'w');
        fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
        fprintf(fileID,'%5.5f\n',v);
        fclose(fileID);
    end
    
    %for those types of files with headers and 5 columns, where:
    % "Time"	"31 Keyboard"	"3 GraSSsx"	"2 FilterDBS"	"1 GrassDx"
    % 0.0000	0.000000        -0.01160	-0.22095        0.06836
    % 0.0004	0.000000        -0.01770	-0.15503        -0.06592
    % 0.0008	0.000000        -0.01953	-0.21057        0.00488
    
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'colheaders') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.data,2)==5 &&...
            size(numeric_columns,1)>1
        disp case11
        t1=numeric_columns(2,1); t2=numeric_columns(3,1);
        dt=t2-t1;
        fs=1/dt;
        for j=3:5
            v=numeric_columns(2:end,j);
            if      isequal(MT.SourceFile{i+1},MT.SourceFile{i}) &&...
                    isequal(MT.SourceFile{i+2},MT.SourceFile{i})
                fileID = fopen([new_filepath,MT.FileName{i+j-3},'.txt'],'w');
                fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
                fprintf(fileID,'%5.5f\n',v);
                fclose(fileID);
            else
                break
            end
        end
    end
    
    %for those types of files with headers and 12 columns, where:
    % "Time"	"31 Keyboard"	"4 ADC3"	"3 ADC2"	"2 ADC1"	"1 ADC0"
    % 0.0000	0.000000                                            -0.23438
    % 0.0004	0.000000        0.62805     0.88745     0.14526     -0.13916
    % 0.0008	0.000000        1.20544     0.90698     0.08972     0.03906
    % 0.0012	0.000000        0.89966     0.61035     -0.01099	0.19531
    if isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'colheaders') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.data,2)==12
        disp case12
        t1=numeric_columns(2,1); t2=numeric_columns(3,1);
        dt=t2-t1;
        fs=1/dt;
        for j=11:12 %Notet that we were just interested in columns 11 and 12
            v=numeric_columns(2:end,j);
            if      isequal(MT.SourceFile{i+1},MT.SourceFile{i})
                fileID = fopen([new_filepath,MT.FileName{i+j-11},'.txt'],'w');
                fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
                fprintf(fileID,'%5.5f\n',v);
                fclose(fileID);
            else
                break
            end
        end
    end
    
    %for those types of files with headers and 3 columns, where:
    % "Time"	"2 FilterDBS"	"1 Controlat"
    % 0.0000	-0.07690        -0.01465
    % 0.0004	-0.05859        -0.00977
    % 0.0008	-0.06104        0.08057
    if      isfield(OriginalSignal,'data') &&...
            isfield(OriginalSignal,'colheaders') &&...
            isfield(OriginalSignal,'textdata') &&...
            size(OriginalSignal.data,2)==3 &&...
            sum(numeric_columns(3:6,2))~=0
        disp case13
        t1=numeric_columns(1,1); t2=numeric_columns(2,1);
        dt=t2-t1;
        fs=1/dt;
        for j=2:3
            v=numeric_columns(2:end,j);
            if      isequal(MT.SourceFile{i+1},MT.SourceFile{i})
                fileID = fopen([new_filepath,MT.FileName{i+j-2},'.txt'],'w');
                fprintf(fileID,'%3s %5.0f\n','"Fs="',fs);
                fprintf(fileID,'%5.5f\n',v);
                fclose(fileID);
            else
                break
            end
        end
    end
    
end
% end
toc