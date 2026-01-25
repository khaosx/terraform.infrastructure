# Proxmox API credentials
variable "proxmox_api_url" {
  description = "Proxmox API endpoint (e.g. https://proxmox.example.com:8006/api2/json)"
  type        = string
}
variable "proxmox_api_token_id" {
  description = "Proxmox user (e.g. root@pam)"
  type        = string
}
variable "proxmox_api_token_secret" {
  description = "Proxmox password or API token"
  type        = string
}
variable "proxmox_tls_insecure" {
  description = "Skip TLS verification"
  type        = bool
  default     = true
}

variable "ci_user" {
  description = "Cloud-init user for all VMs"
  default     = "newuser"
}

variable "ci_password" {
  description = "Cloud-init password for all VMs"
  type        = string
  sensitive   = true
}

variable "ssh_keys" {
  description = "Public SSH keys for all VMs"
  type        = string
}

variable "searchdomain" {
  description = "DNS search domain for all VMs"
  type        = string
}