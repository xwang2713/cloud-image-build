#!/bin/bash
#../cloud-image-build/packer/aws/build.sh -a x86_64 -c el7 -u centos -p -r us-east-2 -v 7.2.22-1 -t ebs -P platform-community
# ../cloud-image-build/packer/aws/build.sh -c xenial -p -r us-west-1 -v 7.2.20-1
#../cloud-image-build/packer/aws/build.sh -c bionic -p -r ap-northeast-1 -v 7.4.0-1
#../cloud-image-build/packer/aws/build.sh -c xenial -p -r eu-central-1 -v 7.4.2-1
#../cloud-image-build/packer/aws/build.sh -c xenial -p -i ../regions -v 7.4.10-1
# ../cloud-image-build/packer/aws/build.sh -c xenial -p -r us-east-1 -v 7.4.8-1
../cloud-image-build/packer/aws/build.sh -c xenial -i ../regions -v 7.8.24-1

