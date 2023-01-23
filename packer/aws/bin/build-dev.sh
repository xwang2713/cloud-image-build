#!/bin/bash

#nohup ./build-dev.sh >/dev/null 2>&1 &

export AWS_PROFILE=richard-aws
#export ACCESS_KEY=AKIAWP62VEA4NOZWJSEY
#export ACCESS_KEY=AKIAWP62VEA4CDCDHPIN
#export SECRET_KEY=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
#export SECRET_KEY=GJ2PP0+yH9noBG4Vw2g3g7wBZHEUjybf7w/ekxPg

#../cloud-image-build/packer/aws/build-dev.sh -c el6 -r ca-central-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -a x86_64 -u centos  -c el6 -r ca-central-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1

# without this ssh authentification will fail when AMI created and create an instance with it
export SSH_KEYPAIR_NAME=hpcc-build
export SSH_PRIVATE_KEY_FILE=~/.ssh/hpcc-build
# instance type m4.2xlarge will be used in our build. Create with default t2.micro will have instance check failure for accessibility
#../cloud-image-build/packer/aws/build-dev.sh -T m4.2xlarge -c xenial -r ca-central-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -T m4.2xlarge -c bionic -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -T t2.large -c bionic -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1

#../cloud-image-build/packer/aws/build-dev.sh -c bionic -r ca-central-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -T t2.large -c el8s -a x86_64 -u centos -r us-east-2 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1

#export SSH_KEYPAIR_NAME=hpcc-build
#export SSH_PRIVATE_KEY_FILE=~/.ssh/hpcc-build
# amzn2 user ec2-user not centos
#../cloud-image-build/packer/aws/build-dev.sh -c amzn2 -D xvda -a x86_64 -u ec2-user -r ca-central-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -c el7 -a x86_64 -u centos -r ca-central-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -c el7 -f j11 -a x86_64 -T t2.large -u centos -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1

#../cloud-image-build/packer/aws/build-dev.sh -c el7 -f j11mysql56 -a x86_64 -T t2.large -u centos -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1

../cloud-image-build/packer/aws/build-dev.sh -c el7 -f mysql57 -a x86_64 -T t2.large -u centos -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#ami-01a9774157c7e995e

#../cloud-image-build/packer/aws/build-dev.sh -c el7 -f mysql8 -a x86_64 -T t2.large -u centos -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#ami-007c4fa7d4b0aabed

#../cloud-image-build/packer/aws/build-dev.sh -c el7 -f 8x -a x86_64 -T t2.large -u centos -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1

#../cloud-image-build/packer/aws/build-dev.sh -c el7 -f 8xmysql8 -a x86_64 -T t2.large -u centos -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#ami-0fae8f7b0bb90ec5c


# -f 8x0 will use mysqlclient 5.6.44-1
#../cloud-image-build/packer/aws/build-dev.sh -c el7 -f 8x0 -a x86_64 -T t2.large -u centos -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -c amzn2 -f j11 -D xvda -a x86_64  -T t2.large -u ec2-user -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -c amzn2 -f 8x -D xvda -a x86_64  -T t2.large -u ec2-user -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -c focal -T t2.large -f 8x -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
#../cloud-image-build/packer/aws/build-dev.sh -c el8s -f 8x -a x86_64 -T t2.large -u centos -r us-east-1 -p subnet-ids-ris -P icanspellthis | tee -a build.log 2>&1
