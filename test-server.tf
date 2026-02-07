module "test-server" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2088
  name               = "test-server"
  target_node        = "proxmox-02"
  tags               = "dev"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 2048
  cores     = 2
  disk_size = "32G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.88"
  mac_address = "BC:24:11:20:00:58"
  gateway     = "10.0.20.1"
  nameserver  = "10.0.10.1"

  # Cloud-init and SSH configuration
  searchdomain = var.searchdomain
  ci_user      = var.ci_user
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys
}
