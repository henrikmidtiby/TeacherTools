== Installation guide ==
1. Install python 2.7
2. Install pdfminer, download from https://pypi.python.org/pypi/pdfminer/
3. Install RStudio
4. Install the following packages in R (knitr, ggplot2, dplyr, plyr, tidyr)


== Workflow == 
1. Download assignments from SDU Assignment (download in folders)
2. Open an assignment in PDF xchange editor
3. Insert comments as text boxes, an example comment could be "1a 6 Message", wher "1a" is the exercise code, "6" is the number of awarded points and "Message" is an optional comment on the exercise.
4. Save the file.
5. Run the python script ectractComments.py. The script saves all comments in the file "statistics"
6. Run the R script "collectedComments.Rnw" through RStudio (generate pdf)
7. Look at the generated pdf file.


== Adjusting grading weights ==
