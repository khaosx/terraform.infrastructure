resource "proxmox_vm_qemu" "control_plane" {
  count       = 3
  name        = "ctrl-0${count.index + 1}"
  vmid        = 2081 + count.index
  target_node = var.proxmox_nodes[count.index]
  pool        = "Gold-Systems"

  bios    = "ovmf"
  machine = "q35"
  boot    = "order=virtio0"
  os_type = "l26"

  memory = 4096
  agent  = 1

  cpu {
    cores = 4
    type  = "host"
  }

  disk {
    slot    = "virtio0"
    size    = "50G"
    type    = "disk"
    storage = "ceph_rbd_data"
  }

  disk {
    slot = "ide2"
    type = "cdrom"
    iso  = "local:iso/talos-metal-amd64.iso"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      disk[1].iso,
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "worker" {
  count       = 3
  name        = "work-0${count.index + 1}"
  vmid        = 2084 + count.index
  target_node = var.proxmox_nodes[count.index]
  pool        = "Gold-Systems"

  bios    = "ovmf"
  machine = "q35"
  boot    = "order=virtio0"
  os_type = "l26"

  memory = 16384
  agent  = 1

  cpu {
    cores = 8
    type  = "host"
  }

  disk {
    slot    = "virtio0"
    size    = "100G"
    type    = "disk"
    storage = "ceph_rbd_data"
  }

  disk {
    slot = "ide2"
    type = "cdrom"
    iso  = "local:iso/talos-metal-amd64.iso"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      disk[1].iso,
      network,
    ]
  }
}
