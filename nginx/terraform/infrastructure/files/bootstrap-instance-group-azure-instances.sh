#! /bin/bash

# Bootstrap script for NGINX Azure instances

# install nginx modules
sudo apt-get install nginx-plus-module-njs

# Add NGINX instance to NGINX One
curl https://agent.connect.nginx.com/nginx-agent/install | DATA_PLANE_KEY="${nginx_one_dataplane_key}" sh -s -- -y

## Append to nginx-agent.conf the app-protect monitoring
#cat << EOF | sudo tee -a /etc/nginx-agent/nginx-agent.conf
#
## Enable reporting NGINX App Protect details to the control plane.
#nginx_app_protect:
#  # Report interval for NGINX App Protect details - the frequency at which NGINX Agent checks NGINX App Protect for changes.
#  report_interval: 15s
## NGINX App Protect Monitoring config
#nap_monitoring:
#  # Buffer size for collector. Will contain log lines and parsed log lines
#  collector_buffer_size: 50000
#  # Buffer size for processor. Will contain log lines and parsed log lines
#  processor_buffer_size: 50000
#  # Syslog server IP address the collector will be listening to
#  syslog_ip: "127.0.0.1"
#  # Syslog server port the collector will be listening to
#  syslog_port: 514
#
#EOF

# Append to agent-dynamic.conf for tags
cat << EOF | sudo tee -a /etc/nginx-agent/agent-dynamic.conf
tags:
    - azure-instances
EOF

# Restart NGINX
sudo systemctl restart nginx

# Restart NGINX Agent
sudo systemctl restart nginx-agent