
##Code Book
This code book is made up of two sections one explaining the data the second explaining the post processing applied to the raw data to extract and compile the submitted tidydata data set. 

##Section One
The raw data was extracted from the Human Activity Recognition Using Smartphones Dataset Version 1.0 available at http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip.  Attribution for the data set is available at the above URL.

The data was produce form experiments carried out with a group of 30 volunteers. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a the experiment defined sensor device. The collected data was randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and 30% the test data. 

The sensor output was used to estimate variables of the feature vector for each pattern:  
The researchers used '-XYZ' used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals were: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete set of 561 variable names is available in the features.txt document.  This data set was complied for a sub set of variables pertaining to Mean and Standard Deviation extracted from the 561 variable superset. 


The reseracgers supplied the following documents with the raw data set:
- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

##Section Two

The following process was executed in the RStudio Version 0.98.507 environment with R x64 3.1.0.

The extracted variables(listed in exhibit A)were extracted from the files that were read into the R environment in the “Read and Unzip” block of the run_analysis.R script. 

if(!file.exists( "D:/RFiles/Get_Data_Proj/UCI_HAR_Dataset.zip")){
                 fileUrl <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
                 download.file(fileUrl, destfile =  "UCI_HAR_Dataset.zip")
                 unzip("UCI_HAR_Dataset.zip", exdir = "D:/RFiles/Get_Data_Proj")
                 dateDownloaded <- date()
                 list.files("D:/RFiles/Get_Data_Proj")
}

The tables of the raw data set were the extracted using the following code block:
colhds <- read.table("D:/RFiles/Get_Data_Proj/features.txt")
col_lab <- as.vector(colhds[,2])
act_lab <- "Activity"
sub_lab <- "Subject"
X_test <- read.table("D:/RFiles/Get_Data_Proj/UCI HAR Dataset/test/X_test.txt", col.names = col_lab, colClasses = "numeric", quote="\"")
X_train <- read.table("D:/RFiles/Get_Data_Proj/UCI HAR Dataset/train/X_train.txt", col.names = col_lab, colClasses = "numeric", quote="\"")
subject_test <- read.table("D:/RFiles/Get_Data_Proj/UCI HAR Dataset/test/subject_test.txt", col.names = sub_lab, quote="\"")
subject_train <- read.table("D:/RFiles/Get_Data_Proj/UCI HAR Dataset/train/subject_train.txt", col.names = sub_lab, quote="\"")
Y_test <- read.table("D:/RFiles/Get_Data_Proj/UCI HAR Dataset/test/y_test.txt", col.names = act_lab, quote="\"")
Y_train <- read.table("D:/RFiles/Get_Data_Proj/UCI HAR Dataset/train/y_train.txt", col.names = act_lab, quote="\"")
index_ord <- grep("[Mm]ean|std", names(X_train))
The “grep” command set was used to identify those variable that pertained to the Mean and Standard Deviation measures.

From the above tables an untidy data set was developed by joining and combining data from the various tables by means of the following script elements:

x_train_raw <- sapply(index_ord, function(x) rbind(X_train[,x]))
x_test_raw <- sapply(index_ord, function(x) rbind(X_test[,x]))
End Block

Start Block: Combine and order
x_test_indexed  <- data.table(cbind(subject_test, Y_test, x_test_raw ))
x_train_indexed  <- data.table(cbind(subject_train, Y_train, x_train_raw))
combined <- rbind(x_train_indexed, x_test_indexed)
ord_comb <- combined[order(combined$Subject, combined$Activity),]
j <- length(ord_comb)
ord_finale <- ddply(ord_comb, c("Subject","Activity"), function(x) apply(x[,3:j],2, mean)) ## Finale tidy data set

The final step was to “clean-up” the colum headings (variable names) to meet the standards of a tidy data set.  The following script segment was used to accomplish this:

ord_finale_tst  <- ord_finale
ord_finale_hds <- read.table("D:/RFiles/Get_Data_Proj/features_alpha.txt")
hdtest <- as.vector(ord_finale_hds[,1])
fin_colnames <- tolower(hdtest)
colnames(ord_finale) <- c("subject", "activity",fin_colnames)
colnames(ord_finale) <- sub("-","",names(ord_finale))
colnames(ord_finale) <- sub(",","",names(ord_finale))

The variables used in the finale tidy data set are those variables that by original variable name implied relevance to the target domain of Mean and Standard Deviation.   There was no mathematical validation that the raw data accurately reflect the implied relevance. 
 
## Exhibit A
tBodyAcc-mean()-X
tBodyAcc-mean()-Y
tBodyAcc-mean()-Z
tBodyAcc-std()-X
tBodyAcc-std()-Y
tBodyAcc-std()-Z
tGravityAcc-mean()-X
tGravityAcc-mean()-Y
tGravityAcc-mean()-Z
tGravityAcc-std()-X
tGravityAcc-std()-Y
tGravityAcc-std()-Z
tBodyAccJerk-mean()-X
tBodyAccJerk-mean()-Y
tBodyAccJerk-mean()-Z
tBodyAccJerk-std()-X
tBodyAccJerk-std()-Y
tBodyAccJerk-std()-Z
tBodyAccJerk-mad()-Z
tBodyGyro-mean()-X
tBodyGyro-mean()-Y
tBodyGyro-mean()-Z
tBodyGyro-std()-X
tBodyGyro-std()-Y
tBodyGyro-std()-Z
tBodyGyroJerk-mean()-X
tBodyGyroJerk-mean()-Y
tBodyGyroJerk-mean()-Z
tBodyGyroJerk-std()-X
tBodyGyroJerk-std()-Y
tBodyGyroJerk-std()-Z
tBodyAccMag-mean()
tBodyAccMag-std()
tGravityAccMag-mean()
tGravityAccMag-std()
tBodyAccJerkMag-mean()
tBodyAccJerkMag-std()
tBodyGyroMag-mean()
tBodyGyroMag-std()
tBodyGyroJerkMag-mean()
tBodyGyroJerkMag-std()
fBodyAcc-mean()-X
fBodyAcc-mean()-Y
fBodyAcc-mean()-Z
fBodyAcc-std()-X
fBodyAcc-std()-Y
fBodyAcc-std()-Z
fBodyAcc-meanFreq()-X
fBodyAcc-meanFreq()-Y
fBodyAcc-meanFreq()-Z
fBodyAccJerk-mean()-X
fBodyAccJerk-mean()-Y
fBodyAccJerk-mean()-Z
fBodyAccJerk-std()-X
fBodyAccJerk-std()-Y
fBodyAccJerk-std()-Z
fBodyAccJerk-meanFreq()-X
fBodyAccJerk-meanFreq()-Y
fBodyAccJerk-meanFreq()-Z
fBodyGyro-mean()-X
fBodyGyro-mean()-Y
fBodyGyro-mean()-Z
fBodyGyro-std()-X
fBodyGyro-std()-Y
fBodyGyro-std()-Z
fBodyGyro-meanFreq()-X
fBodyGyro-meanFreq()-Y
fBodyGyro-meanFreq()-Z
fBodyAccMag-mean()
fBodyAccMag-std()
fBodyAccMag-meanFreq()
fBodyBodyAccJerkMag-mean()
fBodyBodyAccJerkMag-std()
fBodyBodyAccJerkMag-meanFreq()
fBodyBodyGyroMag-std()
fBodyBodyGyroMag-meanFreq()
fBodyBodyGyroJerkMag-mean()
fBodyBodyGyroJerkMag-std()
fBodyBodyGyroJerkMag-meanFreq()
angle(tBodyAccMean
angle(tBodyAccJerkMean)
angle(tBodyGyroMean
angle(tBodyGyroJerkMean
angle(X
angle(Y
angle(Z

