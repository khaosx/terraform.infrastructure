# Terraform Variables Template
# This file uses 1Password secret references
# Run: op inject -i terraform.tfvars.tpl -o terraform.tfvars

# Proxmox API Configuration
proxmox_api_url          = "{{ op://HomeLab/Terraform Proxmox Infrastructure/proxmox_api_url }}"
proxmox_api_token_id     = "{{ op://HomeLab/Terraform Proxmox Infrastructure/proxmox_api_token_id }}"
proxmox_api_token_secret = "{{ op://HomeLab/Terraform Proxmox Infrastructure/proxmox_api_token_secret }}"
proxmox_tls_insecure     = {{ op://HomeLab/Terraform Proxmox Infrastructure/proxmox_tls_insecure }}

# Cloud-init Configuration
ci_user     = "{{ op://HomeLab/Terraform Proxmox Infrastructure/ci_user }}"
ci_password = "{{ op://HomeLab/Terraform Proxmox Infrastructure/ci_password }}"

# SSH Public Key for VM Access
ssh_keys = "{{ op://HomeLab/Terraform Proxmox Infrastructure/ssh_keys }}"

# DNS Configuration
searchdomain = "{{ op://HomeLab/Terraform Proxmox Infrastructure/searchdomain }}"
