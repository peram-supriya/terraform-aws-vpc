locals {
    comman_tags = {
        project = "roboshop"
        environment = terraform.workspace
        terraform = "true"

    }
    vpc_final_tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}"
        },
        var.vpc_tags

  )
    
}