output "vmid" {
  description = "Proxmox VM ID"
  value       = proxmox_vm_qemu.vm.vmid
}

output "name" {
  description = "VM name"
  value       = proxmox_vm_qemu.vm.name
}

output "ip_address" {
  description = "Primary IP address"
  value       = var.ip_address
}
