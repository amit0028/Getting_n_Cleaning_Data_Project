
#### Getting and Cleaning Data Week-4 Assignment


## downloading data from given url



if (!file.exists("./data")) {dir.create("./data")}
fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile="./data/Dataset.zip")


# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Creating Training Datasets
xtrain=read.table("D:/amit/cleaning_data/data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
head(xtrain)
str(xtrain)


ytrain=read.table("D:/amit/cleaning_data/data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

subject_train=read.table("D:/amit/cleaning_data/data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

##### Creating Test Datasets
xtest=read.table("D:/amit/cleaning_data/data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
head(xtest)
str(xtest)


ytest=read.table("D:/amit/cleaning_data/data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

subject_test=read.table("D:/amit/cleaning_data/data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

#Create the features dataset
features= read.table("D:/amit/cleaning_data/data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

#Create activity datasset
activityLabels = read.table("D:/amit/cleaning_data/data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

#### Tagging Train and Test Datasets 

#Create Sanity and Column Values to the Train Data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

#Create Sanity and column values to the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')


#Merging the train and test data - important outcome of the project
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)


#### 1. Merges the training and the test sets to create one data set.

final_mrg_ds = rbind(mrg_train, mrg_test)
head(final_mrg_ds)
str(final_mrg_ds)

###2. Extracts only the measurements on the mean and standard deviation for each measurement.


#  read all the values that are available
colNames = colnames(final_mrg_ds)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
final_mean_std <- final_mrg_ds[ , mean_and_std == TRUE]
head(final_mean_std)
summary(final_mean_std)

####3. Uses descriptive activity names to name the activities in the data set

final_with_activity_names = merge(final_mean_std, activityLabels, by='activityId', all.x=TRUE)

# 4. Create final tidy dataset 
final_ds <- aggregate(. ~subjectId + activityId, final_with_activity_names, mean)
final_ds <- final_ds[order(final_ds$subjectId, final_ds$activityId),]

str(final_ds)

names(final_ds)


############## Output of final tidy dataset into flat file

write.table(final_ds, "final_ds.txt", row.name=FALSE)

