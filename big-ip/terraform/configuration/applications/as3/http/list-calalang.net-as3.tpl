{
    "$schema": "https://raw.githubusercontent.com/F5Networks/f5-appsvcs-extension/main/schema/${as3-version}/as3-schema.json",
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "${as3-version}",
        "id": "listCalalangNetAS3",
        "listCalalangNet": {
            "class": "Tenant",
            "list.calalang.net": {
                "class": "Application",
                "http-as3": {
                    "class": "Service_HTTP",
                    "virtualAddresses": {
                        "use": "address-list-list-calalang-net"
                    },
                    "virtualPort": {
                        "use": "port-list-list-calalang-net"
                    },
                    "layer4": "tcp",
                    "profileTCP": "normal",
                    "profileHTTP": "basic",
                    "persistenceMethods": [
                        "cookie"
                    ],
                    "pool": {
                        "use": "pool-list-calalang-net"
                    }
                },
                "address-list-list-calalang-net": {
                    "class": "Net_Address_List",
                    "addresses": [
                        "10.0.10.6",
                        "10.0.11.6"
                    ]
                },
                "port-list-list-calalang-net": {
                    "class": "Net_Port_List",
                    "ports": [
                        "80",
                        "8080"
                    ]
                },
                "pool-list-calalang-net": {
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