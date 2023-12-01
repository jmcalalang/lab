{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "${as3-version}",
        "id": "forwardProxy",
        "forwardProxy": {
            "class": "Tenant",
            "forwardProxy": {
                "class": "Application",
                "http-as3": {
                    "class": "Service_HTTP",
                    "virtualAddresses": [
                        "10.0.3.8"
                    ],
                    "virtualPort": 3128,
                    "layer4": "tcp",
                    "profileTCP": "normal",
                    "profileHTTP": {
                        "use": "http-profile-forward-proxy"
                    }
                },
                "http-profile-forward-proxy": {
                    "class": "HTTP_Profile",
                    "proxyType": "explicit",
                    "resolver": {
                        "bigip": "/Common/DNS_Resolver"
                    },
                    "defaultConnectAction": "allow"
                }
            }
        }
    }
}