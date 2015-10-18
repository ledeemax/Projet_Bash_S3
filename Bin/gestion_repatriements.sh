#! /bin/bash

# ************************************************************************************
# Fichier 		: gestion_repatriements.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./gestion_repatriements.sh [--list] [--add]  [--del]
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
	fileListRepatriements=${DIR}"/../Data/list_repatriements.txt"
}

# Display the menu. 3 choices are available.
function displayMenu {
	echo "displayMenu function called"
}

# List the repatriements contained in Data/list_repatriements.txt file
function listRepatriements {
	echo "listRepatriements function called"
}

# Delete one or many repatriement(s) in Data/list_repatriements.txt
function delRepatriement {
	echo "delRepatriement function called"
	local sep="|"
	listRepatriementsToDel=`zenity --list --checklist --separator=${sep} --text="Select repatriement(s) to delete :" --width=500 --height=300\
			--column="" --column="Repatriements" \
			$(sed s/^/FALSE\ / ${fileListRepatriements})`
	for repatriement in `echo $listRepatriementsToDel | tr ${sep} " "`
	do
		echo "Removing of repatriement : ${repatriement}"
		sed -i "/${repatriement}/d" ${fileListRepatriements}
	done
}

# Add one repatriement in Data/list_repatriements.txt
function addRepatriement {
	echo "addRepatriement function called"
}


########################
#    Main 
########################

init
if [ $# -lt 1 ]
then
	echo "Displaying the Repatriement Management menu"
	displayMenu
else
	case $1 in
		1 | "--list" | "-l")
			echo "List of repatriements (call of listRepatriements function)"
			listRepatriements
			;;
		2 | "--add" | "-a")
			echo "Add a repatriement (call of addRepatriement function)"
			addRepatriement
			;;
		3 | "--del" | "-d")
			echo "Delete a repatriement (call of delRepatriement function)"
			delRepatriement
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
