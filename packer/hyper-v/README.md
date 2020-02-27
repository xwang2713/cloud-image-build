# HPCC Systems Platform Hyper-V Image
For creating a Hyper-V image with HPCC Systems Platform Community edition pre-installed.


## Build HPCC Systems Hyper-V Image

### Install packer
https://www.packer.io/intro/getting-started/install.html#precompiled-binaries
Download the appropriate packer binary for your system.
Put packer in your PATH

### Get this cloud-image-build repo
```sh
git clone https://github.com/xwang2713/cloud-image-build
```


### Enable Hyper-V
You need to have Hyper-V enabled on your machine: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
Hyper-V and Virtual Box cannot be used at the same time on the same machine. See this StackExchange: https://superuser.com/questions/1208850/why-virtualbox-or-vmware-can-not-run-with-hyper-v-enabled-windows-10


### Build
Create a build directory outside of cloud-image-build
```sh
mkdir build
```
Build a base image if haven't done so
```sh
cd build
cp ../<cloud-image-build>/hyper-v/build-base.ps1
./build-base.ps1
```
This will create base image at "hpcc-base-vm"

Build HPCC Systems Platform Hyper-V image:
In build directory
```sh
cp ../<cloud-image-build>/hyper-v/build.ps1
# Open build.ps1 and change the version to expected value
./build.ps1
```
If build successfully there should be image file: HPCCSystemVM-HyperV-<version>.zip


## Run HPCC Systems Hyper-V VM


### Get Hyper-V zip file  
Get VM file  HPCCSystemVM-HyperV-<version>.zip
unzip it


### Hyper-V network swtich
Make sure at least one network switch vailable in Hyper-V environment
Import Hyper-V image from Windows "Hyper-V Manager"
You probably will be asked to select a network switch.
HPCC System Platform will be started automatically.
Login to VM with user/password:  hpccdemo/hpccdemo

Use provided URL to access EclWatch
