#! /bin/bash

# ************************************************************************************
# Fichier 		: gestion_strategies.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./gestion_strategies.sh [--list] [--add]  [--del]
# ************************************************************************************

#################################
#    Initialisation (CONSTANTES)
#################################
USAGE="Usage:\
\t $0 \n\
\t $0 [1] [--list] [-l] \n\
\t $0 [2] [--add] [-a] \n\
\t $0 [3] [--del] [-d] \n\
\t $0 [--help] [-h] \n\
\t $0 [--version] [-v]"
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
	fileListStrategies=${DIR}"/../Data/list_strategies.txt"
	scriptMain=${DIR}"/../main.sh"
}

# Display the menu. 3 choices are available.
function displayMenu {
	echo "displayMenu function called"
}

# List the strategies contained in Data/list_strategies.txt file
function listStrategies {
	echo "listStrategies function called"
}

# Delete one or many strategie(s) in Data/list_strategies.txt
function delStrategies {
	echo "delStrategies function called"
	local sep="|"
	listStrategiesToDel=`zenity --list --checklist --separator=${sep} --text="Select strategie(s) to delete :" --width=500 --height=300\
			--column="" --column="Strategies" \
			$(sed s/^/FALSE\ / ${fileListStrategies})`
	for strategie in `echo $listStrategiesToDel | tr ${sep} " "`
	do
		echo "Removing of strategie : ${strategie}"
		sed -i "/${strategie}/d" ${fileListStrategies}
		# TODO : call delCron function with argument.
	done
}

# Add one strategie in Data/list_strategies.txt
function addStrategie {
	echo "addStrategie function called"
	#if "journaliere"
	#	set "00 04 * * *"
	#if "hebdomadaire"
	#	set "00 04 6 * *"
	#if "mensuel"
	#	set "00 ..."
	#if "tous les 12"
	#	set
	#if "annuelle"
	#	set ...
	#
	#grep annuelle list_periodiciies.txt | cut 
	#
	#task=1:1:1:00 12 * * *:y
	#task=00 12 * * *
	#task >> list_stategies.txt
	#addCron task
	# TODO : call addCron function with argument.
}

# Add a cron in crontab file
# TODO : modify the syntax of the task
# Argument : TODO
function addCron {
	echo "addCron function called"
	#crontab -l > mycron
	# TODO : use ${scriptMain} variable
	#echo "39 12 * * * ./main.sh --getData 1" >> mycron
	#crontab mycron
	#rm mycron
	# TODO : modify the main.sh file. Add a new case in main.
}

# Delete a cron in crontab file
# Argument : TODO
function delCron {
	echo "delCron function called"
}


########################
#    Main 
########################

init
if [ $# -lt 1 ]
then
	echo "Displaying the Strategie Management menu"
	displayMenu
else
	case $1 in
		1 | "--list" | "-l")
			echo "List of strategies (call of listStrategies function)"
			listStrategies
			;;
		2 | "--add" | "-a")
			echo "Add a strategie (call of addStrategie function)"
			addStrategie
			;;
		3 | "--del" | "-d")
			echo "Delete a strategie (call of delStrategie function)"
			addStrategie
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
