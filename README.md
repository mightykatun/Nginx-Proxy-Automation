# Nginx-Proxy-Automation
Collection of scripts that automate creating proxies for nginx server.
This repository contains three scripts:
- mkproxy : creates an nginx proxy for subdomain.mydomain.com on a port that you specify
- rmproxy : removes proxy files created by `mkproxy` by name (exact match) and creates an inactive backup of that file in `/etc/nginx/sites-available/backup/`
- lsproxy : lists active proxies created by `mkproxy`
Nginx restarts are managed by the scripts, they require admin privileges to run.
