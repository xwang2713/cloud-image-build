#!/bin/bash

DEBIAN_FRONTEND=noninteractive
UCF_FORCE_CONFFNEW=true
export UCF_FORCE_CONFFNEW DEBIAN_FRONTEND

sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" dist-upgrade
sudo apt-get clean
sudo apt-get update
sudo apt-get install -y wget unzip
sudo apt-get install -y ruby

export platformVersion=${HPCC_FULL_VERSION%-*}
export buildCode=${HPCC_FULL_VERSION#*-}
export codename=trusty
export arch=amd64
export pkgType=deb
export now=$(date -u +%Y%m%d-%H%M)

echo "Installing HPCC dependancies"
sudo apt-get install -y --no-install-recommends \
                libaprutil1           \
                libboost-regex1.54.0  \
                libicu52              \
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
                libblas3              \
                libatlas3-base        \
                psmisc                \
                libmemcached10        \
                libmemcachedutil2     \
                libpython2.7          \
                libpython3.4          \
                zip                   \
                openjdk-7-jdk         \
                xterm                 \
                --fix-missing         


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
#export IFLOCATION=http://cdn.hpccsystems.com/releases/CE-Candidate-${platformVersion}/bin/platform/
export IFLOCATION=http://wpc.423a.rhocdn.net/00423A/releases/CE-Candidate-${platformVersion}/bin/platform/
wget --progress=dot:mega --tries 5 $IFLOCATION$PLATFORM
sudo dpkg -i $PLATFORM

echo "Download script for later s3"
sudo wget http://hpccsystems-installs.s3.amazonaws.com/communityedition/util/ips
sudo fromdos ips
sudo chmod +x ips
sudo cp ips /opt/HPCCSystems/sbin

echo "remove HPCC user ssh keys"
sudo rm -rf /home/hpcc/.ssh/*
