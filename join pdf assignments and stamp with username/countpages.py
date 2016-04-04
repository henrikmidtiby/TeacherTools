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
from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument, PDFNoOutlines
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

    subdirectories = get_list_of_subdirectories('./')
    for subdir in sorted(subdirectories):
        print("\n\n=======================================")
        print("Subdir: %s" % subdir)
        assignment = subdir[2:]
        tempDir = subdir + '/'
        files = get_files_in_firectory(tempDir)
        for file in files:
            print(file)
            if not file == "output.pdf":
                try:
                    fullFileName = assignment + "/" + file
                    fullFileNameOutput = assignment + "/" + "output.pdf"
                    numberofpages = getNumberOfPagesInFile(fullFileName)
                    commandLineToAddUserName = "echo \"%s\" | enscript -B --margins=::10: -f Courier-Bold16 -o- | ps2pdf - | pdftk \"%s\" stamp - output %s" % (assignment, fullFileName, fullFileNameOutput)
                    print(commandLineToAddUserName)
                    os.system(commandLineToAddUserName)
                    print("%s - %d" % (fullFileName, numberofpages))
                    command += "\"%s\" " % fullFileNameOutput
                    if(numberofpages % 2 == 1):
                        command += "\"makeeven.pdf\" "
                except:
                    print "Unexpected error:", sys.exc_info()[0]
                    print("Error analyzing file: %s" % fullFileName)

    command += " cat output outputfile.pdf"
    print(command)
    os.system(command)
    #os.system("pdf2ps outputfile.pdf temp.ps")
    #os.system("ps2pdf temp.ps temp2.pdf")
    os.system("./gs-916-linux_x86 -dPDFA -dBATCH -dNOPAUSE -sProcessColorModel=DeviceCMYK -sDEVICE=pdfwrite -sOutputFile=output_filename.pdf outputfile.pdf")


# Function for splitting comments in three parts:
# * exerciseid
# * awarded points
# * comments.
# This is returned as a tuple.
def split_comment(comment):
    val = re.match("([123456789]+[abcde]) (\d+)\s*(.*)", comment)
    if(val):
        exercise = val.group(1)
        point = val.group(2)
        comment = val.group(3)
        return (exercise, point, comment)
    return ("NA", "NA", comment)

def get_list_of_subdirectories(path):
    dirs = []
    files_in_dir = os.listdir(path)
    for file_in_dir in files_in_dir:
        if os.path.isdir(path + file_in_dir):
            dirs.append(path + file_in_dir)
    return dirs

def get_files_in_firectory(path):
    files = []
    files_in_dir = os.listdir(path)
    for file_in_dir in files_in_dir:
        if os.path.isfile(path + file_in_dir):
            files.append(file_in_dir)
    return files

main()
