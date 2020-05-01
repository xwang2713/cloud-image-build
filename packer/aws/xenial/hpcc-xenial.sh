#!/bin/bash

DEBIAN_FRONTEND=noninteractive
UCF_FORCE_CONFFNEW=true
export UCF_FORCE_CONFFNEW DEBIAN_FRONTEND

sleep 120
#sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" dist-upgrade
sudo apt-get clean
sudo apt-get update
sudo apt-get install -y wget unzip
sudo apt-get install -y ruby

export platformVersion=${HPCC_FULL_VERSION%-*}
export buildCode=${HPCC_FULL_VERSION#*-}
export codename=xenial
export arch=amd64
export pkgType=deb
export now=$(date -u +%Y%m%d-%H%M)

echo "Installing HPCC dependancies"
sudo apt-get install -y --no-install-recommends \
                libaprutil1           \
                libboost-regex1.58.0  \
                libicu55              \
                libldap-2.4-2         \
                libtbb2               \
                libnuma1              \
                libxml2               \
                libxslt1.1            \
                g++                   \
                openssh-client        \
                openssh-server        \
                expect                \
                rsync                 \
                python                \
                sudo                  \
                curl                  \
                libblas3              \
                libatlas3-base        \
                psmisc                \
                libmemcached11        \
                libmemcachedutil2     \
                libpython2.7          \
                openjdk-8-jdk         \
                xterm                 \
                --fix-missing         


#git libboost-regex1.54.0 libboost-regex-dev libicu52 libicu-dev libxalan-c111 libxerces-c3.1 binutils libldap-2.4-2 libldap2-dev openssl zlib1g g++ openssh-client openssh-server expect libarchive13 rsync lib32z1-dev tofrodos build-essential libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support subversion autoconf libtool libxslt1.1 libxml2 libapr1 libaprutil1 zip libtbb2 libnuma1

#g++-7
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt update
sudo apt install g++-7 -y

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 \
	                         --slave /usr/bin/g++ g++ /usr/bin/g++-7
sudo update-alternative --config gcc
gcc --version
g++ --version
ls -la /usr/bin/ | grep -oP "[\S]*(gcc|g\+\+)(-[a-z]+)*[\s]" | xargs sudo bash -c 'for link in ${@:1}; do ln -s -f "/usr/bin/${link}-${0}" "/usr/bin/${link}"; done' 7

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y python3.6
# This need re-do in user data when start thee instance
sudo ln -s /usr/bin/python3.6 /usr/bin/python3


echo "Installing instance cloud pre-requisites"
sudo apt-get install -y tofrodos build-essential libfuse-dev libxml2-dev libcurl4-openssl-dev mime-support subversion autoconf libtool

echo "Install s3fs"
wk_dir=$(pwd)
cd /
github clone https://github.com/s3fs-fuse/s3fs-fuse.git s3fs
cd s3fs/
sudo autoreconf --install
sudo ./configure --prefix=/usr
sudo make
sudo make install
cd $wk_dir

echo 'Installing automation support for large cluster config'
sudo apt-get install -y python-paramiko
sudo apt-get install -y python-boto

echo 'Setting up hpcc user'
sudo groupadd hpcc-test
sudo useradd -G hpcc-test hpcc
sudo mkdir -p /home/hpcc
sudo chown -R hpcc:hpcc-test /home/hpcc


echo "Install HPCC Platform"
export PLATFORM=hpccsystems-platform-community_${HPCC_FULL_VERSION}${codename}_${arch}.${pkgType}
#export IFLOCATION=https://d2wulyp08c6njk.cloudfront.net/releases/CE-Candidate-${platformVersion}/bin/platform/
export IFLOCATION=https://d2wulyp08c6njk.cloudfront.net/releases/CE-Candidate-${platformVersion}/bin/platform/
wget --progress=dot:mega --tries 5 $IFLOCATION$PLATFORM
sudo dpkg -i $PLATFORM

echo "Download script for later s3"
sudo wget http://hpccsystems-installs.s3.amazonaws.com/communityedition/util/ips
sudo fromdos ips
sudo chmod +x ips
sudo cp ips /opt/HPCCSystems/sbin

echo "remove HPCC user ssh keys"
sudo rm -rf /home/hpcc/.ssh/*
