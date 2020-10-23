
variable "topic_name" {
  description = "The friendly name for the SNS topic"
  default     = "test-topic"
}

//SNS topic to subscribe
resource "aws_sns_topic" "call_lambda_topic" {
  name = var.topic_name
}

resource "aws_lambda_permission" "allow_sns_invoke" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn // var.function_name
  principal     = "sns.amazonaws.com"
  statement_id  = "AllowSubscriptionToSNS"
  source_arn    = aws_sns_topic.call_lambda_topic.arn
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  endpoint  = aws_lambda_function.lambda.arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.call_lambda_topic.arn
}

output "call_lambda_topic_arn" {
  description = "The SNS topic ARN to be used for sending messages to invoke Lambda Function"
  value       = aws_sns_topic.call_lambda_topic.arn
}
