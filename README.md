# Motor Fault Detection and Analysis Using Acoustic, Current and Temperature Data

## 1. Project Overview

This project is an academic motor fault detection prototype developed using Digital Signal Processing (DSP) and lightweight Machine Learning techniques in MATLAB.

It processes motor-related signal data, extracts numerical features and predicts whether a motor is operating under healthy or abnormal conditions.

The project also uses temperature and current inputs as part of its additional fault classification logic.

## 2. Objectives

- Analyze motor signals using DSP techniques.
- Extract useful signal features.
- Classify motor conditions as healthy or abnormal.
- Provide early warnings for potential motor faults.
- Maintain a structured dataset and model evaluation process.
- Identify software defects through systematic QA testing.

## 3. Technologies Used

- MATLAB
- Digital Signal Processing
- Fast Fourier Transform (FFT)
- RMS-based feature extraction
- Moving Average Filtering
- 1-Nearest Neighbour (1-NN) classification
- MATLAB App Designer

## 4. System Workflow

```text
Motor Signal Dataset
        |
        v
Signal Preprocessing
        |
        v
Feature Extraction
        |
        v
Training and Testing Split
        |
        v
1-Nearest Neighbour Classification
        |
        v
Threshold-Based Decision Logic
        |
        v
Healthy / Abnormal Classification
        |
        v
Fault Warning and Output
```

## 5. Signal Processing and Features

The current implementation performs:

- DC offset removal
- Moving average filtering
- Signal normalization
- RMS calculation
- Mean calculation
- FFT-based peak-bin extraction

The current feature vector contains four values:

```matlab
[rms_value, peak_index, mean_value, fourth_feature]
```

**Note:** The FFT peak index is not yet converted into frequency in Hz. Feature consistency between dataset generation and runtime prediction is also a documented improvement area.

## 6. Dataset Information

The current dataset generation process uses:

- AC induction motor signal files
- BLDC motor signal files

The DC motor workbook was also investigated. However, its experimental worksheets do not yet have a verified healthy/fault label mapping for this classifier. Therefore, DC classification has been deferred.

### Generated Dataset Summary

| Parameter | Result |
|---|---:|
| Total samples | 51 |
| Features | 4 |
| Healthy samples | 24 |
| Faulty samples | 27 |

## 7. Model Evaluation

The model was evaluated using a train-test split and nearest-neighbour classification.

| Metric | Observed Result |
|---|---:|
| Accuracy | 50.00% |
| Precision | 0.43 |
| Recall | 0.75 |
| F1 Score | 0.55 |

**Evaluation note:** These are preliminary results from a small dataset. They do not establish reliable industrial fault detection performance. Further dataset collection, feature validation and model improvement are required.

## 8. Project Structure

```text
Motor-Fault-Detection/
|
|-- create_dataset.m
|-- train_model.m
|-- run_system.m
|-- MotorFaultDetectionUI.m
|-- MotorFaultDetectionApp.mlapp
|-- store.m
|
|-- final_dataset.mat
|-- trained_model.mat
|-- Motor_Fault_Results_Report.xlsx
|
|-- Dataset/
|   |-- AC_Induction/
|   |-- BLDC_sound_data/
|   |-- DC_Motor.xlsx
|
|-- README.md
```

## 9. Execution Instructions

### Step 1: Generate Dataset

```matlab
create_dataset
```

Loads the supported signal datasets, performs preprocessing and generates `final_dataset.mat`.

### Step 2: Train the Model

```matlab
train_model
```

Splits the dataset, performs nearest-neighbour classification, calculates evaluation metrics and saves `trained_model.mat`.

### Step 3: Run Motor Fault Detection

```matlab
run_system
```

Select a motor type, upload a supported signal file and view the predicted motor condition.

### Step 4: Launch GUI

Open and run the MATLAB application:

```matlab
MotorFaultDetectionUI
```

### Step 5: Excel Reporting

The repository includes an Excel results report and a MATLAB reporting script. The reporting workflow should be verified before relying on it for new results.

## 10. Quality Assurance and Testing

Five QA issues were identified and documented using GitHub Issues.

| Issue | Problem | Severity |
|---|---|---|
| [QA-01](https://github.com/SatishSwami/Motor-Fault-Detection-and-Analysis-using-Acoustic-Current-and-Temperature-Data/issues/1) | Incorrect dataset paths and file names | High |
| [QA-02](https://github.com/SatishSwami/Motor-Fault-Detection-and-Analysis-using-Acoustic-Current-and-Temperature-Data/issues/2) | Incorrect DC Excel worksheet selection | High |
| [QA-03](https://github.com/SatishSwami/Motor-Fault-Detection-and-Analysis-using-Acoustic-Current-and-Temperature-Data/issues/3) | FFT peak index reported as frequency | Medium |
| [QA-04](https://github.com/SatishSwami/Motor-Fault-Detection-and-Analysis-using-Acoustic-Current-and-Temperature-Data/issues/4) | Non-reproducible train-test split | Medium |
| [QA-05](https://github.com/SatishSwami/Motor-Fault-Detection-and-Analysis-using-Acoustic-Current-and-Temperature-Data/issues/5) | Inconsistent feature extraction | High |

Each issue includes problem description, 5-Why root cause analysis, severity and corrective action.

## 11. Testing Evidence

The following tests were performed:

| Test | Input / Scenario | Observed Result |
|---|---|---|
| 1 | AC motor – Normal_0.mat | HEALTHY |
| 2 | AC motor – IR_1.mat | ABNORMAL |
| 3 | Invalid motor choice (11) | Invalid choice message displayed |
| 4 | Dataset generation | 51 samples generated |
| 5 | Model evaluation | 50% accuracy |

The abnormal motor test also produced a Mechanical Fault classification after simulated temperature and current values were entered. This does not independently validate the physical fault subtype.

## 12. Project Planning and Tracking

GitHub Projects is used to organize QA tasks through three workflow stages:

- **Todo:** Issues identified and awaiting work.
- **In Progress:** Issues currently being investigated or corrected.
- **Done:** Issues with verified completed solutions.

[View QA Project Board](https://github.com/users/SatishSwami/projects/1/views/1)

## 13. Future Improvements

- Improve model accuracy using a larger and balanced dataset.
- Implement reproducible training and testing.
- Convert FFT indices into actual frequency values.
- Standardize feature extraction across training and runtime.
- Establish verified DC motor fault labels.
- Validate the GUI and Excel reporting workflow.
- Integrate real-time sensor data and IoT monitoring.

## 14. Disclaimer

This project is an academic prototype developed for learning and experimentation. The current model has limited evaluation performance and should not be used as a production industrial safety or predictive maintenance system without further validation.

## 15. Author and Institution

**Institution:** MIT Academy of Engineering (MITAOE), Alandi, Pune

**Project:** Motor Fault Detection and Analysis Using Acoustic, Current and Temperature Data

**Repository Owner:** [SatishSwami](https://github.com/SatishSwami)
