import numpy as np 
from matplotlib.image import imread

# directory = "/home/assembly/code/final project/second part/second"
directory = "/home/assembly/code/final project/second part/"
ImageName = input("please enter image address:")

ImageDirectory = directory + ImageName + ".JPG"
image = imread(ImageDirectory)

FileDirectory = directory + ImageName + ".text"
f = open(FileDirectory, "w")

matrix_shape = image.shape

f.write('size of three matrixes:')
f.write(str(matrix_shape[0])+' '+str(matrix_shape[1])+'\n'+'\n')

array_1d_R_matrix = image[:,:,0].flatten()
list_1d_R_matrix = array_1d_R_matrix.tolist()

array_1d_G_matrix = image[:,:,1].flatten()
list_1d_G_matrix = array_1d_G_matrix.tolist()

array_1d_B_matrix = image[:,:,2].flatten()
list_1d_B_matrix = array_1d_B_matrix.tolist()

R_list = [*list_1d_R_matrix]
G_list = [*list_1d_G_matrix]
B_list = [*list_1d_B_matrix]

f.write('R_matrix')
f.write('\n')
for Item in R_list:
    f.write(str(Item)+' ')
f.write('\n')
f.write('\n')

f.write('G_matrix')
f.write('\n')
for Item in G_list:
    f.write(str(Item)+' ')
f.write('\n')
f.write('\n')

f.write('B_matrix')
f.write('\n')
for Item in B_list:
    f.write(str(Item)+' ')
    
f.write('$')
f.close()