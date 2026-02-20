resource "talos_machine_secrets" "cluster" {}

data "talos_machine_configuration" "control_plane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_vip}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.cluster.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_vip}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.cluster.machine_secrets
}

resource "talos_machine_configuration_apply" "control_plane" {
  count                       = 3
  client_configuration        = talos_machine_secrets.cluster.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = var.control_plane_ips[count.index]

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = "ctrl-0${count.index + 1}"
          interfaces = [{
            interface = "eth0"
            addresses = ["${var.control_plane_ips[count.index]}/24"]
            routes = [{
              network = "0.0.0.0/0"
              gateway = var.gateway
            }]
            vip = {
              ip = var.cluster_vip
            }
          }]
        }
        install = {
          disk = "/dev/vda"
        }
      }
    })
  ]

  depends_on = [proxmox_vm_qemu.control_plane]
}

resource "talos_machine_configuration_apply" "worker" {
  count                       = 3
  client_configuration        = talos_machine_secrets.cluster.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = var.worker_ips[count.index]

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = "work-0${count.index + 1}"
          interfaces = [{
            interface = "eth0"
            addresses = ["${var.worker_ips[count.index]}/24"]
            routes = [{
              network = "0.0.0.0/0"
              gateway = var.gateway
            }]
          }]
        }
        install = {
          disk = "/dev/vda"
        }
      }
    })
  ]

  depends_on = [proxmox_vm_qemu.worker]
}

resource "talos_machine_bootstrap" "bootstrap" {
  client_configuration = talos_machine_secrets.cluster.client_configuration
  node                 = var.control_plane_ips[0]

  depends_on = [talos_machine_configuration_apply.control_plane]
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  client_configuration = talos_machine_secrets.cluster.client_configuration
  node                 = var.control_plane_ips[0]

  depends_on = [talos_machine_bootstrap.bootstrap]
}
