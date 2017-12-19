# Script for cleaning up images of hand drawn sketches.
# Author: Henrik Skov Midtiby
# Date: 2015-12-02
# Version: 0.2

import sys
import numpy as np
import cv2


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

    image_with_adjusted_background = adjust_background(img, kernel_size)

    blue_regions, red_regions = locate_red_and_blue_regions(img)

    thresholded_image = threshold_image(image_with_adjusted_background)
    thresholdedfilename = "%s.thresholded.png" % filename
    cv2.imwrite(thresholdedfilename, thresholded_image)

    colored_image = color_output_image(blue_regions, red_regions, thresholded_image)
    colored_image_filename = "%s.coloredimage.png" % filename
    cv2.imwrite(colored_image_filename, colored_image)


def color_output_image(blue_regions, red_regions, thresholded_image):
    colored_image = cv2.cvtColor(thresholded_image, cv2.COLOR_GRAY2RGB)
    colored_image = cv2.bitwise_or(colored_image, (0, 0, 255), colored_image, mask=red_regions)
    colored_image = cv2.bitwise_or(colored_image, (255, 0, 0), colored_image, mask=blue_regions)
    return colored_image


def locate_red_and_blue_regions(img):
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    red_regions = locate_red_regions(hsv)
    blue_regions = locate_blue_regions(hsv)
    return blue_regions, red_regions


def threshold_image(image_with_adjusted_background):
    grayscale = cv2.cvtColor(image_with_adjusted_background, cv2.COLOR_RGB2GRAY)
    _, thresholded = cv2.threshold(grayscale, 220, 255, cv2.THRESH_BINARY)
    return thresholded


def adjust_background(img, kernel_size):
    kernel = np.ones((kernel_size, kernel_size), np.uint8)
    blackhat = cv2.morphologyEx(img, cv2.MORPH_BLACKHAT, kernel)
    temp = 255 - blackhat
    return temp


if len(sys.argv) == 1:
    print("Program called with no input files.")
    print("Drag a file onto the program.")
    var = raw_input("Please enter something: ")

for k in range(len(sys.argv) - 1):
    main(sys.argv[k + 1])
