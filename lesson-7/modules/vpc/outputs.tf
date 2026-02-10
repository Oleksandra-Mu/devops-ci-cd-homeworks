output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [for s in aws_subnet.private : s.id]
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = [for s in aws_subnet.public : s.cidr_block]
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = [for s in aws_subnet.private : s.cidr_block]
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = [for k, n in aws_nat_gateway.this : n.id]
}
