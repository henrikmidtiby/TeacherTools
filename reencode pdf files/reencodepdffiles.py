#!/usr/bin/env python
#
# extractComments.py - extract comments in pdf files residing in subdirectories.
#
# Tool created for assisting with correction of exam handins at SDU.
# The tool requires pdfminer, which can be downloaded from
# http://www.unixuser.org/~euske/python/pdfminer/
#
# Author: Henrik Skov Midtiby, hemi@mmmi.sdu.dk
# Date: 2014-01-15

# Load dependencies
import sys, os.path
import os
import re



# main function that iterates through all subdirs and analyzes all files in
# each subdir.
# Extracted comments are stored in the file "statistics".
def main():

    subdirs = getListOfSubdirectories('./')
    for subdir in subdirs:
        print("\n\n=======================================")
        print("Subdir: %s" % subdir)
        assignment = subdir[2:]
        tempDir = subdir + '/'
        files = getFilesInDirectory(tempDir)
        for file in files:
            if(file[-3:] == "pdf" and not file == "output.pdf"):
                fullFileName = assignment + "/" + file
                tempFileName = fullFileName[:-4] + ".ps"
                outputFileName = assignment + "/" + "output.pdf"
                command1 = "pdf2ps \"%s\" \"%s\"" % (fullFileName, tempFileName)
                print(command1)                
                os.system(command1)
                command2 = "ps2pdf \"%s\" \"%s\"" % (tempFileName, outputFileName)
                print(command2)                
                os.system(command2)

    pass

def getListOfSubdirectories(path):
    dirs = []
    files_in_dir = os.listdir(path)
    for file_in_dir in files_in_dir:
        if os.path.isdir(path + file_in_dir):
            dirs.append(path + file_in_dir)
    return dirs

def getFilesInDirectory(path):
    files = []
    files_in_dir = os.listdir(path)
    for file_in_dir in files_in_dir:
        if os.path.isfile(path + file_in_dir):
            files.append(file_in_dir)
    return files

main()
