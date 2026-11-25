# AWS Monitoring Stack with Terraform and Ansible

A cloud infrastructure and monitoring lab using Terraform, Ansible, Amazon EKS, Prometheus, Alertmanager, Grafana, and Node Exporter.

## Architecture (high level)

```text
Administrator
    |
    | SSH / Grafana UI (restricted to admin_cidr)
    v
AWS VPC
    |
    +-- Public subnet
    |     +-- EC2 control host (Ansible / kubectl tooling)
    |     +-- EC2 target host (Node Exporter lab target)
    |
    +-- Amazon EKS cluster and managed node group
          |
          +-- Prometheus
          +-- Alertmanager
          +-- Grafana
```

The exact deployment topology and target discovery must be verified against the Terraform resources and Ansible roles in this repository. See [the review and runbook](./docs/REVIEW.md) for known prerequisites and limitations.

## Repository structure

- `terraform/` — AWS infrastructure, IAM, EKS, providers, variables, and outputs.
- `ansible/` — playbooks and roles for host and EKS monitoring configuration.
- `docs/REVIEW.md` — security review, known deployment blockers, and validation guidance.

## Prerequisites

- Terraform CLI and AWS provider credentials configured locally.
- AWS CLI configured for the intended account and region.
- An existing EC2 key pair for the lab.
- Ansible with the required collections and roles.
- A trusted administrator public IPv4 CIDR.

## Important security input

The Terraform security group requires `admin_cidr` for SSH and Grafana access. Supply it at plan/apply time, for example:

```bash
terraform -chdir=terraform plan -var='admin_cidr=YOUR_PUBLIC_IP/32'
```

Do not use `0.0.0.0/0`. The security group allows monitoring ports only from resources sharing that security group.

## Validation

See [docs/REVIEW.md](./docs/REVIEW.md) before deployment. In particular, the current EKS configuration uses a single subnet and the node IAM role needs additional standard permissions. Do not treat a successful Terraform syntax check as proof of a successful deployment.

## Project scope

This repository demonstrates infrastructure as code and configuration-management concepts in a learning environment. It is not presented as a production-ready or currently deployed service.
