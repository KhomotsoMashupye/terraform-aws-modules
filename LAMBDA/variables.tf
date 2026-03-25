variable "aws_region" { type = string, default = "af-south-1" }

variable "lambda_function_name" { type = string }
variable "lambda_role_name" { type = string }
variable "lambda_handler" { type = string, default = "index.handler" }
variable "lambda_runtime" { type = string, default = "nodejs20.x" }
variable "lambda_zip_file" { type = string }
variable "lambda_environment" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type = map(string)
  default = { Environment = "dev" }
}