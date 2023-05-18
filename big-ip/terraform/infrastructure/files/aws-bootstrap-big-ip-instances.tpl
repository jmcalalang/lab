#!/bin/bash -x

# Send output to log file and serial console
mkdir -p  /var/log/cloud /config/cloud /var/config/rest/downloads
LOG_FILE=/var/log/cloud/startup-script.log
[[ ! -f $LOG_FILE ]] && touch $LOG_FILE || { echo "Run Only Once. Exiting"; exit; }
npipe=/tmp/$$.tmp
trap "rm -f $npipe" EXIT
mknod $npipe p
tee <$npipe -a $LOG_FILE /dev/ttyS0 &
exec 1>&-
exec 1>$npipe
exec 2>&1

# Run Immediately Before MCPD starts
/usr/bin/setdb provision.extramb 2048 || true
/usr/bin/setdb restjavad.useextramb true || true
/usr/bin/setdb iapplxrpm.timeout 300 || true
/usr/bin/setdb icrd.timeout 180 || true
/usr/bin/setdb restjavad.timeout 180 || true
/usr/bin/setdb restnoded.timeout 180 || true

# Download or Render BIG-IP Runtime Init Config
cat << 'EOF' > /config/cloud/runtime-init-conf.yaml
---
controls:
  logLevel: silly
  logFilename: /var/log/cloud/bigIpRuntimeInit.log
pre_onboard_enabled: []
runtime_parameters:
  - name: HOST_NAME
    type: metadata
    metadataProvider:
      environment: aws
      type: uri
      value: /latest/meta-data/hostname
  - name: SELF_IP_EXTERNAL
    type: metadata
    metadataProvider:
      environment: aws
      type: network
      field: local-ipv4s
      index: 2
  - name: SELF_IP_INTERNAL
    type: metadata
    metadataProvider:
      environment: aws
      type: network
      field: local-ipv4s
      index: 1
  - name: DEFAULT_GW
    type: metadata
    metadataProvider:
      environment: aws
      type: network
      field: local-ipv4s
      index: 2
      ipcalc: first
bigip_ready_enabled: []
extension_packages:
  install_operations:
    - extensionType: do
      extensionVersion: 1.37.0
      extensionHash: 25dd5256f9fa563e9b2ef9df228d5b01df1aef6b143d7e1c7b9daac822fb91ef
    - extensionType: as3
      extensionVersion: 3.44.0
      extensionHash: 78ecc5a0d3d6410dabb8cc2a80d3a7287a524b6f7ad4c8ff2c83f11947f597db
    - extensionType: ts
      extensionVersion: 1.33.0
      extensionHash: 573d8cf589d545b272250ea19c9c124cf8ad5bcdd169dbe2139e82ce4d51a449
extension_services:
  service_operations:
    - extensionType: do
      type: inline
      value:
        schemaVersion: 1.0.0
        class: Device
        async: true
        label: Example 3NIC BIG-IP with Runtime-Init
        Common:
          class: Tenant
          My_DbVariables:
            class: DbVariables
            config.allow.rfc3927: enable
            dhclient.mgmt: disable
            ui.advisory.enabled: true
            ui.advisory.color: yellow
            ui.advisory.text: AWS Instance Ready
            provision.extramb: 2048
            restjavad.useextramb: true
            icrd.timeout: 180
            restjavad.timeout: 180
            restnoded.timeout: 180
          My_System:
            class: System
            hostname: '{{{ HOST_NAME }}}'
            cliInactivityTimeout: 1200
            consoleInactivityTimeout: 1200
            autoPhonehome: true
          My_Dns:
            class: DNS
            nameServers:
              - 169.254.169.253
          My_Ntp:
            class: NTP
            servers:
              - 169.254.169.253
            timezone: UTC
          My_Provisioning:
            class: Provision
            ltm: nominal
            gtm: nominal
          external:
            class: VLAN
            tag: 4094
            mtu: 1500
            interfaces:
              - name: '1.1'
                tagged: false
          internal:
            class: VLAN
            tag: 4093
            mtu: 1500
            interfaces:
              - name: '1.2'
                tagged: false
          external-self:
            class: SelfIp
            address: '{{{ SELF_IP_EXTERNAL }}}'
            vlan: external
            allowService: default
            trafficGroup: traffic-group-local-only
          internal-self:
            class: SelfIp
            address: '{{{ SELF_IP_INTERNAL }}}'
            vlan: internal
            allowService: default
            trafficGroup: traffic-group-local-only
          default:
            class: Route
            gw: '{{{ DEFAULT_GW }}}'
            mtu: 1500
            network: default
post_onboard_enabled: []
EOF

# Download
for i in {1..30}; do
    curl -fv --retry 1 --connect-timeout 5 -L "${package_url}" -o "/var/config/rest/downloads/f5-bigip-runtime-init.gz.run" && break || sleep 10
done
# Install
bash /var/config/rest/downloads/f5-bigip-runtime-init.gz.run -- "--cloud aws --telemetry-params templateName:f5-bigip-runtime-init/examples/terraform/aws/main.tf"
# Run
f5-bigip-runtime-init --config-file /config/cloud/runtime-init-conf.yaml