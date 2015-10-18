#! /bin/bash

# ************************************************************************************
# Fichier 		: gestion_repatriations.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./gestion_repatriations.sh [--list] [--add]  [--del]
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
	fileListRepatriations=${DIR}"/../Data/list_repatriations.txt"
}

# Display the menu. 3 choices are available.
function displayMenu {
	echo "displayMenu function called"
}

# List the repatriations contained in Data/list_repatriations.txt file
function listRepatriations {
	echo "listRepatriations function called"
}

# Delete one or many repatriation(s) in Data/list_repatriations.txt
function delRepatriation {
	echo "delRepatriation function called"
	local sep="|"
	listRepatriationsToDel=`zenity --list --checklist --separator=${sep} --text="Select repatriation(s) to delete :" --width=500 --height=300\
			--column="" --column="Repatriations" \
			$(sed s/^/FALSE\ / ${fileListRepatriations})`
	for repatriation in `echo $listRepatriationsToDel | tr ${sep} " "`
	do
		echo "Removing of repatriation : ${repatriation}"
		sed -i "\?${repatriation}?d" ${fileListRepatriations}
		#idRepatriation=`echo $repatriation | cut -f 1 -d":"`
		#echo $idRepatriation
		#echo ${fileListRepatriations}
		#sed -i "/^${idRepatriation}:/d" ${fileListRepatriations}
	done
}

# Add one repatriation in Data/list_repatriations.txt
function addRepatriation {
	echo "addRepatriation function called"
}


########################
#    Main 
########################

init
if [ $# -lt 1 ]
then
	echo "Displaying the Repatriation Management menu"
	displayMenu
else
	case $1 in
		1 | "--list" | "-l")
			echo "List of repatriations (call of listRepatriations function)"
			listRepatriations
			;;
		2 | "--add" | "-a")
			echo "Add a repatriation (call of addRepatriation function)"
			addRepatriation
			;;
		3 | "--del" | "-d")
			echo "Delete a repatriation (call of delRepatriation function)"
			delRepatriation
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
