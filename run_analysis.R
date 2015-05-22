#Note that the file paths assume that the working directory is set via setwd() to  "UCI.HAR.Dataset"
#Import train data and cbind data sets together.
subject.train<-read.table("./train/subject_train.txt")
x.train<-read.table("./train/x_train.txt")
y.train<-read.table("./train/y_train.txt")
train<-cbind(subject.train,x.train,y.train)
#Import test data and cbind data sets together.
subject.test<-read.table("./test/subject_test.txt")
x.test<-read.table("./test/x_test.txt")
y.test<-read.table("./test/y_test.txt")
test<-cbind(subject.test,x.test,y.test)
#rbind the test and train sets together to form the full data set.
data<-rbind(test,train)
#Identify the column names from features, filter out the names and put into proper format for grep.
col.names<-read.table("features.txt")
col.names<-col.names[,2]
col.names<-as.character(col.names)
#Use grep to find *indices* of the column names that have "mean" and "std" and bind together to find their (set) union.
mean.col<-grep("-mean()",x=col.names,fixed=TRUE)
std.col<-grep("-std()",x=col.names,fixed=TRUE)
all.col<-c(mean.col,std.col)
all.col<-all.col+1 #since cbind affixed subject to the left of the data set, need to shift indices by 1.
#filter out the columns to leave behind only the first column (subject), last column (activity), mean and std columns.
data1<-data[,c(1,all.col,ncol(data))]
#We need the revalue command from plyr, so load that package. If you don't have plyr, uncomment the next line. 
#install.packages(plyr)
library(plyr)
#The revalue command requires *factors*, not integers, so we first coerce the far-right column of the data frame to be factors.
data1[,ncol(data1)]<-as.factor(data1[,ncol(data1)])
#Now we use the revalue command to change numbers to descriptors.
revalue(data1[,ncol(data1)],c("1"="WALKING"))->data1[,ncol(data1)]
revalue(data1[,ncol(data1)],c("2"="WALKING_UPSTAIRS"))->data1[,ncol(data1)]
revalue(data1[,ncol(data1)],c("3"="WALKING_DOWNSTAIRS"))->data1[,ncol(data1)]
revalue(data1[,ncol(data1)],c("4"="SITTING"))->data1[,ncol(data1)]
revalue(data1[,ncol(data1)],c("5"="STANDING"))->data1[,ncol(data1)]
revalue(data1[,ncol(data1)],c("6"="LAYING"))->data1[,ncol(data1)]
#Find names of columns in data1. Since we added one to the index last time, need to subtract one now.
all.col.names<-col.names[all.col-1]
colnames(data1)<-c("Subject",all.col.names,"Activity")
#We will need the dplyr package to call the next command. If you don't have dplyr, uncomment the next line.
#install.packages(dpyr)
library(dplyr)
#Group the data set by subject & activity and summarize each variable by the mean, as required.
data2<-group_by(data1, Subject, Activity) %>% summarise_each(funs(mean))
#Prints the resulting data set, as required.
print(data2)
write.table(data2,"table.txt")