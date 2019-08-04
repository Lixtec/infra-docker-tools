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

echo "START INSTALL LET'S ENCRYPT by $MAIL for $DOMAINS_URI"

# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# No package install yet.
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
mv certbot-auto /usr/local/bin

# Install the dependencies.
certbot-auto --noninteractive --os-packages-only

certbot-auto certonly --agree-tos --non-interactive --expand --text --rsa-key-size 4096 --email $MAIL --standalone --domains $DOMAINS_URI

#Prepare cron renewall
CRON_SCRIPT="/etc/cron.daily/certbot-renew"
cat>"${CRON_SCRIPT}"<<EOF
#! /BIN/BASH
certbot-auto --no-self-upgrade certonly
EOF
chmod a+x "${CRON_SCRIPT}"
