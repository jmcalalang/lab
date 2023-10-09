{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.47.0",
        "id": "listCalalangNetAS3",
        "listCalalangNet": {
            "class": "Tenant",
            "list.calalang.net": {
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
                    "pool": {
                        "use": "pool"
                    }
                },
                "addressList": {
                    "class": "Net_Address_List",
                    "addresses": [
                        "10.0.10.6",
                        "10.0.20.6"
                    ]
                },
                "portList": {
                    "class": "Net_Port_List",
                    "ports": [
                        "80",
                        "8080"
                    ]
                },
                "pool": {
                    "class": "Pool",
                    "members": [
                        {
                            "serverAddresses": [
                                "192.0.2.100"
                            ],
                            "servicePort": 8080
                        }
                    ],
                    "monitors": [
                        "http"
                    ]
                }
            }
        }
    }
}