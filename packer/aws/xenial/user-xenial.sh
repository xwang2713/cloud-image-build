#!/bin/bash

DEBIAN_FRONTEND=noninteractive
UCF_FORCE_CONFFNEW=true
export UCF_FORCE_CONFFNEW DEBIAN_FRONTEND

apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" dist-upgrade
#apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install ruby1.9.3
#apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install ruby
apt-get clean

sudo apt-get update
sudo apt-get install -y wget unzip
sudo apt-get install -y ruby

echo "wget for ec2 ami tools"
wget https://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip

echo "make directory"
sudo mkdir -p /usr/local/ec2

echo "unzip tools"
sudo unzip ec2-ami-tools.zip -d /usr/local/ec2

echo "Create /etc/profile.d/ec2envvars.sh"
sudo touch /etc/profile.d/ec2envvars.sh

echo "Installing kpartx, grub as required by ec2-ami-tools"
sudo apt-get install kpartx -y
sudo apt-get install grub -y
sudo sed -i 's/console=hvc0/console=ttyS0/' /boot/grub/menu.lst
sudo sed -i 's/LABEL=UEFI.*//' /etc/fstab

sudo apt autoremove

echo "add to etc/profile.d/ec2envvars.sh export variable EC2_AMITOOL_HOME"
#sudo bash -c 'echo "export EC2_AMI_PACKAGE=$(ls /usr/local/ec2/ | grep ec2-ami-tools-)" >> /etc/profile.d/ec2envvars.sh'
#sudo bash -c 'echo "export EC2_AMITOOL_HOME=/usr/local/ec2/\${EC2_AMI_PACKAGE}" >> /etc/profile.d/ec2envvars.sh'
#sudo bash -c 'echo "export PATH=/usr/local/ec2/\${EC2_AMI_PACkAGE}/bin:$PATH:" >> /etc/profile.d/ec2envvars.sh'

sudo bash -c 'echo "export EC2_AMITOOL_HOME=/usr/local/ec2/ec2-ami-tools-1.5.7" >> /etc/profile.d/ec2envvars.sh'
sudo bash -c 'echo "export PATH=/usr/local/ec2/ec2-ami-tools-1.5.7/bin:$PATH:" >> /etc/profile.d/ec2envvars.sh'
#cat /etc/profile.d/ec2envvars.sh
