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
sys.path.append('/home/henrik/lib/python') 
import os
import re
from pdfminer.psparser import PSKeyword, PSLiteral, LIT
from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument, PDFNoOutlines
from pdfminer.pdftypes import PDFObjectNotFound, PDFValueError
from pdfminer.pdftypes import PDFStream, PDFObjRef, resolve1, stream_value
from pdfminer.pdfpage import PDFPage


def getNumberOfPagesInFile(filename):
    fp = file(filename, 'rb')
    parser = PDFParser(fp)
    doc = PDFDocument(parser)
    pagecount = 0
    for pageNumber, page in enumerate(PDFPage.create_pages(doc)):
        pagecount += 1
    fp.close()
    return pagecount


# main function that iterates through all subdirs and analyzes all files in
# each subdir.
# Extracted comments are stored in the file "statistics".
def main():
    command = "pdftk " 

    subdirs = getListOfSubdirectories('./')
    for subdir in subdirs:
        print("\n\n=======================================")
        print("Subdir: %s" % subdir)
        assignment = subdir[2:]
        tempDir = subdir + '/'
        files = getFilesInDirectory(tempDir)
        for file in files:
            try:
                fullFileName = assignment + "/" + file
                numberofpages = getNumberOfPagesInFile(fullFileName)
                print("%s - %d" % (fullFileName, numberofpages))
                command += "\"%s\" " % fullFileName
                if(numberofpages % 2 == 1):
                    command += "\"makeeven.pdf\" "
            except:
                print("Error analyzing file: %s" % fullFileName)

    command += " cat output outputfile.pdf"
    print(command)

    pass

# Function for splitting comments in three parts:
# * exerciseid
# * awarded points
# * comments.
# This is returned as a tuple.
def splitComment(comment):
    val = re.match("([123456789]+[abcde]) (\d+)\s*(.*)", comment)
    if(val):
        exercise = val.group(1)
        point = val.group(2)
        comment = val.group(3)
        return (exercise, point, comment)
    return ("NA", "NA", comment)

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
