#! /bin/bash

# ************************************************************************************
# Fichier 		: main.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./main.sh
# ************************************************************************************

########################
#    Initialisation
########################
USAGE="USAGE : $0"    # TODO A Remplir

########################
#    Functions
########################

function displayMenuMain {

}

function displayMenuGeneratedReport {

}

function createReport {

}

function getData (1) {
	id_rapat=grep $1 list_strategies.txt | cut f=3
	isLoged=grep $1 list_strategies.txt | cut f=5
	destinationDir=grep $id_rapat list_rapatriement.txt | cut f=2
	sourceFil=

	isRecent= checkFileIsRecent()
	
	if (! isRecent)
	{
		wget ftp...fichier.fq
	}
	if isLog=='y') 
	{	
		id_user=grep $1 list_strategies.txt | cut f=2
		prenom=grep $id_user list_users.txt | cut f=2
		nom=grep $id_user list_users.txt | cut f=3
		if (on a bien télécharger le fichier
			setLog() # réussie >> log
		else
			setLogéchec >> log
	
	}
}


function checkLastFile {


}

function setLog {


}


########################
#    Main 
########################



### EXEMPLE : A SUPPRIMER :


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
