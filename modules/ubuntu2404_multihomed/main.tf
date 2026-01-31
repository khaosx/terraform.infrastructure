terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

locals {
  extra_networks = [
    {
      id         = 1
      bridge     = var.bridge1
      macaddr    = var.mac_address1
      ip_address = var.ip_address1
    },
    {
      id         = 2
      bridge     = var.bridge2
      macaddr    = var.mac_address2
      ip_address = var.ip_address2
    },
    {
      id         = 3
      bridge     = var.bridge3
      macaddr    = var.mac_address3
      ip_address = var.ip_address3
    },
  ]

  enabled_extra_networks = [
    for net in local.extra_networks : net
    if net.bridge != "" && net.ip_address != ""
  ]
}

resource "proxmox_vm_qemu" "vm" {
  # --- Basic VM Info ---
  vmid        = var.vmid
  name        = var.name
  target_node = var.target_node
  agent       = 1

  hastate = var.ha_state
  hagroup = var.ha_group_name

  # --- Resources ---
  memory = var.memory

  cpu {
    cores = var.cores
    type  = "host"
  }

  # --- Boot & Hardware Details ---
  # Explicitly set the boot order to use the OS disk first.
  boot               = "order=scsi0;net0"
  clone_id           = var.clone_id
  full_clone         = true
  bios               = "ovmf"
  machine            = "q35"
  os_type            = "cloud-init"
  scsihw             = "virtio-scsi-pci"
  vm_state           = "running"
  automatic_reboot   = true
  start_at_node_boot = true
  pool               = var.pool
  tags               = var.tags

  # --- Cloud-Init Configuration ---
  cicustom     = "vendor=ceph_isos_templates:snippets/ubuntu_2404_cloud.yml"
  ciupgrade    = true
  nameserver   = var.nameserver
  searchdomain = var.searchdomain

  ipconfig0 = "ip=${can(regex("/", var.ip_address)) ? var.ip_address : "${var.ip_address}/24"},gw=${var.gateway},ip6=dhcp"
  ipconfig1 = var.bridge1 != "" && var.ip_address1 != "" ? "ip=${can(regex("/", var.ip_address1)) ? var.ip_address1 : "${var.ip_address1}/24"}" : null
  ipconfig2 = var.bridge2 != "" && var.ip_address2 != "" ? "ip=${can(regex("/", var.ip_address2)) ? var.ip_address2 : "${var.ip_address2}/24"}" : null
  ipconfig3 = var.bridge3 != "" && var.ip_address3 != "" ? "ip=${can(regex("/", var.ip_address3)) ? var.ip_address3 : "${var.ip_address3}/24"}" : null

  skip_ipv6  = true
  ciuser     = var.ci_user
  cipassword = var.ci_password
  sshkeys    = var.ssh_keys

  vga {
    type = "std"
  }

  # --- Storage ---
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "ceph_rbd_data"
          size    = var.disk_size
        }
      }
      scsi1 {
        cloudinit {
          storage = "ceph_rbd_data"
        }
      }
    }
  }

  # efidisk {
  #   storage = "ceph_rbd_data"
  #   efitype = "4m"
  # }

  # --- Network ---
  network {
    id      = 0
    bridge  = var.bridge
    model   = "virtio"
    macaddr = var.mac_address
  }

  dynamic "network" {
    for_each = local.enabled_extra_networks
    content {
      id      = network.value.id
      bridge  = network.value.bridge
      model   = "virtio"
      macaddr = network.value.macaddr
    }
  }

  lifecycle {
    ignore_changes = [
      startup_shutdown,
      target_node,
      hastate,
      hagroup,
    ]
  }
}
