# GetAndCleanDataCourseProject

The analysis file included is the completion of the course project for Getting and Cleaning Data.

There are several input files, which are all found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You must set your local directoty to the location where you unzip this file in order for the R file to run.

There are two ouputs, which are both be stored as dataframes in the R session where the analysis is run:

output_data - This is the training and test data, with descriptive column names, and with the subject and activity added in.

grouped_output_data - This is based on the output_data df, but it is the mean of each set of data, grouped by subject and activity.
