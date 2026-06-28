###############################################################################
# variables.tf — Input variables for the homelab Terraform configuration
###############################################################################

# ── Proxmox connection ───────────────────────────────────────────────────────

variable "proxmox_endpoint" {
  description = "URL of the Proxmox API endpoint (include trailing slash)"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the format user@realm!tokenid=secret"
  type        = string
  sensitive   = true
}

# ── Network ──────────────────────────────────────────────────────────────────
variable "domain_name" {
  description = "Domain name for the homelab (used in VM hostnames and DNS)"
  type        = string
}

variable "vlan_mgmt"     {
  description = "Management VLAN ID"
}

variable "vlan_storage"  {
  description = "Storage/iSCSI VLAN ID"
}

variable "vlan_vm"       {
  description = "VM traffic VLAN ID"
}

variable "vlan_security" {
  description = "Security segment VLAN ID"
}

variable "gateway_mgmt"  {
  description = "Management gateway IP"
}

variable "gateway_vm"    {
  description = "VM traffic gateway IP"
}

variable "gateway_security" {
  description = "Security segment gateway IP"
}

variable "dns_server"    {
  description = "DNS server IP"
}

variable "bridge30"        {
  description = "Bridge interface for VM_TRAFFIC"
}

variable "bridge40"        {
  description = "Bridge interface for SECURITY"
}

variable "vm_ip_monitoring" {
  description = "IP address for the monitoring VM"
}

variable "vm_ip_wazuh_indexer" {
  description = "IP address for the Wazuh Indexer VM"
}

variable "vm_ip_wazuh_server" {
  description = "IP address for the Wazuh Server VM"
}

variable "vm_ip_wazuh_dashboard" {
  description = "IP address for the Wazuh Dashboard VM"
}

variable "vm_ip_openvas" {
  description = "IP address for the OpenVAS VM"
}

variable "vm_ip_gitea" {
  description = "IP address for the Gitea VM"
}
variable "vm_ip_woodpecker" {
  description = "IP address for the Woodpecker CI VM"
}

variable "vm_ip_harbor" {
  description = "IP address for the Harbor VM"
}

variable "vm_ip_vault" {
  description = "IP address for the Vault VM"
}

variable "vm_ip_k3s_control" {
  description = "IP address for the K3s control plane VM"
}

variable "vm_ip_k3s_worker1" {
  description = "IP address for the K3s worker 1 VM"
}

variable "vm_ip_k3s_worker2" {
  description = "IP address for the K3s worker 2 VM"
}

# ── Node targets ─────────────────────────────────────────────────────────────

variable "node_primary"   {
  description = "Primary compute node"
}

variable "node_secondary" {
  description = "Secondary compute node"
}

variable "node_lab"       {
  description = "Lab/GPU node"
}

# ── VM defaults ──────────────────────────────────────────────────────────────

variable "vm_template_id" {
  description = "Proxmox VM ID of the base Debian cloud-init template (primary)"
  type        = number
}

variable "vm_template_id_secondary" {
  description = "Proxmox VM ID of the base Debian cloud-init template (secondary)"
  type        = number
}

variable "vm_template_id_ubuntu" {
  description = "Proxmox VM ID of the base Ubuntu cloud-init template (primary)"
  type        = number
}

variable "vm_template_id_ubuntu02" {
  description = "Proxmox VM ID of the base Ubuntu cloud-init template (secondary)"
  type        = number
}

variable "vm_template_id_lab" {
  description = "Proxmox VM ID of the base Debian cloud-init template (lab)"
  type        = number
}

variable "vm_template_id_ubuntu_lab" {
  description = "Proxmox VM ID of the base Ubuntu cloud-init template (lab)"
  type        = number
}

variable "ssh_public_key" {
  description = "SSH public key injected into VMs via cloud-init"
  type        = string
}

variable "default_user" {
  description = "Default user created by cloud-init"
  type        = string
}

# ── Storage ──────────────────────────────────────────────────────────────────

variable "storage_local_primary"   {
  description = "primary local NVMe storage ID"
}

variable "storage_local_secondary"   {
  description = "secondary local NVMe storage ID"
}

variable "storage_local_lab" {
  description = "lab ZFS mirror storage ID"
}

variable "storage_iscsi_primary"   {
  description = "primary iSCSI storage ID"
}

variable "storage_iscsi_secondary"   {
  description = "secondary iSCSI storage ID"
}
