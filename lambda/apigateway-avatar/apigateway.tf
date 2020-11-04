variable "api_name" {
  description = "The name of the associated REST API"
  default     = "Github's Like Avatars"
}

variable "account_id" {
  description = "The AWS account ID"
  default     = "000000000000"
}

# Creates the ReST API.
resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
  binary_media_types = [
    "*/*",
  ]
}

# ReST API endpoint 'avatars'
resource "aws_api_gateway_resource" "avatars" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "avatars"
}

# 'avatars' endpoint resource path parameter.
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.avatars.id
  path_part   = "{username}"
}

# Defines the resource HTTP method (verb or action).
resource "aws_api_gateway_method" "get-avatar" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.username" = true
  }
}

# Integrates the resource (with the specified verb) into the ReST API.
resource "aws_api_gateway_integration" "resource_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.get-avatar.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.lambda.invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.username"
  }
}

resource "aws_api_gateway_integration_response" "get-avatar-response" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.resource.id
  http_method      = aws_api_gateway_method.get-avatar.http_method
  status_code      = "200"
  content_handling = "CONVERT_TO_BINARY"
}

# Deploy the ReST API (i.e. make it publicly available).
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "stage"
  depends_on  = [aws_api_gateway_method.get-avatar, aws_api_gateway_integration.resource_integration]
}

# Gives the API Gatewat permissions to invoke Lambda functions.
resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = aws_lambda_function.lambda.arn
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}


# Prints the ReST Api ID.
output "rest_api_id" {
  value = aws_api_gateway_rest_api.api.id
}

# Prints the resource ID.
output "resource_id" {
  value = aws_api_gateway_resource.resource.id
}

# Prints the endpoints URL.
output "resource_url" {
  value = "${var.localstack_url}/restapis/${aws_api_gateway_rest_api.api.id}/stage/_user_request_/${aws_api_gateway_resource.avatars.path_part}/type-a-username-here"
}
