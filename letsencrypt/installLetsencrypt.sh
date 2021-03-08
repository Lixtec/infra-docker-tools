#! /bin/bash
#
# This sets up Let's Encrypt SSL certificates and automatic renewal
# using certbot: https://certbot.eff.org
#
# - Run this script as root.
# - A webserver must be up and running.
#
# Certificate files are placed into subdirectories under
# /etc/letsencrypt/live/*.
#
# Configuration must then be updated for the systems using the
# certificates.
#
# The certbot-auto program logs to /var/log/letsencrypt.
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
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot-auto

# Install the dependencies.
certbot --noninteractive --os-packages-only

certbot certonly --agree-tos --non-interactive --expand --text --rsa-key-size 4096 --email $MAIL --standalone --domains $DOMAINS_URI

#Prepare cron renewall
CRON_SCRIPT="/etc/cron.daily/certbot-renew"
cat>"${CRON_SCRIPT}"<<EOF
#! /BIN/BASH
certbot --no-self-upgrade certonly
EOF
chmod a+x "${CRON_SCRIPT}"

# copie des certificats
rm -rf /var/docker/certs/$CERT_PATH && mkdir -p /var/docker/certs/$CERT_PATH
cp -rf /etc/letsencrypt/archive/$CERT_PATH/* /var/docker/certs/$CERT_PATH

