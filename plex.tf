module "plex" {
  source   = "./modules/ubuntu2404_vm_gpu_passthrough"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2090
  name               = "plex"
  target_node        = "proxmox-03"
  tags               = "apps,plex,mediaops"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 8192
  cores     = 8
  disk_size = "64G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.90"
  mac_address = "BC:24:11:20:00:5A"
  gateway     = "10.0.20.1"
  nameserver  = "10.0.10.1"

  # Cloud-init and SSH configuration
  searchdomain = var.searchdomain
  ci_user      = var.ci_user
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys

  # Backup configuration
  pool = "Bronze-Systems"
}
