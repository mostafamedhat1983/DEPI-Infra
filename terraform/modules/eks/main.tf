resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

locals {
  cluster_policies = {
    AmazonEKSClusterPolicy  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    AmazonEKSServicePolicy  = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    AmazonRDSFullAccess     = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  }
}

resource "aws_iam_role_policy_attachment" "cluster" {
  for_each   = local.cluster_policies
  policy_arn = each.value
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = var.subnets
    security_group_ids      = var.security_groups
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster["AmazonEKSClusterPolicy"],
    aws_iam_role_policy_attachment.cluster["AmazonEKSServicePolicy"],
    aws_iam_role_policy_attachment.cluster["AmazonRDSFullAccess"]
  ]

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

locals {
  node_policies = {
    AmazonEKSWorkerNodePolicy              = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    AmazonEKS_CNI_Policy                   = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    AmazonEC2ContainerRegistryReadOnly     = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    AmazonSSMManagedInstanceCore           = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    AmazonEC2ContainerRegistryPowerUser    = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    AmazonRDSFullAccess                    = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  }
}

resource "aws_iam_role_policy_attachment" "nodes" {
  for_each   = local.node_policies
  policy_arn = each.value
  role       = aws_iam_role.nodes.name
}

resource "time_sleep" "wait_for_iam_propagation" {
  depends_on = [
    aws_iam_role_policy_attachment.nodes["AmazonEKSWorkerNodePolicy"],
    aws_iam_role_policy_attachment.nodes["AmazonEKS_CNI_Policy"],
    aws_iam_role_policy_attachment.nodes["AmazonEC2ContainerRegistryReadOnly"],
    aws_iam_role_policy_attachment.nodes["AmazonSSMManagedInstanceCore"],
    aws_iam_role_policy_attachment.nodes["AmazonEC2ContainerRegistryPowerUser"],
    aws_iam_role_policy_attachment.nodes["AmazonRDSFullAccess"]
  ]
  create_duration = "60s"
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnets

  capacity_type = "ON_DEMAND"
  ami_type      = "AL2_x86_64"
  disk_size     = 50
  instance_types = [var.node_type]

  remote_access {
    ec2_ssh_key               = var.key_name
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_cluster.this,
    time_sleep.wait_for_iam_propagation
  ]

  tags = {
    Name = "${var.cluster_name}-${var.node_group_name}"
  }
}