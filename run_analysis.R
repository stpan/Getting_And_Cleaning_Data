setwd("./Education/Data_Science/3_Getting and Cleaning Data/Project/")

# 1. Merge the training and the test sets to create one data set
subj_train<-read.table("./subject_train.txt")
X_train<-read.table("./X_train.txt")
Y_train<-read.table("./y_train.txt")
Train_data<-cbind(subj_train,X_train,Y_train)

subj_test<-read.table("./subject_test.txt")
X_test<-read.table("./X_test.txt")
Y_test<-read.table("./y_test.txt")
Test_data<-cbind(subj_test,X_test,Y_test)

Data_all<-rbind(Train_data,Test_data)
  
# 2. Extracts only the measurements on the mean and stdev for each measurement

library(dplyr)
features_names<-read.table("./features.txt", sep="")
names(Data_all)<-c("Subject",as.character(features_names$V2),"Y")
Data_all<-Data_all[,c(1,grep("mean()",colnames(Data_all),fixed=TRUE),grep("std()",colnames(Data_all)),dim(Data_all)[2])]

# 3. Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table("./activity_labels.txt", sep="")
Data_all<-merge(Data_all,activity_labels,by.x="Y",by.y="V1", all.x=TRUE)

# 4.  Appropriately labels the data set with descriptive variable names

## This is already done in the line: names(Data_all)<-c(as.character(features_names$V2),"Y")
#rename(Data_all,activity = V2)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
Data_all<-Data_all[,-1]
Data_all$Subject <- factor(Data_all$Subject)
mData_all<-melt(Data_all, id.vars=c("Subject","V2"))
Data_tidy<-dcast(mData_all,Subject + V2~variable, mean)
write.table(Data_tidy,file = "./Data_tidy_output.txt",row.names=FALSE)

