{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.47.0",
        "id": "distributedCloudDiscoveryAS3",
        "discoveryCalalangNet": {
            "class": "Tenant",
            "f5-distributed-cloud-discovery": {
                "class": "Application",
                "http-as3": {
                    "class": "Service_HTTP",
                    "virtualAddresses": [
                        "255.255.255.254"
                    ],
                    "virtualPort": 9000,
                    "layer4": "tcp",
                    "profileTCP": "normal",
                    "profileHTTP": "basic",
                    "persistenceMethods": [
                        "cookie"
                    ]
                },
                "endpoint-f5-distributed-cloud-discovery": {
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
                                            "use": "pool-f5-distributed-cloud-discovery"
                                        }
                                    }
                                },
                                {
                                    "type": "httpHeader",
                                    "event": "request",
                                    "replace": {
                                        "name": "HOST",
                                        "value": "discovery.calalang.net"
                                    }
                                }
                            ]
                        }
                    ]
                },
                "pool-f5-distributed-cloud-discovery": {
                    "class": "Pool",
                    "monitors": [
                        "tcp"
                    ],
                    "members": [
                        {
                            "servicePort": 80,
                            "addressDiscovery": "fqdn",
                            "autoPopulate": true,
                            "hostname": "discovery.calalang.net"
                        }
                    ]
                },
                "clone-pool-f5-distributed-cloud-discovery": {
                    "class": "Pool",
                    "members": [
                        {
                            "serverAddresses": [
                                "255.255.255.254"
                            ],
                            "servicePort": 9000
                        }
                    ],
                    "monitors": [
                        "tcp"
                    ]
                }
            }
        }
    }
}