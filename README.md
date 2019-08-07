# cloud-image-build

## Prerequisites
### Install packer
https://www.packer.io/intro/getting-started/install.html#precompiled-binaries
Download packer_<version>_linux_amd64.zip
```sh
sudo unzip -d /usr/local/bin packer_<version>_linux_amd64.zip
```
### Set Environment Variables for AWS EC2
Set following environment variables:
ACCESS_KEY: AWS access key
SECRET_KEY: AWS secret key
EC2_ACCOUNT_ID: EC2 account id
EC2_PIRVATE_KEY: EC2 private key full path
EC2_CERT: EC2 certificate full path

### AWS Client
packer doesn't need AWS Client on local system. But if you want to list/delete AMI entries in ec2 or s3 you need AWS Client command-line  
https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html
```sh
sudo apt-get install python-pip
sudo pip install awscli --upgrade
```

If you want to use aws/tools/* in this repo configure aws output format to "text"
```sh
aws configure
```



## Run build
Current support regions:
   us-east-1
   eu-west-1
   ap-northeast-1
   sa-east-1
   ap-southeast-1
   ap-southeast-2
   eu-central-1
   us-west-1
   us-west-2

Got to a empty build directory 
For example
<cloud-image-build>/packer/aws/build.sh -c trusty -p -r eu-central-1 -v 6.4.26-1
or 
<cloud-image-build>/packer/aws/build.sh -c trusty -p -i <regions file> -v 6.4.26-1

There is regions list file "regions.lst" under root of this repo.

## Check AMI and S3 packages
Go to tools/aws
List AMIs in AWS EC2
```sh
./ami_cli.sh <hpcc version>
```

List S3 package for the AMIs in AWS S3
```sh
./s3.sh <hpcc version>
```

Remove S3 packages for HPCC version
```sh
./s3.sh <hpcc version> delete
```

Remove AMIs for HPCC version
```sh
./ami_cli.sh <hpcc version> delete
```

## Supported Platforms
* [AWS](/packer/aws)
* [AWS with GPU Acceleration](/packer/aws-gpu)
* [Hyper-V](/packer/hyper-v)
* [Virtual Box](/packer/virtual-box)


Known problem:
Build fail for Ubuntu 18.04. AWS ticket: https://console.aws.amazon.com/support/cases?region=us-east-1#/5997229071/en
