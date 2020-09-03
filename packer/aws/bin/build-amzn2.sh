#!/bin/bash
#../cloud-image-build/packer/aws/build.sh -a x86_64 -c el7 -u centos -p -r us-east-2 -v 7.2.22-1 -t ebs -P platform-community
# ../cloud-image-build/packer/aws/build.sh -c xenial -p -r us-west-1 -v 7.2.20-1
#../cloud-image-build/packer/aws/build.sh -c bionic -p -r ap-northeast-1 -v 7.4.0-1
#../cloud-image-build/packer/aws/build.sh -c xenial -p -r eu-central-1 -v 7.4.2-1
#../cloud-image-build/packer/aws/build.sh -c xenial -p -i ../regions -v 7.4.10-1
# ../cloud-image-build/packer/aws/build.sh -c xenial -p -r us-east-1 -v 7.4.8-1
#../cloud-image-build/packer/aws/build.sh -c xenial -r eu-central-1 -v 7.6.30-1

VERSION=7.10.16-1

#REGION=ap-northeast-1
#REGION=eu-west-1
#REGION=sa-east-1
#REGION=ap-southeast-1
#REGION=ap-southeast-2
#REGION=eu-central-1
#REGION=ca-central-1

regions=(
  "us-east-1"
  "us-east-2"
  "us-west-1"
  "us-west-2"
  "sa-east-1"
)

for region in "${regions[@]}"
{
   ~/work/aws_get_saml.py
   ../cloud-image-build/packer/aws/build.sh -a x86_64 -u ec2-user  -c amzn2 -r ${region} -t ebs -v ${VERSION} | tee -a build_amzn2.log 2>&1

}
