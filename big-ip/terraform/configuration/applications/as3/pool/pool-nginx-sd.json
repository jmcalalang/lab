{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.43.0",
        "id": "serviceDiscovery",
        "serviceDiscovery": {
            "class": "Tenant",
            "serviceDiscovery": {
                "class": "Application",
                "pool-sd-proxy": {
                    "class": "Pool",
                    "monitors": [
                        "tcp"
                    ],
                    "members": [
                        {
                            "servicePort": 80,
                            "addressDiscovery": "azure",
                            "updateInterval": 60,
                            "tagKey": "proxy",
                            "tagValue": "proxy",
                            "addressRealm": "private",
                            "subscriptionId": "${subscriptionId}",
                            "resourceGroup": "calalang-nginx-rg",
                            "useManagedIdentity": true
                        }
                    ]
                },
                "pool-sd-api-gateway": {
                    "class": "Pool",
                    "monitors": [
                        "tcp"
                    ],
                    "members": [
                        {
                            "servicePort": 80,
                            "addressDiscovery": "azure",
                            "updateInterval": 60,
                            "tagKey": "proxy",
                            "tagValue": "apigw",
                            "addressRealm": "private",
                            "subscriptionId": "${subscriptionId}",
                            "resourceGroup": "calalang-nginx-rg",
                            "useManagedIdentity": true
                        }
                    ]
                }
            }
        }
    }
}