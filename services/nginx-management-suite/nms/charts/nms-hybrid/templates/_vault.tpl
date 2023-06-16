{*
   ------ NMS VAULT ------
*}
{{- define "nms.vault.env" }}
{{- if or .Values.nmsVault.enabled .Values.externalVault.address -}}
- name: NMS_VAULT_TOKEN
  valueFrom:
    secretKeyRef:
      name: vault-access
      key: vault-token
{{- end }}
{{- end }}

{{/*
Return secrets vault address
*/}}
{{- define "nms.secret.vaultAddress" -}}
{{- if or .Values.nmsVault.enabled .Values.externalVault.address -}}
{{ if .Values.nmsVault.enabled }}
address: http://0.0.0.0:{{ .Values.nmsVault.service.rpcPort | default 8200 }}/v1
{{ else }}
address: {{ .Values.externalVault.address }}
{{ end }}
{{- end }}
{{- end }}

{{/*
Return vault fullname
*/}}
{{- define "nms.vault.fullname" -}}
{{- if .Values.nmsVault.fullnameOverride -}}
{{- .Values.nmsVault.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" "vault" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}

{{- define "nms.vault.labels" -}}
helm.sh/chart: {{ include "nms.chart" . }}
{{ include "nms.vault.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nms.vault.selectorLabels" -}}
app.kubernetes.io/name: {{ template "nms.vault.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return vault address (k8s vault service:port)
*/}}
{{- define "nms.vault.service.tcp" -}}
tcp://{{ include "nms.vault.fullname" . }}:{{ include "nms.vault.containerPort.rpc" . }}
{{- end -}}

{{/*
Return vault RPC port
*/}}
{{- define "nms.vault.containerPort.rpc" -}}
{{ .Values.nmsVault.service.rpcPort | default 8200 }}
{{- end -}}

{{/*
Return vault volumes and mounts
*/}}
{{- define "nms.vault.userVolumeMounts" -}}
- name: nms-conf-volume
  mountPath: /etc/nms/nms.conf
  subPath: nms.conf
- name: secrets-volume
  mountPath: /var/lib/nms/secrets
{{- end -}}

{{- define "nms.vault.userVolumes" -}}
{{- if .Values.core.persistence.enabled }}
- name: secrets-volume
  persistentVolumeClaim:
    claimName: {{ .existingClaim | default (printf "%s-%s" (include "nms.core.name" $ ) "secrets") }}
{{- else }}
- name: secrets-volume
  emptyDir: {}
{{- end -}}
{{- end -}}
