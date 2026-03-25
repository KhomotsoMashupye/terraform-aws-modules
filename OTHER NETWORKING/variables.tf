# General Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "af-south-1"
}


variable "route53_zone_name" {
  description = "Private hosted zone name"
  type        = string
  default     = "placeholder.local"
}

variable "dx_gateway_asn" {
  description = "Autonomous system number for Direct Connect Gateway"
  type        = number
  default     = 65000
}