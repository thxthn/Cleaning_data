fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "dataset.zip", method = "libcurl")
unzip("dataset.zip")
Subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- subject_train <- read.table("UCI HAR Dataset/train/y_train.txt")
Subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

## Merging the data sets 
subject <- rbind(Subject_train,Subject_test)
activity <- rbind(y_train,y_test)
data <- rbind(x_train,x_test)
mergedData <- cbind(data,subject,activity)
colnames(mergedData) <-c(as.character(features$V2),"subject","activity")


## Extracts only the measurements on the mean and standard deviation
## for each measurement
extractedFeatures <- features[grep("-mean\\(\\)|-std\\(\\)",features[,2]),2]
extractedMeasurements <- c(as.character(extractedFeatures),"subject","activity")
Data <- mergedData[,extractedMeasurements]

## Adding descriptive activity names 
Data$activity <- activity_labels[match(Data$activity,activity_labels[,1]),2]

## Label all variables with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


## Create a second, independent tidy data set with the average of each variable 
## for each activity and each subject
tidyData <- aggregate(.~ subject + activity,Data,mean,na.rm=T)
tidyData <- tidyData[order(tidyData$subject,tidyData$activity),]

## Write out data to table
write.table(tidyData, file = "tidydata.txt",row.name=FALSE)