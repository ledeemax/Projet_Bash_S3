#! /bin/bash

# ************************************************************************************
# Fichier 		: main.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./main.sh [--users] [--repatriements] [--strategies] [--report]
# ************************************************************************************

#################################
#    Initialisation (CONSTANTES)
#################################
USAGE="Usage:\
\t $0 \n\
\t $0 [1] [--users] \n\
\t $0 [2] [--repatriements] \n\
\t $0 [3] [--strategies] \n\
\t $0 [4] [--report] \n\
\t $0 [--help] [-h]"
VERSION=1
AUTHORS="Stéphanie LEVON & Maxime LEDEE"
ORGANISATION="Master Degree Bioinformatics - Rouen University"


#################################
#    Functions
#################################

# Initialisation of variables
function init {
	echo "init function called"
	DIR="$( cd "$( dirname "${0}" )" && pwd )"
	# TODO :
	# fileTexModel=
	# fileHtmlModem=
	# dirData=
	# ... ?
}

# Display the main menu. 4 choices are available.
function displayMainMenu {
	echo "displayMainMenu function called"
	choice=`zenity --list --title="Main menu" --text="Select a choice :" --width=320 --height=207 \
		--column="" --column="Description" \
		1 "Gérer la liste des utilisateurs" \
		2 "Gérer la liste des rapatriements" \
		3 "Gérer la liste des stratégies" \
		4 "Générer un rapport"`

	case $choice in
		1)
			echo "Choice 1 selected : Gestion de la liste des utilisateurs (./Bin/gestion_users.sh executed)"
			exec ./Bin/gestion_users.sh
			;;
		2)
			echo "Choice 2 selected : Gestion de la liste des rapatriements (./Bin/gestion_repatriements.sh executed)"
			exec ./Bin/gestion_repatriements.sh
			;;
		3)
			echo "Choice 3 selected : Gestion de la liste des stratégies (./Bin/gestion_strategies.sh executed)"
			exec ./Bin/gestion_strategies.sh
			;;
		4)
			echo "Choice 4 selected : Génération d'un rapport (displayMenuGenerationReport function called)"
			displayMenuGenerationReport
			;;
		*)
			echo "Canceled"
			;;
	esac
}

# Display the menu to generate a report based on a user and/or a period.
function displayMenuGeneratedReport {
	echo "displayMenuGeneratedReport function called"
}

# Generate a report based on a user and/or a period.
# Arguments: a user, a period (the beginning and the end), a type of report (website, document or slide).
# TODO: generate a model (html or tex).
function generateReport {
	echo "generateReport function called"
}

# Download file.
function getData {
	echo "getData function called"
#	id_rapat=grep $1 list_strategies.txt | cut f=3
#	isLoged=grep $1 list_strategies.txt | cut f=5
#	destinationDir=grep $id_rapat list_rapatriement.txt | cut f=2
#	sourceFil=
#
#	isRecent= checkFileIsRecent()
#
#	if (! isRecent)
#	{
#		wget ftp...fichier.fq
#	}
#	if isLog=='y') 
#	{
#		id_user=grep $1 list_strategies.txt | cut f=2
#		prenom=grep $id_user list_users.txt | cut f=2
#		nom=grep $id_user list_users.txt | cut f=3
#		if (on a bien télécharger le fichier
#			setLog() # réussie >> log
#		else
#			setLogéchec >> log
#	}
}

# Check if file to download is not already present in local repertory.
function checkLastFile {
	echo "checkLastFile function called"
}

# Generate/update a log file.
function setLog {
	echo "setLog function called"
}


#################################
#    Main
#################################

# TODO :
# init

if [ $# -lt 1 ]			# less then / est plus petit que
then
	echo "Displaying the main menu"
	displayMainMenu
else
	case $1 in
		1 | "--users")
			echo "Gestion de la liste des utilisateurs (call of ./Bin/gestion_users.sh script)"
			exec ./Bin/gestion_users.sh
			;;
		2 | "--repatriements")
			echo "Gestion de la liste des rapatriements (call of ./Bin/gestion_repatriements.sh script)"
			exec ./Bin/gestion_repatriements.sh
			;;
		3 | "--strategies")
			echo "Gestion de la liste des stratégies (call of ./Bin/gestion_strategies.sh script)"
			exec ./Bin/gestion_strategies.sh
			;;
		4 | "--report")
			echo "Génération d'un rapport (call of displayMenuGenerationReport function)"
			displayMenuGenerationReport
			;;
		"-h" | "--help")
			echo -e ${USAGE}
			exit 1
			;;
		"-v" | "--version")
			echo -e "VERSION: ${VERSION}\nAUTHORS: ${AUTHORS}\nORGANISATION: ${ORGANISATION}"
			exit 1
			;;
		*)
			echo -e "Invalid argument.\n${USAGE}"
			exit 1
			;;
	esac
fi
