###############################################################################
# modules/lxc/main.tf — Reusable LXC container module
###############################################################################

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50"
    }
  }
}

variable "container_id"   { type = number }
variable "name"           { type = string }
variable "node"           { type = string }
variable "template"       {
  type = string
  description = "LXC template e.g. local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
}
variable "cores"          {
  type = number
  default = 1
}
variable "memory_mb"      {
  type = number
  default = 512
}
variable "swap_mb"        {
  type = number
  default = 512
}
variable "disk_size_gb"   {
  type = number
  default = 8
}
variable "storage"        { type = string }
variable "ip_address"     { type = string }
variable "gateway"        { type = string }
variable "dns"            { type = string }
variable "vlan_id"        {
  type = number
  default = 30
}
variable "ssh_public_key" { type = string }
variable "unprivileged"   {
  type = bool
  default = true
}
variable "tags"           {
  type = list(string)
  default = []
}
variable "description"    {
  type = string
  default = ""
}

###############################################################################

resource "proxmox_virtual_environment_container" "lxc" {
  vm_id        = var.container_id
  node_name    = var.node
  description  = var.description
  tags         = var.tags
  unprivileged = var.unprivileged
  start_on_boot = true

  operating_system {
    template_file_id = var.template
    type             = "debian"
  }

  cpu { cores = var.cores }

  memory {
    dedicated = var.memory_mb
    swap      = var.swap_mb
  }

  disk {
    datastore_id = var.storage
    size         = var.disk_size_gb
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr0"
    vlan_id = var.vlan_id
  }

  initialization {
    hostname = var.name
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }
    dns {
      servers = [var.dns]
      domain  = "thenetworker.club"
    }
    user_account {
      keys = [trimspace(var.ssh_public_key)]
    }
  }
}

output "id"         { value = proxmox_virtual_environment_container.lxc.vm_id }
output "name"       { value = proxmox_virtual_environment_container.lxc.initialization[0].hostname }
output "ip_address" { value = var.ip_address }
