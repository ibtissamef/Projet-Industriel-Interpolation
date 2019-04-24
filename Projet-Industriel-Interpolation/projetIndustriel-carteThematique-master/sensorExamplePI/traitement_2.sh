#!/bin/bash
####################################################################################################
# 		Calcul de moyenne de luminosité en chaque capteur pour		  		   #
#	     le temps t0 correspondant à la 1ere ligne du fichier de données  			   #
#          			Author: Ibtissame FOUNDI					   #
####################################################################################################


# Récupérer le temps t0 correspondant à la 1ère ligne du fichier 
t0=`sed -n 1p donneesRDC_id_1.csv| cut -d ',' -f 2`
echo "le temps considéré est bien: $t0"

luminosite1=`sed -n 1p donneesRDC_id_1.csv| cut -d ',' -f 4`

#Parcours sur les capteurs
for capteur_id in `seq 2 4`;
do
	
	#Recuperer les valeurs de temps 
	cut -d ',' -f 2 donneesRDC_id_$capteur_id.csv > donnes.txt

	#Parcourir le fichier de valeurs temporelle
	#Calculer la difference entre le temps et t0 et prendre la plus petite 

	#Récupérer les valeurs de luminosité recencées durant cette plage horaire, et les stocker dans
	# un fichier intermédiare 
	grep -i -e ^"metrics,1529921" donneesRDC_id_$capteur_id.csv | cut -d ',' -f 4 > donnes.txt

	luminosite="0"
	sequence=`expr $taille_echantillon - 1`
	plus=" + "
	
	#Parcours du fichier intermédiare ligne par ligne
	for i in `seq 1 $sequence`;
	do 
		#Récupération de la valeur de la luminosité à la ligne i
		valeur=`sed -n "$i"p donnes.txt`
		#Additionner la valeur récupérée à la valeur précédente de "luminosité"
		luminosite=$( printf '%f + %f\n' "$luminosite" "$valeur" | bc )
	done
	
	#Calcul de la valeur moyenne
	luminosite_moyenne=$( printf '%f / %f\n' "$luminosite" "$taille_echantillon" | bc )
	#Remplissage de la liste
	Liste_V_Luminosite[`expr $capteur_id - 1`]=$luminosite_moyenne
	printf 'luminosite moyenne du capteur %d  est bien = %d \n' "$capteur_id" "$luminosite_moyenne" 
	#Suppression du fichier intermédiaire
	rm donnes.txt
done

#Affichage du contenu de la liste des valeurs moyenne
echo "Notre liste de valeurs moyenne est bien: ${Liste_V_Luminosite[@]}"
