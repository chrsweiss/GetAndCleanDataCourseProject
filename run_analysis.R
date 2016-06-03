library(dplyr)

path <- getwd()

features <- read.table(paste0(path,"features.txt"))
activity_labels <- read.table(paste0(path,"activity_labels.txt"))
y_train <- read.table(paste0(path,"train\\y_train.txt"))
X_train <- read.table(paste0(path,"train\\X_train.txt"))
y_test <- read.table(paste0(path,"test\\y_test.txt"))
X_test <- read.table(paste0(path,"test\\X_test.txt"))
subject_train <- read.table(paste0(path,"train\\subject_train.txt"))
subject_test <- read.table(paste0(path,"test\\subject_test.txt"))


features <- tbl_df(features)
activity_labels <- tbl_df(activity_labels)
y_train <- tbl_df(y_train)
X_train <- tbl_df(X_train)
y_test <- tbl_df(y_test)
X_test <- tbl_df(X_test)

# merge the two datasets together
all_data <- tbl_df(rbind(X_train, X_test))
colnames(all_data) <- as.vector(features$V2)

# extract only variables associated with the mean and stdev,
# and then recombine them into one df, output_data
mean_data <- all_data[,grepl("mean\\(\\)",names(all_data))]
stdev_data <- all_data[,grepl("std\\(\\)",names(all_data))]

output_data <- cbind(mean_data, stdev_data)

# add the activity labels to the output data
y_labels <- rbind(y_train, y_test)
output_data <- cbind(output_data, y_labels)
colnames(output_data)[67] <- "classlabel"
colnames(activity_labels) <- c("classlabel","activityname")

# pull in the activity names to the main dataset
output_data <- left_join(output_data,activity_labels)
output_data <- select(output_data, -classlabel)

# add the subject identifier to the main dataset
subject <- rbind(subject_train, subject_test)
output_data <- cbind(output_data, subject)
colnames(output_data)[68] <- "subject"

rm("activity_labels","all_data","features","mean_data","stdev_data")
rm("y_labels","X_test","X_train","y_test","y_train")
rm("subject_test","subject_train","subject")

# clean up the column names
colnames(output_data) <- tolower(colnames(output_data))
colnames(output_data) <- gsub("\\(\\)","",names(output_data))
colnames(output_data) <- gsub("-","",names(output_data))
colnames(output_data) <- gsub("^t","time",names(output_data))
colnames(output_data) <- gsub("^f","freq",names(output_data))

# This is the output local dataframe
output_data <- tbl_df(output_data)

# This is the output local dataframe summarized by subject and activity name
grouped_output_data <- output_data %>% 
                       group_by(subject, activityname) %>%
                       summarise_each(funs(mean))
