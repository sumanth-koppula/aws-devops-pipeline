{{/*
Expand the name of the chart.
*/}}
{{- define "nodejs-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "nodejs-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nodejs-app.labels" -}}
helm.sh/chart:                {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name:       {{ include "nodejs-app.name" . }}
app.kubernetes.io/instance:   {{ .Release.Name }}
app.kubernetes.io/version:    {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nodejs-app.selectorLabels" -}}
app.kubernetes.io/name:     {{ include "nodejs-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}