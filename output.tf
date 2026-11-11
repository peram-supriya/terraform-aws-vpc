 output "az" {
  value = data.aws_availability_zones.available
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}