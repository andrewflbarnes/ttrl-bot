variable "lambda_source" {
  description = "The zip file containing the lambda"
  type        = string
}

variable "lambda_hash_source" {
  description = "The file to hash for the lambda"
  type        = string
}

variable "lambda_deps_source" {
  description = "The zip file containing the lambda deps"
  type        = string
}

variable "lambda_deps_hash_source" {
  description = "The file to hash for the lambda deps"
  type        = string
}

variable "handler" {
  description = "The name of the lambda handler function"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "The execution runtime for the lambda"
  type        = string
  default     = "nodejs14.x"
}
