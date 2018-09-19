resource "aws_api_gateway_account" "gateway" {
  cloudwatch_role_arn = "${aws_iam_role.cloudwatchlog.arn}"
}

resource "aws_iam_role" "cloudwatchlog_role" {
  name = "gateway_cloudwatchlog"

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

resource "aws_iam_policy_attachment" "cloudwatchlog_attachment" {
  name       = "${var.api_name}_logs"
  roles      = ["${aws_iam_role.cloudwatchlog_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_method_settings" "settings_enabled" {
  rest_api_id = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"
  method_path = "${var.root_path}/${aws_api_gateway_resource.resource.path_part}/${aws_api_gateway_method.method.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "${var.log_level}"
  }
}

resource "aws_cloudwatch_log_group" "gateway_logging" {
  name = "API-Gateway-Execution-Logs_${var.rest_api_id}/${var.stage_name}"

  retention_in_days = "${var.retention_in_days}"
}
