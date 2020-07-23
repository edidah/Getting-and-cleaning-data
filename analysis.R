#load the dplyr package into the environment
library(dplyr)
#download the data into R using the download.file function
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")
#unzip the downloaded file
unzip(zipfile = "./data/Dataset.zip",exdir = "./data")
#get the list of all files
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files
#load the necessary data(Subject, feature and activity data to be used)
Fea_testx_data <- read.table(file.path(path_rf, "test" , "x_test.txt" ),header = FALSE)
Fea_trainx_data <- read.table(file.path(path_rf, "train", "x_train.txt"), header =FALSE)
Act_testy_data <- read.table(file.path(path_rf, "test", "y_test.txt"), header = FALSE)
Act_trainy_data <- read.table(file.path(path_rf, "train", "y_train.txt"), header = FALSE)
subjectdata <- read.table(file.path(path_rf,"test", "subject_test.txt"), header = FALSE)
subject_train <- read.table(file.path(path_rf, "train", "subject_train.txt"), header = FALSE)
#explore the features of the datasets obtained above using the str function
str(Fea_testx_data)
str(Fea_trainx_data)
str(Act_testx_data)
str(Act_testy_data)
str(subjectdata)
str(subject_train)
#merge the train and test data into one 
#concate by rows
dataSubject <- rbind(subject_train, subjectdata)
dataActivity<- rbind(Act_testy_data, Act_trainy_data)
dataFeatures<- rbind(Fea_testx_data, Fea_trainx_data)
#set variables to names
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
#merge by rows
Combinedata <- cbind(dataSubject, dataActivity)
Merged <- cbind(dataFeatures, Combinedata)

#subset name of features by measurements
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
#subset dataframe by selected namee of features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Merged,select=selectedNames)
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
head(Data$activity,30)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
