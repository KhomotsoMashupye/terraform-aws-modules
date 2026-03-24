resource "aws_iam_role" "example_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = var.assume_role_service }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "example_policy" {
  name        = var.policy_name
  description = "A placeholder policy for testing"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.policy_actions
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "attach_policy_to_role" {
  role       = aws_iam_role.example_role.name
  policy_arn = aws_iam_policy.example_policy.arn
}

resource "aws_iam_user" "example_user" {
  name = var.user_name
  tags = var.tags
}

resource "aws_iam_group" "example_group" {
  name = var.group_name
}

resource "aws_iam_user_group_membership" "user_in_group" {
  user   = aws_iam_user.example_user.name
  groups = [aws_iam_group.example_group.name]
}

resource "aws_iam_user_policy_attachment" "user_policy_attach" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.example_policy.arn
}

resource "aws_iam_group_policy_attachment" "group_policy_attach" {
  group      = aws_iam_group.example_group.name
  policy_arn = aws_iam_policy.example_policy.arn
}