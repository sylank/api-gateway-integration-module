resource "aws_api_gateway_method_response" "200_enabled" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.reservation_enabled_resource.id}"
  http_method = "${aws_api_gateway_method.reservation_enabled_method.http_method}"
  status_code = "200"
  depends_on  = ["aws_api_gateway_integration.reservation_enabled_integration"]
}

resource "aws_api_gateway_integration_response" "default_enabled" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.reservation_enabled_resource.id}"
  http_method = "${aws_api_gateway_method.reservation_enabled_method.http_method}"
  status_code       = "${aws_api_gateway_method_response.200_enabled.status_code}"
  selection_pattern = ""

  depends_on = ["aws_api_gateway_integration.reservation_enabled_integration"]
}

resource "aws_api_gateway_method_response" "200_query_all" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.query_all_reservation_method_resource.id}"
  http_method = "${aws_api_gateway_method.query_all_reservation_method.http_method}"
  status_code = "200"
  depends_on  = ["aws_api_gateway_integration.query_all_reservation_integration"]
}

resource "aws_api_gateway_integration_response" "default_query_all" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.query_all_reservation_method_resource.id}"
  http_method = "${aws_api_gateway_method.query_all_reservation_method.http_method}"
  status_code       = "${aws_api_gateway_method_response.200_query_all.status_code}"
  selection_pattern = ""

  depends_on = ["aws_api_gateway_integration.query_all_reservation_integration"]
}

resource "aws_api_gateway_method_response" "200_create" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.create_reservation_resource.id}"
  http_method = "${aws_api_gateway_method.create_reservation_method.http_method}"
  status_code = "200"
  depends_on  = ["aws_api_gateway_integration.create_reservation_integration"]
}

resource "aws_api_gateway_integration_response" "default_create" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.create_reservation_resource.id}"
  http_method = "${aws_api_gateway_method.create_reservation_method.http_method}"
  status_code       = "${aws_api_gateway_method_response.200_create.status_code}"
  selection_pattern = ""

  depends_on = ["aws_api_gateway_integration.create_reservation_integration"]
}