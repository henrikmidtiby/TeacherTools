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
from pdfminer.psparser import PSKeyword, PSLiteral, LIT
from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument, PDFNoOutlines
from pdfminer.pdftypes import PDFObjectNotFound, PDFValueError
from pdfminer.pdftypes import PDFStream, PDFObjRef, resolve1, stream_value
from pdfminer.pdfpage import PDFPage

# dumpcomments
# Analyzes an open pdf file and extracting comments from it.
# It is tested with comments inserted with PDF X-Change Viewer.
def dumpcomments(doc):
    comments = []
    visited = set()
    for xref in doc.xrefs:
        # Iterate over all objects in the pdf file.
        for objid in xref.get_objids():
            if objid in visited: continue
            visited.add(objid)
            try:
                obj = doc.getobj(objid)
                if obj is None: continue
                if(isinstance(obj, dict)):
                    try:
                        # Comments inserted with PDF X-Change Viewer have these
                        # two values, if they are not present the object is not
                        # a comment ...
                        subtype = obj['Subtype']
                        comment = obj['Contents']
                        comments.append(comment)
                    except:
                        pass
            except PDFObjectNotFound, e:
                print >>sys.stderr, 'not found: %r' % e
    return comments


# getCommentsInPdfFile
# Loads a pdf file and extracts comments from that file.
def getCommentsInPdfFile(filename):
    fp = file(filename, 'rb')
    parser = PDFParser(fp)
    doc = PDFDocument(parser)
    comments = dumpcomments(doc)
    fp.close()
    return comments

# main function that iterates through all subdirs and analyzes all files in
# each subdir.
# Extracted comments are stored in the file "statistics".
def main():
    outputFile = open('statistics', 'w')

    header = "ID\tExercise\tPoint\tComment"
    print(header)
    outputFile.write(header + "\n")
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
                comments = getCommentsInPdfFile(fullFileName)
                for comment in comments:
                    opgave, point, comment = splitComment(comment)
                    observation = "%s\t%s\t%s\t%s" % (assignment, opgave, point, comment.replace('\n', ' ').replace('\r', ' '))
                    print(observation)
                    outputFile.write(observation + "\n")
            except:
                print("Error analyzing file: %s" % fullFileName)

    outputFile.close()

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
