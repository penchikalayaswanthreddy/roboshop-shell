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
    

install_package()
{
    dnf list installed "$1" &>> "$log_file"

    if [ $? -eq 0 ]
    then 
        echo -e " $ORANGE package $1 is already installed $NORMAL"
        return
    else
        dnf install -y "$1" &>> "$log_file"

        if [ $? -eq 0 ]
        then
            echo -e  " $GREEN Install of package $1 is successful $NORMAL"
        else
            echo -e  " $RED Installof package $1 is failed  $NORMAL " 
        fi
    fi
}

for i in "$@" 
do
    install_package "$i"
done


    
        
