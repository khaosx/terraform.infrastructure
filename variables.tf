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
  default     = false
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
  default     = "k8s-clst-01"
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

variable "storage_pool" {
  type        = string
  description = "Proxmox storage pool for VM disks"
  default     = "ceph_rbd_data"
}
