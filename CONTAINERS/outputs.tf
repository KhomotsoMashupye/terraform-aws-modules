# EKS Outputs
output "eks_cluster_name" { value = aws_eks_cluster.eks_cluster.name }
output "eks_cluster_endpoint" { value = aws_eks_cluster.eks_cluster.endpoint }
output "eks_cluster_arn" { value = aws_eks_cluster.eks_cluster.arn }
output "node_group_name" { value = aws_eks_node_group.eks_node_group.node_group_name }

# ECS Outputs
output "ecs_cluster_name" { value = aws_ecs_cluster.placeholder_ecs_cluster.name }
output "ecs_task_definition_arn" { value = aws_ecs_task_definition.placeholder_task.arn }
output "ecs_service_name" { value = aws_ecs_service.placeholder_service.name }