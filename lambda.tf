# Current caller
data "aws_caller_identity" "current" {}

# Lambda
resource "aws_lambda_permission" "apigw_lambda_post" {
  statement_id  = "AllowPostExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.post.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_lambda_function" "lambda" {
  s3_bucket     = var.lambda_source_s3_bucket
  s3_key        = var.lambda_source_s3_key
  function_name = var.lambda_name
  role          = aws_iam_role.role.arn
  runtime       = var.lambda_runtime
  handler       = "${var.lambda_handler_file_name}.${var.lambda_handler_function_name}"
  timeout       = var.timeout

  tracing_config {
    mode = var.xray_tracing_mode
  }
}

# IAM
resource "aws_iam_role" "role" {
  name = "lambda-${var.lambda_name}"

  assume_role_policy = <<POLICY
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
POLICY
}

resource "aws_iam_policy" "lambda-policy" {
  name        = "${var.lambda_name}-lambda-policy"
  path        = "/"
  description = "Policy for the lambda function: ${var.lambda_name}"
  policy      = var.lambda_iam_policy
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}
