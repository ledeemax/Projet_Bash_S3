#! /bin/bash

# ************************************************************************************
# Fichier 		: gestion_strategies.sh
# Auteur 		: ledee.maxime@gmail.com, steph.levon@wanadoo.fr
# But du fichier 	:  
# Exécution 		: ./gestion_strategies.sh
# ************************************************************************************

########################
#    Initialisation
########################
USAGE="USAGE : $0 [--add] [--list] [--del]"  # TODO : a remplir
sourceFile=../Data/list_users.txt

########################
#    Functions
########################

function displayMenu {

}

function list {

}

function del {

}

function add {
	if "journaliere"
		set "00 04 * * *"
	if "hebdomadaire"
		set "00 04 6 * *"
	if "mensuel"
		set "00 ..."
	if "tous les 12"
		set
	if "annuelle"
		set ...

	grep annuelle list_periodiciies.txt | cut 

	task=1:1:1:00 12 * * *:y
	#task=00 12 * * *
	task >> list_stategies.txt
	addCron task

}

function addCron{

	crontab -l > mycron
	echo "39 12 * * * ./main.sh --getData 1" >> mycron
	crontab mycron
	rm mycron
}

dans crontab :
30 12 * * * ./main.sh 1


function delCron {

}

########################
#    Main 
########################

#if [ $# -eq 0 ]
if [ $# -lt 1 ]			# less then / est plus petit que
then
	echo $USAGE
	exit 1
else
	echo "$# argument(s) trouvé(s)"
	case $# in
		--getData)
			getData($1)
			echo "Exécution du script TP_exo02.sh"
			exec ./TP_exo02.sh $*
			;;
		2)
			echo "Exécution du script TP_exo03.sh"
			exec ./TP_exo03.sh $*
			;;
		3)
			echo "Exécution du script TP_exo04.sh"
			exec ./TP_exo04.sh $*
			;;
		*)
			echo "Erreur"
	esac
fi
