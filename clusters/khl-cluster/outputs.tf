output "kubeconfig" {
  description = "Kubernetes kubeconfig generated from Talos control plane"
  value       = talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive   = true
}

output "talosconfig" {
  description = "Talos client configuration"
  value       = talos_machine_secrets.cluster.client_configuration
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Talos/Kubernetes control-plane endpoint"
  value       = "https://${var.cluster_vip}:6443"
}

output "control_plane_ips" {
  description = "Control-plane node IPs"
  value       = var.control_plane_ips
}

output "worker_ips" {
  description = "Worker node IPs"
  value       = var.worker_ips
}
