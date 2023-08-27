#!/bin/bash

#Install required packages
sudo yum install targetcli iscsi-initiator-utils -y

#Start and Enable the iscsid service
sudo systemctl enable --now iscsid

#Start and Enable the target service
sudo systemctl enable --now target

#Configure the iscsi target
sudo targetcli backstores/fileio create disk01 /opt/iscsi_disk.img 5G

sudo targetcli iscsi/create iqn.1994-05.com.redhat:df39fcdbfb4a

sudo targetcli iscsi/create iqn.1994-05.com.redhat:df39fcdbfb4a/tpg1/luns/ create  backstores/fileio/disk01

sudo targetcli iscsi/create iqn.1994-05.com.redhat:df39fcdbfb4a/tpg1/luns/acls/ create #Client IQN

#Configure Firewall Rule
firewall-cmd --permanent --add-service=iscsi-target
firewall-cmd --permanent --add-port=3250/tcp
firewall-cmd --reload

echo "iSCSI target server setup complete !"
