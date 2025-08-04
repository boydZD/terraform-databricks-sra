module "instance_profile" {
  source = "./databricks_workspace/instance_profile"
  providers = {
    databricks = databricks.created_workspace
  }

  #resource_prefix = var.resource_prefix
  crossaccount_role_name = aws_iam_role.cross_account_role.name
  external_id = var.databricks_account_id
  resource_prefix = var.resource_prefix

  depends_on = [module.databricks_mws_workspace]
}
module "ext-hms" {
  source = "./aws-external-metastore-existing"
  providers = {
    aws = aws
    databricks = databricks.created_workspace
  }

  hive_database = "organization0"
  rds_host = "jb-test-ext-hms-v2.cj11tymkwz5w.us-west-2.rds.amazonaws.com"
  rds_user = "databricks"
  rds_pword = "Databricks2025"
  hive_version = "0.13.0"
  instance_profile_arn = module.instance_profile.instance_profile_arn

  tags = {
    Project = var.resource_prefix
  }
  
  project_name = var.resource_prefix

  depends_on = [module.databricks_mws_workspace, module.uc_assignment, module.instance_profile]

}

# resource "databricks_storage_credential" "external_hms" {
#   name = "${var.resource_prefix}-external-hms-sc"
#   aws_iam_role {
#     role_arn = module.instance_profile.role_arn
#   }
#   isolation_mode = "ISOLATION_MODE_ISOLATED"
#   depends_on = [module.databricks_mws_workspace, module.uc_assignment, module.instance_profile]
# }

# resource "databricks_external_location" "workspace_catalog_external_location" {
#   name            = "${var.resource_prefix}-external-hms-el"
#   url             = "s3://jboyd-bucket-west2/"
#   credential_name = databricks_storage_credential.external_hms.id
#   comment         = "External location for catalog HMS"
#   isolation_mode  = "ISOLATION_MODE_ISOLATED"
#   #depends_on      = [aws_iam_policy_attachment.unity_catalog_attach, time_sleep.wait_60_seconds]
# }