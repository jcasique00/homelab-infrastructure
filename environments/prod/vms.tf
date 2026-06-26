###############################################################################
# environments/prod/vms.tf
# Provisions all lab VMs across phases 7-9
# VM IDs: 100-199 = core infra, 200-299 = security, 300-399 = devops
###############################################################################

###############################################################################
# PHASE 7 - Core Infrastructure (secondary)
###############################################################################

# Monitoring - Prometheus + Grafana + Loki
module "monitoring" {
  source         = "../../modules/vm"
  vm_id          = 101
  name           = "monitoring"
  node           = var.node_secondary
  template_id    = var.vm_template_id_secondary
  user           = var.default_user
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 48
  storage        = var.storage_local_secondary
  ip_address     = var.vm_ip_monitoring
  gateway        = var.gateway_vm
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge30
  ssh_public_key = var.ssh_public_key
  tags           = ["monitoring", "grafana", "prometheus"]
  description    = "Prometheus + Grafana + Loki monitoring and logging stack"
}

###############################################################################
# PHASE 8 - Security Stack (primary)
###############################################################################

# Wazuh Indexer
module "wazuh_indexer" {
  source         = "../../modules/vm"
  vm_id          = 201
  name           = "wazuh-indexer"
  node           = var.node_primary
  template_id    = var.vm_template_id_ubuntu
  user           = var.default_user
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 60
  storage        = var.storage_local_primary
  ip_address     = var.vm_ip_wazuh_indexer
  gateway        = var.gateway_security
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge40
  ssh_public_key = var.ssh_public_key
  tags           = ["security", "wazuh", "indexer"]
  description    = "Wazuh Indexer - Elasticsearch-compatible backend"
}

# Wazuh Server
module "wazuh_server" {
  source         = "../../modules/vm"
  vm_id          = 202
  name           = "wazuh-server"
  node           = var.node_primary
  template_id    = var.vm_template_id_ubuntu
  user           = var.default_user
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 32
  storage        = var.storage_local_primary
  ip_address     = var.vm_ip_wazuh_server
  gateway        = var.gateway_security
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge40
  ssh_public_key = var.ssh_public_key
  tags           = ["security", "wazuh", "server"]
  description    = "Wazuh Manager - analysis and correlation engine"
}

# Wazuh Dashboard
module "wazuh_dashboard" {
  source         = "../../modules/vm"
  vm_id          = 203
  name           = "wazuh-dashboard"
  node           = var.node_primary
  template_id    = var.vm_template_id_ubuntu
  user           = var.default_user
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 32
  storage        = var.storage_local_primary
  ip_address     = var.vm_ip_wazuh_dashboard
  gateway        = var.gateway_security
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge40
  ssh_public_key = var.ssh_public_key
  tags           = ["security", "wazuh", "dashboard"]
  description    = "Wazuh Dashboard - Kibana-based UI"
}

# OpenVAS / Greenbone Community Edition
module "openvas" {
  source         = "../../modules/vm"
  vm_id          = 204
  name           = "openvas"
  node           = var.node_primary
  template_id    = var.vm_template_id_ubuntu
  user           = var.default_user
  cores          = 4
  memory_mb      = 4096
  disk_size_gb   = 40
  storage        = var.storage_local_primary
  ip_address     = var.vm_ip_openvas
  gateway        = var.gateway_security
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge40
  ssh_public_key = var.ssh_public_key
  tags           = ["security", "openvas", "vulnerability-scanning"]
  description    = "Greenbone Community Edition - vulnerability scanner"
}

###############################################################################
# PHASE 9 - DevOps Stack (mixed)
###############################################################################

# Gitea - self-hosted Git (secondary)
module "gitea" {
  source         = "../../modules/vm"
  vm_id          = 301
  name           = "gitea"
  node           = var.node_secondary
  template_id    = var.vm_template_id_secondary
  user           = var.default_user
  cores          = 1
  memory_mb      = 1024
  disk_size_gb   = 32
  storage        = var.storage_iscsi_secondary
  ip_address     = var.vm_ip_gitea
  gateway        = var.gateway_vm
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge30
  ssh_public_key = var.ssh_public_key
  tags           = ["devops", "git", "gitea"]
  description    = "Gitea - self-hosted Git service"
}

# Woodpecker CI - (secondary)
module "woodpecker" {
  source         = "../../modules/vm"
  vm_id          = 302
  name           = "woodpecker-ci"
  node           = var.node_secondary
  template_id    = var.vm_template_id_secondary
  user           = var.default_user
  cores          = 1
  memory_mb      = 1024
  disk_size_gb   = 32
  storage        = var.storage_iscsi_secondary
  ip_address     = var.vm_ip_woodpecker
  gateway        = var.gateway_vm
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge30
  ssh_public_key = var.ssh_public_key
  tags           = ["devops", "ci-cd", "woodpecker"]
  description    = "Woodpecker CI - pipeline automation server"
}

# Harbor container registry - (primary)
module "harbor" {
  source         = "../../modules/vm"
  vm_id          = 303
  name           = "harbor"
  node           = var.node_primary
  template_id    = var.vm_template_id
  user           = var.default_user
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 64
  storage        = var.storage_local_primary
  ip_address     = var.vm_ip_harbor
  gateway        = var.gateway_vm
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge30
  ssh_public_key = var.ssh_public_key
  tags           = ["devops", "registry", "harbor"]
  description    = "Harbor - private container registry with vulnerability scanning"
}

# HashiCorp Vault (primary)
module "vault" {
  source         = "../../modules/vm"
  vm_id          = 304
  name           = "vault"
  node           = var.node_primary
  template_id    = var.vm_template_id
  user           = var.default_user
  cores          = 1
  memory_mb      = 1024
  disk_size_gb   = 32
  storage        = var.storage_local_primary
  ip_address     = var.vm_ip_vault
  gateway        = var.gateway_vm
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge30
  ssh_public_key = var.ssh_public_key
  tags           = ["devops", "secrets", "vault"]
  description    = "HashiCorp Vault - secrets management"
}

# k3s Control Plane (primary)
module "k3s_control" {
  source         = "../../modules/vm"
  vm_id          = 310
  name           = "k3s-control"
  node           = var.node_primary
  template_id    = var.vm_template_id
  user           = var.default_user
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 40
  storage        = var.storage_local_primary
  ip_address     = var.vm_ip_k3s_control
  gateway        = var.gateway_vm
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge30
  ssh_public_key = var.ssh_public_key
  tags           = ["kubernetes", "k3s", "control-plane"]
  description    = "k3s control plane node"
}

# k3s Worker 1 (primary)
module "k3s_worker1" {
  source         = "../../modules/vm"
  vm_id          = 311
  name           = "k3s-worker1"
  node           = var.node_primary
  template_id    = var.vm_template_id
  user           = var.default_user
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 40
  storage        = var.storage_local_primary
  ip_address     = var.vm_ip_k3s_worker1
  gateway        = var.gateway_vm
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge30
  ssh_public_key = var.ssh_public_key
  tags           = ["kubernetes", "k3s", "worker"]
  description    = "k3s worker node 1"
}

# k3s Worker 2 (secondary)
module "k3s_worker2" {
  source         = "../../modules/vm"
  vm_id          = 312
  name           = "k3s-worker2"
  node           = var.node_secondary
  template_id    = var.vm_template_id_secondary
  user           = var.default_user
  cores          = 2
  memory_mb      = 4096
  disk_size_gb   = 40
  storage        = var.storage_local_secondary
  ip_address     = var.vm_ip_k3s_worker2
  gateway        = var.gateway_vm
  dns            = var.dns_server
  domain_name    = var.domain_name
  bridge         = var.bridge30
  ssh_public_key = var.ssh_public_key
  tags           = ["kubernetes", "k3s", "worker"]
  description    = "k3s worker node 2"
}

###############################################################################
# Outputs - useful for Ansible inventory generation
###############################################################################

output "vm_ips" {
  description = "IP addresses of all provisioned VMs"
  value = {
    monitoring      = module.monitoring.ip_address
    wazuh_indexer   = module.wazuh_indexer.ip_address
    wazuh_server    = module.wazuh_server.ip_address
    wazuh_dashboard = module.wazuh_dashboard.ip_address
    openvas         = module.openvas.ip_address
    gitea           = module.gitea.ip_address
    woodpecker      = module.woodpecker.ip_address
    harbor          = module.harbor.ip_address
    vault           = module.vault.ip_address
    k3s_control     = module.k3s_control.ip_address
    k3s_worker1     = module.k3s_worker1.ip_address
    k3s_worker2     = module.k3s_worker2.ip_address
  }
}
