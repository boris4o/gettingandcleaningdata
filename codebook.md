####This document describes the code for the final project of [Getting and cleaning data](https://www.coursera.org/course/getdata) Coursera course, Data Science track, provided by John Hopkins University.

The document goes step by step through the **run_analysis.R file**.

The code includes comments and is divided into several groups.

###Initializing environment and loading the required libraries
Initially, all the libraries needed are loaded in the first section of the code.

* `library(dplyr)`
* `library(data.table)`
* `library(tidyr)`

Afterwards, the file path is being defined and a **data** directory is created inside (if it doesn't already exist). Then, the data set is **downloaded** and **unzipped**.

Loading the required files from the downloaded data, all the commands use `read.table`.

* `dataSubjectTrain`,
`dataSubjectTest` - loads subject data

* `dataActivityTrain`, 
`dataActivityTest` - loads activity data

* `dataTrain`,
`dataTest` - loads X_train files.

* `alldataSubject`, 
`alldataActivity` - merge training and test data sets.

* `dataTable` - merges and creates the final data table using `rbind`.

Afterwards, **features** and **activities** are loaded and merged so the **mean** and the **sd** values can be extracted

Then, the column names of various columns are changed according to the predefined requirements using `names` and `gsub`, e.g.:

`names(dataTable)<-gsub("std()", "SD", names(dataTable))`

Finally, the new data set is created using `write.table`.

For additional references, please check the comments in the R file.

