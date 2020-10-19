#!/bin/bash

SCRIPTNAME=`basename "$0"`

CONFIGFILE=~/.orgkeysconfig

USAGE="$SCRIPTNAME [ -r ] org key

Options:
    org 						organization where to look
    key 						key to find owner
    -r 							reset credentials

"

list_keys() {
	keys=`curl --silent -u $ORG_KEYS_USERNAME:$ORG_KEYS_TOKEN "https://github.com/$1.keys"`
	if [ ! -z "$keys" ]; then
		printf "#KEYOWNER# $1 : $keys \n" >> $tmpfilename
	fi
}

if [[ $1 == "-r" ]]; then
  rm $CONFIGFILE > /dev/null 2>&1
  shift
fi

if [[ $# -lt 2 ]] || [[ $1 == "-h" ]]; then
  echo "usage: $USAGE"
  exit
fi

ORG=$1
KEY="${@:2}"

source $CONFIGFILE > /dev/null 2>&1

if [[ "$ORG_KEYS_USERNAME" == "" ]];then
	read -p "Enter your Github username: " ORG_KEYS_USERNAME
	read -p "Enter your Github api token: " ORG_KEYS_TOKEN

	echo "export ORG_KEYS_USERNAME=$ORG_KEYS_USERNAME" > $CONFIGFILE
	echo "export ORG_KEYS_TOKEN=$ORG_KEYS_TOKEN" >> $CONFIGFILE
fi

base_url="https://api.github.com/orgs/$ORG/members?per_page=100"

tmpfilename=.$SCRIPTNAME-$(date +"%Y-%m-%d_%H-%M-%S").tmp
trap "rm -f $tmpfilename" EXIT

USER_LIST=`curl -u $ORG_KEYS_USERNAME:$ORG_KEYS_TOKEN $base_url 2>&1 | grep login | sed 's/\"login"://g;s/[\", ]//g'`

if [[ "$USER_LIST" == "" ]];then
	printf "\033[0;31mUnable to get a list of users for organization $ORG - check your username and token (reset with -r)\033[0m\n"
	echo "usage: $USAGE"
 	exit
fi

for i in $USER_LIST ; do
	list_keys $i &
done
wait

result=`sed "/$KEY/q" "$tmpfilename" | grep "#KEYOWNER#" | tail -n 1 | awk '{print $2}'`
echo "Owner: $result"


