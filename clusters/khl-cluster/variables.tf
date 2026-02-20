variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API endpoint (e.g. https://proxmox-01.example.com:8006/api2/json)"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API token ID (e.g. terraform@pve!token)"
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "Proxmox API token secret"
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "Skip TLS verification for Proxmox API"
  default     = true
}

variable "proxmox_nodes" {
  type        = list(string)
  description = "Exactly 3 Proxmox nodes, one per control-plane/worker slot"

  validation {
    condition     = length(var.proxmox_nodes) == 3
    error_message = "proxmox_nodes must contain exactly 3 node names."
  }
}

variable "cluster_name" {
  type        = string
  description = "Talos/Kubernetes cluster name"
  default     = "khl-cluster"
}

variable "cluster_vip" {
  type        = string
  description = "Control-plane virtual IP used for cluster endpoint"
}

variable "control_plane_ips" {
  type        = list(string)
  description = "Exactly 3 control-plane node IPs"

  validation {
    condition     = length(var.control_plane_ips) == 3
    error_message = "control_plane_ips must contain exactly 3 IPs."
  }
}

variable "worker_ips" {
  type        = list(string)
  description = "Exactly 3 worker node IPs"

  validation {
    condition     = length(var.worker_ips) == 3
    error_message = "worker_ips must contain exactly 3 IPs."
  }
}

variable "gateway" {
  type        = string
  description = "Default IPv4 gateway for all cluster nodes"
}
