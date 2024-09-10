# Nginx-Proxy-Automation
Collection of scripts that automate creating proxies for nginx server
This repository contains three scripts:
- mkproxy : creates an nginx proxy for subdomain.mydomain.com on a port that you specify
- rmproxy : removes proxy files created by `mkproxy` by name (exact match) and creates an inactive backup of that file in `/etc/nginx/sites-available/backup/`
- lsproxy : lists active proxies created by `mkproxy`
Nginx restarts are managed by the scripts, they require admin privileges to run.
If you want to generate certificates, please use the apt `certbot` python package https://github.com/certbot

Don't forget to update the `DOMAIN_NAME` and `NGINX_PATH` variables to suit your needs, then put those scripts in your binary dir (usually `/usr/var/bin/` if it's on PATH) and make them executable (`sudo chmod +x <script>`)

Usage:
- mkproxy :
    ```shell
    sudo mkproxy <subdomain> <port>
    ```
- rmproxy :
    ```shell
    sudo rmproxy <subdomain>
    ```
- lsproxy :
    ```shell
    sudo lsproxy
    ```
