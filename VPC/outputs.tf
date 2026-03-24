output "vpc_id" {
  value = aws_vpc.placeholder_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.placeholder_public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.placeholder_private[*].id
}

output "public_route_table_id" {
  value = aws_route_table.placeholder_public_rt.id
}

output "private_route_table_ids" {
  value = aws_route_table.placeholder_private_rt[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.placeholder_igw.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.placeholder_nat[*].id
}