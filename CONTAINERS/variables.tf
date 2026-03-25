variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "af-south-1"
}

# EKS Variables
variable "eks_cluster_name" { default = "placeholder-eks-cluster" }
variable "eks_version" { default = "1.31" }
variable "eks_cluster_role_name" { default = "placeholder-eks-cluster-role" }
variable "eks_node_role_name" { default = "placeholder-eks-node-role" }
variable "eks_node_group_name" { default = "placeholder-node-group" }
variable "private_subnet_ids" {
  description = "List of private subnets"
  type        = list(string)
  default     = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
}
variable "node_ami_type" { default = "AL2_x86_64" }
variable "node_instance_types" { default = ["t3.medium"] }
variable "node_desired_size" { default = 2 }
variable "node_max_size" { default = 3 }
variable "node_min_size" { default = 1 }
variable "cluster_log_types" { default = ["api", "audit", "authenticator"] }
variable "cluster_log_group_name" { default = "/aws/eks/placeholder-cluster/logs" }
variable "cluster_log_retention_days" { default = 7 }

# ECS Variables
variable "ecs_cluster_name" { default = "placeholder-ecs-cluster" }
variable "ecs_task_family" { default = "placeholder-task-family" }
variable "ecs_task_cpu" { default = "256" }
variable "ecs_task_memory" { default = "512" }
variable "ecs_task_execution_role_arn" { default = "arn:aws:iam::123456789012:role/placeholder-execution-role" }
variable "ecs_task_role_arn" { default = "arn:aws:iam::123456789012:role/placeholder-task-role" }
variable "ecs_container_image" { default = "nginx:latest" }
variable "ecs_container_port" { default = 80 }
variable "ecs_service_name" { default = "placeholder-ecs-service" }
variable "ecs_service_desired_count" { default = 1 }
variable "ecs_service_security_groups" { type = list(string) default = ["sg-xxxxxxxx"] }