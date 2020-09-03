#!/bin/bash
../cloud-image-build/packer/aws/build.sh -a x86_64 -c el7 -u centos -p -r us-east-2 -v 7.2.22-1 -t ebs -P platform-community
# ../cloud-image-build/packer/aws/build.sh -c xenial  -r us-west-1 -v 7.2.20-1

