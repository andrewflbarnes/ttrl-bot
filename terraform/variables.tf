variable "region" {
  type        = string
  description = "The region to provision the resources in"
  default     = "eu-west-2"
}

variable "lambda_source" {
  default     = "../ttrl_discord_event_lambda.zip"
  description = "The zip file containing the lambda"
  type        = string
}

variable "lambda_deps_source" {
  default     = "../ttrl_discord_event_lambda_deps.zip"
  description = "The zip file containing the lambda deps layer"
  type        = string
}