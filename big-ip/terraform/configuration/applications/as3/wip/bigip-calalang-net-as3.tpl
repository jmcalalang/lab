{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "${as3-version}",
        "id": "bigipCalalangNetWIP",
        "bigipCalalangNetWIP": {
            "class": "Tenant",
            "Shared": {
                "class": "Application",
                "template": "shared",
                "calalangDomain": {
                    "class": "GSLB_Domain",
                    "domainName": "bigip.calalang.net",
                    "aliases": [
                        "bigip01.calalang.net",
                        "bigip02.calalang.net"
                    ],
                    "resourceRecordType": "A",
                    "poolLbMode": "ratio",
                    "pools": [
                        {
                            "use": "bigipCalalangNetPool"
                        }
                    ]
                },
                "bigipCalalangNetPool": {
                    "class": "GSLB_Pool",
                    "enabled": true,
                    "lbModeAlternate": "ratio",
                    "lbModeFallback": "ratio",
                    "manualResumeEnabled": true,
                    "verifyMemberEnabled": false,
                    "qosHitRatio": 10,
                    "qosHops": 11,
                    "qosKbps": 8,
                    "qosLinkCapacity": 35,
                    "qosPacketRate": 5,
                    "qosRoundTripTime": 75,
                    "qosTopology": 3,
                    "qosVirtualServerCapacity": 2,
                    "qosVirtualServerScore": 1,
                    "members": [
                        {
                            "ratio": 1,
                            "server": {
                                "bigip": "/Common/calalang-azure-0"
                            },
                            "virtualServer": "/bigipCalalangNet/bigip.calalang.net/http-as3",
                            "dependsOn": "none"
                        }
                    ],
                    "bpsLimit": 5,
                    "bpsLimitEnabled": true,
                    "ppsLimit": 4,
                    "ppsLimitEnabled": true,
                    "connectionsLimit": 3,
                    "connectionsLimitEnabled": true,
                    "maxAnswersReturned": 10,
                    "monitors": [
                        {
                            "bigip": "/Common/http"
                        }
                    ],
                    "resourceRecordType": "A",
                    "fallbackIP": "1.1.1.1"
                }
            }
        }
    }
}