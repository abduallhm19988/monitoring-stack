resource "aws_eks_cluster" "monitoring" {
  name     = "monitoring-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [aws_subnet.public.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-policy
  ]
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.monitoring.name
  node_group_name = "monitoring-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [aws_subnet.public.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  instance_types = [var.instance_type]
}
