No longer needed with auto certificates

sudo certbot -d bigip.calalang.net -d apm.calalang.net --manual --preferred-challenges dns certonly
Certificate is saved at: /etc/letsencrypt/live/apm.calalang.net/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/apm.calalang.net/privkey.pem

sudo certbot -d nginx.calalang.net --manual --preferred-challenges dns certonly
Certificate is saved at: /etc/letsencrypt/live/nginx.calalang.net/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/nginx.calalang.net/privkey.pem

sudo certbot -d kubernetes.calalang.net -d argo.calalang.net --manual --preferred-challenges dns certonly
Certificate is saved at: /etc/letsencrypt/live/kubernetes.calalang.net/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/kubernetes.calalang.net/privkey.pem
