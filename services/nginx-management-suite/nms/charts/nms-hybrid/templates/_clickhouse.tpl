{{/* ClickHouse ENV variables and helpers used by NMS */}}
{{- define "nms.clickhouse.env" }}
{{- if .Values.nmsClickhouse.enabled -}}
- name: NMS_CLICKHOUSE_ADDRESS
  value: {{ template "nms.clickhouse.service.tcp" . }}
- name: NMS_CLICKHOUSE_USERNAME
  value: {{ .Values.nmsClickhouse.user | quote }}
- name: NMS_CLICKHOUSE_PASSWORD
  value: {{ .Values.nmsClickhouse.password | quote }}
{{- else -}}
- name: NMS_CLICKHOUSE_ADDRESS
  value: {{ required "externalClickhouse.address is required when nmsClickhouse.enabled is not set" .Values.externalClickhouse.address | quote }}
- name: NMS_CLICKHOUSE_USER
  value: {{ .Values.externalClickhouse.user | default "" }}
- name: NMS_CLICKHOUSE_PASSWORD
  value: {{ .Values.externalClickhouse.password | default "" }}
{{- end }}
{{- end }}

{*
   ------ NMS CLICKHOUSE ------
*}

{{/*
Return clickhouse fullname
*/}}
{{- define "nms.clickhouse.fullname" -}}
{{- if .Values.nmsClickhouse.fullnameOverride -}}
{{- .Values.nmsClickhouse.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" "clickhouse" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}

{{- define "nms.clickhouse.labels" -}}
helm.sh/chart: {{ include "nms.chart" . }}
{{ include "nms.clickhouse.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nms.clickhouse.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nms.clickhouse.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return clickhouse address (k8s clickhouse service:port)
*/}}
{{- define "nms.clickhouse.service.tcp" -}}
tcp://{{ include "nms.clickhouse.fullname" . }}:{{ include "nms.clickhouse.containerPort.rpc" . }}
{{- end -}}

{{/*
Return clickhouse RPC port
*/}}
{{- define "nms.clickhouse.containerPort.rpc" -}}
{{ .Values.nmsClickhouse.service.rpcPort | default 9000 }}
{{- end -}}

{{/* Helper to get clickhouse storage class for storage provisioning */}}
{{- define "nms.clickhouse.storageClass" -}}
{{- if .Values.nmsClickhouse.persistence.storageClass }}
{{- if (eq "-" .Values.nmsClickhouse.persistence.storageClass) }}
storageClassName: ""
{{- else }}
storageClassName: "{{ .Values.nmsClickhouse.persistence.storageClass }}"
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "nms.clickhouse.userVolumes" -}}
- name: nms-clickhouse-volume
{{- if .Values.nmsClickhouse.persistence.enabled }}
  persistentVolumeClaim:
    claimName: {{ .existingClaim | default (include "nms.clickhouse.fullname" . ) }}
{{- else }}
  emptyDir: {}
{{- end -}}
{{- end -}}

{{- define "nms.clickhouse.userVolumeMounts" -}}
{{- if .Values.nmsClickhouse.persistence.enabled }}
- name: nms-clickhouse-volume
  mountPath: /var/lib/clickhouse
{{- end -}}
{{- end -}}