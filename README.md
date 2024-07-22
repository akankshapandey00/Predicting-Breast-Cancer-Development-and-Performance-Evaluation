# Predicting Breast Cancer: Development and Performance Evaluation

**Author:** Akanksha Pandey  
**Date:** 2023-10-03

---

## Overview

This project involves developing a predictive model for breast cancer using the Wisconsin Breast Cancer dataset. The analysis includes data preparation, exploration, modeling, and evaluation. The primary goal is to classify tumors as malignant or benign based on various features.

## Libraries Used

The following R libraries are used in this analysis:
- `dplyr`: Data manipulation
- `ggplot2`: Data visualization
- `class`: k-Nearest Neighbors (kNN) algorithm
- `lubridate`: Date manipulation

## 1. Predicting Breast Cancer

### 1.1. Data Loading and Preparation

The dataset is loaded from a CSV file, and the ID column is dropped to prevent overfitting.

### 1.2. Analysis of Data Distribution

The distribution of the `radius_mean` feature is analyzed using a histogram with an overlaid normal curve.

#### Is the data reasonably normally distributed?
The data exhibits some characteristics of a normal distribution but is slightly right-skewed.

#### Why does it matter?
The assumption of normality is important in many statistical tests and methods. If the data is not normally distributed, it can affect the validity of these tests and methods.

### 1.3. Identification of Outliers

Outliers are identified using Z-scores for all numeric columns. Values more than 2.5 standard deviations from the mean are considered outliers.

### 1.4. Data Preparation

Normalization (Z-score standardization) is applied to ensure all features contribute equally to the computation of distances in algorithms like kNN.

### 1.5. Sampling Training and Validation Data

The dataset is split into training (80%) and validation (20%) sets.

### 1.6. Predictive Modeling

The k-Nearest Neighbors (kNN) algorithm is used to predict the diagnosis of a new data point. Missing values are imputed using the median of the training data.

### 1.7. Model Accuracy

The model's accuracy is evaluated by testing different values of `k` and plotting the accuracy against `k`.

## Conclusion

The accuracy of the kNN model does not significantly vary with different values of `k`, indicating a stable model performance. The model effectively classifies tumors as malignant or benign based on the provided features.

---

## File Structure

- `Wisonsin_breast_cancer.R`: The R script containing the entire analysis, including data loading, preparation, modeling, and evaluation.
- `Wisonsin_breast_cancer_data.csv`: The dataset used for analysis.

---

## References

- [UCI Machine Learning Repository - Wisconsin Breast Cancer Dataset](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic))

This README provides an overview of the analysis, including the objective, data preparation, modeling techniques, evaluation, and results. The detailed R code for each step is included in the accompanying script.
