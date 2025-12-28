# Argo variables

# GitHub Actions Runner
variable "app_gha_runner_version" {
  type        = string
  description = "GitHub Actions Runner Version"
}
variable "gha_runner_github_token" {
  type        = string
  description = "GitHub Token for Actions Runner"
}

# Open WebUI
variable "open_webui_chart_version" {
  type        = string
  description = "Open WebUI Chart Version"
}
