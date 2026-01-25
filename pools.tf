# Proxmox Pools Configuration
# This file defines the Proxmox pools for different backup strategies.

resource "proxmox_pool" "gold" {
  poolid  = "Gold-Systems"
  comment = "Gold: Hourly Backups"
}

resource "proxmox_pool" "silver" {
  poolid  = "Silver-Systems"
  comment = "Silver: Daily Backups"
}

resource "proxmox_pool" "bronze" {
  poolid  = "Bronze-Systems"
  comment = "Bronze: Weekly Backups"
}
