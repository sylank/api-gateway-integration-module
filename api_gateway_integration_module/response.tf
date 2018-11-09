resource "aws_api_gateway_method_response" "200" {
  count = "${var.cors_option_method==true?0:1}"

  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${var.status_200}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "${var.cors_enabled==true}"
  }

  depends_on = ["aws_api_gateway_integration.integration"]
}

resource "aws_api_gateway_integration_response" "default_integration_response" {
  count = "${var.cors_option_method==true?0:1}"

  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.resource.id}"
  http_method       = "${aws_api_gateway_method.method.http_method}"
  status_code       = "${var.status_default}"
  selection_pattern = "${var.default_pattern}"

  depends_on = ["aws_api_gateway_integration.integration"]
}

resource "aws_api_gateway_method_response" "options_200" {
  count = "${var.cors_option_method==true?1:0}"

  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.cors_resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = ["aws_api_gateway_integration.integration"]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  count = "${var.cors_option_method==true?1:0}"

  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.cors_resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "${aws_api_gateway_method_response.options_200.status_code}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = ["aws_api_gateway_method_response.options_200"]
}
