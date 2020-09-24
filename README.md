# lambda-function
A simple, flexible module for spinning up AWS Lambda functions with API Gateway included.

# Getting started

The bare minimum usage of this module looks something like this:

```terraform
module "lf" {
  source                  = "github.com/zack-klein/lambda-function"
  api_gateway_name        = "test-lambda"
  lambda_name             = "test-lambda"
  lambda_source_s3_bucket = "my-lambda-functions"
  lambda_source_s3_key    = "handler.zip"
}
```

This will honestly get you pretty far if you don't need to talk to any other AWS resources.

# Minimum permissions

This ships with X-Ray and logging in Cloudwatch for convenience, so if you write your own policy make sure you include the following permissions:
```json
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
```

# Module Reference

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_gateway\_domain | n/a | `string` | `null` | no |
| api\_gateway\_name | n/a | `string` | n/a | yes |
| lambda\_handler\_file\_name | Name of the file that has the lambda handler. | `string` | `"handler"` | no |
| lambda\_handler\_function\_name | Name of the function that has the lambda handler. | `string` | `"handler"` | no |
| lambda\_iam\_policy | n/a | `string` | `"{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"logs:CreateLogGroup\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\"\n      ],\n      \"Resource\": \"arn:aws:logs:*:*:*\",\n      \"Effect\": \"Allow\"\n    },\n    {\n      \"Action\": [\n        \"xray:PutTraceSegments\"\n      ],\n      \"Resource\": \"*\",\n      \"Effect\": \"Allow\"\n    }\n  ]\n}\n"` | no |
| lambda\_name | n/a | `string` | n/a | yes |
| lambda\_runtime | Runtime for the lambda function. Only tested with Python. | `string` | `"python3.7"` | no |
| lambda\_source\_s3\_bucket | n/a | `string` | n/a | yes |
| lambda\_source\_s3\_key | n/a | `string` | n/a | yes |
| region | AWS region. | `string` | `"us-east-1"` | no |
| stage\_name | n/a | `string` | `"latest"` | no |
| timeout | n/a | `number` | `10` | no |
| xray\_tracing\_mode | n/a | `string` | `"Active"` | no |

## Outputs

| Name | Description |
|------|-------------|
| api\_gateway\_rest\_api | n/a |
| iam\_role | n/a |
| lambda\_function | n/a |
