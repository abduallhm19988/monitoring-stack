# Monitoring Stack - Review and Runbook

## What this repository contains

This is a learning project that combines:

- Terraform for an AWS VPC, public subnet, Internet Gateway, EC2 instances, IAM roles, and an EKS cluster/node group.
- Ansible playbooks for installing Prometheus, Alertmanager, Grafana, Node Exporter, and configuring EKS monitoring components.
- Terraform Kubernetes and Helm providers for cluster-side resources (review the referenced resource files and role contents before applying).

It is an infrastructure lab, not a production-ready monitoring platform.

## Security changes in this review branch

- Replaced the all-protocol/all-port ingress rule from `0.0.0.0/0`.
- SSH (22) and Grafana (3000) are now restricted to the required `admin_cidr` input.
- Prometheus (9090), Alertmanager (9093), and Node Exporter (9100) ingress is limited to resources sharing the monitoring security group.
- The Grafana Ansible playbook no longer prints the initial admin password into Ansible output.

Set `admin_cidr` to your trusted public IPv4 address with a /32 mask (or a tightly controlled office/VPN range). Never use `0.0.0.0/0`.

## Before attempting a deployment

The current Terraform layout still needs additional work before it can be considered reproducible:

1. **EKS subnet topology:** the EKS cluster currently references one public subnet. Design at least two subnets in different Availability Zones and use private subnets for worker nodes where practical.
2. **Node IAM permissions:** the visible node role attaches `AmazonEKSWorkerNodePolicy`, but the standard node role also needs the CNI and ECR read-only permissions (or equivalent least-privilege policies).
3. **EKS networking:** verify the VPC CNI configuration, subnet tags, cluster endpoint access, and security-group paths for the intended topology.
4. **Terraform dependency graph:** verify every Kubernetes/Helm resource referenced by outputs and providers exists in the repository and that the cluster bootstrap sequence is handled. A provider that depends on an EKS cluster can require a staged apply.
5. **Ansible inventory:** `ansible/inventory.yaml` contains placeholder hosts and a placeholder private-key path. Replace these locally; do not commit private keys or real secrets.
6. **Monitoring deployment:** validate the referenced Ansible roles and playbooks against the actual cluster and confirm that Prometheus scrapes the intended targets.
7. **Observability:** add dashboards, alert rules, retention settings, and operational alarms appropriate to the lab.

## Local checks

Run these from the repository root in an environment with Terraform, AWS CLI, Ansible, and the required providers/collections installed:

```bash
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
ansible-playbook --syntax-check -i ansible/inventory.yaml ansible/install_tools.yaml
ansible-playbook --syntax-check -i ansible/inventory.yaml ansible/node_exporter.yaml
ansible-playbook --syntax-check -i ansible/inventory.yaml ansible/eks-monitoring.yaml
```

A syntax check does not prove that AWS resources can be created or that the monitoring stack works end to end.

## Suggested evidence for a portfolio

After a successful lab run, add redacted screenshots showing:

- Terraform outputs and the EKS cluster/node group state.
- Prometheus Targets showing the expected targets as `UP`.
- A Grafana dashboard with live metrics.
- An Alertmanager test alert and its resolved state.

Do not upload AWS account IDs, public IPs, kubeconfigs, private keys, passwords, tokens, or unredacted logs.
