#!/bin/bash

INSTANCE_ID=$(
      aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t2.micro \
    --security-group-ids sg-06768f041e8b8b319 \
    --count 1 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=redis}]' \
    --query 'Instances[0].InstanceId' \
    --output text )

echo "Instance ID : $INSTANCE_ID " 

PRIVATE_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query 'Reservations[0].Instances[0].PrivateIpAddress' \
    --output text)

PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "Private IP: $PRIVATE_IP"
echo "Public IP : $PUBLIC_IP"