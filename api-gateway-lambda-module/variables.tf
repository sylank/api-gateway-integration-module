resource "random_string" "deployment_variable" {
  length  = 10
  special = false
}

variable "api_name" {}

variable "api_description" {}

variable "stage_name" {
  default = "api"
}

variable "deployed_at" {
  default = "${random_string.deployment_variable.result}"
}

variable "region" {}

variable "lambda_function_arn" {}

variable "method_type" {}

variable "root_path" {}

variable "path_url" {}

variable "status_200" {
  default = "200"
}

variable "status_default" {
  default = "${var.status_200}"
}

variable "default_pattern" {
  default = ""
}

variable "log_level" {
  default = "INFO"
}

variable "retention_in_days" {
  default = "7"
}
