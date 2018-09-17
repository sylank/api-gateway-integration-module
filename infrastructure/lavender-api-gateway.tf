locals {
  region = "${data.aws_region.current.name}"
}

resource "random_string" "deployment_variable" {
  length  = 10
  special = false
}

resource "aws_api_gateway_account" "gateway" {
  cloudwatch_role_arn = "${aws_iam_role.cloudwatchlog.arn}"
}

resource "aws_iam_role" "cloudwatchlog" {
  name = "cloudwatchlog"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "cloudwatchlog" {
  name       = "cloudwatchlog"
  roles      = ["${aws_iam_role.cloudwatchlog.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.lavender_backend_deployment.stage_name}"
  method_path = "${aws_api_gateway_resource.reservation_root.path_part}/${aws_api_gateway_resource.reservation_enabled_resource.path_part}/${aws_api_gateway_method.reservation_enabled_method.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "lavender-backend-api"
  description = "Lavender backend services API gateway"
}

resource "aws_api_gateway_resource" "reservation_root" {
  path_part   = "reservation"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_resource" "reservation_enabled_resource" {
  path_part   = "enabled"
  parent_id   = "${aws_api_gateway_resource.reservation_root.id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_resource" "query_all_reservation_method_resource" {
  path_part   = "query"
  parent_id   = "${aws_api_gateway_resource.reservation_root.id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_resource" "create_reservation_resource" {
  path_part   = "create"
  parent_id   = "${aws_api_gateway_resource.reservation_root.id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_method" "reservation_enabled_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.reservation_enabled_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "query_all_reservation_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.query_all_reservation_method_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "create_reservation_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.create_reservation_resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.reservation_enabled_resource.id}"
  http_method = "${aws_api_gateway_method.reservation_enabled_method.http_method}"
  status_code = "200"
  depends_on  = ["aws_api_gateway_integration.reservation_enabled_integration"]
}

resource "aws_api_gateway_integration_response" "default" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.reservation_enabled_resource.id}"
  http_method = "${aws_api_gateway_method.reservation_enabled_method.http_method}"
  status_code       = "${aws_api_gateway_method_response.200.status_code}"
  selection_pattern = ""

  depends_on = ["aws_api_gateway_integration.reservation_enabled_integration"]
}

resource "aws_api_gateway_integration" "reservation_enabled_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.reservation_enabled_resource.id}"
  http_method             = "${aws_api_gateway_method.reservation_enabled_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.reservation_enabled_lambda.arn}/invocations"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = "${file("api_gateway_body_mapping.template")}"
  }
}

resource "aws_api_gateway_integration" "query_all_reservation_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.query_all_reservation_method_resource.id}"
  http_method             = "${aws_api_gateway_method.query_all_reservation_method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.query_all_reservation_lambda.arn}/invocations"
}

resource "aws_api_gateway_integration" "create_reservation_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.create_reservation_resource.id}"
  http_method             = "${aws_api_gateway_method.create_reservation_method.http_method}"
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.create_reservation_lambda.arn}/invocations"
}

resource "aws_api_gateway_deployment" "lavender_backend_deployment" {
  depends_on = [
    "aws_api_gateway_integration.reservation_enabled_integration",
    "aws_api_gateway_integration.query_all_reservation_integration",
    "aws_api_gateway_integration.create_reservation_integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "api"

  variables = {
    "deployed_at" = "${random_string.deployment_variable.result}"
  }
}
