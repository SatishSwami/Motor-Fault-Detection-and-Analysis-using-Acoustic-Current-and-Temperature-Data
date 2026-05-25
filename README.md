# 🚀 Real-Time Motor Fault Detection System using DSP and Lightweight Machine Learning

## 📌 Overview

This project presents a **runtime motor fault detection and early warning system** using **Digital Signal Processing (DSP)** and **lightweight machine learning** techniques.

The system analyzes multiple motor-related signals:

- 🔊 Acoustic Signal
- ⚡ Motor Current Signal
- 🌡 Temperature Input

The project is designed for **industrial predictive maintenance applications**, where early fault detection helps reduce unexpected failures and maintenance cost.

---

# ✨ Key Features

✅ Runtime Motor Fault Detection  
✅ DSP-Based Signal Preprocessing  
✅ FFT Frequency Spectrum Analysis  
✅ Multi-Feature Extraction  
✅ Lightweight KNN Classification  
✅ Hybrid ML + Threshold Decision Logic  
✅ Multi-Motor Support  
✅ GUI-Based Monitoring Dashboard  
✅ Automatic Excel Report Generation  

---

# ⚙️ Supported Motor Types

- AC Motor
- DC Motor
- BLDC Motor
- Servo Motor
- Synchronous Motor

---

# 🧠 DSP Operations Used

The project uses several DSP techniques:

- DC Offset Removal
- Moving Average Filtering
- Signal Normalization
- Fast Fourier Transform (FFT)
- RMS Calculation
- Mean Calculation
- Standard Deviation
- Signal Energy Analysis

---

# 🏗️ System Workflow

```text
Raw Signal Input
        ↓
Signal Preprocessing
        ↓
Feature Extraction
        ↓
FFT Analysis
        ↓
KNN Classification
        ↓
Threshold Validation
        ↓
Fault Detection
        ↓
GUI Display & Excel Report
```

---

# 🤖 Machine Learning Logic

The project uses a lightweight nearest-neighbor KNN approach for abnormality detection.

### Feature Vector Used

```matlab
[rms_value, peak_frequency, mean_value, std_value, energy_value]
```

### Decision Logic

The final decision combines:

1. KNN abnormality prediction
2. Feature threshold validation

This hybrid approach improves runtime reliability and reduces missed fault conditions.

---

# ⚠️ Fault Types Detected

- ✅ Healthy Condition
- 🔧 Mechanical Fault
- 🌡 Overheating Fault
- ⚡ Overload Fault

---

# 📂 Project Structure

```text
Motor-Fault-Detection-System/
│
├── create_dataset.m
├── train_model.m
├── run_system.m
├── MotorFaultDetectionUI.m
├── store.m
│
├── final_dataset.mat
├── trained_model.mat
│
├── Motor_Fault_Results_Report.xlsx
│
└── README.md
```

---

# ▶️ Execution Flow

## Step 1 — Create Dataset

Run:

```matlab
create_dataset.m
```

This file:
- Loads raw datasets
- Performs preprocessing
- Extracts DSP features
- Creates labeled dataset

---

## Step 2 — Train Model

Run:

```matlab
train_model.m
```

This performs:
- Train/Test split
- Lightweight KNN training
- Model evaluation
- Saves trained model

Output:

```text
trained_model.mat
```

---

## Step 3 — Runtime Detection

Run:

```matlab
run_system.m
```

This performs:
- Runtime signal analysis
- Feature extraction
- KNN classification
- Fault detection

---

## Step 4 — Launch GUI

Run:

```matlab
MotorFaultDetectionUI.m
```

GUI Features:
- Signal Upload
- FFT Visualization
- Motor Status Display
- Fault Classification
- Interactive Dashboard

---

## Step 5 — Generate Excel Report

Run:

```matlab
store.m
```

Output:

```text
Motor_Fault_Results_Report.xlsx
```

---

# 📊 Model Performance

| Metric | Value |
|---|---|
| Accuracy | 70% |
| Recall | 100% |
| F1 Score | 0.73 |

The system prioritizes **high fault sensitivity** to avoid missing critical motor failures.

---

# 🖥️ GUI Features

- Industrial-Style Dashboard
- Motor Type Selection
- Signal Upload System
- FFT Visualization
- Feature Display Panel
- Healthy / Fault Status
- Early Warning Alerts
- Fault Classification Output

---

# 🛠 Technologies Used

- MATLAB
- Digital Signal Processing (DSP)
- FFT Analysis
- KNN Classification
- Signal Processing Toolbox
- MATLAB GUI Development

---

# 🏭 Industrial Relevance

This project is inspired by real-world industrial predictive maintenance systems used in:

- Manufacturing Industries
- Smart Maintenance Systems
- Industrial Automation
- Condition Monitoring Platforms
- Motor Health Monitoring Systems

The project demonstrates how lightweight DSP and ML techniques can enable low-cost runtime fault monitoring.

---

# 🔮 Future Scope

Future improvements may include:

- Real-Time Sensor Streaming
- IoT Integration
- Cloud Monitoring
- Deep Learning-Based Classification
- Mobile Application Support
- Advanced Spectral Analysis

---

# 👨‍💻 Team Information

### Project Title
**Real-Time Motor Fault Detection System using DSP and Lightweight Machine Learning**

### Institution
MIT Academy of Engineering (MITAOE)

### Department
Electronics & Communication Engineering

---

# 📌 Disclaimer

This project is developed for academic and research purposes. The current implementation uses lightweight DSP and ML techniques for educational demonstration of motor fault detection concepts.
