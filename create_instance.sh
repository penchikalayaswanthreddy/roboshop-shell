#!/bin/bash

aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t2.micro \
    --security-group-ids sg-06768f041e8b8b319 \
    --count 1 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=frontend}]'