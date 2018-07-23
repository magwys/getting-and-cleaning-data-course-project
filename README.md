# getting-and-cleaning-data-course-project
Course Project for Coursera "Getting and Cleaning Data"

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

This repository contains the following files:

1. README.md, this file, which provides an overview of the data set and how it was created.
2. tidy_data.txt, which contains the data set.
3. CodeBook.md, the code book, which describes the contents of the data set (data, variables and transformations used to generate the data)
4. run_analysis.R, the R script that was used to create the data set

This script requires the dplyr package.

The R script, run_analysis.R, does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
6. The end result is shown in the file tidy.txt.
