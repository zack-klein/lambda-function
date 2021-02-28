variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region."
}

variable "api_gateway_name" {
  type = string
}

variable "lambda_name" {
  type = string
}

variable "lambda_source_s3_bucket" {
  type = string
}

variable "lambda_source_s3_key" {
  type = string
}

variable "stage_name" {
  type    = string
  default = "latest"
}

variable "api_gateway_domain" {
  type    = string
  default = null
}

variable "timeout" {
  type    = number
  default = 10
}

variable "xray_tracing_mode" {
  type    = string
  default = "Active"
}

variable "lambda_iam_policy" {
  type    = string
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "xray:PutTraceSegments"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

variable "lambda_handler_file_name" {
  type        = string
  default     = "handler"
  description = "Name of the file that has the lambda handler."
}

variable "lambda_handler_function_name" {
  type        = string
  default     = "handler"
  description = "Name of the function that has the lambda handler."
}

variable "lambda_runtime" {
  type        = string
  default     = "python3.7"
  description = "Runtime for the lambda function. Only tested with Python."
}

variable "layers" {
  type        = list(string)
  default     = []
  description = "Lambda layers to include with the function. Default is None."
}