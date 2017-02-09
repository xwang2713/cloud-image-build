#!/bin/bash
sudo yum clean all 
sudo yum update -y 
sudo yum install epel-release -y 
sudo yum install net-snmp wget sysstat vim krb5-libs pam_krb5 apr apr-util autoconf automake boost-regex cpp expect gcc gcc-c++ glibc-devel glibc-headers hiredis javapackages-tools kernel-headers libarchive libevent libicu libjpeg-turbo libmemcached libmpc libstdc++-devel libtool libuv libxslt lksctp-tools m4 mpfr perl perl-Carp perl-Data-Dumper perl-Encode perl-Exporter perl-File-Temp perl-Filter perl-Getopt-Long perl-HTTP-Tiny perl-PathTools perl-Pod-Escapes perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-Test-Harness perl-Text-ParseWords perl-Thread-Queue perl-Time-HiRes perl-Time-Local perl-constant perl-libs perl-macros perl-podlators perl-threads perl-threads-shared python-javapackages python-lxml rsync tbb tcl tzdata-java v8 zip tcpdump net-tools pciutils ntp libuv libjvm java-1.8.0-openjdk-headless zlib zlib-devel bzip2 psmisc httpd-tools bind-utils -y



###disable selinux####
sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
#####################

#### auto yum updates#
#sudo yum install yum-cron -y
#sudo bash -c "cat >/etc/sysconfig/yum-cron <<-%EOF
#YUM_PARAMETER="-x ibutils* -x libmlx* -x infini* -x libsdp* -x libnes* -x openib* -x libib* -x opensm* -x perftest*"
#CHECK_ONLY=no
#CHECK_FIRST=no
#DOWNLOAD_ONLY=no
##ERROR_LEVEL=0
##DEBUG_LEVEL=0
#RANDOMWAIT="60"
#MAILTO=russell.wagneriii@risk.lexisnexis.com
##SYSTEMNAME="" 
#DAYS_OF_WEEK="1234" 
#CLEANDAY="0123456"
#SERVICE_WAITS=yes
#SERVICE_WAIT_TIME=300
#%EOF"

sudo bash -c "cat >/etc/yum.conf <<-%EOF
[main]
cachedir=/var/cache/yum
keepcache=0
debuglevel=2
logfile=/var/log/yum.log
distroverpkg=centos-release
tolerant=1
exactarch=1
obsoletes=1
gpgcheck=1
plugins=1
bugtracker_url=http://bugs.centos.org/yum5bug
exclude=

# Note: yum-RHN-plugin doesn't honor this.
metadata_expire=1h

installonly_limit = 2

# PUT YOUR REPOS HERE OR IN separate files named file.repo
# in /etc/yum.repos.d
%EOF"

#######

sudo yum install -y /tmp/hpccsystems-platform-community_6.2.4-1.el7.x86_64.rpm

##fix tty##############
sudo sed -i "s/Defaults    requiretty/Defaults    \!requiretty/g" /etc/sudoers
#######################


####sendmail#########
#sudo bash -c "cat >/etc/postfix/main.cf <<-%EOF
## specify SMTP relay host
#relayhost = [10.195.140.1]:25
#%EOF"


##### Add genesis.hpcc.risk.regn.net to /etc/hosts ####
#sudo bash -c "echo '10.245.37.28 genesis.hpcc.risk.regn.net' >> /etc/hosts"
#####################

###############monitoring##
#mkdir /tmp/monitor/
#sudo tar -xvf /tmp/monitor.tar.gz -C /tmp/monitor/
#sudo /tmp/monitor/post-install
#sudo systemctl enable snmpd
##########################

###########################
sudo systemctl start ntpd
sudo systemctl enable ntpd
###########################

#####Clear yum transaction logs###
sudo yum history new
#######
