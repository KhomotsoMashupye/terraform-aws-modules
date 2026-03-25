provider "aws" {
  region = var.aws_region
}


# EKS CLUSTER


# IAM Role for EKS Cluster

resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Cluster

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = var.cluster_log_types

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_cloudwatch_log_group.eks_cluster_logs
  ]
}

# IAM Role for Node Group
resource "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ])
  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}

# Managed Node Group

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids
  ami_type        = var.node_ami_type
  instance_types  = var.node_instance_types

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  timeouts {
    delete = "20m"
  }

  depends_on = [aws_iam_role_policy_attachment.node_policies]
}




# ECS


# ECS 
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# ECS Task Definition

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "placeholder-container"
      image     = var.ecs_container_image
      essential = true
      portMappings = [
        {
          containerPort = var.ecs_container_port
          hostPort      = var.ecs_container_port
        }
      ]
    }
  ])
}

# ECS Service 
resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.placeholder_ecs_cluster.id
  task_definition = aws_ecs_task_definition.placeholder_task.arn
  desired_count   = var.ecs_service_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = var.ecs_service_security_groups
    assign_public_ip = false
  }

  depends_on = [
    aws_ecs_task_definition.placeholder_task
  ]
}