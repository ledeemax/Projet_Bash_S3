#! /bin/bash

# ************************************************************************************
# Fichier 		: gestion_users.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./gestion_users.sh [--add] [--list] [--del]
# ************************************************************************************

########################
#    Initialisation
########################
USAGE="USAGE : $0 [--add] [--list] [--del]"  # TODO : a remplir
sourceFile=../Data/list_users.txt

########################
#    Functions
########################

function list {

}

function del {

}

function displayMenu {

}

function add {

}



########################
#    Main 
########################

#if [ $# -eq 0 ]
if [ $# -lt 1 ]			# less then / est plus petit que
then
	echo $USAGE
	exit 1
else
	echo "$# argument(s) trouvé(s)"
	case $# in
		--getData)
			getData($1)
			echo "Exécution du script TP_exo02.sh"
			exec ./TP_exo02.sh $*
			;;
		2)
			echo "Exécution du script TP_exo03.sh"
			exec ./TP_exo03.sh $*
			;;
		3)
			echo "Exécution du script TP_exo04.sh"
			exec ./TP_exo04.sh $*
			;;
		*)
			echo "Erreur"
	esac
fi
