{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.43.0",
        "id": "bigipCalalangNetAS3",
        "bigipCalalangNet": {
            "class": "Tenant",
            "bigip.calalang.net": {
                "class": "Application",
                "http-as3": {
                    "class": "Service_HTTP",
                    "virtualAddresses": [
                        "10.0.2.6"
                    ],
                    "iRules": [
                        {
                            "bigip": "/Common/Shared/irule-f5-distributed-cloud-discovery"
                        }
                    ],
                    "layer4": "tcp",
                    "policyEndpoint": "endpoint-policy-bigip-calalang-net",
                    "policyWAF": {
                        "use": "waf-bigip-calalang-net"
                    },
                    "persistenceMethods": [
                        "cookie"
                    ],
                    "profileHTTP": {
                        "use": "http-profile-bigip-calalang-net"
                    },

                    "profileTCP": "normal",
                    "profileTrafficLog": {
                        "bigip": "/Common/Shared/telemetry_traffic_log_profile"
                    },
                    "securityLogProfiles": [
                        {
                            "bigip": "/Common/Shared/secLogRemote"
                        }
                    ]
                },
                "endpoint-policy-bigip-calalang-net": {
                    "class": "Endpoint_Policy",
                    "rules": [
                        {
                            "name": "forward_to_pool",
                            "conditions": [
                                {
                                    "type": "httpUri",
                                    "path": {
                                        "operand": "contains",
                                        "values": [
                                            "/"
                                        ]
                                    }
                                }
                            ],
                            "actions": [
                                {
                                    "type": "httpHeader",
                                    "event": "request",
                                    "replace": {
                                        "name": "Host",
                                        "value": "nginx.org"
                                    }
                                },
                                {
                                    "type": "forward",
                                    "event": "request",
                                    "select": {
                                        "pool": {
                                            "use": "pool-bigip-calalang-net"
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                },
                "http-profile-bigip-calalang-net": {
                    "class": "HTTP_Profile",
                    "insertHeader": {
                        "name": "X-Forwarded-IP-Custom",
                        "value": "[expr { [IP::client_addr] }]:[?\"]"
                    },
                    "xForwardedFor": true
                },
                "pool-bigip-calalang-net": {
                    "class": "Pool",
                    "monitors": [
                        "tcp"
                    ],
                    "members": [
                        {
                            "servicePort": 80,
                            "addressDiscovery": "fqdn",
                            "autoPopulate": true,
                            "hostname": "nginx.org"
                        }
                    ]
                },
                "waf-bigip-calalang-net": {
                    "class": "WAF_Policy",
                    "url": "https://raw.githubusercontent.com/f5devcentral/f5-asm-policy-templates/master/owasp_ready_template/owasp-auto-tune-v1.1.xml",
                    "ignoreChanges": true
                }
            }
        }
    }
}