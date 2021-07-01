data "aws_instance" "clusterb_instance_ips" {
  count = length(var.clusterb_instance_ids)
  instance_id = element(var.clusterb_instance_ids, count.index)
}

data "aws_instance" "clusterc_instance_ips" {
  count = length(var.clusterc_instance_ids)
  instance_id = element(var.clusterc_instance_ids, count.index)
}

locals {
 # Fethig IPS as these two need to be attached to Network LB
 clusterb_instance_ips = data.aws_instance.clusterb_instance_ips.*.private_ip
 clusterc_instance_ips = data.aws_instance.clusterc_instance_ips.*.private_ip
}

/*locals {
#Either way it works so directly used for loop inside resource rather extra local variables
map = {
    for pair in setproduct(var.clusterae_tgs,var.clusterae_instance_ids) :
        "${pair[0]}${pair[1]}" => { target_group = pair[0], instance_id = pair[1] }
  }
  list = keys(local.map)
  tg = local.map[local.list.3].target_group
  id = local.map[local.list.3].instance_id
}


resource "aws_lb_target_group_attachment" "clusterae" {
 for_each = toset(local.list)
  target_group_arn = local.map[each.key].target_group
  target_id = local.map[each.key].instance_id
}
*/

resource "aws_lb_target_group_attachment" "clustera" {
  for_each = {
    for pair in setproduct(var.clusterae_tgs,var.clusterae_instance_ids) : "${pair[0]} ${pair[1]}" => {
      target_group_arn = pair[0]
      target_id        = pair[1]
    }
  }

  target_group_arn = each.value.target_group_arn
  target_id        = each.value.target_id
}

resource "aws_lb_target_group_attachment" "clusterb" {
  for_each = {
    for pair in setproduct(var.clusterb_tgs, local.clusterb_instance_ips) : "${pair[0]} ${pair[1]}" => {
      target_group_arn = pair[0]
      target_id        = pair[1]
    }
  }

  target_group_arn = each.value.target_group_arn
  target_id        = each.value.target_id
}

resource "aws_lb_target_group_attachment" "clusterc_rmq" {
  for_each = {
    for pair in setproduct(slice(var.clusterc_tgs, 0, 2), local.clusterc_instance_ips) : "${pair[0]} ${pair[1]}" => {
      target_group_arn = pair[0]
      target_id        = pair[1]
    }
  }

  target_group_arn = each.value.target_group_arn
  target_id        = each.value.target_id
}

resource "aws_lb_target_group_attachment" "clusterc_presto" {
  for_each = {
    for pair in setproduct(slice(var.clusterc_tgs, 2, 3), var.clusterc_instance_ids) : "${pair[0]} ${pair[1]}" => {
      target_group_arn = pair[0]
      target_id        = pair[1]
    }
  }

  target_group_arn = each.value.target_group_arn
  target_id        = each.value.target_id
}
