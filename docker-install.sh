#!/bin/bash
 
 
DOCKER_PATH="/data/docker"
 
 
[ -e ${DOCKER_PATH} ] || mkdir -p ${DOCKER_PATH}
 
 
yum -y remove docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-engine \
docker-ce \
docker-ce-cli
 
yum  install -y yum-utils device-mapper-persistent-data lvm2
 
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 
yum list docker-ce.x86_64  --showduplicates |sort -r
 
yum  install docker-ce-18.09.8 docker-ce-cli-18.09.8 containerd.io -y
 
systemctl start docker ; systemctl  enable docker
 
cat > /etc/docker/daemon.json << EOE
{
    "registry-mirrors": ["https://registry.docker-cn.com","http://hub-mirror.c.163.com"],
    "exec-opts": ["native.cgroupdriver=systemd"],
    "insecure-registries": ["registry.access.redhat.com","quay.io","harbor.bx.com"],
    "data-root": "${DOCKER_PATH}"
}
 
EOE
 
systemctl restart docker
 
docker --version
 
