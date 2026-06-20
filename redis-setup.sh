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

dnf module disable redis -y &>>"$log_file"
dnf module enable redis:7 -y &>>"$log_file"

validate "$?" "enabling redis 7"

dnf install redis -y &>>"$log_file"
validate "$?" "installing redis" 

sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
validate "$?" "port enable" 

sed -i '/protected-mode/c\protected-mode no' /etc/redis/redis.conf
validate "$?" "disabling protected mode"

systemctl enable redis &>>"$log_file"
systemctl start redis &>>"$log_file"

validate "$?" "restarting redis" 