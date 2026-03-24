output "role_arn" {
  value = aws_iam_role.example_role.arn
}

output "policy_arn" {
  value = aws_iam_policy.example_policy.arn
}

output "user_name" {
  value = aws_iam_user.example_user.name
}

output "group_name" {
  value = aws_iam_group.example_group.name
}