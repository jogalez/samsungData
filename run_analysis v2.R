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
analysis <- function(){
        #set working directory
        setwd("/Users/jonathangarcia/Documents/jonathan/learning/r/GettingAndCleaningData/project/UCI HAR Dataset")
        
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
        
        ## Dataset
        x_train <- read.table("./train/X_train.txt")
        x_train <- tbl_df(x_train) ## dim 7352, 561
        y_train <- read.table("./train/y_train.txt")
        y_train <- tbl_df(y_train) ## dim 7352, 1
        
        ## Test data
        x_test <- read.table("./test/X_test.txt")
        x_test <- tbl_df(x_test) ## dim 2947, 561
        y_test <- read.table("./test/y_test.txt")
        y_test <- tbl_df(y_test) ## dim 2947, 1
        
        #load subjects data
        subjectTrain <- read.table("./train/subject_train.txt")

        subjectTest <- read.table("./test/subject_test.txt")

        
        activityLabels <- read.table("activity_labels.txt")
        
        #load features
        features <- read.table("features.txt", col.names = c("index", 'featureName'))
  
        
        ## 1. Merges the training and the test sets to create one data set.
        test <- bind_cols(x_test, y_test, subjectTest)
        names(test)[c(562, 563)] <- c("activity", "subject")
        
        train <- bind_cols(x_train, y_train, subjectTrain)
        names(train)[c(562, 563)] <- c("activity", "subject")
        
        oneDataSet <- bind_rows(test, train)
        names(oneDataSet)[c(1:561)] <- as.vector(features[,2])
        
        remove(x_test, y_test, subjectTest
               ,x_train, y_train, subjectTrain)
        
        ## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
        oneDataSet <- select(oneDataSet, grep("mean()",names(oneDataSet),fixed=T)
                             , grep("std()", names(oneDataSet), fixed = TRUE)
                             , activity, subject)
        
        ## 3. Uses descriptive activity names to name the activities in the data set
        oneDataSet<-merge(oneDataSet, activityLabels, by.x="activity", by.y="V1") %>%
                select(-activity) 
        
        names(oneDataSet)[68]<-"activity"
        
        ## 4. Appropriately labels the data set with descriptive variable names.
        
        names(oneDataSet)[c(grepl("BodyBody", names(oneDataSet), fixed =T))]<-c(
                "fBodyAccJerkMag-mean()", "fBodyGyroMag-mean()" , "fBodyGyroJerkMag-mean()", "fBodyAccJerkMag-std()",
                "fBodyGyroMag-std()","fBodyGyroJerkMag-std()" )
        
        ## 5. From the data set in step 4, creates a second, independent tidy data set with 
        ##    the average of each variable for each activity and each subject.
        oneDataSet<-melt(oneDataSet, id=c("subject","activity"))
        oneDataSet<-dcast(oneDataSet,formula=activity+subject~...,mean)
    
        write.table(oneDataSet, file = "tidyData v2.txt", row.names = FALSE)
        
        
        return(oneDataSet)
        
}