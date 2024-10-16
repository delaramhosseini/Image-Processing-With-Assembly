# Image Processor in Assembly Language

## Introduction

This project implements an Image Processor using assembly language, designed to process images through various transformations. The workflow involves converting an input image into a matrix using Python, saving that matrix in a text file, processing the matrix in assembly, and then displaying the final image, which is also saved in a text file.

## Features

The Image Processor includes the following features:

1. **Opening Image**: Load an image matrix from a text file.
2. **Reshape**: Change the dimensions of the image matrix.
3. **Resizing**: Alter the size of the image.
4. **Gray Scaling**: Convert the image to grayscale.
5. **Convolution Filters**: Apply various convolution filters to enhance or modify the image.
6. **Pooling**: Reduce the dimensionality of the image while preserving important features.
7. **Noise Processing**: Add or reduce noise in the image.

## Workflow

1. **Convert Image to Matrix**: 
   - Use the provided Python script to convert an input image to a matrix and save it as a text file.
   - Example command: `python convert_image_to_matrix.py input_image.jpg output_matrix.txt`

2. **Process the Matrix**: 
   - Use the assembly program to open the matrix file and apply the desired transformations.
   - The assembly program will display a menu of options for the user to choose from.

3. **Save Final Matrix**: 
   - After applying the desired changes, the modified matrix is saved to a new text file.

4. **Display Final Image**: 
   - Use the Python script to read the final matrix and display the processed image.
   - Example command: `python display_image.py final_matrix.txt`

## Usage

1. **Prepare Input Image**: Ensure your input image is in a supported format (e.g., JPG, PNG).
2. **Run the Conversion Script**: Convert the image to a matrix.
3. **Compile and Run Assembly Program**: Follow the instructions for your specific assembly environment to compile and run the assembly code.
4. **Choose Processing Options**: Use the menu to select desired image processing features.
5. **View Output**: Display the final processed image.

