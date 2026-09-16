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

#public subnet
resource "aws_subnet" "public" {
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

#private subnet

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    local.comman_tags, {
      #roboshop-dev.private.us-east-1a
      Name = "${var.project}-${var.environment}.private-${local.az_zones[count.index]}"
    }
  )
}

# database subnet
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    local.comman_tags, {
      #roboshop-dev.databse.us-east-1a
      Name = "${var.project}-${var.environment}.database-${local.az_zones[count.index]}"
    }
  )
}

#public route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.comman_tags, {
      #roboshop-dev.databse.us-east-1a
      Name = "${var.project}-${var.environment}.public"
    },
    var.public_route_table_tags
  )
}

#private route table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.comman_tags, {
      #roboshop-dev.databse.us-east-1a
      Name = "${var.project}-${var.environment}.private"
    },
    var.private_route_table_tags
  )
}

#database route

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.comman_tags, {
      #roboshop-dev.databse.us-east-1a
      Name = "${var.project}-${var.environment}.database"
    },
    var.database_route_table_tags
  )
}

resource "aws_route" "pulic" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id         = aws_internet_gateway.main.id
}

resource "aws_eip" "nat" {
  domain      = "vpc"

   tags = merge(
    local.comman_tags, {
      #roboshop-dev.databse.us-east-1a
      Name = "${var.project}-${var.environment}.nat"
    },
    var.eip_tags
   )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # we are creating this in us-east-la AZ

  tags = merge(
    local.comman_tags, {
      #roboshop-dev.databse.us-east-1a
      Name = "${var.project}-${var.environment}"
    },
    var.nat_gate_way_tags
   )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}