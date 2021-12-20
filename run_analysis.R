# run_analysis.R  

# 1.  Merge testing and training data

## Read in testing data
# cbind the subject, activity, and measurements into one data frame

y_test <- read.table("UCI_HAR_Dataset/test/y_test.txt")
x_test <- read.table("UCI_HAR_Dataset/test/X_test.txt")
subject_test <- read.table("UCI_HAR_Dataset/test/subject_test.txt")

combined_test <- cbind(subject_test,y_test,x_test)


## Read in training data 
# cbind the subject, activity, and measurements into one data frame

y_train <- read.table("UCI_HAR_Dataset/train/y_train.txt")
x_train <- read.table("UCI_HAR_Dataset/train/X_train.txt")
subject_train <- read.table("UCI_HAR_Dataset/train/subject_train.txt")

combined_train <- cbind(subject_train,y_train,x_train)

## rbind the test and training data 

combined_data <- rbind(combined_test,combined_train)

# 4. Label variables with descriptive names

## give a descriptive name to each column

features <- read.table("UCI_HAR_Dataset/features.txt")
colnames(combined_data) <- c("subject","activity",features$V2)

# 2. Extract the mean and standard deviation of each measurement

## extract mean and standard deviation for each measurement
# keep subject and activity

library(dplyr)
combined_data <- combined_data %>% select("subject","activity",contains("mean") | contains("std"))


# 3. Label activities with descriptive names

## recode activities to descriptive names

combined_data$subject <- as.factor(combined_data$subject)
combined_data$activity <- as.factor(combined_data$activity)

combined_data$activity <- combined_data$activity %>% recode('1' = "walking",'2' = "walk_up",'3'="walk_down",'4'="sitting",'5'="standing",'6'="laying")

# 5. Create independent tidy data set with averages per subject and per activity

## create data set with average for each variable for each activity and each subject

mean_data <- combined_data %>% 
            group_by(subject,activity) %>% 
            summarize(across(everything(),mean)) 
write.table(mean_data,file = "mean_data.txt",row.names = FALSE)
