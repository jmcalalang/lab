{{/*
Expand the name of the chart.
*/}}
{{- define "nms.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nms.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nms.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}

{{- define "nms.labels" -}}
helm.sh/chart: {{ include "nms.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nms.serviceAccountName" -}}
{{ .Values.serviceAccount.name | default "nms"}}
{{- end }}

{*
   ------ NMS configs and secrets ------
*}

{{/* Helper to return nms auth secret name */}}
{{- define "nms.secret.auth.name" -}}
{{ template "nms.fullname" . }}-auth
{{- end -}}

{{/* Helper to return nms cert secret name */}}
{{- define "nms.secret.internal-certs.name" -}}
{{ template "nms.fullname" . }}-internal-certs
{{- end -}}

{{/* Helper to return nms gen certs secret name */}}
{{- define "nms.secret.apigw-certs.name" -}}
{{ template "nms.fullname" . }}-apigw-certs
{{- end -}}

{{/* Helper to return nms.conf name */}}
{{- define "nms.config.name" -}}
{{ template "nms.fullname" . }}-conf
{{- end -}}

{{/* Helper to return nms-http.conf name */}}
{{- define "nms.nginx.http.config.name" -}}
{{ template "nms.fullname" . }}-http-conf
{{- end -}}

{{/* Helper to return Nginx API Gateway config name */}}
{{- define "nms.nginx.config.name" -}}
{{ template "nms.fullname" . }}-nginx-conf
{{- end -}}

{{/* Helper to return openid config name */}}
{{- define "nms.openid.config.name" -}}
{{ template "nms.fullname" . }}-openid-conf
{{- end -}}

{{/* Helper to validate nms admin password required value */}}
{{- define "nms.admin-pwd" -}}
{{ required "A valid .Values.adminPasswordHash entry required!" .Values.adminPasswordHash }}
{{- end -}}

{{/*
Generates server certificates for core, dpm, ingestion, integrations and
client certificates for apigw, core, dpm, ingestion and integrations
*/}}
{{- define "nms.gen-internal-certs" -}}
{{- $ca := . }}
{{- $secretObj := (lookup "v1" "Secret" .Release.Namespace (include "nms.secret.internal-certs.name" . )) | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- $caKey := (get $secretData "ca.key") | default "" }}
{{- $caCert := (get $secretData "ca.pem") | default "" }}
{{- if eq $caKey "" }}
{{- $ca = genCA (include "nms.fullname" .) 36600 -}}
{{- end }}
{{- if ne $caKey ""}}
{{- $ca = buildCustomCert $caCert $caKey -}}
{{- end }}
{{- $servers := (list "core" "dpm" "ingestion" "integrations") }}
{{- $clients := (list (include "nms.apigw.name" .) "core" "dpm" "ingestion" "integrations") }}
{{- range $k, $v := $.Values.global.nmsModules }}
{{- range $i, $s := $v.services }}
{{- $servers = append $servers $s }}
{{- $clients = append $clients $s }}
{{- end }}
{{- end }}
{{- template "gen-certs" ( list $ca $servers $clients $secretData $ ) -}}
{{- end -}}

{{/*
Generates self signed CA and server certificates for apigw
*/}}
{{- define "nms.gen-apigw-certs" -}}
{{- $ca := . }}
{{- $subjectName := include "nms.apigw.name" . }}
{{- $ca = genCA (include "nms.fullname" .) 36600 -}}
{{- $altNames := (list $subjectName (printf "%s.%s.svc" $subjectName .Release.Namespace ) (printf "%s.%s.svc.cluster.local" $subjectName .Release.Namespace )) -}}
{{- $ips := (list "0.0.0.0" "127.0.0.1") -}}
{{- $cert := genSignedCert ( printf "%s.%s" $subjectName .Release.Namespace ) $ips $altNames 36600 $ca -}}
ca.pem: {{ $ca.Cert | b64enc }}
tls.crt: {{ $cert.Cert | b64enc }}
tls.key: {{ $cert.Key | b64enc }}
{{- end -}}

{{- define "gen-certs" -}}
{{- $ca := index . 0 }}
{{- $services := index . 1 }}
{{- $clients := index . 2 }}
{{- $existingCerts := index . 3 }}
{{- $ := index . 4 }}
ca.pem: {{ $ca.Cert | b64enc }}
ca.key: {{ $ca.Key | b64enc }}
{{- range $index, $serviceName := $services }}
{{- printf "\n" -}}
{{- $serverCert := (get $existingCerts (printf "%s-server.pem" $serviceName )) | default "" }}
{{- $serverKey := (get $existingCerts (printf "%s-server.key" $serviceName )) | default "" }}
{{- if ne $serverCert ""}}
{{ printf "%s-server.pem" $serviceName }}: {{ $serverCert }}
{{ printf "%s-server.key" $serviceName }}: {{ $serverKey }}
{{- else }}
{{- template "gen-server-certs" (list $serviceName $ca $) -}}
{{- end }}
{{- end }}
{{- range $index, $clientName := $clients }}
{{- printf "\n" -}}
{{- $clientCert := (get $existingCerts (printf "%s-client.pem" $clientName )) | default "" }}
{{- $clientKey := (get $existingCerts (printf "%s-client.key" $clientName )) | default "" }}
{{- if ne $clientCert ""}}
{{ printf "%s-client.pem" $clientName }}: {{ $clientCert }}
{{ printf "%s-client.key" $clientName }}: {{ $clientKey }}
{{- else }}
{{- template "gen-client-certs" (list $clientName $ca) -}}
{{- end }}
{{- end }}
{{- end -}}

{{- define "gen-server-certs" -}}
{{- $serviceName := index . 0 }}
{{- $ca := index . 1 }}
{{- $ := index . 2 }}
{{- $altNames := (list $serviceName (printf "%s.%s.svc" $serviceName $.Release.Namespace ) (printf "%s.%s.svc.cluster.local" $serviceName $.Release.Namespace )) -}}
{{- $ips := (list "0.0.0.0" "127.0.0.1") -}}
{{- $cert := genSignedCert ( printf "%s.%s" $serviceName $.Release.Namespace ) $ips $altNames 36600 $ca -}}
{{ printf "%s-server.pem" $serviceName }}: {{ $cert.Cert | b64enc }}
{{ printf "%s-server.key" $serviceName }}: {{ $cert.Key | b64enc }}
{{- end -}}

{{- define "gen-client-certs" -}}
{{- $clientName := index . 0 }}
{{- $ca := index . 1 }}
{{- $altNames := (list (printf "%s-api-service" $clientName ) (printf "%s-grpc-service" $clientName )) -}}
{{- $cert := genSignedCert ( printf "%s-client" $clientName ) nil $altNames 36600 $ca -}}
{{ printf "%s-client.pem" $clientName }}: {{ $cert.Cert | b64enc }}
{{ printf "%s-client.key" $clientName }}: {{ $cert.Key | b64enc }}
{{- end -}}

{{/* Helper to return nms internal certs dir */}}
{{- define "nms.secret.internal-certs.dir" -}}
/etc/nms/certs/services
{{- end -}}

{{/*
Project certs for manager to volume mount
*/}}
{{- define "project-manager-certs" -}}
{{- range $index, $name := (list "manager-server" "manager-client") }}
- secret:
    name: $name
    items:
      - key: printf "%s.pem" $name
        path: printf "%s.pem" $name
- secret:
    name: $name
    items:
      - key: printf "%s.key" $name
        path: printf "%s.key" $name
{{- end }}
{{- end -}}

{{/*
Project certs for internal services to volume mount
*/}}
{{- define "project-services-certs" -}}
{{- range $index, $name := (list "manager-client" "core" "dpm" "ingestion" "integrations") }}
- secret:
    name: $name
    items:
      - key: printf "%s.pem" $name
        path: printf "services/%s.pem" $name
- secret:
    name: $name
    items:
      - key: printf "%s.key" $name
        path: printf "services/%s.key" $name
{{- end }}
{{- end -}}

{*
   ------ Nginx API-GW ------
*}

{{/* Helper to return nginx apigw name */}}
{{- define "nms.apigw.name" -}}
{{ .Values.apigw.name | default "apigw" }}
{{- end -}}

{{/* Helper to return nginx apigw service name */}}
{{- define "nms.apigw.service.name" -}}
{{ .Values.apigw.service.name | default "apigw" }}
{{- end -}}

{{- define "nms.apigw.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nms.apigw.name" . }}
{{- end }}

{{/* Helper function to determine which secret needs to be used for apigw */}}
{{- define "nms.apigw.secret-name" -}}
{{- if .Values.apigw.tlsSecret }}
{{- .Values.apigw.tlsSecret -}}
{{ else }}
{{- template "nms.secret.apigw-certs.name" . -}}
{{- end }}
{{- end -}}

{{/* Helper function to return api-gw secrets mount path */}}
{{- define "nms.apigw.secrets.mountPath" -}}
/etc/nms/certs/apigw
{{- end -}}

{{/* Helper function to return api-gw crt file name */}}
{{- define "nms.apigw.secrets.crt" -}}
{{- template "nms.apigw.secrets.mountPath" . -}}/tls.crt
{{- end -}}

{{/* Helper function to give generated api-gw tls key file name */}}
{{- define "nms.apigw.secrets.key" -}}
{{- template "nms.apigw.secrets.mountPath" . -}}/tls.key
{{- end -}}

{{/* Helper function to give generated api-gw ca file name */}}
{{- define "nms.apigw.secrets.ca" -}}
{{- template "nms.apigw.secrets.mountPath" . -}}/ca.pem
{{- end -}}

{{/* Helper to return nms api gateway port */}}
{{- define "nms.apigw.port" -}}
{{- if eq .Values.apigw.service.type "NodePort" -}}
{{- .Values.apigw.service.nodePortHttps -}}
{{- else }}
{{- .Values.apigw.service.httpsPort -}}
{{- end -}}
{{- end }}

{{/* Helper functions for mounting module configuration */}}
{{- define "nms.apigw.moduleVolumeMounts" -}}
{{- range $k, $v := .Values.global.nmsModules }}
{{- if $v.enabled }}
{{- range $i, $config := $v.configs }}
{{- range $j, $key := $config.upstreams }}
- name: {{ $config.configmap }}
  mountPath: /etc/nms/nginx/upstreams/{{ $key }}
  subPath: {{ $key }}
  readOnly: true
{{- end }}
{{- range $j, $key := $config.mapped_apis }}
- name: {{ $config.configmap }}
  mountPath: /etc/nms/nginx/upstreams/mapped_apis/{{ $key }}
  subPath: {{ $key }}
  readOnly: true
{{- end }}
{{- range $j, $key := $config.locations }}
- name: {{ $config.configmap }}
  mountPath: /etc/nms/nginx/locations/{{ $key }}
  subPath: {{ $key }}
  readOnly: true
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "nms.apigw.moduleVolumes" -}}
{{- range $k, $v := .Values.global.nmsModules }}
{{- if $v.enabled }}
{{- range $i, $u := $v.configs }}
- name: {{ $u.configmap }}
  configMap:
    defaultMode: 0644
    name: {{ $u.configmap }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "nms.apigw.nginxWorkerConnections" -}}
{{ .Values.apigw.nginxWorkerConnections | default 1024 }}
{{- end -}}

{{- define "nms.apigw.nginxWorkerRlimitNofile" -}}
{{ .Values.apigw.nginxWorkerRlimitNofile | default 4096 }}
{{- end -}}

{*
   ------ Core ------
*}

{{/* ENV variables */}}
{{- define "nms.core.env" -}}
- name: NMS_DPM_NATS_ADDRESS
  value: {{ include "nms.dpm.service.natsStreaming" . }}
{{- end }}

{{/* Helper to return core name */}}
{{- define "nms.core.name" -}}
{{ .Values.core.name | default "core" }}
{{- end -}}

{{/* Helper to return Core http container bind address */}}
{{- define "nms.core.httpAddress" -}}
0.0.0.0:{{ template "nms.core.httpPort" . }}
{{- end -}}

{{/* Helper to return core http port */}}
{{- define "nms.core.httpPort" -}}
{{ .Values.core.container.port.http | default 8033 }}
{{- end -}}

{{/* Helper to return Core grpc container bind address */}}
{{- define "nms.core.grpcAddress" -}}
0.0.0.0:{{ template "nms.core.grpcPort" . }}
{{- end -}}

{{/* Helper to return core grpc port */}}
{{- define "nms.core.grpcPort" -}}
{{ .Values.core.container.port.grpc | default 8038 }}
{{- end -}}

{{/* Helper to return secrets driver type */}}
{{- define "nms.secret.driverType" -}}
{{- if or .Values.nmsVault.enabled .Values.externalVault.address -}}
vault
{{- else -}}
local
{{- end }}
{{- end }}

{{/* Helper to return Core dqlite container bind address */}}
{{- define "nms.core.dqliteAddress" -}}
{{ "0.0.0.0" }}:{{ .Values.core.container.port.db | default 7891 }}
{{- end -}}

{{/* Helper to return core http endpoint */}}
{{- define "nms.core.service.http" -}}
{{ template "nms.core.name" . }}:{{ .Values.core.service.httpPort }}
{{- end -}}

{{/* Helper to return core grpc endpoint */}}
{{- define "nms.core.service.grpc" -}}
{{ template "nms.core.name" . }}:{{ .Values.core.service.grpcPort }}
{{- end -}}

{{- define "nms.core.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nms.core.name" . }}
{{- end }}

{{/* Helper to get core storage class for storage provisioning */}}
{{- define "nms.core.storageClass" -}}
{{- if .Values.core.persistence.storageClass }}
{{- if (eq "-" .Values.core.persistence.storageClass) }}
storageClassName: ""
{{- else }}
storageClassName: "{{ .Values.core.persistence.storageClass }}"
{{- end }}
{{- end }}
{{- end }}

{{- define "nms.core.initContainers" -}}
{{- if .Values.core.persistence.enabled }}
- name: change-mount-ownership
  image: busybox
  imagePullPolicy: IfNotPresent
  command: [ '/bin/sh', '-c']
  args: ['chown -R 1000:1000 /var/lib/nms']
  volumeMounts:
  {{- include "nms.core.userVolumeMounts" . | nindent 4}}
{{- end }}
{{- end }}

{{- define "nms.core.userVolumes" -}}
{{- if .Values.core.persistence.enabled }}
{{- range .Values.core.persistence.claims }}
{{- if eq "dqlite" .name }}
- name: dqlite-volume
  persistentVolumeClaim:
    claimName: {{ .existingClaim | default (printf "%s-%s" (include "nms.core.name" $ ) .name) }}
{{- else if eq "secrets" .name }}
- name: secrets-volume
  persistentVolumeClaim:
    claimName: {{ .existingClaim | default (printf "%s-%s" (include "nms.core.name" $ ) .name) }}
{{- end }}
{{- end }}
{{- else }}
- name: dqlite-volume
  emptyDir: {}
- name: secrets-volume
  emptyDir: {}
{{- end -}}
{{- end -}}

{{- define "nms.core.userVolumeMounts" -}}
- name: dqlite-volume
  mountPath: /var/lib/nms/dqlite
- name: secrets-volume
  mountPath: /var/lib/nms/secrets
{{- end -}}

{{- define "nms.core.moduleVolume" -}}
{{- $length := len .Values.global.nmsModules -}}
{{- if ne $length 0 -}}
- name: nms-modules-volume
  projected:
    sources:
    {{- range $k, $v := .Values.global.nmsModules }}
    {{- if $v.enabled }}
    {{- range $kc, $c := $v.configs }}
    {{- if gt (len $c.modules) 0 }}
    - configMap:
        name: {{ $c.configmap }}
        items:
        {{- range $i, $key := $c.modules }}
        - key: {{ $key }}
          path: {{ $key }}
        {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
{{- end -}}
{{- end -}}

{{- define "nms.core.moduleVolumeMounts" -}}
{{- $length := len .Values.global.nmsModules -}}
{{- if ne $length 0 -}}
- name: nms-modules-volume
  mountPath: /var/lib/nms/modules
{{- end -}}
{{- end -}}

{*
   ------ DPM ------
*}

{{/* ENV variables used by nms-dpm */}}
{{- define "nms.dpm.env" -}}
- name: NMS_CORE_ADDRESS
  value: {{ include "nms.core.service.http" . }}
{{- end }}

{{/* Helper to return DPM http container bind address */}}
{{- define "nms.dpm.httpAddress" -}}
0.0.0.0:{{ template "nms.dpm.httpPort" . }}
{{- end -}}

{{/* Helper to return DPM dqlite container bind address */}}
{{- define "nms.dpm.dqliteAddress" -}}
{{ "0.0.0.0" }}:{{ .Values.dpm.container.port.db | default 7890 }}
{{- end -}}

{{/* Helper to return DPM grpc container bind address */}}
{{- define "nms.dpm.grpcAddress" -}}
0.0.0.0:{{ template "nms.dpm.grpcPort" . }}
{{- end -}}

{{/* Helper to return dpm name */}}
{{- define "nms.dpm.name" -}}
{{ .Values.dpm.name | default "dpm" }}
{{- end -}}

{{/* Helper to return NATS streaming service */}}
{{- define "nms.dpm.service.natsStreaming" -}}
nats://{{ template "nms.dpm.name" . }}:{{ template "nms.dpm.natsStreamingPort" . }}
{{- end -}}

{{/* Helper to return NATS streaming port */}}
{{- define "nms.dpm.natsStreamingPort" -}}
{{ .Values.dpm.container.port.nats | default 9100 }}
{{- end -}}

{{/* Helper to return dpm http service */}}
{{- define "nms.dpm.service.http" -}}
{{ template "nms.dpm.name" . }}:{{ template "nms.dpm.httpPort" . }}
{{- end -}}

{{/* Helper to return dpm http port */}}
{{- define "nms.dpm.httpPort" -}}
{{ .Values.dpm.container.port.http | default 8034 }}
{{- end -}}

{{/* Helper to return dpm grpc service */}}
{{- define "nms.dpm.service.grpc" -}}
{{ template "nms.dpm.name" . }}:{{ template "nms.dpm.grpcPort" . }}
{{- end -}}

{{/* Helper to return dpm grpc port */}}
{{- define "nms.dpm.grpcPort" -}}
{{ .Values.dpm.container.port.grpc | default 8036 }}
{{- end -}}

{{- define "nms.dpm.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nms.dpm.name" . }}
{{- end }}

{{/* Helper to get dpm storage class for storage provisioning */}}
{{- define "nms.dpm.storageClass" -}}
{{- if .Values.dpm.persistence.storageClass }}
{{- if (eq "-" .Values.dpm.persistence.storageClass) }}
storageClassName: ""
{{- else }}
storageClassName: "{{ .Values.dpm.persistence.storageClass }}"
{{- end }}
{{- end }}
{{- end }}

{{- define "nms.dpm.initContainers" -}}
{{- if .Values.dpm.persistence.enabled }}
- name: change-mount-ownership
  image: busybox
  imagePullPolicy: IfNotPresent
  command: [ '/bin/sh', '-c']
  args: ['chown -R 1000:1000 /var/lib/nms']
  volumeMounts:
  {{- include "nms.dpm.userVolumeMounts" . | nindent 4}}
{{- end }}
{{- end }}

{{- define "nms.dpm.userVolumes" -}}
{{- if .Values.dpm.persistence.enabled }}
{{- range .Values.dpm.persistence.claims }}
{{- if eq "dqlite" .name }}
- name: dqlite-volume
  persistentVolumeClaim:
    claimName: {{ .existingClaim | default ( printf "%s-%s" (include "nms.dpm.name" $ ) .name ) }}
{{- else if eq "nats-streaming" .name }}
- name: nats-streaming-volume
  persistentVolumeClaim:
    claimName: {{ .existingClaim | default ( printf "%s-%s" (include "nms.dpm.name" $ ) .name ) }}
{{- end -}}
{{- end -}}
{{- else }}
- name: dqlite-volume
  emptyDir: {}
- name: nats-streaming-volume
  emptyDir: {}
{{- end -}}
{{- end -}}

{{- define "nms.dpm.userVolumeMounts" -}}
- name: dqlite-volume
  mountPath: /var/lib/nms/dqlite
- name: nats-streaming-volume
  mountPath: /var/lib/nms/streaming
{{- end -}}

{*
   ------ Ingestion ------
*}

{{/* ENV variables nms-ingestion */}}
{{- define "nms.ingestion.env" -}}
- name: NMS_DPM_NATS_ADDRESS
  value: {{ include "nms.dpm.service.natsStreaming" . }}
{{- end }}

{{/* Helper to return ingestion name */}}
{{- define "nms.ingestion.name" -}}
{{ .Values.ingestion.name | default "ingestion" }}
{{- end -}}

{{/* Helper to return ingestion grpc container bind address */}}
{{- define "nms.ingestion.grpcAddress" -}}
0.0.0.0:{{ template "nms.ingestion.grpcPort" . }}
{{- end -}}

{{/* Helper to return ingestion grpc port */}}
{{- define "nms.ingestion.grpcPort" -}}
{{ .Values.ingestion.container.port.grpc | default 8035 }}
{{- end -}}

{{/* Helper to return ingestion grpc service */}}
{{- define "nms.ingestion.service.grpc" -}}
{{ template "nms.ingestion.name" . }}:{{ template "nms.ingestion.grpcPort" . }}
{{- end -}}

{{- define "nms.ingestion.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nms.ingestion.name" . }}
{{- end }}

{*
   ------ Integrations ------
*}

{{/* ENV variables used by nms-integrations */}}
{{- define "nms.integrations.env" -}}
- name: NMS_DPM_NATS_ADDRESS
  value: {{ include "nms.dpm.service.natsStreaming" . }}
- name: NMS_CORE_ADDRESS
  value: {{ include "nms.core.service.http" . }}
{{- end }}

{{/* Helper to return Integrations http container bind address */}}
{{- define "nms.integrations.httpAddress" -}}
0.0.0.0:{{ template "nms.integrations.httpPort" . }}
{{- end -}}

{{/* Helper to return Integrations dqlite container bind address */}}
{{- define "nms.integrations.dqliteAddress" -}}
{{ "0.0.0.0" }}:{{ .Values.integrations.container.port.db | default 7892 }}
{{- end -}}

{{/* Helper to return integrations name */}}
{{- define "nms.integrations.name" -}}
{{ .Values.integrations.name | default "integrations" }}
{{- end -}}

{{/* Helper to return Integrations http service */}}
{{- define "nms.integrations.service.http" -}}
{{ template "nms.integrations.name" . }}:{{ template "nms.integrations.httpPort" . }}
{{- end -}}

{{/* Helper to return Integrations http port */}}
{{- define "nms.integrations.httpPort" -}}
{{ .Values.integrations.container.port.http | default 8037 }}
{{- end -}}

{{- define "nms.integrations.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nms.integrations.name" . }}
{{- end }}

{{/* Helper to get Integrations storage class for storage provisioning */}}
{{- define "nms.integrations.storageClass" -}}
{{- if .Values.integrations.persistence.storageClass }}
{{- if (eq "-" .Values.integrations.persistence.storageClass) }}
storageClassName: ""
{{- else }}
storageClassName: "{{ .Values.integrations.persistence.storageClass }}"
{{- end }}
{{- end }}
{{- end }}

{{- define "nms.integrations.initContainers" -}}
{{- if .Values.integrations.persistence.enabled }}
- name: change-mount-ownership
  image: busybox
  imagePullPolicy: IfNotPresent
  command: [ '/bin/sh', '-c']
  args: ['chown -R 1000:1000 /var/lib/nms']
  volumeMounts:
  {{- include "nms.integrations.userVolumeMounts" . | nindent 4}}
{{- end }}
{{- end }}

{{- define "nms.integrations.userVolumes" -}}
{{- if .Values.integrations.persistence.enabled }}
{{- range .Values.integrations.persistence.claims }}
{{- if eq "dqlite" .name }}
- name: dqlite-volume
  persistentVolumeClaim:
    claimName: {{ .existingClaim | default ( printf "%s-%s" (include "nms.integrations.name" $ ) .name ) }}
{{- end -}}
{{- end -}}
{{- else }}
- name: dqlite-volume
  emptyDir: {}
{{- end -}}
{{- end -}}

{{- define "nms.integrations.userVolumeMounts" -}}
- name: dqlite-volume
  mountPath: /var/lib/nms/dqlite
{{- end -}}

{*
   ------ Utility ------
*}

{{/* ENV variables */}}
{{- define "nms.utility.env" -}}
{{- end }}

{{/* Helper to return utility name */}}
{{- define "nms.utility.name" -}}
{{ .Values.utility.name | default "utility" }}
{{- end -}}

{{- define "nms.utility.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nms.utility.name" . }}
{{- end }}

{{- define "nms.utility.userVolumes" -}}
{{- if .Values.core.persistence.enabled }}
- name: core-dqlite-volume
  persistentVolumeClaim:
    claimName: {{ template "nms.core.name" . }}-dqlite
- name: secrets-volume
  persistentVolumeClaim:
    claimName: {{ template "nms.core.name" . }}-secrets
{{- end }}
{{- if .Values.dpm.persistence.enabled }}
- name: dpm-dqlite-volume
  persistentVolumeClaim:
    claimName: {{ template "nms.dpm.name" . }}-dqlite
{{- end }}
{{- if .Values.integrations.persistence.enabled }}
- name: integrations-dqlite-volume
  persistentVolumeClaim:
    claimName: {{ template "nms.integrations.name" . }}-dqlite
{{- end }}
{{- range $k, $v := $.Values.global.nmsModules }}
{{- if $v.enabled }}
{{- if $v.addClaimsToUtility }}
{{- if eq "nms-adm" $k }}
- name: adm-sqlite-volume
  persistentVolumeClaim:
    claimName: adm-sqlite
{{- else if eq "nms-acm" $k }}
- name: acm-dqlite-volume
  persistentVolumeClaim:
    claimName: acm-dqlite
{{- end }}
- name: {{ $k }}-conf-volume
  configMap:
    defaultMode: 0644
    name: {{ $k }}-conf
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "nms.utility.userVolumeMounts" -}}
{{- if .Values.core.persistence.enabled }}
- name: core-dqlite-volume
  mountPath: /var/lib/nms/dqlite/core
- name: secrets-volume
  mountPath: /var/lib/nms/secrets
{{- end }}
{{- if .Values.dpm.persistence.enabled }}
- name: dpm-dqlite-volume
  mountPath: /var/lib/nms/dqlite/dpm
{{- end }}
{{- if .Values.integrations.persistence.enabled }}
- name: integrations-dqlite-volume
  mountPath: /var/lib/nms/dqlite/integrations
{{- end }}
{{- range $k, $v := $.Values.global.nmsModules }}
{{- if $v.enabled }}
{{- if $v.addClaimsToUtility }}
{{- if eq "nms-adm" $k }}
- name: adm-sqlite-volume
  mountPath: /var/lib/nms/sqlite/adm
- name: {{ $k }}-conf-volume
  mountPath: /etc/nms/modules/adm/adm.yaml
  subPath: adm.yaml
{{- else if eq "nms-acm" $k }}
- name: acm-dqlite-volume
  mountPath: /var/lib/nms/dqlite/acm
- name: {{ $k }}-conf-volume
  mountPath: /etc/nms/acm.conf
  subPath: acm.conf
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}