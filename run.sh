#!/bin/bash

# Setup a vagrant infra we can use
# XXX: this largely comes from adhoc SCL's at the moment, need a better solution longer term

# check we are on centos7
# check we are being run as root

echo 'Yum updating the host' 
yum -y -d0 upgrade

cat > /etc/yum.repos.d/vagrant.repo <<- EOM

[jstribny-vagrant1]
name=Copr repo for vagrant1 owned by jstribny
baseurl=https://copr-be.cloud.fedoraproject.org/results/jstribny/vagrant1/epel-7-x86_64/
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/jstribny/vagrant1/pubkey.gpg
enabled=1

[ruby200-copr]
name=ruby200-copr
baseurl=http://copr-be.cloud.fedoraproject.org/results/rhscl/ruby200-el7/epel-7-x86_64/
enabled=1
gpgcheck=0

[ror40-copr]
name=ror40-copr
baseurl=http://copr-be.cloud.fedoraproject.org/results/rhscl/ror40-el7/epel-7-x86_64/
enabled=1
gpgcheck=0

[virtualbox]
name=Oracle Linux / RHEL / CentOS-$releasever / $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch
enabled=1
gpgcheck=1
gpgkey=https://www.virtualbox.org/download/oracle_vbox.asc

EOM

echo 'Installing Vagrant + VirtualBox'
yum -y -d 1  install epel-release && yum -d 1 -y install dkms
yum -y -d 1 install vagrant1 rsync VirtualBox-4.3
if [ $? -eq 0 ]; then
  service libvirtd start
  rm -rf ~/sync ; mkdir -p ~/sync
  cp answers.conf test_example_helloapache.sh ~/sync/
  chmod u+x ./vagrant_test.sh
  scl enable vagrant1 ./vagrant_test.sh
  if [ $? -ne 0 ]; then
    echo 'Failed'
    exit 1
  fi
fi
