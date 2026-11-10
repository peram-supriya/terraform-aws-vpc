locals {
    common_tags = {
        project = var.project
        environment = var.environment
    }

    final_vpc_tags = merge(local.common_tags, {
        Name = "${var.project}-${var.environment}"
    })
}

