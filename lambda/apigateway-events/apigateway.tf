variable "rest_api_name" {
  description = "The Name of the associated REST API"
  default     = "MyDemoAPI"
}

variable "method" {
  description = "The HTTP method"
  default     = "POST"
}

variable "path" {
  description = "The API resource path"
  default     = "demo"
}

variable "account_id" {
  description = "The AWS account ID"
  default     = "000000000000"
}

resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
}

# The API requires at least one "endpoint", or "resource" in AWS terminology.
# The endpoint created here is: /MyDemoResource
resource "aws_api_gateway_resource" "MyDemoResource" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = var.path
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.MyDemoResource.id
  http_method   = var.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  type        = "AWS"
  uri         = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "MyDemoMethodResponse" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "MyDemoMethodResponseIntegration" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method
  status_code = aws_api_gateway_method_response.MyDemoMethodResponse.status_code

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = aws_lambda_function.lambda.arn
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${var.account_id}:${aws_api_gateway_rest_api.MyDemoAPI.id}/*/${aws_api_gateway_method.MyDemoMethod.http_method}/${aws_api_gateway_resource.MyDemoResource.path}"
}


# We can deploy the API now! (i.e. make it publicly available)
resource "aws_api_gateway_deployment" "hello_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  stage_name  = "stage"
  depends_on  = [aws_api_gateway_method.MyDemoMethod, aws_api_gateway_integration.MyDemoIntegration]
  description = "Deploy methods: ${aws_api_gateway_rest_api.MyDemoAPI.name}"
}

output "MyDemoResource_url" {
  value = "${var.localstack_url}/restapis/${aws_api_gateway_rest_api.MyDemoAPI.id}/stage/_user_request_/${aws_api_gateway_resource.MyDemoResource.path_part}"
}


output "TryWith" {
  value = "curl --header \"Content-Type: application/json\" --request POST --data '{\"username\":\"xyz\",\"password\":\"xyz\"}' ${var.localstack_url}/restapis/${aws_api_gateway_rest_api.MyDemoAPI.id}/stage/_user_request_/${aws_api_gateway_resource.MyDemoResource.path_part}"
}

