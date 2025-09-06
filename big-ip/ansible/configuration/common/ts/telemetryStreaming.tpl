{
    "class": "Telemetry",
    "schemaVersion": "1.32.0",
    "My_Listener": {
        "class": "Telemetry_Listener",
        "port": 6514
    },
    "Poller": {
        "class": "Telemetry_System_Poller",
        "interval": 60,
        "enable": true,
        "trace": false,
        "allowSelfSignedCert": false,
        "host": "localhost",
        "port": 8100,
        "protocol": "http",
        "actions": [
            {
                "enable": true,
                "includeData": {},
                "locations": {
                    "system": true,
                    "virtualServers": true,
                    "httpProfiles": true,
                    "clientSslProfiles": true,
                    "serverSslProfiles": true
                }
            }
        ]
    },
    "Pull_Consumer": {
        "class": "Telemetry_Pull_Consumer",
        "type": "default",
        "systemPoller": [
            "Poller"
        ]
    },
    "OpenTelemetry_Protobuf_secure": {
        "class": "Telemetry_Consumer",
        "type": "OpenTelemetry_Exporter",
        "host": "{{ otel_host }}",
        "port": 55681,
        "protocol": "https",
        "headers": [
            {
                "name": "x-access-token",
                "value": "{{ otel_token }}"
            }
        ],
        "convertBooleansToMetrics": false,
        "exporter": "protobuf"
    }
}