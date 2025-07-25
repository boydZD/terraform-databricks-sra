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

  tags = {
    Project = var.resource_prefix
  }
  
  project_name = var.resource_prefix

  depends_on = [module.databricks_mws_workspace, module.uc_assignment]

}