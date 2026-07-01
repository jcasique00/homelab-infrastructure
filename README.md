# homelab-infrastructure
## My Local HomeLab

The basic goal of this repository is for me to store the code that I am using in my homelab. The lab itself is the environment where I learn and continuously grow my technical skills as a Platform/DevSecOps Engineer. This is also the place where I continue to apply my extensive IAM background.

This is a live repository that will evolve with time and will hopefully showcase my professional growth. It is not meant to be a comprehensive wiki, but rather showcase the code used to automate as much as possible, from the deployment of VMs and containers (IaC - Terraform) to the configuration and maintenance of services and applications in those VMs (Ansible).

Here is a basic breakdown of the lab:

### Hardware

| Item / Hostname | Component Type | Layer / Category | Deployment Method | Primary Function |
| :--- | :--- | :--- | :--- | :--- |
| **pfSense Box** | Network Security Appliance | `Networking & Security` | Physical Hardware | Edge routing, firewall, local DNS/DHCP, and IDS/IDP |
| **Aruba Instant On JL682A** | Managed Switch | `Networking & Security` | Physical Hardware | Layer 2/3 switching, and VLAN routing |
| **Proxmox Host 1 (Main)** | Bare-Metal Hypervisor | `Compute Cluster` | Physical (Type-1) | Runs primary production VMs and containers |
| **Proxmox Host 2 (Secondary)** | Bare-Metal Hypervisor | `Compute Cluster` | Physical (Type-1) | secondary production VMs and lower priority VMs |
| **Proxmox Host 3 (Dev)** | Bare-Metal Hypervisor | `Compute Cluster` | Physical (Type-1) | Sandbox environment for testing IaC and CI/CD workflows |
| **TrueNAS Server** | Storage Appliance | `Storage Tier` | Physical (Bare-Metal) | Centralized storage provider via NFS/iSCSI/SMB shares |

### Software and Services Topology

| Service / VM Name | Service Type | Assigned Host | Deployment Method | Purpose / Function |
| :--- | :--- | :--- | :--- | :--- |
| **harbor** | Container Registry | `Proxmox Host 1 (Main)` | ![Static Badge](https://img.shields.io/badge/Docker%20VM-red) | Private Docker/OCI registry for secure image hosting |
| **vault** | Secrets Management | `Proxmox Host 1 (Main)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Centralized management for API keys, passwords, and certs |
| **k3s_control** | Kubernetes Control Plane | `Proxmox Host 1 (Main)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Master node managing the lightweight K3s cluster |
| **k3s_worker1** | Kubernetes Worker Node | `Proxmox Host 1 (Main)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Active compute node executing container workloads |
| **k3s_worker2** | Kubernetes Worker Node | `Proxmox Host 2 (Secondary)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Distributed compute node providing multi-host resilience |
| **wazuh_indexer** | Security Analytics | `Proxmox Host 1 (Main)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Highly scalable search and indexing engine for SIEM data |
| **wazuh_server** | Threat Detection | `Proxmox Host 1 (Main)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Analyzes agent data, triggers alerts, and manages security |
| **wazuh_dashboard** | Security UI | `Proxmox Host 1 (Main)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Web user interface for data visualization and monitoring |
| **openvas** | Vulnerability Scanner | `Proxmox Host 1 (Main)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Scheduled and on-demand network vulnerability testing |
| **monitoring** | Observability Stack | `Proxmox Host 2 (Secondary)` | ![Static Badge](https://img.shields.io/badge/Dedicated%20VM-orange) | Core metrics collection (Prometheus / Grafana / Loki) |
| **gitea** | Git Source Control | `Proxmox Host 2 (Secondary)` | ![Static Badge](https://img.shields.io/badge/Docker%20VM-red) | Lightweight, self-hosted Git repository hosting server |
| **woodpecker** | CI/CD Automation | `Proxmox Host 2 (Secondary)` | ![Static Badge](https://img.shields.io/badge/Docker%20VM-red) | Continuous Integration server executing automated pipelines |

&nbsp;
&nbsp;

![HomeLab Basic Diagram](./HomeLab.svg)