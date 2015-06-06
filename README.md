# boink
Scientific Progress Goes Boink!

## Setup VirtualBox
- Download latest VirtualBox from https://www.virtualbox.org/wiki/Downloads
- Run the installer.
- Download the Centos6 minimal ISO from http://isoredirect.centos.org/centos/6/isos/x86_64/
- Open VirtualBox and click the New button at the upper left.
  - name: centos6
  - memory size: 2048
  - file size: 20 GB
  - settings -> general -> advanced -> shared clipboard: bidirectional
  - settings -> general -> advanced -> drag'nDrop: Bidirectional
- Start the VM.  When asked, browse to the minimal Centos6 ISO.

## Install Centos6
- Choose the following options:
  - language: english
  - root password: vagrant

## Setup Centos6 Networking
- Login as root
- useradd vagrant
  passwd vagrant
```
vi /etc/sysconfig/network-scripts/ifcfg-eth0
# change ONBOOT to yes
service network start
yum update # this also tests if we have internet access.
shutdown -r now
yum update kernel # this also tests if we have internet access after the reboot.
```

## Install Guest Additions
  Download guest additions from http://download.virtualbox.org/virtualbox/<version>/VBoxGuestAdditions_4.3.28.iso
  yum install -y gcc make kernel-revel bzip2 perl
  yum install -y kernel-devel-2.6.32-504.16.2.el6.x86_64
  Go to Devices -> CD/DVD Devices -> Choose a virtual CD/DVD disk file.
  Pick VBox_Guest_Additions.
  cd /mnt
  mkdir cdrom && mount /dev/cdrom /mnt/cdrom
  cd cdrom && ./VBoxLinuxAdditions.run
  shutodwn -r now

## Install Java
  Download 64-bit JRE from http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html
  Go to settings, Shared Folders, Hit the plus icon.
  Browse to the directory containing the jre and choose auto mount and make permanent.
  usermod -a -G vboxsf vagrant
  Shutdown the VM and restart the VirtualBox app.  
  cp /media/sf_share/jre-8u45-linux-x64.rpm ~
  chmod a+x jre-8u45-linux-x64.rpm
  sudo rpm -ivh jre-8u45-linux-x64.rpm

## Setup Vagrant tools
- yum install -y openssh-clients man git vim wget curl ntp nano
- chkconfig ntpd on && chkconfig sshd on
- sed -i -e 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
- sed -i 's/^\(Defaults.*requiretty\)/#\1/' /etc/sudoers
- echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
- mkdir /home/vagrant/.ssh && chmod 700 /home/vagrant/.ssh
- wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
- chmod 600 /home/vagrant/.ssh/authorized_keys
- chown -R vagrant:vagrant /home/vagrant
- shutdown -h now

## Build the Vagrant package
  cd ~
  mkdir centos6
  vagrant package --output $HOME/centos6.box --base centos6
  Login to https://atlas.hashicorp.com/
  Goto https://atlas.hashicorp.com/EliasGoldberg/boxes/centos7
  Click +New Version on left of screen and follow wizard.

## Start the Elasticsearch boxes
  Navigate to <boink repo>/machines
  vagrant init EliasGoldberg/centos6
  vagrant up
  In your favorite browser, navigate to http://vimes.boink.io:9200/_plugin/marvel
  You should see a cluster named elasticsearch with three nodes and a status of green.