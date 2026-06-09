#!/bin/bash
AMI_ID="ami-0220d79f3f480ecf5"
SECURITY_GROUP_ID="sg-06768f041e8b8b319"
DOMAIN_NAME="yaswanthreddypenchikala.online"
HOSTED_ZONE_ID="Z09213753OGMO79IX22TR"

create_instance()
{
    INSTANCE_ID=$(
      aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t2.micro \
    --security-group-ids $SECURITY_GROUP_ID \
    --count 1 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

    if [ $1 = "nginx" ]
    then
        RECORD_NAME=$DOMAIN_NAME
        IP_ADDRESS=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)
    else
        RECORD_NAME="$1.$DOMAIN_NAME"
        IP_ADDRESS=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query 'Reservations[0].Instances[0].PrivateIpAddress' \
    --output text)
    fi

    aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch '{
        "Changes": [{
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "'$RECORD_NAME'",
                "Type": "A",
                "TTL": 1,
                "ResourceRecords": [
                    {
                        "Value": "'$IP_ADDRESS'"
                    }
                ]
            }
        }]
    }'





}



for module in "$@"
do
    create_instance "$module"
done