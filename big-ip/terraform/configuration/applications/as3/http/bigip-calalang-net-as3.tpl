{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.47.0",
        "id": "bigipCalalangNetAS3",
        "bigipCalalangNet": {
            "class": "Tenant",
            "bigip.calalang.net": {
                "class": "Application",
                "http-as3": {
                    "class": "Service_HTTP",
                    "virtualAddresses": {
                        "use": "addressList"
                    },
                    "virtualPort": {
                        "use": "portList"
                    },
                    "layer4": "tcp",
                    "profileTCP": "normal",
                    "profileHTTP": "basic",
                    "persistenceMethods": [
                        "cookie"
                    ],
                    "policyEndpoint": "nginxOrgForwardPolicy",
                    "policyWAF": {
                        "use": "bigipCalalangNet_OWASP_Auto_Tune"
                    }
                },
                "addressList": {
                    "class": "Net_Address_List",
                    "addresses": [
                        "10.0.2.6",
                        "10.0.20.6"
                    ]
                },
                "portList": {
                    "class": "Net_Port_List",
                    "ports": [
                        "80"
                    ]
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