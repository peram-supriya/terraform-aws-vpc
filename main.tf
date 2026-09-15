resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}



resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  # vpc association

  tags = local.igw_final_tags
}


resource "aws_subnet" "main" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.comman_tags, {
      #roboshop-dev.public.us-east-1a
      Name = "${var.project}-${var.environment}.public-${local.az_zones[count.index]}"
    }
  )
}