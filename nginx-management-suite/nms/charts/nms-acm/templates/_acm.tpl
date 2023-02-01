{{/*
Expand the name of the chart.
*/}}
{{- define "acm.name" -}}
{{ .Values.acm.name | default "acm" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "acm.fullname" -}}
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
{{- define "acm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}

{{- define "acm.labels" -}}
helm.sh/chart: {{ include "acm.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "acm.serviceAccountName" -}}
{{ template "nms.serviceAccountName" index .Subcharts "nms-hybrid" }}
{{- end -}}


{*
   ------ ACM configs and secrets ------
*}

{{/* 
Helper to return acm cert secret name 
See https://helm.sh/docs/chart_template_guide/function_list/#index for how to use index,
  needed as subchart has `-` in name
*/}}
{{- define "acm.secret.internal-certs.name" -}}
{{ .Release.Name }}-internal-certs
{{- end -}}

{{/* Helper to return acm.conf name */}}
{{- define "acm.config.name" -}}
nms-acm-conf
{{- end -}}

{{/* Helper to return acm-upstream name */}}
{{- define "acm.upstream.name" -}}
{{ template "acm.fullname" . }}-upstream
{{- end -}}

{{/* Helper to return acm-module name */}}
{{- define "acm.module.name" -}}
{{ template "acm.fullname" . }}-module
{{- end -}}

{*
   ------ ACM ------
*}

{{/* Helper to return acm log level */}}
{{- define "acm.logLevel" -}}
{{ .Values.acm.logLevel | default "info" }}
{{- end -}}

{{/* ENV variables */}}
{{- define "acm.env" -}}
- name: SSL_CERT_DIR
  value: "/etc/ssl/certs/"
{{- end }}

{{/* Helper to return acm http container bind address */}}
{{- define "acm.httpAddress" -}}
0.0.0.0:{{ template "acm.containerHttpPort" . }}
{{- end -}}

{{/* Helper to return acm http port */}}
{{- define "acm.containerHttpPort" -}}
{{ .Values.acm.container.port.http | default 8037 }}
{{- end -}}

{{/* Helper to return acm http port */}}
{{- define "acm.serviceHttpPort" -}}
{{ .Values.acm.service.httpPort | default 8037 }}
{{- end -}}

{*
   ------ NMS ------
*}

{{/* Helper to return core address */}}
{{- define "acm.core.address" -}}
{{ template "acm.core.host" . }}:{{ .Values.acm.nms.corePort | default 8033 }}
{{- end -}}

{{/* Helper to return dpm address */}}
{{- define "acm.dpm.address" -}}
{{ template "acm.dpm.host" . }}:{{ .Values.acm.nms.dpmPort | default 8034 }}
{{- end -}}

{{/* Helper to return nats address */}}
{{- define "acm.nats.address" -}}
nats://{{ template "acm.dpm.host" . }}:{{ .Values.acm.nms.natsPort | default 9100 }}
{{- end -}}

{{- define "acm.core.host" -}}
core.{{ .Release.Namespace }}.svc
{{- end -}}
{{- define "acm.dpm.host" -}}
dpm.{{ .Release.Namespace }}.svc
{{- end -}}

{{/* Helper to return acm dqlite container bind address */}}
{{- define "acm.dqliteAddress" -}}
{{ "0.0.0.0" }}:{{ .Values.acm.container.port.db | default 7891 }}
{{- end -}}

{{/* Helper to return acm http endpoint */}}
{{- define "acm.service.http" -}}
{{ template "acm.name" . }}:{{ .Values.acm.service.httpPort }}
{{- end -}}

{{- define "acm.selectorLabels" -}}
app.kubernetes.io/name: {{ template "acm.name" . }}
{{- end }}

{{/* Helper to get acm storage class for storage provisioning */}}
{{- define "acm.storageClass" -}}
{{- if .Values.acm.persistence.storageClass }}
{{- if (eq "-" .Values.acm.persistence.storageClass) }}
storageClassName: ""
{{- else }}
storageClassName: "{{ .Values.acm.persistence.storageClass }}"
{{- end }}
{{- end }}
{{- end }}

{{- define "acm.initContainers" -}}
{{- if .Values.acm.persistence.enabled }}
- name: change-mount-ownership
  image: busybox
  command: [ '/bin/sh', '-c']
  args: ['chown -R 1000:1000 /var/lib/nms']
  volumeMounts:
  {{- include "acm.userVolumeMounts" . | nindent 4}}
{{- end }}
- name: wait-for-nms-core
  image: busybox
  command: ['sh', '-c', 'until nc -vz {{ template "acm.core.host" . }} {{ .Values.acm.nms.corePort | default 8033 }}; do echo "Waiting for nms core at {{ template "acm.core.host" . }}:{{ .Values.acm.nms.corePort | default 8033 }}..."; sleep 3; done;']
- name: wait-for-nms-dpm
  image: busybox
  command: ['sh', '-c', 'until nc -vz {{ template "acm.dpm.host" . }} {{ .Values.acm.nms.dpmPort | default 8034 }}; do echo "Waiting for nms dpm at {{ template "acm.dpm.host" . }}:{{ .Values.acm.nms.dpmPort | default 8034 }}..."; sleep 3; done;']
{{- end }}

{{- define "acm.userVolumes" -}}
{{- if .Values.acm.persistence.enabled }}
{{- range .Values.acm.persistence.claims }}
{{- if eq "dqlite" .name }}
- name: dqlite-volume
  persistentVolumeClaim:
    claimName: {{ .existingClaim | default (printf "%s-%s" (include "acm.name" $ ) .name) }}
{{- end }}
{{- end }}
{{- else }}
- name: dqlite-volume
  emptyDir: {}
{{- end -}}
{{ if and .Values.acm.devportal.client.caSecret.name .Values.acm.devportal.client.caSecret.key }}
- name: acm-devportal-ca-cert
  secret:
    secretName: {{ .Values.acm.devportal.client.caSecret.name }}
    defaultMode: 0644
{{- end -}}
{{- end -}}

{{- define "acm.userVolumeMounts" -}}
- name: dqlite-volume
  mountPath: /var/lib/nms/dqlite
{{ if and .Values.acm.devportal.client.caSecret.name .Values.acm.devportal.client.caSecret.key }}
- name: acm-devportal-ca-cert
  mountPath: "/etc/ssl/certs/{{ .Values.acm.devportal.client.caSecret.key }}"
  subPath: "{{ .Values.acm.devportal.client.caSecret.key }}"
{{- end -}}
{{- end -}}

{{- define "acm.livenessProbe" -}}
livenessProbe:
  httpGet:
    path: /healthz
    port: http
    scheme: HTTPS
  initialDelaySeconds: 10
  failureThreshold: 2
  periodSeconds: 10
{{- end -}}