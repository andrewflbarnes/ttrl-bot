provider "aws" {
  profile = "default"
  region  = var.region
}

terraform {
  backend "s3" {
    bucket = "aflb-terraform-state"
    key    = "ttrl-bot/terraform.tfstate"
    region = "eu-west-2"
  }
}

module "lambda" {
  source = "./modules/lambda"

  lambda_source = var.lambda_source
}

module "api_gateway" {
  source = "./modules/api_gateway"

  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.function_name
}
