#!/bin/bash

if [ $EUID -ne 0 ]; then
        echo "You must be root to do this"
        exit 1
fi

DOMAIN_NAME="domain.com"

NGINX_PATH="/etc/nginx"

COUNT=0

echo "Listing proxies..."

for FILE in $NGINX_PATH/sites-available/*; do
        if [ ! -d "$FILE" ]; then
                WAS_CREATED=$(cat $FILE | grep "#mkproxy")
                if [[ $WAS_CREATED == "#mkproxy" ]]; then
                        PORT=$(cat $FILE | grep -oP "(?<=127.0.0.1:)([^/]+)" | sed "s/;$//")
                        FILE=${FILE##*/}
                        if [[ $COUNT == 0 ]]; then
                                echo ""
                        fi
                        echo -e "Domain: \e[1m$FILE.$DOMAIN_NAME\e[0m running on port \e[1m$PORT\e[0m proxied"
                        COUNT=$((COUNT+1))
                fi
        fi
done
if [[ $COUNT == 1 ]]; then
        echo ""
        echo "$COUNT domain proxied"
fi
if [[ $COUNT == 0 ]]; then
        echo -e "No domains currently proxied, add a proxy using \e[1mmkproxy\e[0m"
fi
if [[ $COUNT > 1 ]]; then
        echo ""
        echo "$COUNT domains proxied"
fi
