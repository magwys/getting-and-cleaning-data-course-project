##############################################################################
# FILE
#   run_analysis.R
#
#   Using data collected from the accelerometers from the Samsung Galaxy S 
#   smartphone, work with the data and make a clean data set.
#   See README.md for details.
#

library(dplyr)

##############################################################################
# STEP 0 - Download and unzip the dataset

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}

##############################################################################
# STEP 0 - Read files

# read training data
trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainingSet <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainingLabels <- read.table(file.path(dataPath, "train", "y_train.txt"))

# read test data
testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testSet <- read.table(file.path(dataPath, "test", "X_test.txt"))
testLabels <- read.table(file.path(dataPath, "test", "y_test.txt"))

# read features, don't convert text labels to factors
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)

# read activity labels
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

##############################################################################
# Step 1 - Merge the training and the test sets to create one data set

# merge individual data tables to make one data table
dataSet <- rbind(
  cbind(trainingSubjects, trainingSet, trainingLabels),
  cbind(testSubjects, testSet, testLabels)
)

# remove individual data tables
rm(trainingSubjects, trainingSet, trainingLabels, 
   testSubjects, testSet, testLabels)

# assign column names
colnames(dataSet) <- c("subject", features[, 2], "activity")

##############################################################################
# Step 2 - Extract only the measurements on the mean and standard deviation
#          for each measurement

# determine columns of data set to keep based on column name
extractcolumns <- grepl("subject|activity|mean|std", colnames(dataSet))

# keep data in these columns only
dataSet <- dataSet[, extractcolumns]

##############################################################################
# Step 3 - Use descriptive activity names to name the activities in the data set

dataSet$activity <- factor(dataSet$activity, levels = activities[, 1], labels = activities[, 2])

##############################################################################
# Step 4 - Appropriately label the data set with descriptive variable names

# get column names
dataSetCol <- colnames(dataSet)

# remove special characters
dataSetCol <- gsub("[\\(\\)-]", "", dataSetCol)

# expand abbreviations and clean up names
dataSetCol <- gsub("^f", "frequencyDomain", dataSetCol)
dataSetCol <- gsub("^t", "timeDomain", dataSetCol)
dataSetCol <- gsub("Acc", "Accelerometer", dataSetCol)
dataSetCol <- gsub("Gyro", "Gyroscope", dataSetCol)
dataSetCol <- gsub("Mag", "Magnitude", dataSetCol)
dataSetCol <- gsub("Freq", "Frequency", dataSetCol)
dataSetCol <- gsub("mean", "Mean", dataSetCol)
dataSetCol <- gsub("std", "StandardDeviation", dataSetCol)

# correct typo
dataSetCol <- gsub("BodyBody", "Body", dataSetCol)

# use new labels as column names
colnames(dataSet) <- dataSetCol

##############################################################################
# Step 5 - Create a second, independent tidy set with the average of each
#          variable for each activity and each subject

# group by subject and activity and summarise using mean
dataSetMeans <- dataSet %>% 
  group_by(subject, activity) %>%
  summarise_all(mean)

# output to file "tidy_data.txt"
write.table(dataSetMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)