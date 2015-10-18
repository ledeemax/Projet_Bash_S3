#! /bin/bash

# ************************************************************************************
# Fichier 		: main.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./main.sh
# ************************************************************************************

#################################
#    Initialisation (CONSTANTES)
#################################
USAGE="Usage:\
\t ./main.sh \n\
\t ./main.sh [1] [--users] \n\
\t ./main.sh [2] [--repatriements] \n\
\t ./main.sh [3] [--strategies] \n\
\t ./main.sh [4] [--report] \n\
\t ./main.sh [--help] [-h]"
VERSION=1
AUTHORS="Stéphanie LEVON & Maxime LEDEE"
ORGANISATION="Master Degree Bioinformatics - Rouen University"

#################################
#    Functions
#################################

# Display the main menu. 4 choices are available.
function displayMainMenu {
	chx=`zenity --list --title="Main menu" --text="Select a choice :" --width=320 --height=207 --column="Choice" --column="Description" \
1 "Gérer la liste des utilisateurs" \
2 "Gérer la liste des rapatriements" \
3 "Gérer la liste des stratégies" \
4 "Générer un rapport"`

	case $chx in
		1)
			echo "Choice 1 : Gestion de la liste des utilisateurs (./Bin/gestion_users.sh executed)"
			exec ./Bin/gestion_users.sh
			;;
		2)
			echo "Choice 2 : Gestion de la liste des rapatriements (./Bin/gestion_repatriements.sh executed)"
			exec ./Bin/gestion_repatriements.sh
			;;
		3)
			echo "Choice 3 : Gestion de la liste des stratégies (./Bin/gestion_strategies.sh executed)"
			exec ./Bin/gestion_strategies.sh
			;;
		4)
			echo "Choice 4 : Génération d'un rapport (displayMenuGenerationReport function called)"
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

# Check if file to download is not already present in local repertory..
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

#if [ $# -eq 0 ]
if [ $# -lt 1 ]			# less then / est plus petit que
then
	echo "Displaying the main menu"
	displayMainMenu
else
	#echo "$# argument(s) trouvé(s)"
	case $1 in
		1 | "--users")
			echo "Gestion de la liste des utilisateurs (./Bin/gestion_users.sh executed)"
			exec ./Bin/gestion_users.sh
			;;
		2 | "--repatriements")
			echo "Gestion de la liste des rapatriements (./Bin/gestion_repatriements.sh executed)"
			exec ./Bin/gestion_repatriements.sh
			;;
		3 | "--strategies")
			echo "Gestion de la liste des stratégies (./Bin/gestion_strategies.sh executed)"
			exec ./Bin/gestion_strategies.sh
			;;
		4 | "--report")
			echo "Génération d'un rapport (displayMenuGenerationReport function called)"
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
			echo -e "Argument incorrect.\n${USAGE}"
			exit 1
	esac
fi
