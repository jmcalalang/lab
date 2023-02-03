#! /bin/bash
curl -k https://10.0.4.54/install/nginx-agent > install.sh && sudo sh install.sh -g api && sudo systemctl start nginx-agent
sudo apt-get update