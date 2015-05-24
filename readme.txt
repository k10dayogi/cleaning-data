There are explanatory comments throughout the code, but this summarises how the program operates.
#Note that the file paths assume that the working directory is set via setwd() to  "UCI.HAR.Dataset", so make sure you do that first.
#Note that you need the plyr and dplyr packages at one point, so use install.packages(plyr) and/or install.packages(dplyr) first if you don't have it.

#Imports train data and cbind data sets together and import test data and cbind data sets together.
#Uses rbind on the test and train sets together to form the full data set.
#Identifies the column names from the features.txt file, filters out the names and put into proper format for grep.
#Uses grep to find *indices* of the column names that have "mean" and "std" and binds the sets together to find their (set) union.
#Filters out the columns to leave behind only the first column (subject), last column (activity), mean and std columns.
#We need the revalue command from plyr so program loads that package. 
#The revalue command requires *factors*, not integers, so we first coerce the far-right column of the data frame to be factors.
#Uses the revalue command to change numbers to descriptors.
#Find names of columns.
#Groups the data set by subject & activity and summarize each variable by the mean, as required.
#Writes data set to file.