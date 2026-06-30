# Variable mappings to ingest parameters dynamically from terraform.tfvars

variable "postgres_username" {
  type      = string
  sensitive = true
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "docker_hub_username" {
  type = string
}

variable "jenkins_api_token" {
  type      = string
  sensitive = true
}

variable "jenkins_webhook_url" {
  type = string
}