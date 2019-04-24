# coding: utf-8
##################################################################################################
#			Script d'interpolation utilisant différentes méthodes			 #
#				Author: Ibtissame FOUNDI			 		 #
##################################################################################################

import matplotlib.pyplot as plt
import numpy as np
import scipy.interpolate
import pykrige.kriging_tools as kt
from pykrige.ok import OrdinaryKriging

#Les coordonnées des capteurs convertis
x = np.array([4.40382550111228, 4.40367297055063, 4.40374381807926, 4.40363212903412])
y = np.array([ 45.4279240753273, 45.4280007044454,  45.4278930726774,45.4278597301859])

# Valeurs de luminosité moyenne des 4 capteurs
# pour la plage horaire:1529921000000000000:1529921999999999999
z = np.array([98,39 ,73,92])


# Création des pairs de coordonnées
cartcoord = list(zip(x, y))
X = np.linspace(min(x), max(x),1000)
Y = np.linspace(min(y), max(y),1000)
X, Y = np.meshgrid(X, Y)

########################## Triangulation interpolation#####################################
interp = scipy.interpolate.LinearNDInterpolator(cartcoord, z, fill_value=0)
Z0 = interp(X, Y)
plt.figure(1)
plt.pcolormesh(X, Y, Z0)
plt.grid()
plt.title("Interpolation par triangulation")
plt.colorbar()
plt.show()

########################### Kriging Interpolation #########################################

#Utilisation du package pyKrige de python 

OK = OrdinaryKriging(x, y, z, variogram_model='linear',verbose=False, enable_plotting=False)

# Creates the kriged grid and the variance grid. Allows for kriging on a rectangular
# grid of points, on a masked rectangular grid of points, or with arbitrary points.
gridx = np.arange(x.min(), x.max(), 0.0000005)
gridy = np.arange(y.min(), y.max(), 0.0000005)
Z, ss = OK.execute('grid', gridx, gridy)
plt.figure(2)
plt.pcolormesh(gridx, gridy, Z)
plt.grid()
plt.title("Interpolation par krigeage")
plt.colorbar()
plt.show()

# Writes the kriged grid to an ASCII grid file.
kt.write_asc_grid(gridx, gridy, Z, filename="outputKrigeage.asc")

###########################################################################################
# Spline linear interpolation
func = scipy.interpolate.interp2d(x, y, z)
Z = func(X[0, :], Y[:, 0])
plt.figure(3)
plt.pcolormesh(X, Y, Z)
plt.grid()
plt.title("Interpolation par Spline Lineaire")
plt.colorbar()
plt.show()

