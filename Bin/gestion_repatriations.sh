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
	choice=`zenity --list --title="Main menu" --text="Select a choice :" --width=320 --height=207 \
		--column="" --column="Description" \
		1 "Display the list of all repatriations" \
		2 "Add a repatriation" \
		3 "Delete a repatriation"`
		
		case $choice in
		1)
			echo "Choice 1 selected : Display the list of all repatriations"
			listRepatriations
			;;
		2)
			echo "Choice 2 selected : Add a repatriation"
			addRepatriation
			;;
		3)
			echo "Choice 3 selected : Delete repatriation(s)"
			delRepatriation
			;;

		*)
			echo "Canceled"
			;;
	esac
}

# List the repatriations contained in Data/list_repatriations.txt file
function listRepatriations {
	echo "listRepatriations function called"
	id=$(cat $fileListRepatriations | cut -d : -f 1) 
	folder=$(cat $fileListRepatriations | cut -d : -f 2) 
	file_adress=$(cat $fileListRepatriations | cut -d : -f 3)
	yad --list --center --text="Display repatriation" --width=600 --height=300\
			--column="Id" $id --column="Destination folder" $folder --column="File link" $file_adress \
			--button=Return
	
	echo "Return to Menu"
	displayMenu
}

# Add one repatriation in Data/list_repatriations.txt
function addRepatriation {
	echo "addRepatriation function called"
	newRepatriation=`yad --width=400 --title="" --center --text="Please enter your details:" --separator=":" \
		--form \
		--field="Destination folder" \
		--field="File adress"`
	getNewId
	newDestinationFolder=`echo $newRepatriation | cut -d : -f 1`
	newFileAdress=`echo $newRepatriation | cut -d : -f 2`
	echo "$newId:$newDestinationFolder:$newFileAdress" >> $fileListRepatriations 
	echo "New Repatriation add"
	../main.sh
}

function getNewId {
	lastId=$(cat $fileListRepatriations | cut -d : -f 1 | sort -nr | head -n 1 )
	newId=$(($lastId+1))
}

# Delete one or many repatriation(s) in Data/list_repatriations.txt
function delRepatriation {
	echo "delRepatriation function called"
	listRepatriationsToDel=`zenity --list --checklist --separator=" " --text="Select repatriation(s) to delete :" --width=500 --height=300\
			--column="" --column="Repatriations" \
			$(sed s/^/FALSE\ / ${fileListRepatriations})`
	for repatriation in `echo $listRepatriationsToDel`
	do
		echo "Removing of repatriation : ${repatriation}"
		sed -i "\?${repatriation}?d" ${fileListRepatriations}
	done
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
