# terraform-aws-ec2-tg-attach
Terraform module to attach ec2 instances to loadbalancers

## This module will take target groups and instace ids as input and will attach to repective target groups

### Example usage

```
module "use1_tgs_ec2_attach" {
  source = "../../../modules/aws-tg-ec2"

  clusterae_tgs = data.terraform_remote_state.infra.outputs.use1_cae_tg_arns
  clusterb_tgs  = data.terraform_remote_state.infra.outputs.use1_cb_tg_arns
  clusterc_tgs  = data.terraform_remote_state.infra.outputs.use1_cc_tg_arns

  clusterae_instance_ids = data.terraform_remote_state.infra.outputs.use1_clusterabe_instance_ids
  clusterb_instance_ids = data.terraform_remote_state.infra.outputs.use1_clusterabe_instance_ids
  clusterc_instance_ids = data.terraform_remote_state.infra.outputs.use1_clusterc_instance_ids
}


module "usw2_tgs_ec2_attach" {
  providers = { aws = aws.us-west-2 }

  source = "../../../modules/aws-tg-ec2"

  clusterae_tgs = data.terraform_remote_state.infra.outputs.usw2_cae_tg_arns
  clusterb_tgs  = data.terraform_remote_state.infra.outputs.usw2_cb_tg_arns
  clusterc_tgs  = data.terraform_remote_state.infra.outputs.usw2_cc_tg_arns

  clusterae_instance_ids = data.terraform_remote_state.infra.outputs.usw2_clusterabe_instance_ids
  clusterb_instance_ids = data.terraform_remote_state.infra.outputs.usw2_clusterabe_instance_ids
  clusterc_instance_ids = data.terraform_remote_state.infra.outputs.usw2_clusterc_instance_ids
}

```
