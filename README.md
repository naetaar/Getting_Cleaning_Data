# Getting_Cleaning_Data

The script for this file:
* Downloads the data to the computer.
* Reads the data into R as *.file objects.
* rbinds the test and training set for each section, *_all objects
* Gives the variable names from features.a object.
* cbinds the X_all, subject_all and y_all tables together.
* Keeps only the variables related to mean and standard deviation. (mean_std_col)
* New object is called X.
* Creates meaning labels for y_all using activities.label into y_factor object.
* Change the variable names for the subject and position columns (Col. 70 & 71)
* Create a new variable subj_pos, which is the subject + his position (180 factors)
* For Step 5, create a data.frame X_summary to summarize the data (69 rows, 180 columns).
* Label the columns and rows.
* Use t-apply to calculate the mean for each column by the subj_pos factor list.
* Write this table to the computer.
