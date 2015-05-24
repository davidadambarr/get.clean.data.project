# get.clean.data.project
Repository of work relating to coursera "getting and cleaning data" module coursework 

## How the script run_analysis.R works

The script will make a new folder in your working directory called "rawdata" and download  a zip file to that folder called "accelerometer.zip". 
The needed subfiles will then be unzipped into the R environment and combined into a new dataframe called "merged".
This dataframe will be curated with new descriptive character strings etc before a new 'tidy' dataset is made, called "newdf". 
In this there will be 180 rows, with each row coresponding to one person doing one activity (30 people or 'subjects' * 6 activities = 180 rows). 
Each column except "subject" and "activity" represents a particular measured variable (details in original files in the accelerometer.zip folder) such that each cell in that column is the mean for that variable accross all the observations of the variable for the subject and activity defined by the row.

This dataframe will be written to your working directory as a .txt file called newdf.txt.

#**PLEASE CHECK YOU DO NOT ALREADY HAVE A TEXT FILE CALLED newdf.txt IN YOUR CURRENT WORKING DIRECTORY BECAUSE THIS SCRIPT WILL OVERWRITE IT!!!**
