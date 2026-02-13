module "concierge" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2089
  name               = "concierge"
  target_node        = "proxmox-02"
  tags               = "apps,concierge,notifications"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 4096
  cores     = 2
  disk_size = "32G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.89"
  mac_address = "BC:24:11:20:00:59"
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
