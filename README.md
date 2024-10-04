# Nginx-Proxy-Automation

Collection of scripts to automate the creation and management of proxies for an Nginx server.

## Contents

This repository includes three primary scripts:

- **mkproxy**: Creates an Nginx proxy for `subdomain.mydomain.com` on a specified port.
- **rmproxy**: Removes proxy files created by `mkproxy` and creates an inactive backup in `/etc/nginx/sites-available/backup/`.
- **lsproxy**: Lists active proxies created by `mkproxy`.

## Requirements

- The scripts require administrative privileges to run.
- Ensure `DOMAIN_NAME` and `NGINX_PATH` variables are updated according to your setup.
- Place the scripts in your binary directory (usually `/usr/local/bin/`) and make them executable:
  ```shell
  sudo chmod +x <script>
  ```

## Usage

### mkproxy

Creates an Nginx proxy.
```shell
sudo mkproxy <subdomain> <port>
```

### rmproxy

Removes a specified proxy and creates a backup.
```shell
sudo rmproxy <subdomain>
```

### lsproxy

Lists all active proxies.
```shell
sudo lsproxy
```

## Certificate Generation

To generate certificates, use the `certbot` package:
[Certbot GitHub](https://github.com/certbot)
