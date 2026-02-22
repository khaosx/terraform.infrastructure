# Terraform Variables Template
# This file uses 1Password secret references
# Run: op inject -i terraform.tfvars.tpl -o terraform.tfvars

# Proxmox API Configuration
proxmox_api_url          = "{{ op://khaosx-infrastructure/Proxmox API Token - Terraform/proxmox_api_url }}"
proxmox_api_token_id     = "{{ op://khaosx-infrastructure/Proxmox API Token - Terraform/proxmox_api_token_id }}"
proxmox_api_token_secret = "{{ op://khaosx-infrastructure/Proxmox API Token - Terraform/proxmox_api_token_secret }}"
proxmox_tls_insecure     = false

# Cloud-init Configuration
ci_user     = "{{ op://khaosx-infrastructure/Admin User/username }}"
ci_password = "{{ op://khaosx-infrastructure/Admin User/password }}"

# SSH Public Key for VM Access
ssh_keys = "{{ op://khaosx-infrastructure/Admin User/ssh public key }}"

# DNS Configuration
searchdomain = "khaosx.io"

# Proxmox nodes used for distribution (one node per index 0..2)
proxmox_nodes = [
  "proxmox-01",
  "proxmox-02",
  "proxmox-03",
]

# control-plane VIP
cluster_vip = "10.0.20.246"

# control-plane node addresses
control_plane_ips = [
  "10.0.20.81",
  "10.0.20.82",
  "10.0.20.83",
]

# worker node addresses
worker_ips = [
  "10.0.20.84",
  "10.0.20.85",
  "10.0.20.86",
]

# default gateway
gateway = "10.0.20.1"