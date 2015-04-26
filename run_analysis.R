require("data.table")
require("reshape2")

# Set the working dir
setwd("~/Desktop/Coursera/UCI HAR Dataset")

# Read accesory names and labels
activity_labels <- read.table("./activity_labels.txt")[,2]
features <- read.table("./features.txt")[,2]

# Filtering only the mean and std columns
filtered <- grepl("mean|std", features)

# Read test data
xtest <- read.table("~/Desktop/Coursera/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("~/Desktop/Coursera/UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("~/Desktop/Coursera/UCI HAR Dataset/test/subject_test.txt")
names(xtest) = features

# Filter the data with the needed features
x_test = xtest[,filtered]

# Load activity labels
y_test[,2] = activity_labels[ytest[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subjecttest) = "subject"

# Join the data
testdata <- cbind(as.data.table(subject_test), y_test, x_test)

# Read the train daya
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subjecttrain <- read.table("./train/subject_train.txt")
names(xtrain) = features

# Filter the data with the needed features
x_train = xtrain[,filtered]

# Load activity data
y_train[,2] = activity_labels[ytrain[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subjecttrain) = "subject"

# Joining the data
traindata <- cbind(as.data.table(subjecttrain), y_train, x_train)

# Merge test and train data
data = rbind(testdata, traindata)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Compute yhe mean
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")

