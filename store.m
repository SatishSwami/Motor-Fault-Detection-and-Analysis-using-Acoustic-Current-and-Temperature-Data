clc; clear;

%% ================= LOAD MODEL =================
load('trained_model.mat');

baseFolder = 'C:\Users\ishan\Downloads\acoustic\Dataset';

results = {};

fprintf('\nGenerating Excel Report...\n');

Fs = 51200;

%% =====================================================
%% AC MOTOR FILES
%% =====================================================

acFolder = fullfile(baseFolder,'AC_induction');

acFiles = dir(fullfile(acFolder,'*.mat'));

for i = 1:length(acFiles)

    filePath = fullfile(acFiles(i).folder, acFiles(i).name);

    [results] = processFile(filePath,'AC',model,results,Fs);

end

%% =====================================================
%% BLDC FILES
%% =====================================================

bldcFolder = fullfile(baseFolder,'BLDC_sound_data');

subFolders = {'healthy','bearing','propeller'};

for s = 1:length(subFolders)

    folderPath = fullfile(bldcFolder, subFolders{s});

    files = dir(fullfile(folderPath,'*.wav'));

    for i = 1:length(files)

        filePath = fullfile(files(i).folder, files(i).name);

        [results] = processFile(filePath,'BLDC',model,results,Fs);

    end
end

%% =====================================================
%% DC FILE
%% =====================================================

dcPath = fullfile(baseFolder,'DC_motor.xlsx');

[results] = processDC(dcPath,'DC',model,results);

%% =====================================================
%% SAVE TO EXCEL
%% =====================================================

headers = {'File_Name', ...
           'Motor_Type', ...
           'RMS_Value', ...
           'Peak_Frequency', ...
           'Mean_Value', ...
           'Motor_Condition', ...
           'Fault_Type'};

disp(size(results))

finalTable = cell2table(results, ...
    'VariableNames', headers);

outputFile = 'Motor_Fault_Results_Report.xlsx';

writetable(finalTable, outputFile);

fprintf('\n====================================\n');
fprintf('Excel Report Generated Successfully\n');
fprintf('Saved File : %s\n', outputFile);
fprintf('====================================\n');

%% =====================================================
%% FUNCTION : PROCESS WAV / MAT FILES
%% =====================================================

function results = processFile(filePath,motorType,model,results,Fs)

[~, fileName, ext] = fileparts(filePath);

%% LOAD SIGNAL
if strcmpi(ext,'.wav')

    [sig,~] = audioread(filePath);

    if size(sig,2) > 1
        sig = mean(sig,2);
    end

elseif strcmpi(ext,'.mat')

    d = load(filePath);

    vars = fieldnames(d);

    sig = d.(vars{1});

else
    return;
end

sig = sig(:);

%% PREPROCESSING
sig = sig - mean(sig);

sig = movmean(sig,5);

sig = sig / max(abs(sig)+eps);

%% FEATURE EXTRACTION

rms_val  = rms(sig);

mean_val = mean(sig);

std_val  = std(sig);

energy_val = sum(sig.^2);

N = length(sig);

Yf = abs(fft(sig));

f = (0:N-1)*(Fs/N);

[~, idx] = max(Yf);

peak_freq = f(idx);

feature = [rms_val peak_freq mean_val std_val energy_val];

feature = normalize(feature);

%% KNN

X = model.features;

Y = model.labels;

d = sqrt(sum((X - feature).^2,2));

[~, id] = min(d);

label = Y(id);

%% FINAL DECISION

if label == 1
    condition = 'ABNORMAL';
    faultType = 'Mechanical Fault';
else
    condition = 'HEALTHY';
    faultType = 'No Fault';
end

%% STORE

results(end+1,1:7) = { ...
    string([fileName ext]), ...
    string(motorType), ...
    double(rms_val), ...
    double(peak_freq), ...
    double(mean_val), ...
    string(condition), ...
    string(faultType)};

end

%% =====================================================
%% FUNCTION : PROCESS DC FILE
%% =====================================================

function results = processDC(filePath,motorType,model,results)

[~, fileName, ext] = fileparts(filePath);

data = readmatrix(filePath);

current = data(:,1);

speed = data(:,2);

sig = current(:);

%% PREPROCESSING

sig = sig - mean(sig);

sig = movmean(sig,5);

sig = sig / max(abs(sig)+eps);

%% FEATURE EXTRACTION

rms_val  = rms(sig);

mean_val = mean(sig);

std_val  = std(sig);

energy_val = sum(sig.^2);

peak_freq = std(speed);

feature = [rms_val peak_freq mean_val std_val energy_val];

feature = normalize(feature);

%% KNN

X = model.features;

Y = model.labels;

d = sqrt(sum((X - feature).^2,2));

[~, id] = min(d);

label = Y(id);

%% FINAL DECISION

if label == 1
    condition = 'ABNORMAL';
    faultType = 'Mechanical Fault';
else
    condition = 'HEALTHY';
    faultType = 'No Fault';
end

%% STORE

results(end+1,1:7) = { ...
    string([fileName ext]), ...
    string(motorType), ...
    double(rms_val), ...
    double(peak_freq), ...
    double(mean_val), ...
    string(condition), ...
    string(faultType)};

end