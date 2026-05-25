function MotorFaultDetectionUI
clc; clear;

%% ================= LOAD MODEL =================
load('trained_model.mat','model');
selectedFile = '';
abnormalFlag = 0;
selectedMotor = 'AC';

%% ================= MAIN WINDOW =================
fig = uifigure('Name','Motor Fault Detection System',...
    'Position',[100 100 1000 650],...
    'Color',[0.95 0.95 0.95]);

%% ================= HEADER =================
header = uipanel(fig,...
    'Position',[10 590 980 50],...
    'BackgroundColor',[0 0.45 0.74]);

uilabel(header,...
    'Text','Machine Learning Based Multi-Motor Fault Detection and Diagnosis System',...
    'Position',[80 10 850 30],...
    'FontSize',18,...
    'FontWeight','bold',...
    'FontColor','white');

%% ================= INPUT PANEL =================
inputPanel = uipanel(fig,'Title','Input Panel',...
    'Position',[10 360 300 220]);

uilabel(inputPanel,'Text','Motor Type:',...
    'Position',[20 160 100 22]);

motorDrop = uidropdown(inputPanel,...
    'Items',{'AC','DC','BLDC','Servo','Synchronous'},...
    'Position',[120 160 150 22]);

uploadBtn = uibutton(inputPanel,'push',...
    'Text','Upload Signal File',...
    'Position',[20 110 250 30],...
    'ButtonPushedFcn',@uploadFile);

fileField = uieditfield(inputPanel,'text',...
    'Position',[20 70 250 30],...
    'Editable','off');

runBtn = uibutton(inputPanel,'push',...
    'Text','Run Detection',...
    'Position',[20 20 250 35],...
    'BackgroundColor',[0.2 0.6 0.2],...
    'FontColor','white',...
    'ButtonPushedFcn',@runDetection);

%% ================= FEATURE PANEL =================
featurePanel = uipanel(fig,'Title','Extracted Features',...
    'Position',[330 360 300 220]);

uilabel(featurePanel,'Text','RMS Value:',...
    'Position',[20 150 100 22]);
rmsField = uieditfield(featurePanel,'numeric',...
    'Position',[130 150 120 22],...
    'Editable','off');

uilabel(featurePanel,'Text','Peak Frequency:',...
    'Position',[20 100 100 22]);
peakField = uieditfield(featurePanel,'numeric',...
    'Position',[130 100 120 22],...
    'Editable','off');

uilabel(featurePanel,'Text','Mean Value:',...
    'Position',[20 50 100 22]);
meanField = uieditfield(featurePanel,'numeric',...
    'Position',[130 50 120 22],...
    'Editable','off');

%% ================= STATUS PANEL =================
statusPanel = uipanel(fig,'Title','Motor Status',...
    'Position',[650 360 340 220]);

statusLamp = uilamp(statusPanel,...
    'Position',[20 170 20 20],...
    'Color',[0.5 0.5 0.5]);

statusText = uitextarea(statusPanel,...
    'Position',[20 20 290 130],...
    'Editable','off');

statusText.Value = {'System Ready'};

%% ================= FAULT PANEL =================
faultPanel = uipanel(fig,'Title','Fault Classification',...
    'Position',[10 130 650 210]);

uilabel(faultPanel,'Text','Temperature:',...
    'Position',[20 140 100 22]);
tempField = uieditfield(faultPanel,'numeric',...
    'Position',[130 140 120 22]);

uilabel(faultPanel,'Text','Current (%):',...
    'Position',[20 90 100 22]);
currentField = uieditfield(faultPanel,'numeric',...
    'Position',[130 90 120 22]);

classifyBtn = uibutton(faultPanel,'push',...
    'Text','Classify Fault',...
    'Position',[20 30 230 35],...
    'ButtonPushedFcn',@classifyFault);

faultText = uitextarea(faultPanel,...
    'Position',[300 30 320 130],...
    'Editable','off');

tempField.Enable = 'off';
currentField.Enable = 'off';
classifyBtn.Enable = 'off';

%% ================= REPORT PANEL =================
reportPanel = uipanel(fig,'Title','Report Panel',...
    'Position',[680 130 310 210]);

downloadBtn = uibutton(reportPanel,'push',...
    'Text','Download Excel Report',...
    'Position',[40 120 220 40],...
    'ButtonPushedFcn',@downloadReport);

resetBtn = uibutton(reportPanel,'push',...
    'Text','Reset System',...
    'Position',[40 50 220 40],...
    'ButtonPushedFcn',@resetSystem);

%% ================= UPLOAD FILE =================
    function uploadFile(~,~)
        [file,path] = uigetfile({'*.wav;*.mat','Signal Files (*.wav, *.mat)'});
        if isequal(file,0)
            return;
        end
        selectedFile = fullfile(path,file);
        fileField.Value = selectedFile;
    end

%% ================= RUN DETECTION =================
    function runDetection(~,~)
        if isempty(selectedFile)
            uialert(fig,'Please upload a signal file first.','No File');
            return;
        end

        selectedMotor = motorDrop.Value;

        [~,~,ext] = fileparts(selectedFile);

        if strcmpi(ext,'.wav')
            [sig,~] = audioread(selectedFile);
            if size(sig,2) > 1
                sig = mean(sig,2);
            end
        elseif strcmpi(ext,'.mat')
            d = load(selectedFile);
            vars = fieldnames(d);
            sig = d.(vars{1});
        else
            uialert(fig,'Unsupported file type.','Error');
            return;
        end

        sig = sig(:);

        % Preprocessing
        sig = sig - mean(sig);
        sig = sig + 0.02*randn(size(sig));
        sig = movmean(sig,5);
        sig = sig / max(abs(sig)+eps);

        % Feature Extraction
        rms_val = rms(sig);
        mean_val = mean(sig);
        Yf = abs(fft(sig));
        [~,idx] = max(Yf);
        peak_freq = idx;

        feature = [rms_val peak_freq mean_val 0];

        % Display features
        rmsField.Value = rms_val;
        peakField.Value = peak_freq;
        meanField.Value = mean_val;

        % KNN
        X = model.features;
        Y = model.labels;

        d = sqrt(sum((X - feature).^2,2));
        [~,id] = min(d);
        label = Y(id);

        % Warning support
        warning_count = 0;
        if rms_val > 0.35, warning_count = warning_count + 1; end
        if peak_freq > 1500, warning_count = warning_count + 1; end
        if abs(mean_val) > 0.1, warning_count = warning_count + 1; end

        if label == 1
            abnormalFlag = 1;
        elseif warning_count >= 2
            abnormalFlag = 1;
        else
            abnormalFlag = 0;
        end

        if abnormalFlag == 1
            statusLamp.Color = 'red';
            statusText.Value = {'Motor Condition : ABNORMAL';...
                                'Early Warning : Something is wrong in motor';...
                                'Action : Stop motor immediately'};
            tempField.Enable = 'on';
            currentField.Enable = 'on';
            classifyBtn.Enable = 'on';
        else
            statusLamp.Color = 'green';
            statusText.Value = {'Motor Condition : HEALTHY';...
                                'No abnormality detected'};
            tempField.Enable = 'off';
            currentField.Enable = 'off';
            classifyBtn.Enable = 'off';
            faultText.Value = {'No Fault'};
        end
    end

%% ================= CLASSIFY FAULT =================
    function classifyFault(~,~)
        temp = tempField.Value;
        current = currentField.Value;

        switch selectedMotor
            case 'AC'
                temp_th = 110; curr_th = 130;
            case 'DC'
                temp_th = 95; curr_th = 140;
            case 'BLDC'
                temp_th = 100; curr_th = 130;
            case 'Servo'
                temp_th = 85; curr_th = 110;
            case 'Synchronous'
                temp_th = 115; curr_th = 150;
        end

        if temp > temp_th
            result = 'Fault Type : Overheating Fault';
        elseif current > curr_th
            result = 'Fault Type : Overload Fault';
        else
            result = 'Fault Type : Mechanical Fault';
        end

        faultText.Value = {result};
    end

%% ================= DOWNLOAD REPORT =================
    function downloadReport(~,~)
        if isfile('Motor_Fault_Results_Report.xlsx')
            winopen('Motor_Fault_Results_Report.xlsx');
        else
            uialert(fig,'Excel report not found. Generate it first.','Missing File');
        end
    end

%% ================= RESET SYSTEM =================
    function resetSystem(~,~)
        selectedFile = '';
        abnormalFlag = 0;

        fileField.Value = '';
        rmsField.Value = 0;
        peakField.Value = 0;
        meanField.Value = 0;
        tempField.Value = 0;
        currentField.Value = 0;

        tempField.Enable = 'off';
        currentField.Enable = 'off';
        classifyBtn.Enable = 'off';

        statusLamp.Color = [0.5 0.5 0.5];
        statusText.Value = {'System Ready'};
        faultText.Value = {''};
    end

end