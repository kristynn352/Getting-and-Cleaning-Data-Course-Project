#################Merges the training and the test sets##################

##Load in test and training datasets for x variables, turn into one dataset
x_test <- read.table("test/X_test.txt")
x_train <- read.table("train/X_train.txt")
x_total <- rbind(x_test,x_train)

##Load in test and traning datasets for y variables, turn into one dataset
y_test <- read.table("test/y_test.txt")
y_train <- read.table("train/y_train.txt")
y_total <- rbind(y_test,y_train)
names(y_total)<- "activity"

##Load in test and training datasets for subject variables, turn into one dataset
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
subject <- rbind(subject_test,subject_train)
names(subject) <- "Subject"

################ Appropriately labels the data set with descriptive variable names. ##################

##Read in variable names for "x" variable
features <- read.table("features.txt")
features <- features[,2]

## name X variables in dataset
names(x_total)<-features

###read in activity lables

activities <- read.table("activity_labels.txt")

#################Extracts only the measurements on the mean and standard deviation for each measurement. #################33

#subset any variable with "mean()" in the variable name
x_sub_mean <- x_total[,grep("mean()",names(x_total), value=TRUE)]

#subset any variable with "mean()" in the variable name
x_sub_std <- x_total[,grep("std()",names(x_total), value=TRUE)]

################## Merge total dataset##########################

fitdata <- cbind(subject, y_total, x_sub_mean, x_sub_std)
fitdata$Subject <- factor(fitdata$Subject)

################## Uses descriptive activity names to name the activities in the data set##################

fitdata$activity <- factor(fitdata$activity, levels=activities[,1], labels=as.character(activities[,2]))

################## From the data set created, creates a second, independent tidy data set with the average of each variable for each activity and each subject.###

aggfitdata <- ddply(fitdata[,3:81], .(fitdata$Subject, fitdata$activity), numcolwise(mean))
