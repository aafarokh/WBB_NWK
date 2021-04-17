%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JsonAdoptor.m reads the metadata file and for each row (each signal) 
% combines the corresponding information and the signal in one .json file.
% This script needs the function saveAsJSON.m to run. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is written by AmirAli Farokhniaee, Ph.D. in 2020 
% and can be found at:
% https://github.com/aafarokh/WBB_NWK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
clearvars
%%%choose which sheet of the metadata file to read:
% selectsheet = 'PD_Basal';
% selectsheet = 'PD_DBS_OffOnOff';
selectsheet = 'PD_MED_DBS';
MTstruct=importdata('C:\Users\amirali.farokhniaee\Desktop\ProcessingSignals\Metadata.xlsx');
colheaders=MTstruct.textdata.(selectsheet)(1,:);
directorypath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',selectsheet,'\'];
new_filepath=['C:\Users\amirali.farokhniaee\Desktop\Processed_Signals\',selectsheet,'\'];
%%%In case of starting from the last file to continue the conversion we need these three lines:
xx=dir(new_filepath);   %Go to the new directory to find the last file
cc=xx(end).name;        %Find the name of the last file in the new folder
lastone=str2double(cc(12:end-4)); %Convert it to the row number in MT

% for i=lastone+1:size(MTstruct.textdata.PD_Basal,1)
for i=2:size(MTstruct.textdata.(selectsheet),1)
%  for i=10
    disp(num2str(i))
    entire_row_num=MTstruct.data.(selectsheet)(i-1,:);
    entire_row_text=MTstruct.textdata.(selectsheet)(i,:);
    file= [directorypath,entire_row_text{1},'.txt'];
    xx_struct=importdata(file(1,:));
    if isnan(entire_row_num(2))%check if Fs does not exist
        yy=xx_struct;
        signal=zeros(length(yy),1);
        for j=2:length(yy)
            format long g
            signal(j-1)=str2double(yy{j});
        end
        signal(end)=str2double(yy{end});
    else
        yy=xx_struct.textdata;
        signal=zeros(length(yy),1);
        for j=2:length(yy)
            format long g
            signal(j-1)=str2double(yy{j});
        end
        signal(end)=str2double(xx_struct.colheaders{1,1});
    end
    if isempty(entire_row_text{27})%check if the signal duration is unknown
        if isnumeric(entire_row_num(2))%check if Fs exist
            SigDuration=length(signal)/entire_row_num(2);
        end
    end
    if ~isempty(entire_row_text{25}) %check if recording date and time exist
        recDT=entire_row_text{25};
        if ~isempty(entire_row_text{26})
            recDT=[recDT,'T',entire_row_text{26}];
        end
    else
        recDT=NaN;
    end
    S=struct(colheaders{1},entire_row_text{1},...
        colheaders{2},entire_row_text{2},...
        colheaders{3},entire_row_text{3},...
        colheaders{4},entire_row_text{4},...
        colheaders{5},entire_row_text{5},...
        colheaders{6},entire_row_text{6},...
        colheaders{7},entire_row_text{7},...
        colheaders{8},entire_row_text{8},...
        colheaders{9},entire_row_text{9},...
        colheaders{10},entire_row_text{10},...
        colheaders{11},entire_row_text{11},...
        colheaders{12},entire_row_text{12},...
        colheaders{13},entire_row_text{13},...
        colheaders{14},entire_row_text{14},...
        colheaders{15},entire_row_text{15},...
        colheaders{16},entire_row_text{16},...
        colheaders{17},entire_row_text{17},...
        colheaders{31},entire_row_num(13),...
        colheaders{32},entire_row_num(14),...
        colheaders{33},entire_row_num(15),...
        colheaders{18},entire_row_text{18},...
        colheaders{20},entire_row_num(2),...
        colheaders{21},entire_row_num(3),...
        colheaders{22},entire_row_num(4),...
        colheaders{23},entire_row_text{23},...
        colheaders{24},entire_row_text{24},...
        'RecordingDateTime',recDT,...
        colheaders{27},SigDuration,...
        colheaders{28},entire_row_text{28},...
        'Code',['WBB_',entire_row_text{12},'_',entire_row_text{11},'_',entire_row_text{13},'_','MSMT_SITE_',entire_row_text{15},entire_row_text{14}],... 
        'v',signal(1:100,1)); %save just the first 100 signal samples
%             WBB_ATS_LFP_REST_MSMT_SITE_RSTN
    J=jsonencode(S,'ConvertInfAndNaN',false);
    %Save as a JSON file:
    saveAsJSON(S, [new_filepath,entire_row_text{1},'.json'])
end
toc