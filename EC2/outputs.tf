output "on_demand_ids" {
  value = aws_instance.on_demand[*].id
}

output "spot_instance_id" {
  value = try(aws_instance.spot[0].id, null)
}

output "asg_name" {
  value = try(aws_autoscaling_group.placeholder_asg[0].name, null)
}