#!/bin/bash

# install ansible
if test -z $(which ansible-playbook);then
  sudo yum install -y epel-release
  sudo yum install -y ansible
fi

# install git
if test -z $(which git);then
  sudo yum -y install git
fi

# install expect
if test -z $(which expect);then
  sudo yum -y install expect
fi

# setup ssh
path_sshconfig="/home/vagrant/.ssh/config"
if [ -e ${path_sshconfig} ];then
  sudo -u vagrant chmod 600 ${path_sshconfig}
fi
path_key="/home/vagrant/.ssh/id_rsa"
if [ ! -e ${path_key} ];then
  sudo -u vagrant ssh-keygen -t rsa -N '' -f ${path_key}
fi

if test -z $(sudo -u vagrant ssh sandbox);then
  expect -c "
  set timeout 10
  spawn sudo -u vagrant sh -c \"ssh-copy-id sandbox\"
  expect \"*(yes/no)?*\"
  send \"yes\r\"
  expect \"*password:\"
  send \"vagrant\r\"
  expect \"*expecting.\"
  interact
  "
fi
