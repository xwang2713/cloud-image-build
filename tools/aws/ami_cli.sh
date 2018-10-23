#!/bin/bash

# Example: ./ami_cli.sh 7.0.0-beta2-trusty delete

if [ -z "$1" ]; then
   echo "Must supply HPCC version"
   exit 1
fi
VERSION=$1

ACTION="list"

[ -n "$2" ] && ACTION=$2 

ACTION=$(echo $ACTION | tr '[:upper:]' '[:lower:]')

aws ec2 describe-regions | while read x region region2
do
    
    echo 
    echo "Process region $region2 ..."
    #ec2-describe-images --region $region2  | while read name id image x
    aws ec2 describe-images --region $region2 --query 'Images[*].{ID:ImageId Name:Name}' \
        --owners $EC2_ACCOUNT_ID | grep hpcc-systems | while read id name 
    do
        #echo "$id $name"
        echo $name |  grep -q "hpcc-systems-community-${VERSION}"
        if [ $? -eq 0 ]
        then
            if [ "$ACTION" = "delete" ]; then
               echo "aws ec2 deregister --region $region2 $id"
               aws ec2 deregister --region $region2 $id
            elif [ "$ACTION" = "list" ]; then
               echo "$id  $name"
            fi
        fi
    done
done
