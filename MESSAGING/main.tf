provider "aws" {
  region = var.aws_region
}

# SNS Topic for notifications
resource "aws_sns_topic" "notifications" {
  name = var.sns_topic_name
  display_name = "General Notifications"

  tags = var.tags
}

# SQS Queue
resource "aws_sqs_queue" "queue" {
  name                      = var.sqs_queue_name
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  sqs_managed_sse_enabled = true

  tags = var.tags
}

# SNS to SQS Subscription
resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn = aws_sns_topic.notifications.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue.arn

  raw_message_delivery = true
}

# SQS Policy to allow SNS to push messages
resource "aws_sqs_queue_policy" "sns_policy" {
  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "sns.amazonaws.com" }
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.queue.arn
        Condition = {
          ArnEquals = { "aws:SourceArn" = aws_sns_topic.notifications.arn }
        }
      }
    ]
  })
}