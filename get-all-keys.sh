#!/bin/bash

mylogin=pedrocatalao
organization=kabisa
mypassword=my_token_or_password
members_url="https://api.github.com/orgs/$organization/members?per_page=100"

for i in `curl -u $mylogin:$mypassword $members_url 2>&1 | grep login | sed 's/\"login"://g;s/[\", ]//g'` ; do
 key=`curl --silent -u $mylogin:$mypassword "https://github.com/$i.keys"` && echo -e "\n### $i ###\n\n$key\n" ;
done