#!/bin/bash

export codename=amzn2
export arch=x86_64
export pkgType=rpm
export now=$(date -u +%Y%m%d-%H%M)

echo "wait 180"
sleep 180
echo "done waiting"

sudo yum update
sudo amazon-linux-extras install -y epel

sleep 10

sudo yum install -y unzip

echo "Installing HPCC build prerequisites"

sudo yum install -y \
                 wget                  \
                 curl                  \
                 gcc-c++               \
                 m4                    \
                 libicu                \
                 boost-regex           \
                 openldap              \
                 openssl-server        \
                 openssl-clients       \
                 libtool               \
                 libxslt               \
                 libxml                \
                 expect                \
                 libarchive            \
                 rsync                 \
                 apr                   \
                 apr-util              \
                 zip                   \
                 tbb                   \
                 net-tools             \
                 psmisc                \
                 numa-libs             \
                 java-1.8.0-openjdk    \
                 python                \
                 python-libs           \
                 python36              \
                 python36-libs         \
		 blas.x86_64           \
		 atlas.x86_64          




FULL_VERSION=${HPCC_VERSION}
VERSION=${FULL_VERSION%-*} 
PLATFORM_PACKAGE=hpccsystems-platform-community_${FULL_VERSION}.amzn2.x86_64.rpm

wget  "http://wpc.423a.rhocdn.net/00423A/releases/CE-Candidate-${VERSION}/bin/platform/${PLATFORM_PACKAGE}" 
yum install --nogpgcheck -y "${PLATFORM_PACKAGE}" 
rm -rf  "${PLATFORM_PACKAGE}"
