module "paperless-01" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2087
  name               = "paperless-01"
  target_node        = "proxmox-02"
  tags               = "apps,paperless,documents"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 8192
  cores     = 4
  disk_size = "32G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.87"
  mac_address = "BC:24:11:20:00:57"
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
