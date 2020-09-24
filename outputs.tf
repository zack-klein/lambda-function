output "api_gateway_rest_api" {
  value = aws_api_gateway_rest_api.api
}

output "lambda_function" {
  value = aws_lambda_function.lambda
}

output "iam_role" {
  value = aws_iam_role.role
}
