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

ec2-describe-regions | while read x region region2
do
    
    echo 
    echo "Process region $region ..."
    ec2-describe-images --region $region | while read name id image x
    do
        #echo "$name $id  $image"
        [ "$name" != "IMAGE" ] && continue
        echo $image |  grep -q "hpcc-systems-community-${VERSION}"
        if [ $? -eq 0 ]
        then
            if [ "$ACTION" = "delete" ]; then
               echo "ec2-deregister --region $region $id"
               ec2-deregister --region $region $id
            elif [ "$ACTION" = "list" ]; then
               echo "$id  $image"
            fi
        fi
    done
done
