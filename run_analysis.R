## steps to collect, work and clean data from Samsung Galaxy S Smartphone
## working directory should be set on a new UCI HAR Dataset directory

##Getting and Cleaning data Course project
##You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with 
##    the average of each variable for each activity and each subject.

run_analysis <- function(){
        ## Libraries
        if (!"data.table" %in% installed.packages()) {install.packages("data.table")}
        if (!"reshape2" %in% installed.packages()) {install.packages("reshape2")}
        if (!"tidyr" %in% installed.packages()) {install.packages("tidyr")}
        if (!"dplyr" %in% installed.packages()) {install.packages("dplyr")}
        if (!"readr" %in% installed.packages()) {install.packages("readr")}
        
        library("data.table")
        library("tidyr")
        library("reshape2")
        library("dplyr")
        library("readr")
        
        ## 1. Merges the training and the test sets to create one data set.
                ## Train data
                x_train <- read.table("./train/X_train.txt")
                x_train <- tbl_df(x_train) ## dim 7352, 561
                y_train <- read.table("./train/y_train.txt")
                y_train <- tbl_df(y_train) ## dim 7352, 1
                
                ## Test data
                x_test <- read.table("./test/X_test.txt")
                x_test <- tbl_df(x_test) ## dim 2947, 561
                y_test <- read.table("./test/y_test.txt")
                y_test <- tbl_df(y_test) ## dim 2947, 1
                
                ## row bind training and test data
                oneDataSet <- bind_rows(x_train, x_test)
                
                res <- oneDataSet
                
        ## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
                #load features
                features <- read.table("features.txt", col.names = c("index", 'featureName'))
                features <- tbl_df(features)
                #extract only mean and std
                measurements <- grep("(mean()|std())", select(features, featureName))
                oneDataSet <- oneDataSet[, measurements]
                
                res <- oneDataSet
                
        ## 4. Appropriately labels the data set with descriptive variable names.
                ## Assign label to features
                #delete special characters
                gsubFeatureNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
                names(oneDataSet) <- gsubFeatureNames[measurements]
                
                #load subjects data
                subjectTrain <- read.table("./train/subject_train.txt")
                subjectTrain <- tbl_df(subjectTrain) 
                subjectTest <- read.table("./test/subject_test.txt")
                subjectTest <- tbl_df(subjectTest) 
                
                #row bind subject data
                subject  <- bind_rows(subjectTest, subjectTrain)
                names(subject) <- 'subject'
                
                #row bind measure to by analyze
                activity <- bind_rows(y_train, y_test)
                names(activity) <- 'activity'
                
                #binding all 
                oneDataSet <- bind_cols(subject, activity, oneDataSet)
                
                res <- oneDataSet
        
        ## 3. Uses descriptive activity names to name the activities in the data set
                #assing activity names to dataset
                activityGroup <- factor(oneDataSet$activity)
                activityLabels <- read.table("activity_labels.txt")
                levels(activityGroup) <- activityLabels[,2]
                oneDataSet <- mutate(oneDataSet, activity = activityGroup)
                
                res <- oneDataSet
            
        ## 5. From the data set in step 4, creates a second, independent tidy data set with     
        ##    the average of each variable for each activity and each subject.
                #reshaping to tidy data
                pivotFeature <- melt(oneDataSet,(id.vars=c("subject","activity")))
                unpivotFeature <- dcast(pivotFeature, subject + activity ~ variable, mean)
                
                write.table(unpivotFeature, "tidyData.txt", row.names = FALSE)
        
}