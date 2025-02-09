output "vpc_name" {
  description = "Name tag of the VPC"
  value       = aws_vpc.monitor_vpc.tags["Name"]
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.monitoring.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.monitoring.endpoint
}

output "eks_node_group_status" {
  description = "Status of EKS node group"
  value       = aws_eks_node_group.nodes.status
}

output "control_instance_public_ip" {
  description = "Public IP address of the control instance"
  value       = aws_instance.control-1.public_ip
}

output "target_instance_public_ip" {
  description = "Public IP address of the target instance"
  value       = aws_instance.target-1.public_ip
}

output "grafana_url" {
  description = "Grafana LoadBalancer URL"
  value       = "http://${kubernetes_service_v1.grafana.status.0.load_balancer.0.ingress.0.hostname}"
  depends_on  = [kubernetes_service_v1.grafana]
}
