import numpy as np
import matplotlib.pyplot as plt

FileDirectory = input("Please enter matrix address: ")
f = open(FileDirectory, "r")

lines = f.readlines()
f.close()

ShapeOfMatrix = lines[0].split()
Int_ShapeOfMatrix = [int(dim) for dim in ShapeOfMatrix]

R_matrix = lines[1].split()
IntR_matrix = [int(value) for value in R_matrix]
Reshape_IntR_matrix_NP = np.array(IntR_matrix).reshape(Int_ShapeOfMatrix[0], Int_ShapeOfMatrix[1])

G_matrix = lines[2].split()
IntG_matrix = [int(value) for value in G_matrix]
Reshape_IntG_matrix_NP = np.array(IntG_matrix).reshape(Int_ShapeOfMatrix[0], Int_ShapeOfMatrix[1])

B_matrix = lines[3].split()
IntB_matrix = [int(value) for value in B_matrix]
Reshape_IntB_matrix_NP = np.array(IntB_matrix).reshape(Int_ShapeOfMatrix[0], Int_ShapeOfMatrix[1])

Final3DMatrix = np.stack([Reshape_IntR_matrix_NP, Reshape_IntG_matrix_NP, Reshape_IntB_matrix_NP], axis=-1)

plt.imshow(Final3DMatrix, cmap="grey" if Final3DMatrix[:,:,1:].sum() == 0 else None)
plt.axis('off')
plt.show()
plt.savefig("./second part/plot_Result.png")
