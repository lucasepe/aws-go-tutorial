variable "table_name" {
  description = "The friendly name for the DynamoDB table"
  default     = "test-table"
}

resource "aws_dynamodb_table" "call_lambda_table" {
  name           = var.table_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "title"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "title"
    type = "S"
  }
}

// Allows Lambda functions to get events from the DynamoDB table 
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_dynamodb_table.call_lambda_table.arn
  enabled          = true
  function_name    = aws_lambda_function.lambda.arn
  batch_size       = 1
}
