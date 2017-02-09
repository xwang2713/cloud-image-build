From Eli.Tarrago@lexisnexisrisk.com

Sure, I use an application called packer (not related to the fedora compression application) to build AMI's in an automated fashion.

https://www.packer.io/

included is the json file, and user script.


on top of packer: https://cloudnative.io/docs/bakery/

build: 
#. ~/.bashrc 
packer build aws-build.json
