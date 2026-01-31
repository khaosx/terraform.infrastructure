module "pihole-01" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 1005
  name               = "pihole-01"
  target_node        = "proxmox-02"
  tags               = "infrastructure,pihole,dns"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 2048
  cores     = 1
  disk_size = "24G"

  # Network configuration
  bridge      = "vmbr0"
  ip_address  = "10.0.10.5"
  mac_address = "BC:24:11:10:00:05"
  gateway     = "10.0.10.1"
  nameserver  = "10.0.10.1"

  # Cloud-init and SSH configuration
  searchdomain = var.searchdomain
  ci_user      = var.ci_user
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys

  # High Availability configuration
  ha_state      = "started"
  ha_group_name = "critical-infra"

  # Backup configuration
  pool = "Bronze-Systems"
}
