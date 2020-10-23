
variable "queue_name" {
  description = "The friendly name for the SQS queue"
  default     = "test-queue"
}

// Create the SQS queue
resource "aws_sqs_queue" "call_lambda_queue" {
  name                       = var.queue_name
  redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.arn}\",\"maxReceiveCount\":5}"
  visibility_timeout_seconds = 300
}

// Dead letter queue
resource "aws_sqs_queue" "dead_letter_queue" {
  name = "dead_letter_${var.queue_name}"
}

// Allows Lambda functions to get events from the SQS queue 
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.call_lambda_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.lambda.arn
  batch_size       = 1
}

output "call_lambda_queue_url" {
  description = "The SQS queue URL to be used for sending messages to invoke Lambda Function"
  value       = aws_sqs_queue.call_lambda_queue.id
}
