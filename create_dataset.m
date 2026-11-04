
clc; clear;

baseFolder = fullfile(pwd, 'Dataset');

assert(isfolder(baseFolder), 'Dataset folder not found.');

features = [];
labels = [];

%% AC INDUCTION MOTOR
acFolder = fullfile(baseFolder, 'AC_Induction');
acFiles = dir(fullfile(acFolder, '*.mat'));

assert(~isempty(acFiles), 'No AC motor MAT files found.');

for i = 1:length(acFiles)
    filePath = fullfile(acFiles(i).folder, acFiles(i).name);
    data = load(filePath);
    vars = fieldnames(data);

    assert(~isempty(vars), 'Empty MAT file.');

    signal = data.(vars{1});
    assert(isnumeric(signal) && ~isempty(signal), 'Invalid AC signal.');

    signal = signal(:);
    signal = signal - mean(signal);
    signal = signal + 0.02*randn(size(signal));
    signal = movmean(signal,5);
    signal = signal / max(abs(signal)+eps);

    rms_val = rms(signal);
    mean_val = mean(signal);
    Y = abs(fft(signal));
    [~, idx] = max(Y);
    peak_freq = idx;

    features = [features; rms_val peak_freq mean_val 0];

    if contains(acFiles(i).name,'Normal')
        labels = [labels; 0];
    else
        labels = [labels; 1];
    end
end

%% BLDC MOTOR
bldcFolder = fullfile(baseFolder,'BLDC_sound_data');
subFolders = {'Healthy','Bearing','Propeller'};

for s = 1:length(subFolders)
    folderPath = fullfile(bldcFolder, subFolders{s});
    files = dir(fullfile(folderPath,'**','*.wav'));

    assert(~isempty(files), 'No WAV files found in %s.', folderPath);

    for i = 1:length(files)
        filePath = fullfile(files(i).folder, files(i).name);
        [y, ~] = audioread(filePath);

        if size(y,2) > 1
            y = mean(y,2);
        end

        signal = y(:);
        signal = signal - mean(signal);
        signal = signal + 0.02*randn(size(signal));
        signal = movmean(signal,5);
        signal = signal / max(abs(signal)+eps);

        rms_val = rms(signal);
        mean_val = mean(signal);
        Y = abs(fft(signal));
        [~, idx] = max(Y);
        peak_freq = idx;

        features = [features; rms_val peak_freq mean_val 0];

        if strcmp(subFolders{s},'Healthy')
            labels = [labels; 0];
        else
            labels = [labels; 1];
        end
    end
end

%% DC MOTOR
% DC workbook contains experimental data, not verified
% healthy/fault labels. Excluded until label mapping is confirmed.
disp('DC experimental data identified; classification deferred.');

%% VALIDATE AND SAVE
assert(size(features,1) == numel(labels), ...
    'Feature and label counts do not match.');

assert(all(isfinite(features(:))), 'Features contain invalid values.');

save('final_dataset.mat','features','labels');

fprintf('Dataset generated successfully.\n');
fprintf('Total samples: %d\n', size(features,1));
fprintf('Feature count: %d\n', size(features,2));
fprintf('Healthy samples: %d\n', sum(labels==0));
fprintf('Faulty samples: %d\n', sum(labels==1));
