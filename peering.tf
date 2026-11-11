resource "aws_vpc_peering_connection" "vpc_peering" {
    count = var.is_peer_connection_required ? 1 : 0
    peer_vpc_id   = local.peering_id
    vpc_id        = aws_vpc.main.id
    auto_accept = true

    accepter {
        allow_remote_vpc_dns_resolution = true
    }

    requester {
        allow_remote_vpc_dns_resolution = true
    }

    tags = merge(local.common_tags, {
            Name = "${var.project}-${var.environment}-peering"
        })
}

resource "aws_route" "public_peering" {
    count = var.is_peer_connection_required ? 1 : 0
    route_table_id            = aws_route_table.public.id
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[count.index].id
    destination_cidr_block    = data.aws_vpc.default.cidr_block
    
}

resource "aws_route" "private_peering" {
    count = var.is_peer_connection_required ? 1 : 0
    route_table_id            = aws_route_table.private.id
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[count.index].id
    destination_cidr_block    = data.aws_vpc.default.cidr_block
    
}

resource "aws_route" "database_peering" {
    count = var.is_peer_connection_required ? 1 : 0
    route_table_id            = aws_route_table.database.id
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[count.index].id
    destination_cidr_block    = data.aws_vpc.default.cidr_block
    
}

resource "aws_route" "default_peering" {
    count = var.is_peer_connection_required ? 1 : 0
    route_table_id            = data.aws_route_table.default.id
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[count.index].id
    destination_cidr_block    = var.vpc_cidr
    
}
