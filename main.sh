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
	scriptGestionUsers=${DIR}"/Bin/gestion_users.sh"
	scriptGestionRepatriations=${DIR}"/Bin/gestion_repatriations.sh"
	scriptGestionStrategies=${DIR}"/Bin/gestion_strategies.sh"
	fileListStrategies=${DIR}"/Data/list_strategies.txt"
	fileListUsers=${DIR}"/Data/list_users.txt"
	fileListRepatriations=${DIR}"/Data/list_repatriations.txt"
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
	echo -e "sourceRepat : ${sourceRepat} \n"

	wget --timestamping \
		--progress=bar \
		--level=1 \
		--append-output log_wget.tmp \
		--directory-prefix ${destRepatriation} \
		--tries=45 \
		--no-parent \
		${sourceRepat}

		#--no-remove-listing \
		#--quota=1k
	status=$?
	echo "status : $status \t $?"
	
#	if protocol == 'ftp' :
#		FTPDownload(protocol, server, remote_dir)
#	if protocol == 'http':
#		HTTPDownload(protocol, server, remote_dir, self.bank.config)
#	if protocol == 'local':
#		dLocalDownload(remote_dir)

#	isRecent= checkFileIsRecent()
#
#	if (! isRecent)
#	{
#		wget ftp...fichier.fq
#	}

	if [ "$isToLog" == "yes" ] 
	then
		echo "status : $status \t $?"
		setLog "${idUser}" "${lastNameUser}" "${firstNameUser}" "${mailUser}" "${destRepatriation}" "${sourceRepatriation}" "${status}" "log_wget.tmp"
	fi
	#rm log_wget.tmp

}

# Check if file to download is not already present in local repertory.
function checkLastFile {
	echo "checkLastFile function called"
}

# Generate/update a log file.
function setLog {
	echo "setLog function called"
	local idUser=$1
	local lastNameUser=$2
	local firstNameUser=$3
	local mailUser=$4
	local destRepatriation=$5
	local sourceRepatriation=$6
	local status=$7
	local logFileName=$8
	
	echo -e "\t logFileName : $logFileName"
	echo -e "\t idUser : $idUser"
	echo -e "\t lastNameUser : $lastNameUser"
	echo -e "\t firstNameUser : $logFileName"
	echo -e "\t mailUser : $mailUser"
	echo -e "\t destRepatriation : $destRepatriation"
	echo -e "\t sourceRepatriation : $sourceRepatriation"
	echo -e "\t status : $status \t $?"

	if [ -f ${logFileName} ]
	then
		tail -2 ${logFileName} #| head -1 
	else
		echo "Error : log file does not exist"
	fi
#		if (on a bien télécharger le fichier
#			setLog() # réussie >> log

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
