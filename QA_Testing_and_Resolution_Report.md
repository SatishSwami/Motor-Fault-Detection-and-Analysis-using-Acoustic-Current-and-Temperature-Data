# QA Testing and Resolution Report

## Project
Motor Fault Detection and Analysis Using Acoustic, Current and Temperature Data

## Testing Summary

| Test | Input | Observed Result |
|---|---|---|
| Healthy motor | Normal_0.mat | HEALTHY |
| Abnormal motor | IR_1.mat | ABNORMAL |
| Invalid motor selection | Choice 11 | Rejected |
| Dataset generation | AC and BLDC data | 51 samples |
| Model evaluation | Train-test split | 50% accuracy |

## QA Issue Register

| Issue | Problem | Severity | Current Status |
|---|---|---|---|
| #1 | Incorrect dataset paths and filenames | High | Closed after local verification and commit |
| #2 | Incorrect DC Excel worksheet | High | Open; DC classification deferred |
| #3 | FFT peak index treated as frequency in Hz | Medium | Open |
| #4 | Random train-test split | Medium | Open |
| #5 | Inconsistent feature extraction | High | Open |

## Root Cause Analysis

All five issues were investigated using the Five Whys technique. The analysis identified problems involving incorrect file paths, workbook worksheet selection, FFT frequency interpretation, experiment reproducibility and inconsistent feature definitions.

## Corrective Actions

### QA-01
Corrected the dataset base path, AC folder name and DC workbook filename. Dataset generation was successfully verified with 51 samples: 24 healthy and 27 faulty.

### QA-02
Inspected the DC workbook and identified that the default worksheet contained descriptions rather than experimental measurements. DC classification was deferred until reliable labels can be established.

### QA-03
Identified that the FFT maximum-value index is displayed instead of a frequency calculated using the sampling rate. Correction remains pending.

### QA-04
Identified the need for a fixed random seed to make train-test splitting reproducible. Correction remains pending.

### QA-05
Identified inconsistencies between training and runtime feature extraction. A shared and validated feature extraction pipeline remains pending.

## Model Evaluation

- Accuracy: 50.00%
- Precision: 0.43
- Recall: 0.75
- F1 Score: 0.55

These are preliminary results from a small dataset and require further validation.

## Conclusion

The QA process identified five issues, documented their root causes and proposed corrective actions. One issue was corrected, committed and verified locally. The remaining issues are tracked openly for future improvement.
