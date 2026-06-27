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

dnf module disable nodejs -y &>>"$log_file"

validate "$?" "Disabling nodejs"

dnf module enable nodejs:20 -y &>>"$log_file"

validate "$?" "enabling nodejs"

dnf install nodejs -y &>>"$log_file"

validate "$?" "installing nodejs"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>"$log_file"

validate "$?" "creating roboshop user"

mkdir /app 

validate "$?" "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>>"$log_file"

validate "$?" "downloading code"

cd /app 

validate "$?" "moving to app directory"

unzip /tmp/catalogue.zip &>>"$log_file"

validate "$?" "unzipping code"


npm install &>>"$log_file"

validate "$?" "installing dependencies"


cp "$SCRIPT_DIR/catalogue.service" /etc/systemd/system/catalogue.service &>>"$log_file"

validate "$?" "creating catalogue service file"

systemctl daemon-reload

validate "$?" "daemon-relaod"

systemctl enable catalogue 

validate "$?" "enabling service"

systemctl start catalogue

validate "$?" "starting service"


cp "$SCRIPT_DIR/mongo.repo"  /etc/yum.repos.d/mongo.repo &>>"$log_file"

validate "$?" "adding mongo repo"

dnf install mongodb-mongosh -y &>>"$log_file"

validate "$?" "installing of mongo client"

mongosh --host mongodb.yaswanthreddypenchikala.online </app/db/master-data.js &>>"$log_file"

validate "$?" "loading data"