provider "aws" {
  alias = "region"
}

resource "aws_api_gateway_rest_api" "ttrl" {
  provider = aws.region
  name     = "ttrl"
}

resource "aws_api_gateway_resource" "ttrl" {
  provider    = aws.region
  parent_id   = aws_api_gateway_rest_api.ttrl.root_resource_id
  path_part   = "ttrl"
  rest_api_id = aws_api_gateway_rest_api.ttrl.id
}

resource "aws_api_gateway_method" "ttrl-event" {
  provider      = aws.region
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.ttrl.id
  rest_api_id   = aws_api_gateway_rest_api.ttrl.id
}

resource "aws_api_gateway_integration" "ttrl" {
  provider    = aws.region
  http_method = aws_api_gateway_method.ttrl-event.http_method
  resource_id = aws_api_gateway_resource.ttrl.id
  rest_api_id = aws_api_gateway_rest_api.ttrl.id
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "ttrl" {
  provider    = aws.region
  rest_api_id = aws_api_gateway_rest_api.ttrl.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.ttrl.id,
      aws_api_gateway_method.ttrl-event.id,
      aws_api_gateway_integration.ttrl.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "ttrl" {
  provider      = aws.region
  deployment_id = aws_api_gateway_deployment.ttrl.id
  rest_api_id   = aws_api_gateway_rest_api.ttrl.id
  stage_name    = "ttrl"
}
