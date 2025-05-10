
library("dplyr")
library("ggplot2")
library("class")
library("lubridate")



# 1 / Predicting Breast Cancer

data <- read.csv("/Users/a/Documents/Wisonsin_breast_cancer_data.csv")
#str(data)
#dim(data)
#summary(data)
#dropping ID 
data <- data[-1]


# 1.1 / Analysis of Data Distribution
# Plot histogram with overlaid normal curve
data %>%
  ggplot(aes(x=radius_mean)) + 
  geom_histogram(aes(y=..density..), bins=30, fill="blue", alpha=0.6) +
  stat_function(fun=dnorm, args=list(mean=mean(data$radius_mean, na.rm=TRUE), 
                                     sd=sd(data$radius_mean, na.rm=TRUE)), 
                color="black", size=1) +
  labs(title="Histogram of radius_mean with Normal Curve", 
       x="radius_mean", 
       y="Density") +
  theme_minimal()


shapiro.test(data$radius_mean)



# 1.2 / Identification of Outliers

# Calculate Z-scores for all numeric columns
z_scores <- scale(data %>% select(-diagnosis))

# Identify outliers for each column (threshold set to 2.5)
outliers <- apply(z_scores, 2, function(column) {
  return(which(abs(column) > 2.5))
})
outliers


# 1.3 / Data Preparation

# Find absolute value of z-score for each value in each column
normalize <- function(column) {
  return ((column - mean(column)) / sd(column))
}

data_normalized <- as.data.frame(lapply(data %>% select(-diagnosis), normalize))
data_normalized <- cbind.data.frame(data_normalized, diagnosis = data$diagnosis)



# 1.4 / Sampling Training and Validation Data
# Randomize (shuffle) the data
shuffled_data = data_normalized[sample(1:nrow(data_normalized)), ]

# Split the data based on the "Diagnosis" column
validation_data <- shuffled_data %>% 
  group_by(diagnosis) %>% 
  sample_frac(0.20)

# Creating training set
training_data <- anti_join(shuffled_data, validation_data)
training_data <- training_data[-31]


# 1.5 / Predictive Modeling
medians <- sapply(training_data[sapply(training_data, is.numeric)], median, na.rm = TRUE)

# New data point
new_data <- data.frame(
  Radius_mean = 14.5, Texture_mean = 17.0, Perimeter_mean = 87.5, 
  Area_mean = 561.3, Smoothness_mean = 0.098, Compactness_mean = 0.105,
  Concavity_mean = 0.085, Concave_points_mean = 0.050, Symmetry_mean = 0.180,
  Fractal_dimension_mean = 0.065, Radius_se = 0.351, Texture_se = 1.015,
  Perimeter_se = 2.457, Area_se = 26.15, Smoothness_se = 0.005, Compactness_se = 0.022,
  Concavity_se = 0.036, Concave_points_se = 0.013, Symmetry_se = 0.030,
  Fractal_dimension_se = 0.005, Radius_worst = 16.5, Texture_worst = 25.3,
  Perimeter_worst = 114.8, Area_worst = 733.5, Smoothness_worst = 0.155,
  Compactness_worst = 0.220, Concavity_worst = NA, Concave_points_worst = NA,
  Symmetry_worst = 0.360, Fractal_dimension_worst = 0.110
)

# Impute missing values
missing_cols <- which(is.na(new_data))
for (col in missing_cols) {
  new_data[1, col] <- median(training_data[[col]], na.rm = TRUE)
}

train_data <- training_data[-31]
# Standardize the Data
new_data_normalized <- as.data.frame(lapply(1:ncol(new_data), function(column) {
  return ((new_data[[column]] - mean(train_data[[column]])) / sd(train_data[[column]]))
}))


train_data <- training_data[-31]

# Predict using k-NN
predicted_diagnosis <- knn(train = train_data, test = new_data_normalized, cl = training_data$diagnosis, k=5)
predicted_diagnosis

# 1.6 / Model Accuracy
k_values <- 2:10
accuracy_values <- numeric(length(k_values))

for (i in 1:length(k_values)) {
  predictions <- knn(train = train_data, test = new_data_normalized, cl = training_data$diagnosis, k   = k_values[i])
  accuracy_values[i] <- sum(predictions == validation_data$diagnosis) / nrow(validation_data)
}

# Plotting k vs accuracy
plot(k_values, accuracy_values, type = "b", xlab = "k", ylab = "Accuracy", main = "k vs Accuracy for kNN")

