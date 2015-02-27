# Course project for Getting & Cleaning Data
# Coursera.org
# David Boorman 22 Feb. 2015

# Description of the dataset is at
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

getwd()
directory <- "C:/Users/David Boorman/Documents/R/Coursera_R/Getting_Cleaning_Data/Project"
setwd(directory)
getwd()

# Import the data
gcd.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(gcd.url, gcd.zip, mode="wd")
unzip(gcd.zip)

# File locations
X_test.file <- "C:/Users/David Boorman/Documents/R/Coursera_R/Getting_Cleaning_Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt"
y_test.file <- "C:/Users/David Boorman/Documents/R/Coursera_R/Getting_Cleaning_Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt"
subject_test.file <-"C:/Users/David Boorman/Documents/R/Coursera_R/Getting_Cleaning_Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt"

X_train.file <- "C:/Users/David Boorman/Documents/R/Coursera_R/Getting_Cleaning_Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"
y_train.file <- "C:/Users/David Boorman/Documents/R/Coursera_R/Getting_Cleaning_Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt"
subject_train.file <- "C:/Users/David Boorman/Documents/R/Coursera_R/Getting_Cleaning_Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt"

features.file <- "C:/Users/David Boorman/Documents/R/Coursera_R/Getting_Cleaning_Data/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt"


# Read files
features.a <- read.table(features.file,header=FALSE,
                         stringsAsFactors=FALSE,sep=" ")
head(features.a)
str(features.a) # data.frame, 561 observations, 2 variable

subject_test.a <- read.table(subject_test.file,header=FALSE,sep="\n")
head(subject_test.a)
str(subject_test.a) # data.frame, 2947 observations, 1 variable

subject_train.a <- read.table(subject_train.file,header=FALSE,sep="\n")
head(subject_train.a)
str(subject_train.a) # data.frame, 7352 observations, 1 variable

y_test.a <- read.table(y_test.file,header=FALSE,sep="\n")
head(y_test.a); str(y_test.a) # data frame 2947 obs. 1 var.

y_train.a <- read.table(y_train.file,header=FALSE, sep="\n")
head(y_train.a); str(y_train.a) # data.frame 7352 obs, 1 var.

# Activities Label
activities.label <- 
  data.frame(value=1:6, 
             label=c("Walking","Walking upstairs",
                     "Walking downstairs","Sitting",
                     "Standing", "Laying"))
activities.label
str(activities.label) # data.frame, 6 obs. 2 variables

# Read X_test and X_train files
X_test<-read.table(X_test.file,stringsAsFactors=FALSE)
str(X_test) # 2947 obs. with 561 variables.  All variables numeric

X_train <- read.table(X_train.file,stringsAsFactors=FALSE)
str(X_train) # 7352 obs., 561 var.

X_all <- rbind(X_test,X_train)
str(X_all) # data.frame 10299 obs., 561 var.

rm(X_test); rm(X_train) # To free up RAM
names(X_all) <- features.a[,2]

y_all <- rbind(y_test.a,y_train.a)
str(y_all) # data.frame 10299 obs, 1 var., int.

subject_all <- rbind(subject_test.a,subject_train.a)
str(subject_all) # data.frame 10299 obs, 1 var, int.

X <- cbind(X_all,subject_all,y_all)  # 10299 obs, 563 var.
rm(X_all)

# Select only columns related to mean and standard deviation
mean_std_col <- c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,
                  227:228,240:241,253:254,266:271,345:350,424:429,
                  503:504,516:517,529:530,542:543,559:563)
X <- X[,mean_std_col] # 10299 obs., 71 variables

# Create meaningful labels for y_all column
y_factor <- factor(y_all[,1], labels=activities.label[,2])
head(y_factor); tail(y_factor)
X[,71] <- y_factor

# Put a label on the subject and position columns
var <- names(X)
var[70:71] <- c("subject","position")
names(X)<-var
head(X[,69:71])

library(dplyr)

X_grouped<-group_by(X,subject,position)
var2 <- var[1:69]

# Convert subjects to a factor
X[,70]<-as.factor(X[,70])

# This works tapply(X=X[,1], INDEX=X[,"position"], FUN=mean)
# Doesn't work: tapply(X=X[,1], INDEX=X$position, X$subject, FUN=mean)
# Create a concatenated variable for subject and position
subj_pos <- paste(X$subject,X$position,sep="-")
subj_pos <- as.factor(subj_pos)
str(subj_pos);head(subj_pos)
# Tag to X variable
X <- mutate(X,subj_pos)
head(X[,69:72])

# Create row names for each 180 levels
subj_pos_order <- dimnames(tapply(X=X[,1], INDEX=X[,"subj_pos"], FUN=mean))
q<-rep(1:30,each=6)
subj_pos_order2 <- paste(q,activities.label[,2],sep="-")

# Loop through to get mean of each column by subject and position
# 30 subjects and 6 positions = 180 variables


X_summary <- as.data.frame(
  matrix(nrow=69, ncol=180),row.names=var2)
names(X_summary)<-subj_pos_order2
            
for (i in 1:length(var2)) {
  X_summary[i,] <- tapply(X=X[,i], INDEX=X[,"subj_pos"], 
                          FUN=mean)
}
head(X_summary[,1:5])

write.table(X_summary, file="X_summary.txt",quote=FALSE,
            row.names=FALSE)



