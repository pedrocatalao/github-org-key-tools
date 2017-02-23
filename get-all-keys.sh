#!/bin/bash

me=`basename "$0"`

while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
	    -u|--user)
	    user="$2"
	    shift
	    ;;
	    -t|--token)
	    token="$2"
	    shift
	    ;;
	    -o|--org)
	    organization="$2"
	    shift
	    ;;
	    *)
	    # unknown option
	    ;;
	esac
	shift
done

if [ -z "$user" ] || [ -z "$token" ] || [ -z "$organization" ]; then
	echo "Usage: $me -u username -t token -o organization"
	exit 1
fi

base_url="https://api.github.com/orgs/$organization/members?per_page=100"

for i in `curl -u $user:$token $base_url 2>&1 | grep login | sed 's/\"login"://g;s/[\", ]//g'` ; do
	key=`curl --silent -u $user:$token "https://github.com/$i.keys"` && echo -e "\n### $i ###\n\n$key\n" ;
done
