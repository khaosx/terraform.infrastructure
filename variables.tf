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
  sensitive   = true
}
variable "proxmox_tls_insecure" {
  description = "Skip TLS verification"
  type        = bool
  default     = true
}


# Technitium API credentials
variable "technitium_url_dns01" {
  description = "Technitium DNS-01 server URL (e.g. https://dns-01.example.com:53443)"
  type        = string
}

variable "technitium_token_dns01" {
  description = "Technitium API token for dns-01"
  type        = string
  sensitive   = true
}


variable "technitium_skip_certificate_verification" {
  description = "Skip TLS verification for the Technitium provider"
  type        = bool
  default     = false
}


variable "technitium_dns01_ipv4" {
  description = "IPv4 address for dns-01 A record"
  type        = string
  default     = "10.0.10.2"
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

variable "nameserver" {
  description = "DNS nameserver for all VMs"
  type        = string
  default     = "10.0.10.1"
}
