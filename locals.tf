locals {
    common_tags = {
        project = var.project
        environment = var.environment
    }

    final_vpc_tags = merge(local.common_tags, {
        Name = "${var.project}"
    })

    final_igw_tags = merge(local.common_tags, {
        Name = "${var.project}-${var.environment}"
    })

    az_zones = slice(data.aws_availability_zones.available.names, 0, 2)


    peering_id = data.aws_vpc.default.id
    
}

