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
	fileListStrategies=${DIR}"/../Data/list_strategies.txt"
	scriptMain=${DIR}"/../main.sh"
}

# Display the menu. 3 choices are available.
function displayMenu {
	echo "displayMenu function called"
	choice=`zenity --list --title="Main menu" --text="Select a choice :" --width=320 --height=250 \
		--column="" --column="User menu" \
		1 "Display list" \
		2 "Add" \
		3 "Modify" \
		4 "Delete"\
		5 "Back to Main Menu"`
		
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
			echo "Choice 3 selected : Modify user"
			modifyUser
			;;
		4)
			echo "Choice 4 selected : Delete user(s)"
			delUser
			;;
		5)
			echo "Choice 5 selected : Back to Main Menu"
			exec ${scriptMain}
			;;

		*)
			echo "Canceled"
			;;
	esac
}

# List the users contained in ../Data/list_users.txt file
function listUsers {	# TODO : au lieu d'une seule colonne en construire 3 ac Nom - Prenom - mail
	echo "listUsers function called"
	user=$(cut -d : -f 2- $fileListUsers) # User file without Id
	yad --center --list --separator=${sep} --button=Return  --text="Display users" --width=600 --height=300\
			--column="Users" $user
	
	echo "Return to Menu"
	displayMenu
}

# Add one user in Data/list_users.txt
function addUser {
	chmod +w $fileListUsers
	echo "addUser function called"
	newUser=`yad --center --width=400 --title="" --text="Please enter your details:" --separator=":" \
		--form \
		--field="Last name" \
		--field="First name" \
		--field="email adresse"`
	getNewId
	if ! [ -z "$newUser" ]
	then
		lastName=`echo $newUser | sed "s/ /_/g" | cut -d : -f 1 | tr [a-z] [A-Z]` # Formate le nom de famille en majuscule, remplace les éventuels espaces par "_"
		firstName=`echo $newUser | cut -d : -f 2` 
		email=`echo $newUser | cut -d : -f 3 | sed "s/:$//"`
		echo "$newId:$lastName:$firstName:$email" >> $fileListUsers # Ajoute le nouvel utilisateur au fichier Utilisateur
		yad --center --width=400 --title="What next?" --text "A new user has been successfully added. \n You can now add a repatriation or a strategy :) " 
		exec ${scriptMain}
	else
		yad --center --width=400 --title="No new user add" --text "No user added. \n Click \"Validate\" to return to User Menu." 
		displayMenu
	fi
}

function getNewId {
	lastId=$(cat $fileListUsers | cut -d : -f 1 | sort -nr | head -n 1 )
	newId=$(($lastId+1))
}

# Modify one user
function modifyUser {
	echo "modifyUser function called"
	
	listUsers=$(cat ${fileListUsers} | tr "\n" "," | sed "s/,$//")
	userToModify=`yad --width=400 --center --title="Modify user" --text="Please enter your changes:" --separator="#" \
		--form --item-separator="," \
		--field="Select user :":CB \
		--field="New user Last name :" \
		--field="New user First name :" \
		--field="New user email :" \
		--text="Value will not be changed for unfilled field." \
		"${listUsers}"`
	if ! [ -z "$userToModify" ]
	then
		echo "$userToModify" 
		# 6 fe  fezzz

		# 6:BERGER:michel:michel_b@gmail.com|BERGER|Michel|michhhhh@b.fr|
		# 5:LE_TIROIR_DE_LA_COMMODE:monique:momo.tiroir@gege.com||Micheline||
		idUser=`echo $userToModify | cut -c 1`
		newlastName=`echo $userToModify | cut -d"#" -f 2`
		newfirstName=`echo $userToModify | cut -d"#" -f 3`
		newMail=`echo $userToModify | cut -d"#" -f 4`
		
		echo "$idUser $firstName $lastName $mail"
		
		if [ -z "$newLastName" ]
		then
			echo "pas de valeurs dans last name"
		else
			lastName=$newLastName
		fi


		if [ -z "$newFirstName" ]
		then 
			echo "pas de valeurs dans first name"
		else
			firstName=$newFirstName
		fi
		
		
		if [ -z "$newMail" ]
		then 
			echo "pas de valeurs dans mail"
		else
			email=$newMail
		fi
		echo "$idUser $firstName $lastName $mail"
	else
		displayMenu
	fi
}

# Delete one or many user(s) in Data/list_users.txt
function delUser {
	echo "delUser function called"
	local listUsersToDel=`zenity --list --checklist --separator=" " --text="Select user(s) to delete :" --width=500 --height=300\
			--column="" --column="Utilisateurs" \
			$(sed s/^/FALSE\ / ${fileListUsers})`

	if ! [ -z "$listUsersToDel" ]
	then 
		for user in `echo $listUsersToDel`
		do
			local idUser=`echo ${user} | cut -f 1 -d":"`
			if [ "$(cut -f 2 -d":" ${fileListStrategies} | grep ${idUser})" ]
			then
				zenity --warning --width=500 --height=50 \
					--text "ID user's is used in list strategies's. Please remove the strategy containing the user ID's (${idUser}), then come back here to remove it"
			else
				echo "Removing of user : ${user}"
				sed -i "/${user}/d" ${fileListUsers}
				chmod +w ${fileListUsers}
			fi
		done
		yad --center --width=400 --title="User deleted" --text "User(s) has been successfully deleted. \n Click \"Validate\" to return to the Main Menu." 
		exec ${scriptMain}
	else
		yad --center --width=400 --title="No user deleted" --text "No user deleted. \n Click \"Validate\" to return to User Menu." 
		displayMenu
	fi
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
