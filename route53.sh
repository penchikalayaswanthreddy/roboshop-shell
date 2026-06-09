#!/bin/bash

PUBLIC_IP="3.84.111.89"
PRIVATE_IP="172.31.20.87"
DOMAIN_NAME="yaswanthreddypenchikala.online"
HOSTED_ZONE_ID="Z09213753OGMO79IX22TR"


create_instance()
{
    if [ $1 = "frontend" ]
    then
        aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch '{
      "Changes": [{
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "'$DOMAIN_NAME'",
          "Type": "A",
          "TTL": 1,
          "ResourceRecords": [
            {"Value": "'$PUBLIC_IP"'}
          ]
        }
      }]
    }'
    else
        aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch '{
      "Changes": [{
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "'$1.$DOMAIN_NAME'",
          "Type": "A",
          "TTL": 1,
          "ResourceRecords": [
            {"Value": "'$PRIVATE_IP'"}
          ]
        }
      }]
    }'
    fi




}





for module in "$@" 

do 
    create_instance "$module"

done 