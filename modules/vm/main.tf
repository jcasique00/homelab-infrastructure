###############################################################################
# modules/vm/main.tf — Reusable VM module
# Usage: see environments/prod/vms.tf
###############################################################################

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50"
    }
  }
}

variable "vm_id"          { type = number }
variable "name"           { type = string }
variable "node"           { type = string }
variable "template_id"    { type = number }
variable "template_node" {
  type    = string
  default = ""
  description = "Node where the template lives; empty means same node as the VM"
}
variable "cores"          { 
  type = number
  default = 2
}
variable "memory_mb"      {
  type = number
  default = 2048
}
variable "disk_size_gb"   {
  type = number
  default = 32
}
variable "storage"        { type = string }
variable "ip_address"     { 
  type = string
  description = "CIDR notation e.g. 10.10.30.10/24"
}
variable "gateway"        { type = string }
variable "dns"            { type = string }
variable "domain_name"    { type = string }
variable "bridge"         {type = string}
variable "ssh_public_key" { type = string }
variable "user"           { type = string }
variable "tags"           {
  type = list(string)
  default = []
}
variable "description"    {
  type = string
  default = ""
}

variable "cloud_init_storage" {
  type        = string
  default     = ""
  description = "Storage for the cloud-init drive; defaults to the VM disk storage"
}

variable "extra_disks" {
  description = "Additional disks to attach"
  type = list(object({
    size_gb  = number
    storage  = string
    interface = string
  }))
  default = []
}

###############################################################################

resource "proxmox_virtual_environment_vm" "vm" {
  vm_id       = var.vm_id
  name        = var.name
  node_name   = var.node
  description = var.description
  tags        = var.tags

  clone {
    vm_id     = var.template_id
    node_name = var.template_node != "" ? var.template_node : null
    full      = true
    retries   = 3
  }

  agent { enabled = true }

  cpu {
    cores = var.cores
    type  = "x86-64-v2-AES"
  }

  memory { dedicated = var.memory_mb }

  disk {
    datastore_id = var.storage
    interface    = "virtio0"
    size         = var.disk_size_gb
    discard      = "on"
    iothread     = true
  }

  dynamic "disk" {
    for_each = var.extra_disks
    content {
      datastore_id = disk.value.storage
      interface    = disk.value.interface
      size         = disk.value.size_gb
      discard      = "on"
      iothread     = true
    }
  }

  network_device {
    bridge  = var.bridge
    model   = "virtio"
  }

  initialization {
    datastore_id = var.cloud_init_storage != "" ? var.cloud_init_storage : var.storage
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }
    dns {
      servers = [var.dns]
      domain  = var.domain_name
    }
    user_account {
      username = var.user
      keys     = [trimspace(var.ssh_public_key)]
    }
  }

  lifecycle {
    ignore_changes = [clone]
  }
}

output "id"         { value = proxmox_virtual_environment_vm.vm.vm_id }
output "name"       { value = proxmox_virtual_environment_vm.vm.name }
output "ip_address" { value = var.ip_address }
