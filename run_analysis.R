
# set your working directory
# e.g. setwd("C:/Users/David/Desktop/Coursera")

# check required packages are installed and available
library(dplyr)
library(reshape)

#create a folder in your working directory to download the data into 
if(!file.exists("./rawdata")) {dir.create("./rawdata")}

# download the zip file containing all the data into a folder called accelerometer.zip in the wd
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="./rawdata/accelerometer.zip", mode="wb") #WARNING : is 59.7Mb

###EXTRACT TEST DATA INTO ONE DF

#unzip and read in the required data objects into R environment
df1 <- read.table(unz("./rawdata/accelerometer.zip", "UCI HAR Dataset/test/subject_test.txt"))
df2 <- read.table(unz("./rawdata/accelerometer.zip", "UCI HAR Dataset/test/X_test.txt"))
df3 <- read.table(unz("./rawdata/accelerometer.zip", "UCI HAR Dataset/test/y_test.txt"))

#rename the vectors containing subject and activity information
df1 <- rename(df1, subject=V1)
df3 <- rename(df3, activity=V1)
#make a new vector that will id each observation as being from the test set
nr <- nrow(df1)
set <- as.character(rep("test", nr))
#combine all the tetst set data into one df
test <- cbind(df2, set, df1, df3)


##NOW DO SAME FOR THE TRAINING SET DATA

#unzip and read in the required data objects into R environment
df1 <- read.table(unz("./rawdata/accelerometer.zip", "UCI HAR Dataset/train/subject_train.txt"))
df2 <- read.table(unz("./rawdata/accelerometer.zip", "UCI HAR Dataset/train/X_train.txt"))
df3 <- read.table(unz("./rawdata/accelerometer.zip", "UCI HAR Dataset/train/y_train.txt"))

#rename the vectors containing subject and activity information
df1 <- rename(df1, subject=V1)
df3 <- rename(df3, activity=V1)
#make a new vector that will id each observation as being from the test set
nr <- nrow(df1)
set <- as.character(rep("train", nr))
#combine all the training set data into one df
train <- cbind(df2, set, df1, df3)

#combine training and tets set data into one df called "merged"
identical((names(test)), (names(train))) #check is TRUE
merged <- rbind(test, train)

#clear unneeded objects from environmnet to free memory
rm(df1, df2, df3, test, train, fileURL, nr, set)


###remove variables which are not mean or s.d. measures

# assume order of variables in data is same as order of variable names in features.txt file,
# import them as a vector and use to rename columns in "merged" accordingly
vars <- read.table(unz("./rawdata/accelerometer.zip", "UCI HAR Dataset/features.txt"))
vars <- as.character(vars[ ,2])

for(i in 1:561) {
  names(merged)[i] <- vars[i]
}

# subset the merged df to include only columns which are:
# 1. variables which are measurements on mean
# 2. variables which are measurements on s.d.
# 3. set, subject, activity columns

df1 <- merged[ ,grepl("mean", colnames(merged))]
df2 <- merged[ ,grepl("std", colnames(merged))]
df3 <- merged[ ,c(562:564)]

merged2 <- cbind(df3, df1, df2)

rm(df1, df2, df3, merged, i, vars)


### give activities descriptive entries based on the code book file at 
# read.table(unz("./rawdata/accelerometer.zip", "UCI HAR Dataset/activity_labels.txt"))

nr <- nrow(merged2)
for(i in 1:nr) {
  if(merged2$activity[i] == 1) merged2$activity[i] <- "walking"
  if(merged2$activity[i] == 2) merged2$activity[i] <- "walking upstairs"
  if(merged2$activity[i] == 3) merged2$activity[i] <- "walking downstairs"
  if(merged2$activity[i] == 4) merged2$activity[i] <- "sitting"
  if(merged2$activity[i] == 5) merged2$activity[i] <- "standing"
  if(merged2$activity[i] == 6) merged2$activity[i] <- "laying"
}

### create new tidy dataset of summary measures (mean of each measure, by subject + activity)
# each row is a different observation identified by subjcet and activity

merged2 <- merged2[ ,c(2:82)]
merged2$subject <- as.factor(merged2$subject)
merged2$activity <- as.factor(merged2$activity)

md <- melt(merged2, id=c("subject", "activity"))
newdf <- cast(md, subject + activity ~ variable, mean)


### write the tidy (ish!) new df to the working directory
write.table(newdf, file="coursework.newdf.txt", row.name=FALSE)

