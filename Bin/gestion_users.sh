#! /bin/bash

# ************************************************************************************
# Fichier 		: gestion_users.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./gestion_users.sh [--list] [--add] [--del]
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
	fileListUsers=${DIR}"/../Data/list_users.txt"
}

# Display the menu. 3 choices are available.
function displayMenu {
	echo "displayMenu function called"
}

# List the users contained in Data/list_users.txt file
function listUsers {
	echo "listUsers function called"
}

# Delete one or many user(s) in Data/list_users.txt
function delUser {
	echo "delUser function called"
	listUsersToDel=`zenity --list --checklist --separator=" " --text="Select user(s) to delete :" --width=500 --height=300\
			--column="" --column="Utilisateurs" \
			$(sed s/^/FALSE\ / ${fileListUsers})`
	for user in `echo $listUsersToDel`
	do
		echo "Removing of user : ${user}"
		sed -i "/${user}/d" ${fileListUsers}
	done
}

# Add one user in Data/list_users.txt
function addUser {
	echo "addUser function called"
}


########################
#    Main 
########################

init
if [ $# -lt 1 ]
then
	echo "Displaying the User Management menu"
	displayMenu
else
	case $1 in
		1 | "--list" | "-l")
			echo "List of users (call of listUsers function)"
			listUsers
			;;
		2 | "--add" | "-a")
			echo "Add a user (call of addUser function)"
			addUser
			;;
		3 | "--del" | "-d")
			echo "Delete a user (call of delUser function)"
			delUser
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
