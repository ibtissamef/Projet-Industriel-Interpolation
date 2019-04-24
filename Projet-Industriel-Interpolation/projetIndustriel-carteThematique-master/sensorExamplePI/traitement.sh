#!/bin/bash
####################################################################################################
# 		Calcul de moyenne de luminosité en chaque capteur pour		  		   #
#	     la plage horaire 1529921000000000000,1529921999999999999 ms			   #
#          			Author: Ibtissame FOUNDI					   #
####################################################################################################

#Liste des valeurs initialisée
Liste_V_Luminosite=(0 0 0 0)

#Parcours sur les capteurs
for capteur_id in `seq 1 4`;
do
	# Récupérer la taille de l'échantillon du capteur séléctionné 
	taille_echantillon=`grep -i -e ^"metrics,1529921" donneesRDC_id_$capteur_id.csv | wc -l`
	echo "la taille de l echantillon est bien: $taille_echantillon"
	
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
