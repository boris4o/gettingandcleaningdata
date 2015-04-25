#load the libraries needed
library(dplyr)
library(data.table)
library(tidyr)

#Download the data
filesPath <- "C:\\Users\\Boris\\Desktop\\getDataFinal"
setwd(filesPath)
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#unzip the data in /data folder
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Create data  tables for the files
#it's easier to directly write the path in Windows
dataSubjectTrain <- tbl_df(read.table("C:\\Users\\Boris\\Desktop\\getDataFinal\\data\\UCI HAR Dataset\\train\\subject_train.txt"))
dataSubjectTest  <- tbl_df(read.table("C:\\Users\\Boris\\Desktop\\getDataFinal\\data\\UCI HAR Dataset\\test\\subject_test.txt"))

dataActivityTrain <- tbl_df(read.table("C:\\Users\\Boris\\Desktop\\getDataFinal\\data\\UCI HAR Dataset\\train\\y_train.txt"))
dataActivityTest  <- tbl_df(read.table("C:\\Users\\Boris\\Desktop\\getDataFinal\\data\\UCI HAR Dataset\\test\\y_test.txt"))

dataTrain <- tbl_df(read.table(file.path("C:\\Users\\Boris\\Desktop\\getDataFinal\\data\\UCI HAR Dataset\\train\\X_train.txt")))
dataTest  <- tbl_df(read.table("C:\\Users\\Boris\\Desktop\\getDataFinal\\data\\UCI HAR Dataset\\test\\X_test.txt"))

#merge the training and the test sets to create one data set.
alldataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(alldataSubject, "V1", "subject")
alldataActivity<- rbind(dataActivityTrain, dataActivityTest)
setnames(alldataActivity, "V1", "activityNum")

#combine the train and test sets
dataTable <- rbind(dataTrain, dataTest)

#name the variables according to a feature
dataFeatures <- tbl_df(read.table("C:\\Users\\Boris\\Desktop\\getDataFinal\\data\\UCI HAR Dataset\\features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName

#column names for activity labels
activityLabels<- tbl_df(read.table("C:\\Users\\Boris\\Desktop\\getDataFinal\\data\\UCI HAR Dataset\\activity_labels.txt"))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

#merge the columns
alldataSubjAct<- cbind(alldataSubject, alldataActivity)
dataTable <- cbind(alldataSubjAct, dataTable)

#read features.txt and take only mean and sd
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)

#take only mean and sd and add subject and activity number
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTable<- subset(dataTable,select=dataFeaturesMeanStd) 

#enter the names of the activities into dataTable
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)

#create dataTable with variable means sorted by subject and activity
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean) 
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

#check names before
head(str(dataTable),2)

#rename
names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))

#check names after
head(str(dataTable),6)

#export

write.table(dataTable, "TidyData.txt", row.name=FALSE)