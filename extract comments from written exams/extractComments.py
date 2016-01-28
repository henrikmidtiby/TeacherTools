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
import sys
import os
import re
from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument
from pdfminer.pdftypes import PDFObjectNotFound


# dump_comments
# Analyzes an open pdf file and extracting comments from it.
# It is tested with comments inserted with PDF X-Change Viewer.
def dump_comments(doc):
    comments = []
    visited = set()
    for xref in doc.xrefs:
        # Iterate over all objects in the pdf file.
        for objid in xref.get_objids():
            if objid in visited:
                continue
            visited.add(objid)
            try:
                obj = doc.getobj(objid)
                if obj is None:
                    continue
                if isinstance(obj, dict):
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


def get_comments_in_pdf_file(filename):
    """

    :param filename: Name of pdf file to analyse.
    :return: List of comments found in the pdf file.
    """
    fp = file(filename, 'rb')
    parser = PDFParser(fp)
    doc = PDFDocument(parser)
    comments = dump_comments(doc)
    fp.close()
    return comments


# main function that iterates through all subdirs and analyzes all files in
# each subdir.
# Extracted comments are stored in the file "statistics".
def main():
    output_file = open('statistics', 'w')

    header = "ID\tExercise\tPoint\tComment"
    print(header)
    output_file.write(header + "\n")
    sub_directories = get_list_of_subdirectories('./')
    for subdir in sub_directories:
        print("\n\n=======================================")
        print("Subdir: %s" % subdir)
        assignment = subdir[2:]
        temp_dir = subdir + '/'
        files = get_files_in_directory(temp_dir)
        for filename in files:
            full_filename = assignment + "/" + filename
            try:
                comments = get_comments_in_pdf_file(full_filename)
                for comment in comments:
                    opgave, point, comment = split_comment(comment)
                    observation = "%s\t%s\t%s\t%s" % (assignment, opgave,
                                                      point, comment.replace('\n', ' ').replace('\r', ' '))
                    print(observation)
                    output_file.write(observation + "\n")
            except:
                print("Error analyzing file: %s" % full_filename)

    output_file.close()

    pass


def split_comment(comment):
    """
    Function for splitting comments in three parts:

    :param comment: The comment text string that should be analyzed.
    :return: Tuple with the values, exerciseid, number of awarded points and a text string with comments.
    """
    val = re.match("([0123456789]+[abcdefghijklmnopqrstu]) (\d+)\s*(.*)", comment)
    if val:
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


def get_files_in_directory(path):
    files = []
    files_in_dir = os.listdir(path)
    for file_in_dir in files_in_dir:
        if os.path.isfile(path + file_in_dir):
            files.append(file_in_dir)
    return files


main()
