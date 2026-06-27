#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ORANGE="\e[33m"
NORMAL="\e[0m"


log_file="$( echo $0 | cut -d "." -f1).log"

SCRIPT_DIR=$PWD

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

dnf module disable nginx -y &>>"$log_file"
validate "$?" "disabling nginx"

dnf module enable nginx:1.24 -y &>>"$log_file"
validate "$?" "enabling nginx"

dnf install nginx -y &>>"$log_file"
validate "$?" "installing nginx"

systemctl enable nginx  &>>"$log_file"
validate "$?" "enabling nginx"

systemctl start nginx  &>>"$log_file"
validate "$?" "starting nginx"

rm -rf /usr/share/nginx/html/* &>>"$log_file"
validate "$?" "deleting deafult html content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>"$log_file"
validate "$?" "downloading code"

cd /usr/share/nginx/html &>>"$log_file"
validate "$?" "change to html directory"

unzip /tmp/frontend.zip &>>"$log_file"
validate "$?" "unzipping code"

cp "$SCRIPT_DIR/nginx.conf" /etc/nginx/nginx.conf &>>"$log_file"
validate "$?" "copying nginx conf"

systemctl restart nginx  &>>"$log_file"
validate "$?" "restarting nginx"