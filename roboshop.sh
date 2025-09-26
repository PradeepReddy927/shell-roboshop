#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-01bc6f6c9dc6d7fc5"

for i instance in $@
do
   INSTANCE_ID=$(aws ec2 run-instances --image-id ami- ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-01bc6f6c9dc6d7fc5 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

   # GET Private IP
   if [ $instance != "frontend" ]; then
      IP=$(aws ec2 describe-instances --instance-ids i-04894d9fd93f3e487 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
   else
      IP=$(aws ec2 describe-instances --instance-ids i-04894d9fd93f3e487 --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
   fi

    echo "$instance: $IP"
done