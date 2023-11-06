{
  "tenant_name": "fast-http",
  "app_name": "fast-http-application",
  "virtual_address": "192.168.1.100",
  "pool_members": [
    {
      "serverAddresses": [
        "192.168.1.101"
      ],
      "servicePort": 80,
      "connectionLimit": 0,
      "priorityGroup": 0,
      "shareNodes": true
    }
  ],
  "use_sd": true,
  "service_discovery": [
    {
      "sd_type": "event",
      "sd_port": 80
    }
  ]
}