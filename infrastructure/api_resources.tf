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