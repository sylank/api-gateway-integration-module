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

resource "aws_api_gateway_method_settings" "settings_enabled" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.lavender_backend_deployment.stage_name}"
  method_path = "${aws_api_gateway_resource.reservation_root.path_part}/${aws_api_gateway_resource.reservation_enabled_resource.path_part}/${aws_api_gateway_method.reservation_enabled_method.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}