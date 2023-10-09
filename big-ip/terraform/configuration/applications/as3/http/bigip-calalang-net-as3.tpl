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
                "https-10-0-2-6-as3": {
                    "class": "Service_HTTP",
                    "virtualAddresses": [
                        "10.0.2.6"
                    ],
                    "securityLogProfiles": [
                        {
                            "bigip": "/Common/Shared/secLogRemote"
                        }
                    ],
                    "policyEndpoint": "nginxOrgForwardPolicy",
                    "policyWAF": {
                        "use": "bigipCalalangNet_OWASP_Auto_Tune"
                    },
                    "persistenceMethods": [
                        "cookie"
                    ],
                    "profileHTTP": "basic",
                    "layer4": "tcp",
                    "profileTCP": "normal"
                },
                "pool-dns-nginx-org": {
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
                "nginxOrgForwardPolicy": {
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
                                    "type": "forward",
                                    "event": "request",
                                    "select": {
                                        "pool": {
                                            "use": "pool-dns-nginx-org"
                                        }
                                    }
                                },
                                {
                                    "type": "httpHeader",
                                    "event": "request",
                                    "replace": {
                                        "name": "HOST",
                                        "value": "nginx.org"
                                    }
                                }
                            ]
                        }
                    ]
                },
                "bigipCalalangNet_OWASP_Auto_Tune": {
                    "class": "WAF_Policy",
                    "url": "https://raw.githubusercontent.com/f5devcentral/f5-asm-policy-templates/master/owasp_ready_template/owasp-auto-tune-v1.1.xml",
                    "ignoreChanges": true
                }
            }
        }
    }
}