output "lambda_invoke_arn" {
  value = aws_lambda_function.ttrl_discord_event.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.ttrl_discord_event.function_name
}