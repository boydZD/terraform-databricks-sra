output "databricks_host" {
  description = "Host name of the workspace URL"
  value       = module.databricks_mws_workspace.workspace_url
}

# output "databricks_token" {
#   value     = module.databricks_mws_workspace.databricks_token
#   sensitive = true
# }

# output "vpc_id" {
#   value     = module.vpc[0].vpc_id
# }