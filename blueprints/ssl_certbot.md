# Creating SSL Certificate for NGINX using Certbot

* add to `nginx.conf` inside the `http` body
```
include /etc/nginx/sites-enabled/*
```

* create `/etc/nginx/sites-enabled/your-domain-name.com`
```
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    server_name example.com www.example.com;
}
```

* check NGINX config with `nginx -t`

* reload NGINX

* run `certbot --nginx` and follow instructions

* now the file `/etc/nginx/sites-enabled/your-domain-name.com` has been updated
    to support SSL
