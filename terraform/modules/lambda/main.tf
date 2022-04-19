resource "aws_iam_role" "ttrl_discord_event" {
  name               = "ttrl_discord_event_iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "ttrl_discord_event" {
  function_name    = "ttrl_discord_event"
  description      = "Handles any discord events for ttrl"
  runtime          = var.runtime
  role             = aws_iam_role.ttrl_discord_event.arn
  handler          = var.handler
  filename         = var.lambda_source
  source_code_hash = filebase64sha256(var.lambda_source)
}
