# module "ext-hms" {
#   source = "./aws-external-metastore-rds"
#   providers = {
#     aws = aws
#     databricks = databricks.created_workspace
#   }

#   vpc_id = module.vpc[0].vpc_id
#   workspace_security_group_id = aws_security_group.sg[0].id

#   #databricks_workspace_url = module.sra.databricks_host
#   #databricks_workspace_token = module.sra.databricks_token

#   tags = {
#     Project = var.resource_prefix
#   }
#   region = var.region
#   project_name = var.resource_prefix

#   depends_on = [module.databricks_mws_workspace, module.uc_assignment]

# }