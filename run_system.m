clc; clear;

%% ================= LOAD TRAINED MODEL =================
load('trained_model.mat');

%% ================= MOTOR TYPE SELECTION =================
disp('Select Motor Type:')
disp('1 - AC')
disp('2 - DC')
disp('3 - BLDC')
disp('4 - Servo')
disp('5 - Synchronous')

choice = input('Enter choice (1-5): ');

while isempty(choice) || ~ismember(choice,1:5)
    disp('Invalid choice! Please enter a number between 1 and 5.');
    choice = input('Enter choice (1-5): ');
end

switch choice
    case 1
        motorType = 'AC';
    case 2
        motorType = 'DC';
    case 3
        motorType = 'BLDC';
    case 4
        motorType = 'Servo';
    case 5
        motorType = 'Synchronous';
end

%% ================= LOAD INPUT SIGNAL =================
[file, path] = uigetfile({'*.wav;*.mat','Motor Signal Files (*.wav, *.mat)'}, ...
                         'Select Input Motor Signal');

if isequal(file,0)
    error('No file selected');
end

filePath = fullfile(path,file);
[~,~,ext] = fileparts(filePath);

if strcmpi(ext,'.wav')
    [sig, ~] = audioread(filePath);

    if size(sig,2) > 1
        sig = mean(sig,2);   % stereo to mono
    end

elseif strcmpi(ext,'.mat')
    d = load(filePath);
    vars = fieldnames(d);
    sig = d.(vars{1});

else
    error('Unsupported file type');
end

sig = sig(:);

%% ================= PREPROCESSING =================
sig = sig - mean(sig);                 % Remove DC offset
sig = sig + 0.02 * randn(size(sig));   % Add Gaussian noise
sig = movmean(sig, 5);                 % Denoising
sig = sig / max(abs(sig) + eps);       % Normalize

%% ================= FEATURE EXTRACTION =================
rms_val  = rms(sig);
mean_val = mean(sig);

Yf = abs(fft(sig));
[~, idx] = max(Yf);
peak_freq = idx;

feature = [rms_val peak_freq mean_val 0];

fprintf('\n===== EXTRACTED FEATURES =====\n');
fprintf('RMS Value       : %.4f\n', rms_val);
fprintf('Peak Frequency  : %d\n', peak_freq);
fprintf('Mean Value      : %.4f\n', mean_val);
fprintf('==============================\n');

%% ================= KNN PREDICTION =================
X = model.features;
Y = model.labels;

d = sqrt(sum((X - feature).^2, 2));
[~, id] = min(d);
label = Y(id);   % Primary ML decision

%% ================= FEATURE WARNING CHECK =================
warning_count = 0;

if rms_val > 0.35
    warning_count = warning_count + 1;
end

if peak_freq > 1500
    warning_count = warning_count + 1;
end

if abs(mean_val) > 0.1
    warning_count = warning_count + 1;
end

%% ================= FINAL DECISION =================
% KNN is primary
% Feature thresholds are only support
if label == 1
    abnormal = 1;
elseif warning_count >= 2
    abnormal = 1;
else
    abnormal = 0;
end

%% ================= HEALTH / FAULT OUTPUT =================
if abnormal == 1

    fprintf('\n====================================\n');
    fprintf('Motor Condition : ABNORMAL\n');
    fprintf('Early Warning   : Something is wrong in the motor\n');
    fprintf('Action          : Motor should be stopped immediately\n');
    fprintf('====================================\n');

    %% Ask only if abnormal
    temp = input('Enter Temperature: ');
    current = input('Enter Current in %%: ');

    %% ================= MOTOR-SPECIFIC THRESHOLDS =================
    switch motorType
        case 'AC'
            temp_th = 110;
            curr_th = 130;

        case 'DC'
            temp_th = 95;
            curr_th = 140;

        case 'BLDC'
            temp_th = 100;
            curr_th = 130;

        case 'Servo'
            temp_th = 85;
            curr_th = 110;

        case 'Synchronous'
            temp_th = 115;
            curr_th = 150;
    end

    %% ================= FAULT CLASSIFICATION =================
    if temp > temp_th
        result = 'Fault Type : Overheating Fault';

    elseif current > curr_th
        result = 'Fault Type : Overload Fault';

    else
        result = 'Fault Type : Mechanical Fault';
    end

    fprintf('%s\n', result);
    fprintf('====================================\n');

else
    fprintf('\n====================================\n');
    fprintf('Motor Condition : HEALTHY\n');
    fprintf('No abnormality detected\n');
    fprintf('====================================\n');
end