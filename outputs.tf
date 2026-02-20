# DNS Servers
output "dns_01" {
  description = "dns-01 VM details"
  value = {
    vmid       = module.dns-01.vmid
    name       = module.dns-01.name
    ip_address = module.dns-01.ip_address
  }
}

output "dns_02" {
  description = "dns-02 VM details"
  value = {
    vmid       = module.dns-02.vmid
    name       = module.dns-02.name
    ip_address = module.dns-02.ip_address
  }
}

# PiHole Servers
output "pihole_01" {
  description = "pihole-01 VM details"
  value = {
    vmid       = module.pihole-01.vmid
    name       = module.pihole-01.name
    ip_address = module.pihole-01.ip_address
  }
}

output "pihole_02" {
  description = "pihole-02 VM details"
  value = {
    vmid       = module.pihole-02.vmid
    name       = module.pihole-02.name
    ip_address = module.pihole-02.ip_address
  }
}

# Application VMs
output "paperless_01" {
  description = "paperless-01 VM details"
  value = {
    vmid       = module.paperless-01.vmid
    name       = module.paperless-01.name
    ip_address = module.paperless-01.ip_address
  }
}

output "concierge" {
  description = "concierge VM details"
  value = {
    vmid       = module.concierge.vmid
    name       = module.concierge.name
    ip_address = module.concierge.ip_address
  }
}
