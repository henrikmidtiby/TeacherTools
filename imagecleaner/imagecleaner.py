# Script for cleaning up images of hand drawn sketches.
# Author: Henrik Skov Midtiby
# Date: 2014-10-10
# Version: 0.1

import sys
sys.path.append('/opt/ros/hydro/lib/python2.7/dist-packages')
import cv2
import numpy as np

def locate_first_and_last_false(input_list):
    first_index_of_false_value = -1
    last_index_of_false_value = -1
    for idx, elem in enumerate(input_list.tolist()):
        if elem is False:
            if first_index_of_false_value is -1:
                first_index_of_false_value = idx
            last_index_of_false_value = idx
    return first_index_of_false_value, last_index_of_false_value


def locate_red_regions(hsv):
    lower_red = np.array([0, 50, 100])
    upper_red = np.array([15, 255, 255])
    red_regions_1 = cv2.inRange(hsv, lower_red, upper_red)
    lower_red = np.array([165, 50, 100])
    upper_red = np.array([189, 255, 255])
    red_regions_2 = cv2.inRange(hsv, lower_red, upper_red)
    red_regions = red_regions_1 + red_regions_2
    kernel = np.ones((3, 3), np.uint8)
    red_regions = cv2.dilate(red_regions, kernel, iterations=1)
    return red_regions


def locate_blue_regions(hsv):
    lower_blue = np.array([100, 50, 50])
    upper_blue = np.array([140, 255, 255])
    blue_regions = cv2.inRange(hsv, lower_blue, upper_blue)
    kernel = np.ones((3, 3), np.uint8)
    blue_regions = cv2.dilate(blue_regions, kernel, iterations=1)
    return blue_regions


def main(filename):
    kernel_size = 35
    img = cv2.imread(filename)
    kernel = np.ones((kernel_size, kernel_size), np.uint8)
    blackhat = cv2.morphologyEx(img, cv2.MORPH_BLACKHAT, kernel)
    temp = 255 - blackhat

    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    red_regions = locate_red_regions(hsv)
    blue_regions = locate_blue_regions(hsv)

    # Threshold image.
    grayscale = cv2.cvtColor(temp, cv2.cv.CV_RGB2GRAY)
    _, thresholded = cv2.threshold(grayscale, 220, 255, cv2.THRESH_BINARY)
    thresholdedfilename = "%s.thresholded.png" % filename
    cv2.imwrite(thresholdedfilename, thresholded)

    colored_image = cv2.cvtColor(thresholded, cv2.cv.CV_GRAY2RGB)
    colored_image = cv2.bitwise_or(colored_image, (0, 0, 255), colored_image, mask=red_regions)
    colored_image = cv2.bitwise_or(colored_image, (255, 0, 0), colored_image, mask=blue_regions)
    colored_image_filename = "%s.coloredimage.png" % filename
    cv2.imwrite(colored_image_filename, colored_image)


if len(sys.argv) == 1:
    # main('2014-10-29 13.45.09.jpg')
    print("Program called with no input files.")
    print("Drag a file onto the program.")
    var = raw_input("Please enter something: ")

for k in range(len(sys.argv) - 1):
    main(sys.argv[k + 1])
