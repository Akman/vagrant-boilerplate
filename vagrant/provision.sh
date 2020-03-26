#!/bin/bash

SSH_USER=$1
SSH_IDENTITY=$2
SSH_PORT=$3

MC_INI=$4
MC_PANELS=$5

function pkg-present {
  dpkg-query -s "$@" >/dev/null
  if [ $? -ne 0 ]
    then
    apt-get install -y "$@"
    else
    echo -e "Package '$@' already installed"
  fi
}

function ppa-present {
  if ! grep -q "^deb .*$@" /etc/apt/sources.list /etc/apt/sources.list.d/*
    then
    apt-add-repository -y "ppa:$@"
    else
    echo -e "Repository 'ppa:$@' already added"
  fi
}

echo -e "Provision started ..."

if ! grep -q "$(cut -d' ' -f2 <<<"${SSH_IDENTITY}")" "/home/${SSH_USER}/.ssh/authorized_keys"
  then
  echo -e "\n${SSH_IDENTITY}" >> "/home/${SSH_USER}/.ssh/authorized_keys"
  echo -e "Identity added to /home/${SSH_USER}/.ssh/authorized_keys"
fi
if [ ! -f "/home/${SSH_USER}/.ssh/config" ]
  then
  cat >"/home/${SSH_USER}/.ssh/config" <<EOL
Host *
  LogLevel FATAL
  ForwardAgent yes
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  PasswordAuthentication no
  ControlMaster auto
  ControlPersist 60s
  IdentitiesOnly no
EOL
  echo -e "Config created in /home/${SSH_USER}/.ssh/config"
fi

if grep -q -i -E "^(Port).*$" /etc/ssh/sshd_config
  then
  if ! [[ -v SSH_RESTART ]]
    then
    SSH_RESTART="yes"
  fi
  sed -i -r "s/^(Port).*$/\\1 ${SSH_PORT}/gi" /etc/ssh/sshd_config
  echo -e "Fixed ssh port"
fi
if grep -q -i -E "^#?(PermitRootLogin|PermitEmptyPasswords|PasswordAuthentication|X11Forwarding|GSSAPIAuthentication|UseDNS)\s+yes" /etc/ssh/sshd_config
  then
  if ! [[ -v SSH_RESTART ]]
    then
    SSH_RESTART="yes"
  fi
  sed -i -r "s/^#?(PermitRootLogin|PermitEmptyPasswords|PasswordAuthentication|X11Forwarding|GSSAPIAuthentication|UseDNS).*$/\\1 no/gi" /etc/ssh/sshd_config
  echo -e "Fixed ssh permissions"
fi
if ! grep -q -i -E "^#?(UseDNS)\s+no" /etc/ssh/sshd_config
  then
  if ! [[ -v SSH_RESTART ]]
    then
    SSH_RESTART="yes"
  fi
  echo -e "\nUseDNS no" >> /etc/ssh/sshd_config
  echo -e "Fixed ssh dns usage"
fi
if [[ -v SSH_RESTART ]]
  then
  service ssh restart
  echo -e "Restarted ssh service"
fi

if ! grep -q -i -E "^cd ~/provision" "/home/${SSH_USER}/.profile"
  then
  echo -e "\ncd ~/provision" >> "/home/${SSH_USER}/.profile"
  echo -e "Fixed /home/${SSH_USER}/.profile"
fi
if [ -d "/home/${SSH_USER}/provision" ]
  then
  cd "/home/${SSH_USER}/provision"
  chmod +x *.sh
fi
if [ ! -d "/home/${SSH_USER}/bin" ]; then
  mkdir "/home/${SSH_USER}/bin"
  chmod 700 "/home/${SSH_USER}/bin"
  chown "${SSH_USER}:${SSH_USER}" "/home/${SSH_USER}/bin"
fi
if [ ! -L "/home/${SSH_USER}/bin/pvn" ]; then
  ln -s "/home/${SSH_USER}/provision/provision.sh" "/home/${SSH_USER}/bin/pvn"
fi
cp "/home/${SSH_USER}/provision/config/ansible.cfg" "/home/${SSH_USER}/ansible.cfg"
chmod 644 "/home/${SSH_USER}/ansible.cfg"
if [ ! -f "/home/${SSH_USER}/.config/mc/ini" ]
  then
  mkdir -p "/home/${SSH_USER}/.config/mc"
  echo -e "${MC_INI}" > "/home/${SSH_USER}/.config/mc/ini"
fi
if [ ! -f "/home/${SSH_USER}/.config/mc/panels.ini" ]
  then
  echo -e "${MC_PANELS}" > "/home/${SSH_USER}/.config/mc/panels.ini"
fi
if [ ! -f "/root/.config/mc/ini" ]
  then
  mkdir -p "/root/.config/mc"
  echo -e "${MC_INI}" > "/root/.config/mc/ini"
fi
if [ ! -f "/root/.config/mc/panels.ini" ]
  then
  echo -e "${MC_PANELS}" > "/root/.config/mc/panels.ini"
fi

apt-get -y update

ppa-present ansible/ansible

apt-get -y update

# pkg-present git
# pkg-present dnsutils
# pkg-present curl
pkg-present aptitude
pkg-present build-essential
pkg-present software-properties-common
pkg-present python-minimal
pkg-present python-openssl
pkg-present python-apt
pkg-present ansible
pkg-present tree
pkg-present mc
