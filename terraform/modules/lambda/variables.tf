variable "lambda_source" {
  description = "The zip file containing the lambda"
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
  default     = "nodejs12.x"
}
