### Getting Data - Course Project
#### Cleaning, Merging and Creating a Fresh New Dataset

The following repo covers Coursera's Cleaning and Getting Data Course project. This Repo outlines the steps to complete the project:

###### Loading data from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip covering Samsung Galancy Smart Phone data in a working directory.
###### Writing the README file in addition to a CodeBook.md file that explains the data set and the different manipulations applied to get the final tiny data output.
###### Writing an R script "run_analysis.R" that will allow for the creation of a tiny data set to satisfy the below Project tasks

```
Prerequisites:
The work outlined in the Codebook.rm/rmd and run_analysis.R assume that and internet connection is available to download the project necessary files. In addition, the "run_analysis.R" file requires the following packages to be installed:

*[downloader] (http://cran.r-project.org/web/packages/downloader/index.html)
*[plyr] (http://cran.r-project.org/web/packages/plyr/)
*[dplyr] (http://cran.r-project.org/web/packages/dplyr/)
*[httr] (http://cran.r-project.org/web/packages/httr/)
*[reshape2] (http://cran.r-project.org/web/packages/reshape2/)

Note however that the run_analysis file includes the needed functions to download the packages if need be, you can search for the term "install.packages" and remove the "#" in the "run_analysis.R" with the install.packages() function for the above packages.
```

Project tasks:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

