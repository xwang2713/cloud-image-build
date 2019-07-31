# GPU Accelerated HPCC Systems Platform on AWS
For use in conjunction with the HPCC-GPU Bundle https://www.github.com

## Description
This provides a facility to create a GPU accelerated AWS AMI with HPCC Systems Platform and NVIDIA CUDA pre-installed.
It is a special version of the HPCC Systems Platform for training neural networks utilizing one or more GPUs.


### Install packer
https://www.packer.io/intro/getting-started/install.html#precompiled-binaries
Download the appropriate packer binary for your system.
Put packer in your PATH

### Set AWS Access and Secret Keys
Set following keys:
ACCESS_KEY: AWS access key
SECRET_KEY: AWS secret key
In the .json file, under variables. This is required.

### Validate .JSON
Packer does not need any client tools for building on AWS. First, validate the .json after adding the keys.
```sh
packer validate NAME.json
```

### Build the GPU enabled AMI
Next, build the AMI with the following:
```sh
packer build NAME.json
```

### Start and Connect to Your Instance
Create a new GPU enabled instance, such as a p2.xlarge, with the newly created AMI. You might need to create a VPC for this instance. Make sure port 8010 is open.
Amazon VPC: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-getting-started.html
Amazon P2: https://aws.amazon.com/ec2/instance-types/p2/

SSH into your instance and start the HPCC System Platform with:
```sh
sudo systemctl start hpccsystems-platform.target
```

From here you can start training neural networks with GPU acceleration. There is an HPCC bundle that provides this functionality, and was created in conjunction with this AMI.

### Supports


### Known Issues:
After starting the HPCC System, the Landing Zone's directory can sometimes not be created, and can prevent files from being uploaded to the cluster. Fix this by simply manually creating the directory:
```sh
sudo mkdir /var/lib/HPCCSystems/mydropzone
```
