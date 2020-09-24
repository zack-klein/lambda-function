
resource "aws_api_gateway_rest_api" "api" {
  name               = var.api_gateway_name
  binary_media_types = ["multipart/form-data"]
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = var.api_gateway_name
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post-integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.post-integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.post-integration),
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}
