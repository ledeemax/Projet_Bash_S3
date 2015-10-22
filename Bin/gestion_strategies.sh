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
	fileListUsers=${DIR}"/../Data/list_users.txt"
	fileListRepatriations=${DIR}"/../Data/list_repatriations.txt"
	fileListPeriodicities=${DIR}"/../Data/list_periodicities.txt"
}

# Display the menu. 3 choices are available.
function displayMenu {
	echo "displayMenu function called"
	choice=`zenity --list --title="Main menu" --text="Select a choice :" --width=320 --height=215 \
		--column="" --column="Strategy menu" \
		1 "Display list" \
		2 "Add" \
		3 "Delete"\
		4 "Back to Main Menu"`
		
	case $choice in
		1)
			echo "Choice 1 selected : Display the list of all strategies"
			listStrategies
			;;
		2)
			echo "Choice 2 selected : Add a strategy"
			addStrategy
			;;
		3)
			echo "Choice 3 selected : Delete user(s)"
			delStrategy
			;;
		4)
			echo "Choice 4 selected : Back to Main Menu"
			../main.sh 
			;;

		*)
			echo "Canceled"
			;;
	esac
}

# List the strategies contained in Data/list_strategies.txt file
function listStrategies {
	echo "listStrategies function called"
	strategies=$(cut -d : -f 2- $fileListStrategies) 
	yad --center --list --separator=${sep} --button=Return  --text="Display strategies" --width=600 --height=300\
			--column="Users" $strategies
	echo "Return to Menu"
	displayMenu
}

# Delete one or many strategie(s) in Data/list_strategies.txt
function delStrategy {
	echo "delStrategies function called"
	listStrategiesToDel=`zenity --list --checklist --separator=" " --text="Select strategie(s) to delete :" --width=500 --height=300\
			--column="" --column="Strategies" \
			$(sed s/^/FALSE\ / ${fileListStrategies})`
	if ! [ -z "$listStrategiesToDel" ]
	then
		for strategyToDel in `echo $listStrategiesToDel`
		do
			echo "Removing of strategy : ${strategyToDel}"
			sed -i "/${strategyToDel}/d" ${fileListStrategies}
			idStrategyToDel=`echo ${strategyToDel} | cut -f 1 -d":"`
			delCron ${idStrategyToDel}
		done
	else
		yad --center --width=400 --title="No strategy deleted" --text "No strategy deleted. \n Click \"Validate\" to return to Strategy Menu." 
		displayMenu
	fi
}

# Add one strategy in Data/list_strategies.txt
function addStrategy {
	echo "addStrategy function called"
	
	listUsers=$(cat ${fileListUsers} | tr "\n" "," | sed "s/,$//")
	listRepatriations=$(cat ${fileListRepatriations} | tr "\n" "," | sed "s/,$//")
	listPeriodicities=$(cat ${fileListPeriodicities} | cut -f 1 -d":" | tr "\n" "," | sed "s/,$//")
	# TODO ? Autoriser l'user à définir un cron personnel ?
	# listPeriodicities=$(cat ${fileListPeriodicities} | cut -f 1 -d":" | tr "\n" ",")"other"
	# --field="Examples setting personal periodicity :":RO \
	# "Tous les jours à 12h30 : 30 12 * * *"
	
	strategyToAdd=`yad --width=400 --center --title="Add strategy" --text="Please enter your strategy:" \
		--form --item-separator="," \
		--field="Select user :":CB \
		--field="Select source file :":CB \
		--field="Select periodicity :":CB \
		--field="will be logged ?":CB \
		"${listUsers}" "${listRepatriations}" "${listPeriodicities}"  "yes,no"`

	if [ "${strategyToAdd}" == "" ]
	then
		echo "Cancelling to add a strategy"
		yad --center --width=400 --title="What next?" --text "No strategy added. \n Click \"Validate\" to return to the Main Manu." 
		displayMenu
		
	else
		idUser=$(echo $(echo ${strategyToAdd} | cut -f 1 -d"|") | cut -f 1 -d":")
		idRepatriation=$(echo $(echo ${strategyToAdd} | cut -f 2 -d"|") | cut -f 1 -d":")
		periodName=$(echo ${strategyToAdd} | cut -f 3 -d"|")
		periodCron=`grep ${periodName} ${fileListPeriodicities} | cut -f 2 -d":"`
		isToLog=$(echo ${strategyToAdd} | cut -f 4 -d"|")
		echo "idUser = ${idUser}"
		echo "idRepatriation = ${idRepatriation}"
		echo "periodName = ${periodName}"
		echo "isToLog = ${isToLog}"
		echo "periodCron = ${periodCron}"

		getNewId
		echo "newIdStrategy = $newIdStrategy"

		strategyToAdd="${newIdStrategy}:${idUser}:${idRepatriation}:${periodName}:${isToLog}"
		echo "Updating of Data/list_strategies.txt file"
		chmod +w ${fileListStrategies}
		echo ${strategyToAdd} >> ${fileListStrategies}
		addCron
		yad --center --width=400 --title="What next?" --text "Your strategy has been successfully add. \n Click \"Validate\" to return to the Main Manu." 
		exec ${scriptMain}
	fi
	
}

# Add a cron in crontab file
function addCron {
	echo "addCron function called"
	crontab -l > mycron.tmp
	echo "${periodCron} ${scriptMain} --get-data ${newIdStrategy}" >> mycron.tmp
	echo "${periodCron} ${scriptMain} --get-data ${newIdStrategy}"
	crontab mycron.tmp
	rm -f mycron.tmp
}

# Delete a cron in crontab file
function delCron {
	echo "delCron function called"
	local idToDel=$1
	echo "idToDel = $idToDel"
	crontab -l > mycron.tmp
	sed -i "/${idToDel}$/d" mycron.tmp
	crontab mycron.tmp
	rm -f mycron.tmp
	echo -e "Successfull removal of the strategy n°${idToDel} in crontab"
	yad --center --width=400 --title="Strategy deleted" --text "The strategy/strategies has successfully been deleted. Click \"Validate\" to return to the Main Menu " 
		exec ${scriptMain}
}

# Get the max ID in Data/list_strategies.txt, and increment to 1
function getNewId {
	newIdStrategy=`cat ${fileListStrategies} | cut -f 1 -d":" | sort -nr | head -n1`
	newIdStrategy=$((newIdStrategy+1))
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
			echo "Add a strategy (call of addStrategy function)"
			addStrategy
			;;
		3 | "--del" | "-d")
			echo "Delete a strategy (call of delStrategy function)"
			delStrategy
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
