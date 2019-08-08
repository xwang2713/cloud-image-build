# HPCC Systems Platform Hyper-V Image
For creating a Hyper-V image with HPCC Systems Platform Community edition pre-installed.


### Install packer
https://www.packer.io/intro/getting-started/install.html#precompiled-binaries
Download the appropriate packer binary for your system.
Put packer in your PATH

### Download HPCC Systems Platform Files
Run the script that is included in [tools](/tools)

Linux [script](/tools/hpcc_file_downloader.sh):
```sh
./hpcc_file_downloader.sh
```

PowerShell [script](/tools/hpcc_file_downloader.sh):
```sh
./hpcc_file_downloader.ps1
```


### Hyper-V
You need to have Hyper-V enabled on your machine: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
Hyper-V and Virtual Box cannot be used at the same time on the same machine. See this StackExchange: https://superuser.com/questions/1208850/why-virtualbox-or-vmware-can-not-run-with-hyper-v-enabled-windows-10

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
Create a Hyper-V instance using the newly created image. This assumes prior Hyper-V networking experience.

SSH into your instance and start the HPCC System Platform with:
* username: ubuntu
* password: hpccdemo

```sh
sudo systemctl start hpccsystems-platform.target
```

From here you can access your HPCC System via port 8010. Ensure your Hypervisor network settings allow for access on port 8010.

### Supports
This image supports 

### Known Issues:
After starting the HPCC System, the Landing Zone's directory can sometimes not be created, and can prevent files from being uploaded to the cluster. Fix this by simply manually creating the directory:
```sh
sudo mkdir /var/lib/HPCCSystems/mydropzone
```
