# khl-cluster (Talos on Proxmox)

This stack creates a 6-node Talos Kubernetes cluster on Proxmox:
- Control plane: `ctrl-01`, `ctrl-02`, `ctrl-03`
- Workers: `work-01`, `work-02`, `work-03`

It is self-contained under `clusters/khl-cluster` and intentionally does not reuse the Ubuntu cloud-init modules.

## What this stack manages

- 6 Proxmox VMs (`proxmox_vm_qemu`) in `Gold-Systems`
- Talos machine secrets (`talos_machine_secrets`)
- Talos machine configs for control plane and workers
- Talos bootstrap + kubeconfig retrieval

## Important safety notes

- Talos machine secrets are stored in Terraform state. Treat state as sensitive and back it up securely.
- Talos does not use SSH for management. Do not plan SSH-based post-provision steps.
- `lifecycle.ignore_changes = [iso, network]` is intentional to prevent Terraform from reattaching ISO/network after Talos installs to disk.

## Prerequisites

1. Terraform installed.
2. Access to Proxmox API token with VM create/manage permissions.
3. Talos ISO downloaded and uploaded to Proxmox ISO storage **before apply**.
4. Confirm networking values before apply:
   - `cluster_vip`
   - `control_plane_ips`
   - `worker_ips`
   - `gateway`

## Talos ISO preparation

Example (adjust version as needed):

```bash
# Download Talos metal ISO
curl -L -o talos-metal-amd64.iso \
  https://github.com/siderolabs/talos/releases/latest/download/metal-amd64.iso

# Upload to Proxmox ISO storage so this path exists:
# local:iso/talos-metal-amd64.iso
# (Use Proxmox UI or pvesm upload workflow)
```

Terraform assumes:
- `iso = "local:iso/talos-metal-amd64.iso"`

## Sensitive variables

Set secrets as environment variables at runtime:

```bash
export TF_VAR_proxmox_api_url="https://proxmox-01.example.com:8006/api2/json"
export TF_VAR_proxmox_api_token_id="terraform@pve!token"
export TF_VAR_proxmox_api_token_secret="REPLACE_ME"
```

Optional:

```bash
export TF_VAR_proxmox_tls_insecure=true
```

## Configure non-sensitive values

Edit `terraform.tfvars`:
- `proxmox_nodes`
- `cluster_name`
- `cluster_vip`
- `control_plane_ips`
- `worker_ips`
- `gateway`

## Deploy

```bash
cd /Users/kris/projects/terraform.infrastructure/clusters/khl-cluster
terraform init
terraform plan
terraform apply
```

## Outputs

- `kubeconfig` (sensitive)
- `talosconfig` (sensitive)
- `cluster_endpoint`
- `control_plane_ips`
- `worker_ips`

Examples:

```bash
terraform output -raw kubeconfig > kubeconfig
terraform output -json talosconfig > talosconfig.json
```

## Post-apply verification

1. Confirm Talos nodes are reachable and healthy (using talosctl with generated talosconfig).
2. Confirm Kubernetes API is available on `https://<cluster_vip>:6443`.
3. Export kubeconfig and verify node status:

```bash
export KUBECONFIG=$PWD/kubeconfig
kubectl get nodes -o wide
```

Expected initially: nodes may be `NotReady` until CNI is installed.

## Cilium install (post-apply, manual)

This stack does **not** install CNI. Install Cilium after cluster bootstrap:

```bash
cilium install
kubectl get nodes
```

Wait for all nodes to reach `Ready`.
