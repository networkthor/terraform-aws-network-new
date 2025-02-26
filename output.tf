output "vpc_id" {
  value = aws_vpc.my_vpc.id
  description = "VPC ID"
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
  description = "Public Subnet 1 ID"
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets[*].id
  description = "Private Subnet 1 ID"
}

output "list_of_availability_zone_names" {
  value = data.aws_availability_zones.available.names
  description = "List of availability zones"
}