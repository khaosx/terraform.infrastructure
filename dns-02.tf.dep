module "dns-02" {
  source   = "./modules/ubuntu2404_multihomed"
  clone_id = 9910

  # Properties for new VM
  vmid               = 1003
  name               = "dns-02"
  target_node        = "proxmox-02"
  tags               = "infrastructure,dns"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 2048
  cores     = 1
  disk_size = "32G"

  # Network configuration
  bridge      = "vmbr0"
  ip_address  = "10.0.10.3"
  mac_address = "BC:24:11:0A:00:03"
  gateway     = "10.0.10.1"
  nameserver  = "10.0.10.1"

  bridge1      = "vmbr20"
  ip_address1  = "10.0.20.3"
  mac_address1 = "BC:24:11:14:00:03"

  bridge2      = "vmbr50"
  ip_address2  = "10.0.50.3"
  mac_address2 = "BC:24:11:32:00:03"

  bridge3      = "vmbr60"
  ip_address3  = "10.0.60.3"
  mac_address3 = "BC:24:11:3C:00:03"

  # Cloud-init and SSH configuration
  searchdomain = var.searchdomain
  ci_user      = var.ci_user
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys

  # High Availability configuration
  ha_state      = "started"
  ha_group_name = "critical-infra"
}
