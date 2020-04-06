#!/bin/bash

export codename=amzn2
export arch=x86_64
export pkgType=rpm
export now=$(date -u +%Y%m%d-%H%M)

echo "wait 180"
sleep 180
echo "done waiting"

sudo yum update

sleep 10

sudo amazon-linux-extras install -y epel
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



#wget http://mysql.mirrors.hoobly.com/Downloads/MySQL-5.6/MySQL-devel-5.6.42-1.amzn2.x86_64.rpm
#sudo rpm -i MySQL-devel-5.6.42-1.amzn2.x86_64.rpm
#rm -rf MySQL-devel-5.6.42-1.amzn2.x86_64.rpm 

#echo "Installing R"
#sudo yum install -y R-core-devel
#export Rcpp_package=Rcpp_0.12.19.tar.gz
#wget https://cran.r-project.org/src/contrib/Archive/Rcpp/${Rcpp_package}
#sudo R CMD INSTALL ${Rcpp_package}
#rm -rf ${Rcpp_package}
#export RInside_package=RInside_0.2.12.tar.gz
#wget https://cran.r-project.org/src/contrib/Archive/RInside/${RInside_package}
#sudo R CMD INSTALL ${RInside_package}
#rm -rf ${RInside_package}

#echo "Install AWS Cli"
#curl -O https://bootstrap.pypa.io/get-pip.py
#sudo python3.4 get-pip.py
#sudo pip3 install awscli --upgrade
#rm -rf get-pip.py

FULL_VERSION=${HPCC_VERSION}
VERSION=${FULL_VERSION%-*} 
PLATFORM_PACKAGE=hpccsystems-platform-community_${FULL_VERSION}.amzn2.x86_64.rpm

wget  "http://wpc.423a.rhocdn.net/00423A/releases/CE-Candidate-${VERSION}/bin/platform/${PLATFORM_PACKAGE}" 
yum install --nogpgcheck -y "${PLATFORM_PACKAGE}" 
rm -rf  "${PLATFORM_PACKAGE}"
