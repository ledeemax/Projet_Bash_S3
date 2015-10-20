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
	choice=`zenity --list --title="Main menu" --text="Select a choice :" --width=320 --height=207 \
		--column="" --column="Description" \
		1 "Display the list of all users" \
		2 "Add a user" \
		3 "Delete a user"`
		
	case $choice in
		1)
			echo "Choice 1 selected : Display the list of all users"
			listUsers
			;;
		2)
			echo "Choice 2 selected : Add a user"
			addUser
			;;
		3)
			echo "Choice 3 selected : Delete user(s)"
			delUser
			;;

		*)
			echo "Canceled"
			;;
	esac
}

# List the users contained in Data/list_users.txt file
function listUsers {	# TODO : au lieu d'une seule colonne en construire 3 ac Nom - Prenom - mail
	echo "listUsers function called"
	#numero=$(cut -c1 $fileListUsers)
	#echo $numero
	user=$(cut -d : -f 2- $fileListUsers)
	#echo $user
	yad --list --separator=${sep} --button=Return --center --text="Display users" --width=600 --height=300\
			--column="Users" $user
	
	echo "Return to Menu"
	displayMenu
}

# Add one user in Data/list_users.txt
function addUser {
	echo "addUser function called"
	newUser=`yad --width=400 --title="" --text="Please enter your details:" --separator=":" \
		--form \
		--field="Last name" \
		--field="First name" \
		--field="email adresse"`
	getNewId
	lastName=`echo $newUser | cut -d : -f 1 | tr [a-z] [A-Z]`
	firstName=`echo $newUser | cut -d : -f 2`
	email=`echo $newUser | cut -d : -f 3 | sed "s/:$//"`
	echo "$newId:$lastName:$firstName:email" >> $fileListUsers 
	../main.sh
}

function getNewId {
	lastId=$(cat $fileListUsers | cut -d : -f 1 | sort -nr | head -n 1 )
	newId=$(($lastId+1))
}

# Delete one or many user(s) in Data/list_users.txt
function delUser {
	echo "delUser function called"
	local sep="|"
	listUsersToDel=`zenity --list --checklist --separator=${sep} --text="Select user(s) to delete :" --width=500 --height=300\
			--column="" --column="Utilisateurs" \
			$(sed s/^/FALSE\ / ${fileListUsers})`
	for user in `echo $listUsersToDel | tr ${sep} " "`
	do
		echo "Removing of user : ${user}"
		sed -i "/${user}/d" ${fileListUsers}
	done
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
