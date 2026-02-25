locals {
  pihole_target_nodes = ["proxmox-02", "proxmox-03"]

  pihole_nodes = {
    for i in range(2) : format("pihole-%02d", i + 1) => {
      vmid        = 1005 + i
      target_node = local.pihole_target_nodes[i]
      ip_address  = "10.0.10.${5 + i}"
      mac_address = format("BC:24:11:10:00:%02X", 5 + i)
    }
  }
}

# ── Pi-hole Nodes ─────────────────────────────────────────────────────────────

module "pihole" {
  source   = "./modules/ubuntu2404_vm"
  for_each = local.pihole_nodes
  clone_id = 9910

  vmid               = each.value.vmid
  name               = each.key
  target_node        = each.value.target_node
  tags               = "infrastructure,pihole,dns"
  start_at_node_boot = true

  memory    = 2048
  cores     = 1
  disk_size = "32G"

  bridge      = "vmbr0"
  ip_address  = each.value.ip_address
  mac_address = each.value.mac_address
  gateway     = "10.0.10.1"
  nameserver  = "10.0.10.1"

  searchdomain = var.searchdomain
  ci_user      = var.ci_user
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys

  ha_state      = "started"
  ha_group_name = "critical-infra"

  pool = "Bronze-Systems"
}

