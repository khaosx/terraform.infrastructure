module "dns-01" {
  source   = "./modules/ubuntu2404_multihomed"
  clone_id = 9910

  # Properties for new VM
  vmid               = 1002
  name               = "dns-01"
  target_node        = "proxmox-03"
  tags               = "infrastructure,dns"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 2048
  cores     = 1
  disk_size = "24G"

  # Network configuration
  bridge      = "vmbr0"
  ip_address  = "10.0.10.2"
  mac_address = "BC:24:11:0A:00:02"
  gateway     = "10.0.10.1"
  nameserver  = "10.0.10.1"

  bridge1      = "vmbr20"
  ip_address1  = "10.0.20.2"
  mac_address1 = "BC:24:11:14:00:02"

  bridge2      = "vmbr50"
  ip_address2  = "10.0.50.2"
  mac_address2 = "BC:24:11:32:00:02"

  bridge3      = "vmbr60"
  ip_address3  = "10.0.60.2"
  mac_address3 = "BC:24:11:3C:00:02"

  # Cloud-init and SSH configuration
  searchdomain = var.searchdomain
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys

  # High Availability configuration
  ha_state      = "started"
  ha_group_name = "critical-infra"
}
