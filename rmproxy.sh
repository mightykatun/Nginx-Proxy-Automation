#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to do this"
        exit 1
fi

if [[ $# -lt 1 ]]; then
        echo "Error: One argument required [subdomain name]"
        exit 1
fi

NGINX_PATH="/etc/nginx"

DOMAIN_NAME="domain.com"
SUBDOMAIN_NAME=$1.$DOMAIN_NAME

if [[ ! -f $NGINX_PATH/sites-available/$1 ]]; then
        echo -e "File \e[1m$1\e[0m does not exist, will not be removed"
        exit 0
fi

WAS_CREATED=$(cat $NGINX_PATH/sites-available/$1 | grep "#mkproxy")

if [[ $WAS_CREATED != "#mkproxy" ]]; then
        echo -e "File \e[1m$1\e[0m was not created by mkproxy, will not be removed"
        exit 0
fi

PORT=$(cat $NGINX_PATH/sites-available/$1 | grep -oP "(?<=127.0.0.1:)([^/]+)" | sed "s/;$//")

echo -n -e "Are you sure you want to remove \e[1m$SUBDOMAIN_NAME\e[0m running on port \e[1m$PORT\e[0m ? [y/n] "
read BOOL

if [[ $BOOL != "y" ]]; then
        echo "Aborted"
        exit 0
fi

mkdir -p $NGINX_PATH/sites-available/backup && mv $NGINX_PATH/sites-available/$1 $NGINX_PATH/sites-available/backup/
echo -e "Created backup \e[1m$NGINX_PATH/sites-available/backup/$1\e[0m"

rm $NGINX_PATH/sites-enabled/$1

echo -e "File \e[1m$1\e[0m removed successfully"
echo "Restarting nginx..." && systemctl restart nginx
echo "You can now update the certificates using \"certbot --nginx\" (requires root privileges)"
