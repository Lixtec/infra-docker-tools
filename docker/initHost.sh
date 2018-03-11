#! /bin/bash

set -e
VERSION_DOCKER=17.12.0~ce-0~ubuntu
if [ -n "$1" ]; then
	VERSION_DOCKER=$1
fi


echo "========================" &&\
echo "CONFIGURATION DU SYSTEME" && \
echo "========================" &&\
apt-get install curl software-properties-common &&\
curl -kfsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add - &&\apt-key fingerprint 0EBFCD88 &&\
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
echo " "


echo "========================" &&\
echo "MISE A JOUR DU SYSTEME" &&\
echo "========================" &&\
cp ca/* /usr/local/share/ca-certificates/. &&  update-ca-certificates &&\
apt-get remove docker-ce &&\
rm -rf /etc/systemd/system/docker.service.d &&\
apt -y full-upgrade &&  apt-get update
echo " "


echo "========================" &&\
echo "INSTALLATION DE DOCKER $VERSION_DOCKER" &&\
echo "========================" &&\
apt-get -y install apt-transport-https &&\
apt-get -y install docker-ce=$VERSION_DOCKER &&\
apt autoremove && apt-mark hold 'docker-ce' &&\
mkdir /etc/systemd/system/docker.service.d &&\
echo '[Service]' | tee /etc/systemd/system/docker.service.d/docker.conf &&\
echo 'ExecStart=' | tee -a /etc/systemd/system/docker.service.d/docker.conf &&\
echo 'ExecStart=/usr/bin/dockerd -H fd://' | tee -a /etc/systemd/system/docker.service.d/docker.conf &&\
systemctl daemon-reload && systemctl restart docker &&\
docker -v
