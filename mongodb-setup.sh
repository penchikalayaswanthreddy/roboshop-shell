#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ORANGE="\e[33m"
NORMAL="\e[0m"


log_file="$( echo $0 | cut -d "." -f1).log"

uid=$(id -u)

if [ $uid -ne 0 ]
then
    echo -e " $RED Please login as root user to install packages $NORMAL" 
    exit 1
fi

validate()
{

    if [ $1 -eq 0 ]
    then
        echo -e "  $2 :  $GREEN SUCCESS $NORMAL " 
    else
        echo -e " $2 : $RED FAILURE $NORMAL " 
    fi

}

cp "$PWD/mongo.repo"  /etc/yum.repos.d/mongo.repo &>>"$log_file"

validate "$?" "copying mongo repo to yum.repos directory"

dnf install mongodb-org -y  &>>"$log_file"

validate "$?" "Installing mongodb"

systemctl enable mongod 

systemctl start mongod

validate "$?" "enabling and starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>"$log_file"

validate "$?" "mongodb port opening"

systemctl restart mongod

validate "$?" "restarting mongod"