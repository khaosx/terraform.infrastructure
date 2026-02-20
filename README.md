# Terraform Infrastructure

Terraform configuration for managing Proxmox virtual infrastructure, including DNS servers and PiHole instances across a 3-node cluster.

## Overview

This repository provisions and manages:
- **DNS Servers** (dns-01, dns-02) - Multi-homed Ubuntu 24.04 VMs for DNS resolution
- **PiHole Servers** (pihole-01, pihole-02) - Single-homed Ubuntu 24.04 VMs for DNS filtering
- **Paperless VM** (paperless-01) - Single-homed Ubuntu 24.04 VM for document management
- **Concierge VM** (concierge) - Single-homed Ubuntu 24.04 VM for interface and notification services
- **Resource Pools** - Backup tier management (Gold/Silver/Bronze)

Production VMs are configured with High Availability and distributed across the Proxmox cluster nodes.

## Architecture

```
┌────────────────────────────────────────────────────────┐
│                     Proxmox Cluster                    │
├──────────────┬──────────────────────────┬──────────────┤
│  proxmox-01  │       proxmox-02         │  proxmox-03  │
│              │                          │              │
│  (no VMs)    │  dns-02                  │  dns-01      │
│              │  pihole-01               │  pihole-02   │
│              │  paperless-01            │              │
│              │  concierge               │              │
└──────────────┴──────────────────────────┴──────────────┘
                            │
                            ▼
                  ┌─────────────────┐
                  │   Ceph Storage  │
                  │  (ceph_rbd_data)│
                  └─────────────────┘
```

## Prerequisites

- Terraform >= 1.0
- [1Password CLI](https://developer.1password.com/docs/cli/) with desktop app integration
- Access to Proxmox API
- AWS credentials for S3 state backend
- SSH key pair for VM access

## Project Structure

```
.
├── providers.tf              # Proxmox provider configuration
├── backend.tf                # S3 backend (partial configuration)
├── backend.hcl.tpl           # 1Password backend template
├── variables.tf              # Global variables
├── outputs.tf                # VM ID and IP outputs
├── pools.tf                  # Proxmox resource pools
├── terraform.tfvars.tpl      # 1Password secret template
├── terraform.tfvars.example  # Example variables (safe to commit)
├── dns-01.tf                 # DNS server 1 (proxmox-03, multihomed)
├── dns-02.tf                 # DNS server 2 (proxmox-02, multihomed)
├── pihole-01.tf              # PiHole server 1 (proxmox-02)
├── pihole-02.tf              # PiHole server 2 (proxmox-03)
├── paperless-01.tf           # Document management (proxmox-02)
├── concierge.tf              # Notifications/interface (proxmox-02)
└── modules/
    ├── ubuntu2404_vm/        # Single-homed VM module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ubuntu2404_multihomed/ # Multi-homed VM module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Modules

### ubuntu2404_vm

Creates a single-homed Ubuntu 24.04 VM with one network interface.

| Variable | Description | Default |
|----------|-------------|---------|
| `name` | Name of the VM | - |
| `vmid` | Proxmox VM ID | - |
| `target_node` | Proxmox node to deploy on | - |
| `cores` | Number of CPU cores | `1` |
| `memory` | Memory in MB | `4096` |
| `disk_size` | Disk size (e.g., "16G") | `"16G"` |
| `ip_address` | Static IP with CIDR | - |
| `gateway` | Network gateway | `"10.0.20.1"` |
| `bridge` | Network bridge | `"vmbr20"` |
| `pool` | Resource pool for backups | `"Silver-Systems"` |
| `ha_state` | HA state (started, stopped, enabled, disabled) | `null` |
| `ha_group_name` | HA group name | `null` |

### ubuntu2404_multihomed

Creates a multi-homed Ubuntu 24.04 VM supporting up to 4 network interfaces.

Accepts all variables from `ubuntu2404_vm` plus additional interface fields:

| Variable | Description | Default |
|----------|-------------|---------|
| `bridge1` | Network bridge name (NIC 2) | `""` |
| `ip_address1` | IP address with CIDR (NIC 2) | `""` |
| `mac_address1` | MAC address (NIC 2) | `""` |
| `bridge2` | Network bridge name (NIC 3) | `""` |
| `ip_address2` | IP address with CIDR (NIC 3) | `""` |
| `mac_address2` | MAC address (NIC 3) | `""` |
| `bridge3` | Network bridge name (NIC 4) | `""` |
| `ip_address3` | IP address with CIDR (NIC 4) | `""` |
| `mac_address3` | MAC address (NIC 4) | `""` |

## Configuration

### Secrets Management with 1Password

Secrets are managed via 1Password CLI. The `terraform.tfvars.tpl` template references secrets stored in 1Password using the `op://` URI scheme.

**1Password Vault:** `khaosx-infrastructure`

**1Password Items:**
- `Proxmox API Token - Terraform`
- `Admin User`
- `Terraform Backend Config`

**Required fields:**
| Field | Item | Description |
|-------|------|-------------|
| `proxmox_api_url` | Proxmox API Token - Terraform | Proxmox API endpoint |
| `proxmox_api_token_id` | Proxmox API Token - Terraform | API token ID (e.g., `terraform@pve!token`) |
| `proxmox_api_token_secret` | Proxmox API Token - Terraform | API token secret |
| `ci_user` | Admin User | Cloud-init username |
| `ci_password` | Admin User | Cloud-init password |
| `ssh_keys` | Admin User | Public SSH key for VM access |
| `s3_bucket` | Terraform Backend Config | S3 bucket for Terraform state |
| `s3_region` | Terraform Backend Config | AWS region for S3 bucket |

### Manual Configuration (Alternative)

If not using 1Password, copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

### State Backend

State is stored in AWS S3 using [partial configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration#partial-configuration). The `backend.hcl.tpl` template pulls S3 configuration from 1Password.

## Resource Pools

| Pool | Backup Frequency | Use Case |
|------|------------------|----------|
| Gold-Systems | Hourly | Critical production systems |
| Silver-Systems | Daily | Standard infrastructure |
| Bronze-Systems | Weekly | Non-critical systems |

## VLAN 20 Deterministic Mapping

Use the following mapping for VLAN 20 hosts (x = host number 2..254):

```
IP:    10.0.20.x
MAC:   BC:24:11:20:00:XX  (XX = two-digit hex of x)
VMID:  2000 + x
```

Example: x=88 -> IP 10.0.20.88, MAC BC:24:11:20:00:58, VMID 2088.

## Usage

### Quick Start

```bash
# Generate configs from 1Password
op inject -i backend.hcl.tpl -o backend.hcl
op inject -i terraform.tfvars.tpl -o terraform.tfvars

# Initialize and apply
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### Commands

| Command | Description |
|---------|-------------|
| `op inject -i backend.hcl.tpl -o backend.hcl` | Generate backend config from 1Password |
| `op inject -i terraform.tfvars.tpl -o terraform.tfvars` | Generate variables from 1Password |
| `terraform init -backend-config=backend.hcl` | Initialize with backend config |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy all resources |

## VM Inventory

| Name | VMID | Node | IP | Purpose | HA Group |
|------|------|------|-----|---------|----------|
| dns-01 | 1002 | proxmox-03 | 10.0.10.2 | DNS Server (multihomed) | critical-infra |
| dns-02 | 1003 | proxmox-02 | 10.0.10.3 | DNS Server (multihomed) | critical-infra |
| pihole-01 | 1005 | proxmox-02 | 10.0.10.5 | PiHole DNS Filter | critical-infra |
| pihole-02 | 1006 | proxmox-03 | 10.0.10.6 | PiHole DNS Filter | critical-infra |
| paperless-01 | 2087 | proxmox-02 | 10.0.20.87 | Document management | none |
| concierge | 2089 | proxmox-02 | 10.0.20.89 | Interface/notification host | none |

## Adding a New VM

1. Create a new `.tf` file (e.g., `newvm-01.tf`)
2. Use the appropriate module:

```hcl
module "newvm-01" {
  source = "./modules/ubuntu2404_vm"

  name            = "newvm-01"
  vmid            = 1100
  target_node     = "proxmox-01"
  cores           = 2
  memory          = 4096
  disk_size       = "40G"
  ip_address      = "10.0.10.100/24"
  gateway         = "10.0.10.1"
  bridge          = "vmbr0"
  pool            = "Silver-Systems"
  ha_group_name   = "critical-infra"
  ci_user         = var.ci_user
  ci_password     = var.ci_password
  ssh_keys        = var.ssh_keys
  searchdomain    = var.searchdomain
  nameserver      = var.nameserver
}
```

3. Run `terraform plan` to verify
4. Run `terraform apply` to create
