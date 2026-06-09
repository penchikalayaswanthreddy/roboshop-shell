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
                    {
                        "Value": "'$PUBLIC_IP'"
                    }
                ]
            }
        }]
    }'


