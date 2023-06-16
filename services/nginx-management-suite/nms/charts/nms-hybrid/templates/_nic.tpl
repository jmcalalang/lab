{{/* Helper to return nic nms virtual server name */}}
{{- define "nic.nms.name" -}}
{{ .Values.nic.name | default "nms" }}
{{- end -}}

{{/* Helper to validate nic host name */}}
{{- define "nic.nms.host" -}}
{{ required "A valid .Values.nic.host entry required!" .Values.nic.host }}
{{- end -}}

{{- define "nic.nms.userUpstreams" -}}
{{- if .Values.nic.enabled }}
{{- with .Values.nic.upstreams }}
{{- toYaml . -}}
{{- end -}}
{{- end -}}
{{- end -}}
