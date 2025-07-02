# module "harden_firewall" {
#   source = "./firewall"
#   providers = {
#     aws = aws
#   }

#   vpc_id                = module.vpc[0].vpc_id
#   vpc_cidr_range        = var.vpc_cidr_range
#   public_subnets_cidr   = module.vpc[0].public_subnets_cidr_blocks
#   private_subnets_cidr  = module.vpc[0].private_subnets_cidr_blocks
#   private_subnet_rt     = module.vpc[0].private_route_table_ids
#   firewall_subnets_cidr = ["10.0.63.0/28", "10.0.63.64/28", "10.0.63.128/28"]
#   firewall_allow_list   = ["mdb7sywh50xhpr.chkweekm4xjq.us-east-1.rds.amazonaws.com","cloud.databricks.com"]
#   #hive_metastore_fqdn   = <HMS FQDN from: https://docs.databricks.com/en/resources/ip-domain-region.html#rds-addresses-for-legacy-hive-metastore>
#   hive_metastore_fqdn   = "mdb7sywh50xhpr.chkweekm4xjq.us-east-1.rds.amazonaws.com"
#   availability_zones    = var.availability_zones
#   region                = var.region
#   resource_prefix       = var.resource_prefix

#   depends_on = [module.databricks_mws_workspace]
# }