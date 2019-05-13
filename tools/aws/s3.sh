#!/bin/bash

# Example: ./s3.sh 7.0.0 delete

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


aws ec2 describe-regions | while read x region region2
do
    bucket=hpccsystems-amis-${region2}
    echo 
    echo "Process bucket $bucket ..."
    echo 
    aws s3 ls s3://${bucket} | grep "hpccsystems-community-${VERSION}" | while read d t s f 
    do
        [ -z "$f" ] && continue
        if [ "$ACTION" = "delete" ]; then
          #echo "Delete in region $region2 $f ... " 
          #aws s3 rm --recursive s3://${bucket}/$f
          aws s3 rm s3://${bucket}/$f
        else		 
           echo "$region2 $f"
        fi
    done
done
