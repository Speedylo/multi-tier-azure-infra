# Multi-Tier Azure Infrastructure with Terraform and Ansible Automation

![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/ansible-%23EE0000.svg?style=for-the-badge&logo=ansible&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)

**Automated the deployment of a secure multi-tier infrastructure in Azure using Terraform and Ansible, featuring Nginx web server, PostgreSQL database, and Prometheus/Grafana monitoring stack.**

## Architecture Overview

```mermaid
 graph TB

    subgraph AzureVNet ["Azure Virtual Network"]
        style AzureVNet fill:#f5f5f5,stroke:#0078d4,stroke-width:2px,stroke-dasharray: 10

        subgraph PublicSubnet ["Public Subnet"]
            style PublicSubnet fill:#e1f5fe,stroke:#01579b
            WebVM["Web VM"]
            Nginx["Nginx (:80)"]
            WNE["Node Exporter (:9100)"]

            WebVM ---- Nginx
            WebVM --- WNE
        end

        subgraph PrivateSubnet ["Private Subnet"]
            style PrivateSubnet fill:#efebe9,stroke:#4e342e           
            subgraph DB_VM ["DB VM"]
                PSQL[("PostgreSQL (:5432)")]
                DNE["Node Exporter (:9100)"]
            end
            subgraph Mon_VM ["Monitoring VM"]
                Prom["Prometheus (:9090)"]
                Graf["Grafana (:3000)"]
                MNE["Node Exporter (:9100)"]
            end
        end
    end

    

    %% Network Traffic Flow
    User((User)) -- "HTTP" --> Nginx
    Nginx -- "DB Traffic" --> PSQL
    Prom -- "Pull Metrics" --> WNE
    Prom -- "Pull Metrics" --> DNE
    Prom -- "Pull Metrics" --> MNE
    Graf -- "Read" --> Prom

    PublicSubnet ~~~ AzureVNet
```

| Component | Subnet | Services |
|-----------|--------|----------|
| **Web VM** | Public | Nginx, Node Exporter |
| **DB VM** | Private | PostgreSQL, Node Exporter |
| **Monitoring VM** | Private | Prometheus, Grafana, Node Exporter |

## Tech Stack

| Category | Tools |
|----------|-------|
| **IaC** | Terraform, Azure |
| **Config** | Ansible |
| **Web** | Ubuntu Server 24.04, Nginx |
| **Database** | PostgreSQL |
| **Monitoring** | Prometheus, Grafana, Node Exporter |

## Quick Start

### 1. Deploy Infrastructure

```bash
cd terraform/
terraform init
terraform plan
terraform apply -auto-approve
```

### 2. Configure Services

```bash
ansible-playbook site.yml
```

### 3. Validate

```bash
# Web server
curl http://$web_ip 

# Prometheus targets
curl http://$monitoring_ip:9090/api/v1/targets

# Node Exporter (from monitoring VM)
curl http://$db_ip:9100/metrics
```


## Deployment Checklist

- [x] `terraform apply` completes
- [x] All VMs reachable via SSH
- [x] `curl http://$web_ip` serves HTML
- [x] Prometheus shows 3/3 targets UP
- [x] Grafana login works (admin/admin)
- [x] Node Exporter metrics scrape successfully

## Key Learnings

 **Port Conflicts**: Prometheus apt installation comes with built-in Node Exporter, which conflicts with the manual install → Solution: Install Prometheus binaries to properly configure it

 **NSG Gotcha**: Cross-subnet Prometheus scraping requires explicit NSG rules for port 9100

 **Ansible Tips**:
 - For static HTML, use `files/` directory
 - For a service restart, use handlers
 - For selective runs, use `--tags` for development