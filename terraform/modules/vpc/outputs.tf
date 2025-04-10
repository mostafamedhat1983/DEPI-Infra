output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "List of IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "nat_gateway_ips" {
  description = "List of public IP addresses associated with the NAT Gateways."
  value       = aws_eip.nat[*].public_ip
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}