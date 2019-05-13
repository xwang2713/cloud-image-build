#!/bin/bash

export AWS_DEFAULT_REGION=us-east-1

#aws ec2 describe-images \
# --filters Name=name,Values=ubuntu/images/hvm:instance/ubuntu-bionic-18.04-amd64* \
# --query 'Images[*].[ImageId,CreationDate]' --output text \
# | sort -k2 -r \
# | head -n1

aws ec2 describe-images \
 --filters "Name=name,Values=ubuntu*" "Name=root-device-type,Values=instance-store" --output text 
