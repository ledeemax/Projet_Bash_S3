#! /bin/bash

# ****************************************************************************************
# Fichier 		: main.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./main.sh [--users] [--repatriations] [--strategies] [--report]
# ****************************************************************************************

#################################
#    Initialisation (CONSTANTES)
#################################
USAGE="Usage:\
\t $0 \n\
\t $0 [1] [--users] \n\
\t $0 [2] [--repatriations] \n\
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
	mkdir -p ${DIR}"/Data" ${DIR}"/Log" ${DIR}"/Reports"
	scriptGestionUsers=${DIR}"/Bin/gestion_users.sh"
	scriptGestionRepatriations=${DIR}"/Bin/gestion_repatriations.sh"
	scriptGestionStrategies=${DIR}"/Bin/gestion_strategies.sh"
	fileListStrategies=${DIR}"/Data/list_strategies.txt"
	fileListUsers=${DIR}"/Data/list_users.txt"
	fileListRepatriations=${DIR}"/Data/list_repatriations.txt"
	fileLog=${DIR}"/Log/get_data.log"
	logFileTmp="log_wget.tmp"
	# TODO :
	# fileTexModel=
	# fileHtmlModem=
	# dirData=
	# ... ?
}

# Display the main menu. 4 choices are available.
function displayMainMenu {
	echo "displayMainMenu function called"
	choice=`zenity --list --title="Main menu" --text="Select a choice :" --width=320 --height=210 \
		--column="" --column="Description" \
		1 "Manage users" \
		2 "Manage repatriations" \
		3 "Manage strategies" \
		4 "Generate a report"\
		5 "Quit"`

	case $choice in
		1)
			echo "Choice 1 selected : Gestion de la liste des utilisateurs (./Bin/gestion_users.sh executed)"
			exec ${scriptGestionUsers}
			;;
		2)
			echo "Choice 2 selected : Gestion de la liste des rapatriements (./Bin/gestion_repatriations.sh executed)"
			exec ${scriptGestionRepatriations}
			;;
		3)
			echo "Choice 3 selected : Gestion de la liste des stratégies (./Bin/gestion_strategies.sh executed)"
			exec ${scriptGestionStrategies}
			;;
		4)
			echo "Choice 4 selected : Génération d'un rapport (displayMenuGenerationReport function called)"
			displayMenuGenerationReport
			;;
		5)
			echo "Good bye"
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

# Perform the repatriation
# Argument: Strategy ID's
# TODO: plusieurs facons pour vérifier et tester un rapatriement
#			1/	ftp .... << BYEBYE
#					newer
#				BYEBYE
#			2/  rsync
#			3/	mirror.pl
function getData {
	echo "getData function called"
	
	local idStrategy=$1
	local strategyLine=`grep ^${idStrategy}: ${fileListStrategies}`
	if [ -z "${strategyLine}" ]
	then
		echo "ERROR: Strategy ID's does not exist"
		exit 1
	fi
	local idUser=`echo ${strategyLine} | cut -f 2 -d":"`
	local idRepatriation=`echo ${strategyLine} | cut -f 3 -d":"`
	local periodicity=`echo ${strategyLine} | cut -f 4 -d":"`
	local isToLog=`echo ${strategyLine} | cut -f 5 -d":"`
	
	local repatriationLine=`grep ^${idRepatriation}: ${fileListRepatriations}`
	local destRepatriation=`echo ${repatriationLine} | cut -f 2 -d":"`
	local protocolRepatriation=`echo ${repatriationLine} | cut -f 3 -d":"`
	local serverRepatriation=`echo ${repatriationLine} | cut -f 4 -d":"`
	local remoteDirRepatriation=`echo ${repatriationLine} | cut -f 5 -d":"`
	local remoteFilesRepatriation=`echo ${repatriationLine} | cut -f 6 -d":"`
	
	local userLine=`grep ^${idUser}: ${fileListUsers}`
	local lastNameUser=`echo ${userLine} | cut -f 2 -d":"`
	local firstNameUser=`echo ${userLine} | cut -f 3 -d":"`
	local mailUser=`echo ${userLine} | cut -f 4 -d":"`
	
	echo -e "\t idStrategy : $idStrategy"
	echo -e "\t idUser : $idUser"
	echo -e "\t idRepatriation : $idRepatriation"
	echo -e "\t periodicity : $periodicity"
	echo -e "\t isToLog : $isToLog"
	destRepatriation=Data/${destRepatriation}
	echo -e "\t destRepatriation : $destRepatriation"
	echo -e "\t protocolRepatriation : $protocolRepatriation"
	echo -e "\t serverRepatriation : $serverRepatriation"
	echo -e "\t remoteDirRepatriation : $remoteDirRepatriation"
	echo -e "\t remoteFilesRepatriation : $remoteFilesRepatriation"
	echo -e "\t lastNameUser : $lastNameUser"
	echo -e "\t firstNameUser : $firstNameUser"
	echo -e "\t mailUser : $mailUser"

	#echo -e "telechargement de : ${protocolRepatriation}://${sourceRepatriation} \n"
	sourceRepat=${protocolRepatriation}://${serverRepatriation}/${remoteDirRepatriation}/${remoteFilesRepatriation}
	echo -e "\t sourceRepat : ${sourceRepat} \n"

	if [[ "$protocolRepatriation" == "ftp" ]]
	then
		echo "check ftp : OK"
		wget --timestamping \
			--progress=bar \
			--level=1 \
			--append-output ${logFileTmp} \
			--directory-prefix ${destRepatriation} \
			--tries=45 \
			--no-parent \
			${sourceRepat}
			#--no-remove-listing \
			#--quota=1k
		status=$?
		if [[ "$isToLog" == "yes" ]]
		then
			setLogFromWget ${idUser} ${lastNameUser} ${firstNameUser} ${mailUser} ${destRepatriation} ${sourceRepat} ${status}
		fi
	elif [[ "$protocolRepatriation" == "http" ]]
	then
		echo "check http : OK"
		wget --timestamping \
			--progress=bar \
			--level=1 \
			--append-output ${logFileTmp} \
			--directory-prefix ${destRepatriation} \
			--tries=45 \
			--no-parent \
			${sourceRepat}
			#--no-remove-listing \
			#--quota=1k
		status=$?
		if [[ "$isToLog" == "yes" ]]
		then
			setLogFromWget ${idUser} ${lastNameUser} ${firstNameUser} ${mailUser} ${destRepatriation} ${sourceRepat} ${status} ${remoteFilesRepatriation}
		fi
	elif [[ "$protocolRepatriation" == "local" ]]
	then
		echo ""
	fi
	
	if [ -f ${logFileTmp} ]
	then
		rm ${logFileTmp}
	fi


#	isRecent= checkFileIsRecent()
#
#	if (! isRecent)
#	{
#		wget ftp...fichier.fq
#	}


}

# Check if file to download is not already present in local repertory.
function checkLastFile {
	echo "checkLastFile function called"
}

# Generate/update a log file.
function setLogFromWget {
	echo "setLog function called"
	local idUser=$1
	local lastNameUser=$2
	local firstNameUser=$3
	local mailUser=$4
	local destRepatriation=$5
	local sourceRepatriation=$6
	local status=$7
	local remoteFilesRepatriation=$8
	
	echo -e "\t idUser : $idUser"
	echo -e "\t lastNameUser : $lastNameUser"
	echo -e "\t firstNameUser : $firstNameUser"
	echo -e "\t mailUser : $mailUser"
	echo -e "\t destRepatriation : $destRepatriation"
	echo -e "\t sourceRepatriation : $sourceRepatriation"
	echo -e "\t remoteFilesRepatriation : $remoteFilesRepatriation"
	echo -e "\t status : $status"

	if [ -f ${logFileTmp} ]
	then
		wgetLog=`tail -3 ${logFileTmp}`
		echo -e "wgetLog = $wgetLog \n"
		case ${status} in
			# No problems occurred :
			"0")
				#taille=`stat -c%s ${destRepatriation}/${remoteFilesRepatriation}`
				#taille=`du -h ${destRepatriation}/${remoteFilesRepatriation} | cut -d"\t" -f1`
				#taille=`du -h Data/IMAGES/googlelogo_color_272x92dp.png `
				taille="12"
				#echo "taille = $taille"
				if [[ ! -z `echo ${wgetLog} | grep "enregistré"` ]]
				then
					echo "Status : 0 (No problems occurred)"
					RES="téléchargement réussie (${taille})"
				elif [[ ! -z `echo ${wgetLog} | grep "pas plus récent que le fichier local"` ]]
				then
					echo "Status : 0 (No problems occurred) but Fichier distant pas plus récent que le fichier local"
					RES="Fichier distant pas plus récent que le fichier local"
				fi
				;;
			# Generic error code :
			"1")
				echo "Status : 1 (Generic error code)"
				RES="Generic error code"
				;;
			# Parse error—for instance :
			"2")
				echo "Status : 2 (Parse error—for instance, when parsing command-line options, the ‘.wgetrc’ or ‘.netrc’...)"
				RES="Parse error—for instance"
				;;
			# File I/O error :
			"3")
				echo "Status : 3 (File I/O error)"
				RES="File I/O error"
				;;
			# Network failure :
			"4")
				echo "Status : 4 (Network failure)"
				RES="Network failure"
				;;
			# SSL verification failure :
			"5")
				echo "Status : 5 (SSL verification failure)"
				RES="SSL verification failure"
				;;
			# Username/password authentication failure :
			"6")
				echo "Status : 6 (Username/password authentication failure)"
				RES="Username/password authentication failure"
				;;
			# Protocol errors :
			"7")
				echo "Status : 7 (Protocol errors)"
				RES="Protocol errors"
				;;
			# Server issued an error response
			"8")
				echo "Status : 8 (Server issued an error response). Répertoire ou Fichier source inexistant"
				RES="Server issued an error response (Répertoire ou Fichier source inexistant)"
				;;
			*)
				echo "Status : > 8 (Others errors)"
				RES="Others errors"
				;;
		esac
	else
		echo "Error : log file does not exist"
	fi
 
	date=`date`
	echo "$date;$lastNameUser;$firstNameUser;$mailUser;$destRepatriation;$sourceRepatriation;$RES" >> ${fileLog}

#date:nom:prenom:email:destFile:sourcFile:RES

#RES:
#- téléchargement réussie (taille)
#- fichier source non disponible
#- fichier récent déjà présent en local
#- échec lors du téléchargement
#- espace de stockage insuffisant

#destFile: TODO lors du rapport, mettre un lien symbolique cliquable
}


#################################
#    Main
#################################

init
if [ $# -lt 1 ]			# less then / est plus petit que
then
	echo "Displaying the main menu"
	displayMainMenu
else
	case $1 in
		1 | "--users")
			echo "Gestion de la liste des utilisateurs (call of ./Bin/gestion_users.sh script)"
			exec ${scriptGestionUsers}
			;;
		2 | "--repatriations")
			echo "Gestion de la liste des rapatriements (call of ./Bin/gestion_repatriations.sh script)"
			exec ${scriptGestionRepatriations}
			;;
		3 | "--strategies")
			echo "Gestion de la liste des stratégies (call of ./Bin/gestion_strategies.sh script)"
			exec ${scriptGestionStrategies}
			;;
		4 | "--report")
			echo "Génération d'un rapport (call of displayMenuGenerationReport function)"
			displayMenuGenerationReport
			;;
		"--get-data")
			if [ -z "$2" ]
			then
				echo "ERROR lors du rapatriement d'un fichier : missing argument"
				exit 1
			elif ! [[ "$2" =~ ^[0-9]+$ ]]
			then
				echo "ERROR lors du rapatriement d'un fichier : second parameter ($2) must be a number"
				exit 1
			else
				echo "Rapatriement d'un fichier (call of getData function)"
				getData $2
			fi
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
			echo -e "ERROR: Invalid argument.\n${USAGE}"
			exit 1
			;;
	esac
fi
