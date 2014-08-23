if(!file.exists( "D:/RFiles/Get_Data_Proj/UCI_HAR_Dataset.zip")){
                 fileUrl <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
                 download.file(fileUrl, destfile =  "UCI_HAR_Dataset.zip")
                 unzip("UCI_HAR_Dataset.zip", exdir = "D:/RFiles/Get_Data_Proj")
                 dateDownloaded <- date()
                 list.files("D:/RFiles/Get_Data_Proj")
}

##Star Block: Read tables in
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
##End Block





##Start Block: Create relevent tables
x_train_raw <- sapply(index_ord, function(x) rbind(X_train[,x]))
x_test_raw <- sapply(index_ord, function(x) rbind(X_test[,x]))
##End Block

##Start Block: Combine and order
x_test_indexed  <- data.table(cbind(subject_test, Y_test, x_test_raw ))
x_train_indexed  <- data.table(cbind(subject_train, Y_train, x_train_raw))
combined <- rbind(x_train_indexed, x_test_indexed)
ord_comb <- combined[order(combined$Subject, combined$Activity),]
j <- length(ord_comb)
ord_finale <- ddply(ord_comb, c("Subject","Activity"), function(x) apply(x[,3:j],2, mean)) ## Finale tidy data set
##End Block


##Tidy up the variable labels
ord_finale_tst  <- ord_finale
ord_finale_hds <- read.table("D:/RFiles/Get_Data_Proj/features_alpha.txt")
hdtest <- as.vector(ord_finale_hds[,1])
fin_colnames <- tolower(hdtest)
colnames(ord_finale) <- c("subject", "activity",fin_colnames)
colnames(ord_finale) <- sub("-","",names(ord_finale))
colnames(ord_finale) <- sub(",","",names(ord_finale))
##End Block

head(ord_finale)
tail(ord_finale)
