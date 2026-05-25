clc; clear;

load('final_dataset.mat');

X = features;
Y = labels;

% Train/Test Split
n = size(X,1);
idx = randperm(n);

train_n = round(0.8*n);

Xtrain = X(idx(1:train_n),:);
Ytrain = Y(idx(1:train_n));

Xtest  = X(idx(train_n+1:end),:);
Ytest  = Y(idx(train_n+1:end));

% Store KNN Model
model.features = Xtrain;
model.labels   = Ytrain;

save('trained_model.mat','model');

% Evaluation
pred = zeros(length(Ytest),1);

for i = 1:length(Ytest)
    d = sqrt(sum((Xtrain - Xtest(i,:)).^2,2));
    [~, id] = min(d);
    pred(i) = Ytrain(id);
end

TP = sum((pred==1)&(Ytest==1));
TN = sum((pred==0)&(Ytest==0));
FP = sum((pred==1)&(Ytest==0));
FN = sum((pred==0)&(Ytest==1));

accuracy  = (TP+TN)/(TP+TN+FP+FN);
precision = TP/(TP+FP+eps);
recall    = TP/(TP+FN+eps);
f1score   = 2*(precision*recall)/(precision+recall+eps);

fprintf('\n===== MODEL EVALUATION =====\n');
fprintf('Accuracy  : %.2f%%\n', accuracy*100);
fprintf('Precision : %.2f\n', precision);
fprintf('Recall    : %.2f\n', recall);
fprintf('F1 Score  : %.2f\n', f1score);
fprintf('============================\n');