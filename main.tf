##########################
# VPC peering connection #
##########################
resource "aws_vpc_peering_connection" "this" {
  provider      = var.aws_this
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.this_vpc_id
  peer_region   = data.aws_region.peer.name
  tags          = merge(var.tags, tomap({ "Side" = local.same_acount_and_region ? "Both" : "Requester" }))
  # hardcoded
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

######################################
# VPC peering accepter configuration #
######################################
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider                  = var.aws_peer
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = var.auto_accept_peering
  tags                      = merge(var.tags, tomap({ "Side" = local.same_acount_and_region ? "Both" : "Accepter" }))
}

#######################
# VPC peering options #
#######################
resource "aws_vpc_peering_connection_options" "this" {
  provider                  = aws.this
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_accepter.id

  requester {
    allow_remote_vpc_dns_resolution = var.this_dns_resolution
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_accepter.id

  accepter {
    allow_remote_vpc_dns_resolution = var.peer_dns_resolution
  }
}

###################
# This VPC Routes #  Route from THIS route table to PEER cidr
###################
resource "aws_route" "this_routes" {
  provider = aws.this
  # Only create routes for this route table if input dictates it, and in that case, for all combinations
  count                     = var.from_this ? length(local.this_routes) : 0
  route_table_id            = local.this_routes[count.index].rts_id
  destination_cidr_block    = local.this_routes[count.index].dest_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

###################
# Peer VPC Routes #  Route from PEER route table to THIS cidr
###################
resource "aws_route" "peer_routes" {
  provider = aws.peer
  # Only create routes for peer route table if input dictates it, and in that case, for all combinations
  count                     = var.from_peer ? length(local.peer_routes) : 0
  route_table_id            = local.peer_routes[count.index].rts_id
  destination_cidr_block    = local.peer_routes[count.index].dest_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
