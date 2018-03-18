#! /bin/bash

set -e
VERSION_DOCKER=17.09.1~ce-0~ubuntu
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
cp ../ca/* /usr/local/share/ca-certificates/.  || echo ''
update-ca-certificates
apt-mark unhold 'docker-ce' || echo '' && apt-get remove -y docker-ce || echo '' &&\
rm -rf /etc/systemd/system/docker.service.d &&\
apt-get update && apt -y full-upgrade
echo " "


echo "========================" &&\
echo "INSTALLATION DE DOCKER $VERSION_DOCKER" &&\
echo "========================" &&\
apt-get -y install apt-transport-https &&\
apt-get -y --allow-downgrades install docker-ce=$VERSION_DOCKER &&\
apt autoremove -y --purge && apt-mark hold 'docker-ce' &&\
mkdir /etc/systemd/system/docker.service.d &&\
echo '[Service]' | tee /etc/systemd/system/docker.service.d/docker.conf &&\
echo 'ExecStart=' | tee -a /etc/systemd/system/docker.service.d/docker.conf &&\
echo 'ExecStart=/usr/bin/dockerd -H fd://' | tee -a /etc/systemd/system/docker.service.d/docker.conf &&\
systemctl daemon-reload && systemctl restart docker &&\
docker -v
