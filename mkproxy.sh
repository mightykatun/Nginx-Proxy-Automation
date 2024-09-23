#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to do this"
        exit 1
fi

if [[ $# -lt 2 ]]; then
        echo "Error: Two arguments required [subdomain name, port]"
        exit 1
fi

DOMAIN_NAME="domain.com"
SUBDOMAIN_NAME=$1.$DOMAIN_NAME
PORT=$2

NGINX_PATH="/etc/nginx"
AUTH_FILE="$NGINX_PATH/.htpasswd"
AUTH=0

echo -n "Do you want to setup basic auth? [y/n] "
read BOOL

if [[ $BOOL != "y" ]]; then
        echo "No basic auth will be configured"
else
        echo -n "Enter the authentication header: "
        read AUTH_BASIC
        AUTH=1
fi

echo -n -e "Are you sure you want to proxy \e[1m$SUBDOMAIN_NAME\e[0m running on port \e[1m$PORT\e[0m ? [y/n] "
read BOOL

if [[ $BOOL != "y" ]]; then
        echo "Aborted"
        exit 0
fi

if [[ -f $NGINX_PATH/sites-available/$1 ]]; then
        WAS_CREATED=$(cat $NGINX_PATH/sites-available/$1 | grep "#mkproxy")
        if [[ $WAS_CREATED != "#mkproxy" ]]; then
                echo -e "File \e[1m$1\e[0m exists but was not created by mkproxy, will not be overwritten"
                exit 0
        fi
        echo -n -e "File \e[1m$1\e[0m exists, do you still want to proceed? [y/n] "
        read BOOL
        if [[ $BOOL != "y" ]]; then
                echo "Aborted"
                exit 0
        fi
        mkdir -p $NGINX_PATH/sites-available/backup && cp $NGINX_PATH/sites-available/$1 $NGINX_PATH/sites-available/backup/$1
        echo -e "Created backup \e[1m$NGINX_PATH/sites-available/backup/$1\e[0m"
fi

touch $NGINX_PATH/sites-available/$1

if [[ ! -f $NGINX_PATH/sites-enabled/$1 ]]; then
        ln -s $NGINX_PATH/sites-available/$1 $NGINX_PATH/sites-enabled/$1
else
        echo "Did not create symbolic link as it already existed!"
fi

if [[ $AUTH -eq 0 ]]; then
        echo "#mkproxy

server{
        server_name $SUBDOMAIN_NAME;
        location / {
                proxy_pass http://127.0.0.1:$PORT;
                proxy_read_timeout 300;
                proxy_buffering off;
                proxy_cache off;
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto \$scheme;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection upgrade;
                add_header X-Robots-Tag \"noindex, nofollow, nosnippet, noarchive\";
        }
}" > $NGINX_PATH/sites-available/$1
else
        echo "#mkproxy

server{
        server_name $SUBDOMAIN_NAME;
        location / {
                auth_basic \"$AUTH_BASIC\";
                auth_basic_user_file $AUTH_FILE;
                proxy_pass http://127.0.0.1:$PORT;
                proxy_read_timeout 300;
                proxy_buffering off;
                proxy_cache off;
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto \$scheme;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection upgrade;
                add_header X-Robots-Tag \"noindex, nofollow, nosnippet, noarchive\";
        }
}" > $NGINX_PATH/sites-available/$1
fi

echo -e "File \e[1m$1\e[0m created successfully"
echo ""

cat $NGINX_PATH/sites-available/$1

echo ""
echo "Restarting nginx..." && systemctl restart nginx
echo "You can now generate certificates using \"sudo certbot --nginx\" (requires root privileges)"
