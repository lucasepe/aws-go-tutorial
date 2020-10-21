# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem."
}

variable "function_name" {
  description = "A unique name for your Lambda Function."
}

/*
variable "handler" {
  description = "The function entrypoint in your code."
}
*/

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "localstack_url" {
  description = "Localstack endpoint"
  default     = "http://localhost:4566"
}

variable "description" {
  description = "Description of what your Lambda Function does."
  default     = ""
}

variable "runtime" {
  description = "The runtime environment for the Lambda function you are uploading."
  default     = "go1.x"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default     = 128
}

variable "bucket_name" {
  description = "S3 event source bucket name."
  default     = "test"
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1."
  default     = "-1"
}
