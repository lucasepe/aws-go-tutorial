

resource "aws_lambda_function" "lambda" {
  description                    = var.description
  filename                       = var.filename
  function_name                  = var.function_name
  handler                        = var.function_name
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  role                           = aws_iam_role.lambda.arn
  runtime                        = var.runtime
  source_code_hash               = filebase64sha256(var.filename)
  timeout                        = var.timeout
}

resource "aws_iam_role" "lambda" {
  name               = "${var.function_name}-${data.aws_region.current.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_region" "current" {}
