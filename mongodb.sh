#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privileges"
    exit 1 #failure is other than 0
fi

VALIDATE(){ #functions receive inputs through args just like shell script args
   if [ $1 -ne 0 ]; then
       echo -e "$2 ... $R FAILURE $N" | tee -a $LOG_FILE
       exit 1
    else
       echo -e "$2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

cp mango.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding Mongo repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enable MongoDB"

systemctl start mongod
VALDATE $? "start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALDATE $? "Allowing remote connections to MongodB"

systemctl restart mongod
VALIADTE $? "Restarted MongoDB"
