# Terraform Backend Configuration Template
# This file uses 1Password secret references
# Run: op inject -i backend.hcl.tpl -o backend.hcl

bucket       = "{{ op://HomeLab/Terraform Proxmox Infrastructure/s3_bucket }}"
key          = "{{ op://HomeLab/Terraform Proxmox Infrastructure/s3_key }}"
region       = "{{ op://HomeLab/Terraform Proxmox Infrastructure/s3_region }}"
use_lockfile = true
encrypt      = true
