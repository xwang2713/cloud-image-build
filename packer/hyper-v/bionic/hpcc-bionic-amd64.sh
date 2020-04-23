#!/bin/bash
sleep 5

sudo apt-get update -y
sudo apt-get -y install net-tools

# Install HPCC Platform and Plugins
sudo dpkg -i /tmp/*.deb 
sudo apt-get -y -f install || exit 1
sudo rm /tmp/*.deb

cat > /tmp/get-ip-address << EOM
#!/bin/bash
i=0
MAX_TRIAL=1
interval=3
RC=
while [ \$i -lt \$MAX_TRIAL ] 
do
  i=\$(expr \$i \+ 1)
  RC=\$(/sbin/ifconfig eth0 | grep "inet " | grep -v "127.0.0.1" | awk '{ print \$2 }' | awk -F: '{ print \$1 }')
  [ -n "\$RC" ] && break 
  sleep \$interval
done
echo \$RC
EOM
chmod a+x /tmp/get-ip-address
sudo cp /tmp/get-ip-address /usr/local/bin/get-ip-address
sudo ls -l /usr/local/bin/get-ip-address

cat > /tmp/issue-standard << EOM
Welcome to the HPCC Platform VM Version ==VERSION==!
Please use the following credentials to login to the shell.
User: hpccdemo
Pass: hpccdemo
(This user has full passwordless sudo rights.)
EclWatch: http://%IP%:8010

If URL IP is empty check if your network is configured correctly.
HPCC Platform will use network interface eth0: ifconfig eth0

EOM
sudo cp  /tmp/issue-standard   /etc/issue-standard 
sudo chmod 444 /etc/issue-standard


cat > /tmp/issue << EOM
#!/bin/bash
if [ "\$METHOD" = loopback ]; then
    exit 0
fi
# Only run from ifup.
if [ "\$MODE" != start ]; then
    exit 0
fi
IP=\`/usr/local/bin/get-ip-address\`
sudo sed -e "s;%IP%;\${IP};" /etc/issue-standard > /tmp/issue.in
sudo sed -e "s;%IP%;\${IP};" /etc/issue-standard > /tmp/motd.in
#sudo cp /tmp/issue-standard  /tmp/issue.in
#sudo cp /tmp/issue-standard > /tmp/motd.in
version=\$(dpkg -l | grep hpccsystems-platform | awk '{print \$3}')
#sudo sed -e "s/==VERSION==/\${version}/" /etc/issue.in > /etc/issue
#sudo sed -e "s/==VERSION==/\${version}/" /tmp/motd.in > /etc/motd 
sudo sed -e "s/==VERSION==/\${version}/" /tmp/issue.in > /etc/issue
sudo sed -e "s/==VERSION==/\${version}/" /tmp/motd.in > /etc/motd 

version2=\$(echo \$version | sed -e "s/\./-/g") 
sudo hostname "hpccvm64-\${version2}"
EOM

chmod a+x /tmp/issue
sudo cp /tmp/issue /etc/network/if-up.d/issue

sudo ls -l /etc/network/if-up.d/issue

cat > /tmp/rc.local << EOM
#!/bin/sh -e
#IP=\$(/usr/local/bin/get-ip-address)
#[ -z "\$IP" ] && dhclient eth0
export MODE="start"
/etc/network/if-up.d/issue

/etc/init.d/hpcc-init start
exit 0
EOM

chmod +x /tmp/rc.local
sudo cp /tmp/rc.local /etc/rc.local
sudo ls -l /etc/rc.local
