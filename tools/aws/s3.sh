#!/bin/bash

# Example: ./s3.sh 7.0.0-beta2trusty delete

if [ -z "$1" ]; then
   echo "Must supply HPCC version."
   exit 1
fi
VERSION=$1

ACTION="list"

[ -n "$2" ] && ACTION=$2

ACTION=$(echo $ACTION | tr '[:upper:]' '[:lower:]')

MAJOR_VERSION=${VERSION%%.*}
#if [ $MAJOR_VERSION -le 9 ]; then
#   VERSION="0${VERSION}"
#fi


ec2-describe-regions | while read x region region2
do
    
    bucket=hpccsystems-amis-${region}
    echo 
    echo "Process bucket $bucket ..."
    if [ "$ACTION" = "delete" ]; then
       echo 
       echo "Delete in region $region ... " 
       s3cmd del s3://${bucket}/hpccsystems-community-${VERSION}*
    fi
    s3cmd ls s3://${bucket} | while read d t s f 
    do
        [ -z "$f" ] && continue
        echo $f |  grep  "hpccsystems-community-${VERSION}"
    done
done
