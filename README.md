# cloud-image-build

##Prerequisites
###Install packer
https://www.packer.io/intro/getting-started/install.html#precompiled-binaries
Download packer_<version>_linux_amd64.zip
```sh
sudo unzip -d /usr/local/bin packer_<version>_linux_amd64.zip
```
###Set Environment Variables for AWS EC2
Set following environment variables:
ACCESS_KEY: AWS access key
SECRET_KEY: AWS secret key
EC2_ACCOUNT_ID: EC2 account id
EC2_PIRVATE_KEY: EC2 private key full path
EC2_CERT: EC2 certificate full path


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
<cloud-image-build>/packer/aws/build.sh -c trusty -p -r en-central-1 -v 6.4.26-1
