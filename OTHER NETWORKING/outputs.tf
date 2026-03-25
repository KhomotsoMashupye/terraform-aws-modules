# VPC Endpoints
output "s3_vpc_endpoint_id" {
  value       = aws_vpc_endpoint.s3_endpoint.id
  description = "ID of the S3 VPC Endpoint"
}

output "dynamodb_vpc_endpoint_id" {
  value       = aws_vpc_endpoint.dynamodb_endpoint.id
  description = "ID of the DynamoDB VPC Endpoint"
}

# VPN Gateway
output "vpn_gateway_id" {
  value       = aws_vpn_gateway.vgw.id
  description = "ID of the Virtual Private Gateway"
}

# Direct Connect Gateway
output "dx_gateway_id" {
  value       = aws_dx_gateway.direct_connect.id
  description = "ID of the Direct Connect Gateway"
}

# Network ACL
output "private_nacl_id" {
  value       = aws_network_acl.private_nacl.id
  description = "ID of the private NACL"
}

# Route 53
output "private_hosted_zone_id" {
  value       = aws_route53_zone.private_zone.id
  description = "ID of the private hosted zone"
}