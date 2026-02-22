# ── Control Plane Nodes ───────────────────────────────────────────────────────

module "ctrl-01" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2081
  name               = "ctrl-01"
  target_node        = "proxmox-03"
  tags               = "ubuntu,24.04,k8s,control-plane"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 8192
  cores     = 4
  disk_size = "32G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.81"
  mac_address = "BC:24:11:20:00:51"
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

module "ctrl-02" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2082
  name               = "ctrl-02"
  target_node        = "proxmox-01"
  tags               = "ubuntu,24.04,k8s,control-plane"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 8192
  cores     = 4
  disk_size = "32G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.82"
  mac_address = "BC:24:11:20:00:52"
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

module "ctrl-03" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2083
  name               = "ctrl-03"
  target_node        = "proxmox-02"
  tags               = "ubuntu,24.04,k8s,control-plane"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 8192
  cores     = 4
  disk_size = "32G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.83"
  mac_address = "BC:24:11:20:00:53"
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

# ── Worker Nodes ──────────────────────────────────────────────────────────────

module "work-01" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2084
  name               = "work-01"
  target_node        = "proxmox-02"
  tags               = "ubuntu,24.04,k8s,worker"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 16384
  cores     = 8
  disk_size = "64G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.84"
  mac_address = "BC:24:11:20:00:54"
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

module "work-02" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2085
  name               = "work-02"
  target_node        = "proxmox-03"
  tags               = "ubuntu,24.04,k8s,worker"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 16384
  cores     = 8
  disk_size = "64G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.85"
  mac_address = "BC:24:11:20:00:55"
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

module "work-03" {
  source   = "./modules/ubuntu2404_vm"
  clone_id = 9910

  # Properties for new VM
  vmid               = 2086
  name               = "work-03"
  target_node        = "proxmox-01"
  tags               = "ubuntu,24.04,k8s,worker"
  start_at_node_boot = true

  # --- Hardware Resources ---
  memory    = 16384
  cores     = 8
  disk_size = "64G"

  # Network configuration
  bridge      = "vmbr20"
  ip_address  = "10.0.20.86"
  mac_address = "BC:24:11:20:00:56"
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
