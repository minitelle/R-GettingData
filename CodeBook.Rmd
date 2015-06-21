Course Project - CodeBook
------------------------

## Prerequisites details:

```
- All details and explanations defined below have been performed and tested using R studio Version 0.98.1103 on a MAC 10.9.5.
- The work outlined in the Codebook.rm/rmd and run_analysis.R assume that and internet connection is available to download the project necessary files.
- Several R packages have been used such as: downloader, plyr, dplyr, httr and reshape2 have been specified in the run_analysis.R file in the same directory: github.com/minitelle/R- GettingData`
- Note however that the run_analysis file includes the needed functions to download the packages if need be, you can search for the term "install.packages" and remove the "#" in the "run_analysis.R" with the install.packages() function for the above packages.
```


**The goal of this markdown file is to describe the data in the out output file *tidy_data_file.txt*, all its variables and any transformations or work that were performed running the *run_analysis.R* script.**


##Course Project : run_analysis.R

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Data Preparation -  Preliminary Steps prior to covering the project tasks in the script file run_analysis.R


```getwd()```

Confirm the working directoy you want to use for anlaysis. The most important is so no change below as we are setting a directory for the analysis.

```dir <-"./CourseProject/"
if (file.exists(dir)){
  setwd(file.path(dir))
  } else {
  dir.create(file.path(dir))
  setwd(file.path(dir))
}```

```#[1] "/Users/yourname/CourseProject" this is the confirm that the above directory "Course project" has indeed been created.```

```getwd()```

Set the file to download for analysis. The assumption is that the directory doens't already exist so this si torpovide you with the file used for the project an dhave a fresh new install.

```download_zip <- download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="project_dataset.zip", method ="curl")```

Confirm the zip file has been downloded -  the dowlonad might take sometime.

```file.exists("project_dataset.zip") #[1] TRUE```

To unzip the file the simplest is to download the downloader package. the assumption is that you do not have it.
If you don't please proceed. If you do please proceed right away to calling the library instead of starting by downloading it.

```install.packages(downloader)``` 
Only install if you have haven't installed the package before.

```library("downloader")```
The downloader package is required to unzip the file.

```unzip ("project_dataset.zip", exdir = "./")```

Call the list.dirs() and you should see the list below

```list.dirs()
#[1] "."                                        "./UCI HAR Dataset"                       
#[3] "./UCI HAR Dataset/test"                   "./UCI HAR Dataset/test/Inertial Signals" 
#[5] "./UCI HAR Dataset/train"                  "./UCI HAR Dataset/train/Inertial Signals"
```

```
Note: 
For the purposes of this project, the only files from the "./UCI HAR Dataset" folder we will use are:
*features.txt
*activity_labels.text
*/train/subject_train.txt
*/test/subject_test.txt
*/train/X_train.txt
*/test/X_test.txt
*/train/y_train.txt
*/test/y_test.txt

The files under the "/train/Inertial Signals/" or "/test/Inertial Signals/" folders will not be used.
From reading the README.txt and features_info.text files, we quickly notice after opening the above files very common aspects such as 561 measures in the features.txt file, Xtrain and Xtest files. We also gleen from the features_info.txt and activity_labels.txt that the subject_test.txt & Ytest.txt files cover the volunteers subjectIDs and the various activites that were measured from using the Samsung devices.  (The same deduction can be made looking at the train files).

We will work below on combining the files to satisfy the project.
```


Load a few R packages to complete the project. This assums these packages have already been downloaded. 
If the packages are already installed then proceed to loading the packages, no need to download them again:

```
install.packages("plyr")
install.packages("dplyr")
install.packages("httr")
```

Loading the packages step

```
library(plyr)
library(dplyr)
library(httr)
```

- train data set cbind() - Combining the the files for the train folder is our data set for 70% of the volunteers.

*Strain: represents the subjects IDs
```Strain <- read.table("./UCI HAR Dataset/train/subject_train.txt")```

*Ytrain: represents the activity label that we will map to the activity_labels.txt file
```Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")```

*Xtrain: represents the 561 measurements whose label we wil add using the features.txt info file.
```Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")```

*Combine the 3 Train files by columns with the order: Strain, Ytrain, Xtrain.*
```train_full <- cbind(Strain, Ytrain, Xtrain)``` 
```dim(train_full)```

```#[1] 7352  563```
This function confirms the number observations and variables which should be as follows:

- test data set cbind() - Combining the colums for the test folder in our data set for 30% of the volunteers.

*Stest: represents the subjects IDs
```Stest <- read.table("./UCI HAR Dataset/test/subject_test.txt")```

*Ytest: represents the activity label that we will map to the activity_labels.txt file
```Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")```

*Xtest: represents the 561 measurements whose label we wil add using the features.txt info file.
```Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")```

*Combine the 3 Test files by columns with the order: Stest, Ytest, Xtest.
```test_full <- cbind(Stest, Ytest, Xtest)```

```
dim(test_full)
#[1] 2947  563
```
This function confirms the number observations and variables which should be as follows:

#### 1. Merge the training and the test sets to create one data set for that an rbin() will suffice


```
data_full <- rbind(train_full, test_full)
dim(data_full)
```
#This is to confirm that we will have 561 variables after the first column which represents the subject IDs and a second colum for the activity labels, 563 columsn in total
# [1] 10299   563

and confirm that we have now about 10299 observations.

```str(data_full)```

```#'data.frame':  10299 obs. of  563 variables
```

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

Read the features file that includes the names of the measurements in the full data set.

```feat_labels <- read.table("./UCI HAR Dataset/features.txt")```

Assign the measurements labels to the columns in data_full

```names(data_full) <- c("SubjectID", "Activity",as.character(feat_labels[,2]))```

```
str(data_full) #This will show us the file will the names of all the variables.
#'data.frame':  10299 obs. of  563 variables:
# $ Subject ID                          : int  1 1 1 1 1 1 1 1 1 1 ...
#$ Activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
#$ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
#$ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
#$ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
#$ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
#$ tBodyAcc-std()-Y                    : 
```

Select and only keep the Mean (mean()) and Standard Deviation (str()) measurements from the rest of the measures in the features file.

```feat_mean.std <- feat_labels$V2[grep("mean\\(\\)|std\\(\\)", feat_labels$V2)]
```
Create the column name to use for te data_full data frame.

```col_mean.std <- c("SubjectID", "Activity", as.character(feat_mean.std))
```

Subset data_full data frame to only keep columns related for the Subject ID, Activity, the mean() and std() measurements as defined in col_mean.std.

```data_mean.std <- subset(data_full, select = col_mean.std)
dim(data_mean.std)
```
This will show us that we have 12099 observations and 68 variables.

OR use the str() to see the structure of the file:

```
str(data_mean.std)
#'data.frame':  10299 obs. of  68 variables:
#$ Subject ID                 : int  1 1 1 1 1 1 1 1 1 1 ...
#$ Activity                   : int  5 5 5 5 5 5 5 5 5 5 ...
#$ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...
#$ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
#$ tBodyAcc-mean()-Z          : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
#$ tBodyAcc-std()-X           : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
#$ tBodyAcc-std()-Y           : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
#$ tBodyAcc-std()-Z           : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
#$ tGravityAcc-mean()-X       : num  0.963 0.967 0.967 0.968 0.968 ...
#$ tGravityAcc-mean()-Y       : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
#$ tGravityAcc-mean()-Z       : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
#$ tGravityAcc-std()-X        : num  -0.985 -0.997 -1 -0.997 -0.998 ...
#...
```

#### 3. Use descriptive activity names to name the activities in the data set

Read the activity txt file and set it into a variable activity_labels.

```activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names=c("id", "name"))
dim(activity_labels) #Using this function will show you that the file include 2 variables
V1 with the activity ids while V2 includes the 6 friendly names.
```

We have to now set these friednly names to the file from the previous steps.

```for(i in 1:nrow(activity_labels)) { 
  data_mean.std$Activity[data_mean.std$Activity == activity_labels[i, "id"]] <- as.character(activity_labels[i, "name"])
  }
```

This step will confrim that the Activity column now inclues the friendly names rather than activity IDs.
```str(data_mean.std) 
#This step will confrim that the Activity column now inclues the friendly names rather than activity IDs.
#'data.frame':  10299 obs. of  68 variables:
#$ Subject ID                 : int  1 1 1 1 1 1 1 1 1 1 ...
#$ Activity                   : chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
#$ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...
#$ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
#$ tBodyAcc-mean()-Z          : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
```

#### 4. Appropriately labels the data set with descriptive variable names. 

We can work on changing the variable names by removing abbreviations as explained in the features_info.txt file
Modify the activity Names to lowercase.

```data_mean.std$Activity <- tolower(data_mean.std$Activity)
```
Change the measures mean and std variables by removing the abbreviations for the prefixes t and f & remove duplicate Body values.

```names(data_mean.std)<-gsub("^t", "Time ", names(data_mean.std))
```
```names(data_mean.std)<-gsub("^f", "Frequency ", names(data_mean.std))
```
```names(data_mean.std)<-gsub("BodyBody|Body", "Body ", names(data_mean.std))
```
```names(data_mean.std)<-gsub("[-]", " ", names(data_mean.std))
```

```head(data_mean.std)
#Subject ID Activity TimeBody Acc mean() X TimeBody Acc mean() Y TimeBody Acc mean() Z
#1          1 standing             0.2885845           -0.02029417            -0.1329051
#2          1 standing             0.2784188           -0.01641057            -0.1235202
#3          1 standing             0.2796531           -0.01946716            -0.1134617
#4          1 standing             0.2791739           -0.02620065            -0.1232826
#5          1 standing             0.2766288           -0.01656965            -0.1153619
#6          1 standing             0.2771988           -0.01009785            -0.1051373
#TimeBody Acc std() X TimeBody Acc std() Y TimeBody Acc std() Z TimeGravityAcc mean() X
#1           -0.9952786           -0.9831106           -0.9135264               0.9633961
#2           -0.9982453           -0.9753002           -0.9603220               0.9665611
```

#### 5. **FINAL STEP** - TIDY DATA: From the data set in step 4, creates a second, independent tidy data set


Using the reshape2 R package is helpdul to modify the strcuture of a dataframe. If not installed proceed.

```install.packages("reshape2") # If the package is already installed on your machine, proceed to the next line
library("reshape2") #This is required to reshape the file and create the ridy data set. We have a wide range file, the goal is to change it to smaller width.
```
**Step 1:** Melt the dataset and mold it to a long form file to sort by SubjectID and Activity

```data_melt <- melt(data_mean.std, id=c("SubjectID","Activity"))
```
```str(data_melt)
#'data.frame':  679734 obs. of  4 variables:
#'$ SubjectID: int  1 1 1 1 1 1 1 1 1 1 ...
#$ Activity : chr  "standing" "standing" "standing" "standing" ...
#$ variable : Factor w/ 66 levels "Time Body Acc mean() X",..: 1 1 1 1 1 1 1 1 1 1 ...
#$ value    : num  0.289 0.278 0.28 0.279 0.277 ...
```
**Step2:** Apply the mean on all variables and reshape the file to a wider format to see the means for all varibales by each SujectID and Activity.

```data_cast <- dcast(data_melt, SubjectID+Activity ~ variable, mean)
```
```str(data_cast)
#'data.frame':  180 obs. of  68 variables:
#$ SubjectID                        : int  1 1 1 1 1 1 2 2 2 2 ...
#$ Activity                         : chr  "laying" "sitting" "standing" "walking" ...
#$ Time Body Acc mean() X           : num  0.222 0.261 0.279 0.277 0.289 ...
#$ Time Body Acc mean() Y           : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
#$ Time Body Acc mean() Z           : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
#$ Time Body Acc std() X            : num  -0.928 -0.977 -0.996 -0.284 0.03 ...
```
####Create the tidy_data file. This is the final step to complete the project:

```write.table(data_cast, file = "./tidy_data_file.txt",row.name=FALSE)
wd <- getwd()
cat("Congratulations! The file `tidy_data_file.txt` is in your working directory: ", wd)
```
Remove the file used for this project to save memory
```rm(download_zip, i, dir, activity_labels, Xtrain, Xtest, Strain, Stest, Ytrain, Ytest, train_full, test_full, col_mean.std, feat_labels, feat_mean.std, data_cast, data_melt, data_full, data_mean.std)
```


####Variables List:
The tidy_data_file.text includes the following dimensions:

* SubjectID: integer, the identifier of each volunteerbeing whoe activity is being measured
* Activity: string, this is the name of the physical activty tracked by.                         
The below 66 variables, are the measurements based on the activities each volunteer has taken while using the samsung devices:

* Time Body Acc mean() X           
* Time Body Acc mean() Y           
* Time Body Acc mean() Z           
* Time Body Acc std() X            
* Time Body Acc std() Y            
* Time Body Acc std() Z            
* Time GravityAcc mean() X         
* Time GravityAcc mean() Y         
* Time GravityAcc mean() Z         
* Time GravityAcc std() X          
* Time GravityAcc std() Y          
* Time GravityAcc std() Z          
* Time Body AccJerk mean() X       
* Time Body AccJerk mean() Y       
* Time Body AccJerk mean() Z       
* Time Body AccJerk std() X        
* Time Body AccJerk std() Y        
* Time Body AccJerk std() Z        
* Time Body Gyro mean() X          
* Time Body Gyro mean() Y          
* Time Body Gyro mean() Z          
* Time Body Gyro std() X           
* Time Body Gyro std() Y           
* Time Body Gyro std() Z           
* Time Body GyroJerk mean() X      
* Time Body GyroJerk mean() Y      
* Time Body GyroJerk mean() Z      
* Time Body GyroJerk std() X       
* Time Body GyroJerk std() Y       
* Time Body GyroJerk std() Z       
* Time Body AccMag mean()          
* Time Body AccMag std()           
* Time GravityAccMag mean()        
* Time GravityAccMag std()         
* Time Body AccJerkMag mean()      
* Time Body AccJerkMag std()       
* Time Body GyroMag mean()         
* Time Body GyroMag std()          
* Time Body GyroJerkMag mean()     
* Time Body GyroJerkMag std()      
* Frequency Body Acc mean() X      
* Frequency Body Acc mean() Y      
* Frequency Body Acc mean() Z      
* Frequency Body Acc std() X       
* Frequency Body Acc std() Y       
* Frequency Body Acc std() Z       
* Frequency Body AccJerk mean() X  
* Frequency Body AccJerk mean() Y  
* Frequency Body AccJerk mean() Z  
* Frequency Body AccJerk std() X   
* Frequency Body AccJerk std() Y   
* Frequency Body AccJerk std() Z   
* Frequency Body Gyro mean() X     
* Frequency Body Gyro mean() Y     
* Frequency Body Gyro mean() Z     
* Frequency Body Gyro std() X      
* Frequency Body Gyro std() Y      
* Frequency Body Gyro std() Z      
* Frequency Body AccMag mean()     
* Frequency Body AccMag std()      
* Frequency Body AccJerkMag mean() 
* Frequency Body AccJerkMag std()  
* Frequency Body GyroMag mean()    
* Frequency Body GyroMag std()     
* Frequency Body GyroJerkMag mean()
* Frequency Body GyroJerkMag std() 

