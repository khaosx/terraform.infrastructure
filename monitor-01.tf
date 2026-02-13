module "monitor-01" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2091
  name               = "monitor-01"
  target_node        = "proxmox-03"
  tags               = "infra,monitoring,observability"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 32768
  cores     = 8
  disk_size = "1024G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.91"
  mac_address = "BC:24:11:20:00:5B"
  gateway     = "10.0.20.1"
  nameserver  = "10.0.10.1"

  # Cloud-init and SSH configuration
  searchdomain = var.searchdomain
  ci_user      = var.ci_user
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys

  # Backup configuration
  pool = "Silver-Systems"
}
