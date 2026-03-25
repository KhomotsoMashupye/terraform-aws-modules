output "sns_topic_arn" {
  value = aws_sns_topic.notifications.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.queue.id
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.queue.arn
}