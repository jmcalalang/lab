{
    "tenant_name": "fast-ldap",
    "app_name": "calalang.net",
    "virtual_address": "10.0.2.5",
    "virtual_port": 389,
    "enable_snat": true,
    "snat_automap": true,
    "enable_tls_server": false,
    "enable_tls_client": false,
    "enable_pool": true,
    "make_pool": true,
    "pool_members": [
        {
            "serverAddresses": [
                "10.0.3.15"
            ],
            "servicePort": 389,
            "connectionLimit": 0,
            "priorityGroup": 0,
            "shareNodes": true
        }
    ],
    "load_balancing_mode": "least-connections-member",
    "slow_ramp_time": 300,
    "enable_monitor": true,
    "make_monitor": true,
    "monitor_interval": 30,
    "monitor_username": "service_ldap",
    "monitor_passphrase": "${monitor_passphrase}",
    "monitor_base": "dc=calalang,dc=net",
    "monitor_filter": "objectclass=*",
    "common_tcp_profile": false,
    "make_tcp_ingress_profile": true,
    "tcp_ingress_topology": "wan",
    "make_tcp_egress_profile": true,
    "tcp_egress_topology": "lan",
    "irule_names": [],
    "vlans_enable": false,
    "enable_analytics": false,
    "enable_waf_policy": false,
    "enable_asm_logging": false,
    "enable_firewall": false,
    "enable_telemetry": false
}