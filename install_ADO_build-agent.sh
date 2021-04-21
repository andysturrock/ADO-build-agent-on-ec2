#!/bin/bash -x

yum -y install shadow-utils

useradd ado_build_agent_user

curl https://vstsagentpackage.azureedge.net/agent/2.184.2/vsts-agent-linux-x64-2.184.2.tar.gz --output /tmp/vsts-agent-linux-x64-2.184.2.tar.gz
mkdir -p /home/ado_build_agent_user/ado_build_agent
cd /home/ado_build_agent_user/ado_build_agent
tar zxvf /tmp/vsts-agent-linux-x64-2.184.2.tar.gz
rm /tmp/vsts-agent-linux-x64-2.184.2.tar.gz

chown -R ado_build_agent_user:ado_build_agent_user /home/ado_build_agent_user

su ado_build_agent_user -c "/home/ado_build_agent_user/ado_build_agent/config.sh"
cd /home/ado_build_agent_user/ado_build_agent
/home/ado_build_agent_user/ado_build_agent/svc.sh install ado_build_agent_user
/home/ado_build_agent_user/ado_build_agent/svc.sh start

# Not needed for the basic build agent but needed for some of my projects
yum -y install docker
systemctl enable docker
systemctl start docker
usermod -aG docker ado_build_agent_user

yum -y install qemu-kvm libvirt libvirt-python libguestfs-tools virt-install
