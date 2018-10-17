# Script for extracting student names and associated images 
# from an e-learn / blackboard page with the students.
# The data should afterwards be imported into mnemosyne, to aid me 
# in learning names of all the students.
# 
# Author: Henrik Skov Midtiby
# Date: 2018-10-17

# User guide
# 1. Open the relevant course on elearn / blackboard.
# 2. Find the list of participants with photos.
# 3. Select "show all".
# 4. Save the webpage with a name like "coursecode-year", avoid spaces in the filename.
# 5. Put this script in the directory containing the just saved html file ("coursecode-year.html").
# 6. Run the script and save the output to a text file (python3 parser.py coursecode-year.html > cardsformnemosyne.txt).
# 7. Copy the directory with images to the directory "/home/henrik/.local/share/mnemosyne/default.db_media/".
# 8. Remove the first three lines in cardsformnemosyne.txt
# 9. Import the generated textfile into mnemosyne (files -> import).

# Be aware of many hardcoded elements in this file. 
from html.parser import HTMLParser

import argparse


class MyHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.printing_stuff = False
        self.current_student_name = None
        self.current_student_email = None
        self.current_student_image = None
        self.collecting_name = False
        self.collecting_email = False

    def handle_starttag(self, tag, attrs):
        if tag == "tr":
            self.printing_stuff = True
        if tag == "img":
            for attr in attrs:
                if attr[0] == 'src':
                    self.current_student_image = attr[1]
        if tag == "a":
            self.collecting_email = True
        if tag == "h2":
            self.collecting_name = True

    def handle_endtag(self, tag):
        if tag == "tr":
            self.printing_stuff = False
            print('<img = src="%s"/>\t%s' % (self.current_student_image, self.current_student_name))
        if tag == "a":
            self.collecting_email = False
        if tag == "h2":
            self.collecting_name = False

    def handle_data(self, data):
        if self.collecting_name:
            self.current_student_name = data
        if self.collecting_email:
            self.current_student_email = data


def parse_file(filename):
    htmlparser = MyHTMLParser()
    with open(filename) as fh:
        for line in fh:
            htmlparser.feed(line)

def main():
    argparser = argparse.ArgumentParser(description = "Small tool to extract name / image pairs from blackboards list of participants with photos.")
    argparser.add_argument("inputfilename")
    args = argparser.parse_args()
    parse_file(args.inputfilename)

main()
