resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.ttrl.id}/*/${aws_api_gateway_method.ttrl-event.http_method}${aws_api_gateway_resource.ttrl-event.path}"
}

resource "aws_api_gateway_rest_api" "ttrl" {
  name = "ttrl"
}

resource "aws_api_gateway_resource" "ttrl-event" {
  parent_id   = aws_api_gateway_rest_api.ttrl.root_resource_id
  path_part   = "event"
  rest_api_id = aws_api_gateway_rest_api.ttrl.id
}

resource "aws_api_gateway_method" "ttrl-event" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.ttrl-event.id
  rest_api_id   = aws_api_gateway_rest_api.ttrl.id
}

resource "aws_api_gateway_integration" "ttrl" {
  http_method = aws_api_gateway_method.ttrl-event.http_method
  resource_id = aws_api_gateway_resource.ttrl-event.id
  rest_api_id = aws_api_gateway_rest_api.ttrl.id
  # type                    = "HTTP_PROXY"
  # integration_http_method = "GET"
  # uri                     = "https://my-json-server.typicode.com/typicode/demo/posts"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "ttrl" {
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
      aws_api_gateway_resource.ttrl-event,
      aws_api_gateway_method.ttrl-event,
      aws_api_gateway_integration.ttrl,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "ttrl" {
  deployment_id = aws_api_gateway_deployment.ttrl.id
  rest_api_id   = aws_api_gateway_rest_api.ttrl.id
  stage_name    = "ttrl"
}
