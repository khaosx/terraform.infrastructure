locals {
  ctrl_target_nodes = ["proxmox-03", "proxmox-01", "proxmox-02"]
  work_target_nodes = ["proxmox-02", "proxmox-03", "proxmox-01"]

  control_nodes = {
    for i in range(3) : format("ctrl-%02d", i + 1) => {
      vmid        = 2081 + i
      target_node = local.ctrl_target_nodes[i]
      ip_address  = "10.0.20.${81 + i}"
      mac_address = format("BC:24:11:20:00:%02X", 81 + i)
    }
  }

  worker_nodes = {
    for i in range(3) : format("work-%02d", i + 1) => {
      vmid        = 2084 + i
      target_node = local.work_target_nodes[i]
      ip_address  = "10.0.20.${84 + i}"
      mac_address = format("BC:24:11:20:00:%02X", 84 + i)
    }
  }
}

# ── Control Plane Nodes ───────────────────────────────────────────────────────

module "control_plane" {
  source   = "./modules/ubuntu2404_vm"
  for_each = local.control_nodes
  clone_id = 9910

  vmid               = each.value.vmid
  name               = each.key
  target_node        = each.value.target_node
  tags               = "ubuntu,24.04,k8s,control-plane"
  start_at_node_boot = true

  memory    = 8192
  cores     = 4
  disk_size = "32G"

  bridge      = "vmbr20"
  ip_address  = each.value.ip_address
  mac_address = each.value.mac_address
  gateway     = "10.0.20.1"
  nameserver  = "10.0.10.1"

  searchdomain = var.searchdomain
  ci_user      = var.ci_user
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys

  pool = "Silver-Systems"
}

# ── Worker Nodes ──────────────────────────────────────────────────────────────

module "worker" {
  source   = "./modules/ubuntu2404_vm"
  for_each = local.worker_nodes
  clone_id = 9910

  vmid               = each.value.vmid
  name               = each.key
  target_node        = each.value.target_node
  tags               = "ubuntu,24.04,k8s,worker"
  start_at_node_boot = true

  memory    = 16384
  cores     = 8
  disk_size = "64G"

  bridge      = "vmbr20"
  ip_address  = each.value.ip_address
  mac_address = each.value.mac_address
  gateway     = "10.0.20.1"
  nameserver  = "10.0.10.1"

  searchdomain = var.searchdomain
  ci_user      = var.ci_user
  ci_password  = var.ci_password
  ssh_keys     = var.ssh_keys

  pool = "Silver-Systems"
}

