#! /bin/bash
#
# This sets up Let's Encrypt SSL certificates
#
# - Run this script as root.
#
# Certificate files are placed into subdirectories under
# /etc/letsencrypt/live/*.
#
# Configuration must then be updated for the systems using the
# certificates.
#
# The certbot program logs to /var/log/letsencrypt.
#
set-e
MAIL="contact@lixtec.fr" 
DOMAINS_URI="lets.dev.lan"
if [ -n "$1" ]; then
  MAIL=$1;
fi

if [ -n "$2" ]; then
  DOMAINS_URI=$2;
fi

if [ -n "$3" ]; then
  CERT_PATH=$3;
fi

echo "START INSTALL LET'S ENCRYPT by $MAIL for $DOMAINS_URI"

# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# No package install yet.
apt install python3-pip
pip3 install -U certbot
pip3 install -U certbot-dns-ovh

# Install the dependencies.
/usr/local/bin/certbot certonly --dns-ovh --dns-ovh-credentials /etc/certbot/.ovhapi --agree-tos --non-interactive --expand --text --rsa-key-size 4096 --email $MAIL --domains $DOMAINS_URI

# copie des certificats
rm -rf /var/docker/certs/$CERT_PATH && mkdir -p /var/docker/certs/$CERT_PATH
cp -rf /etc/letsencrypt/archive/$CERT_PATH/* /var/docker/certs/$CERT_PATH

