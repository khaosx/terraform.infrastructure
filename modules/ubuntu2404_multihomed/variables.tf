# modules/ubuntu2404_multihomed/variables.tf

# --- Resource Location ---
variable "target_node" { type = string }
variable "pool" {
  description = "Proxmox resource pool (Gold-Systems, Silver-Systems, Bronze-Systems)"
  type        = string
  default     = "Silver-Systems"

  validation {
    condition     = contains(["Gold-Systems", "Silver-Systems", "Bronze-Systems"], var.pool)
    error_message = "pool must be one of: Gold-Systems, Silver-Systems, Bronze-Systems."
  }
}

variable "start_at_node_boot" {
  description = "Whether to start the VM when the Proxmox node boots"
  type        = bool
  default     = true
}

# --- VM Identity ---
variable "vmid" { type = number }
variable "name" { type = string }
variable "tags" {
  type    = string
  default = "terraform,ubuntu,24.04"
}

# --- Template & Boot ---
variable "clone_id" {
  description = "VMID of the source template"
  type        = number
  default     = 9901
}

# --- Hardware Resources ---
variable "memory" { default = 4096 }
variable "cores" { default = 1 }
variable "disk_size" { default = "16G" }

# --- Network Config ---
variable "bridge" { default = "vmbr20" }
variable "ip_address" {
  description = "IP or CIDR"

  validation {
    condition     = can(cidrhost(strcontains(var.ip_address, "/") ? var.ip_address : "${var.ip_address}/32", 0))
    error_message = "ip_address must be a valid IPv4/IPv6 address or CIDR."
  }
}
variable "gateway" {
  default = "10.0.20.1"

  validation {
    condition     = can(cidrhost("${var.gateway}/32", 0))
    error_message = "gateway must be a valid IPv4 address."
  }
}
variable "mac_address" { default = "" }
variable "bridge1" { default = "" }
variable "ip_address1" {
  default = ""

  validation {
    condition     = var.ip_address1 == "" || can(cidrhost(strcontains(var.ip_address1, "/") ? var.ip_address1 : "${var.ip_address1}/32", 0))
    error_message = "ip_address1 must be empty or a valid IPv4/IPv6 address or CIDR."
  }
}
variable "mac_address1" { default = "" }
variable "bridge2" { default = "" }
variable "ip_address2" {
  default = ""

  validation {
    condition     = var.ip_address2 == "" || can(cidrhost(strcontains(var.ip_address2, "/") ? var.ip_address2 : "${var.ip_address2}/32", 0))
    error_message = "ip_address2 must be empty or a valid IPv4/IPv6 address or CIDR."
  }
}
variable "mac_address2" { default = "" }
variable "bridge3" { default = "" }
variable "ip_address3" {
  default = ""

  validation {
    condition     = var.ip_address3 == "" || can(cidrhost(strcontains(var.ip_address3, "/") ? var.ip_address3 : "${var.ip_address3}/32", 0))
    error_message = "ip_address3 must be empty or a valid IPv4/IPv6 address or CIDR."
  }
}
variable "mac_address3" { default = "" }

# --- Cloud-Init & DNS ---
variable "nameserver" {
  description = "DNS Servers (comma separated)"
  type        = string
  default     = "10.0.10.1"
}
variable "searchdomain" {
  description = "DNS search domain"
  type        = string
}

# --- Secrets ---
variable "ci_user" { default = "jarvis" }
variable "ci_password" { sensitive = true }
variable "ssh_keys" {}

variable "ha_state" {
  description = "The requested HA state (started, stopped, enabled, disabled)"
  type        = string
  default     = null # Default to null so it doesn't force HA on every VM

  validation {
    condition     = var.ha_state == null || contains(["started", "stopped", "enabled", "disabled"], var.ha_state)
    error_message = "ha_state must be null or one of: started, stopped, enabled, disabled."
  }
}

variable "ha_group_name" {
  description = "The HA group identifier"
  type        = string
  default     = null
}
