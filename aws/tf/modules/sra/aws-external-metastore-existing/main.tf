/**
 * Pulls HMS dependencies and initializes HMS schema in RDS via Databricks job
 */

locals {
  lib_dir = "modules/sra/aws-external-metastore-existing/lib"
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_secret_scope" "this" {
  name = "hms-secret-scope"
}

resource "databricks_secret_acl" "user_acl" {
  principal  = "users"
  permission = "READ"
  scope      = databricks_secret_scope.this.name
}

resource "databricks_secret_acl" "admin_acl" {
  principal  = "admins"
  permission = "MANAGE"
  scope      = databricks_secret_scope.this.name
}

resource "databricks_secret" "hms_pword" {
  key          = "hms-db-pword"
  string_value = var.rds_pword
  scope        = databricks_secret_scope.this.name
}

resource "databricks_secret" "hms_user" {
  key          = "hms-db-user"
  string_value = var.rds_user
  scope        = databricks_secret_scope.this.name
}

resource "databricks_secret" "hms_conn" {
  key          = "hms-db-conn"
  string_value = "jdbc:mysql://${var.rds_host}:${var.rds_port}/${var.hive_database}?useUnicode=true&characterEncoding=UTF-8&trustServerCertificate=true&useSSL=true"
  scope        = databricks_secret_scope.this.name
}

# resource "null_resource" "download_metastore_lib_hive" {
#   provisioner "local-exec" {
#     command = "[ ! -f apache-hive-${var.hive_lib_version}-bin.tar.gz ] && wget https://archive.apache.org/dist/hive/hive-${var.hive_lib_version}/apache-hive-${var.hive_lib_version}-bin.tar.gz || echo 'File already exists'"
#     interpreter = ["bash", "-c" ]
#     working_dir = local.lib_dir
#   }
# }

# resource "null_resource" "download_metastore_lib_hadoop" {
#   provisioner "local-exec" {
#     command = "[ ! -f hadoop-${var.hadoop_version}.tar.gz ] && wget https://archive.apache.org/dist/hadoop/common/hadoop-${var.hadoop_version}/hadoop-${var.hadoop_version}.tar.gz || echo 'File already exists'"
#     interpreter = ["bash", "-c" ]
#     working_dir = local.lib_dir
#   }
# }

# resource "null_resource" "download_metastore_lib_mariadb" {
#   provisioner "local-exec" {
#     command = "[ ! -f mariadb-java-client-2.7.3.jar ] && wget https://downloads.mariadb.com/Connectors/java/connector-java-2.7.3/mariadb-java-client-2.7.3.jar || echo 'File already exists'"
#     interpreter = ["bash", "-c" ]
#     working_dir = local.lib_dir
#   }
# }

# resource "databricks_dbfs_file" "this" {
#     depends_on = [null_resource.download_metastore_lib_mariadb,null_resource.download_metastore_lib_mariadb,null_resource.download_metastore_lib_hive]
#     for_each = fileset("${path.root}/${local.lib_dir}", "*[.jar|.tar.gz]")
#         source = "${path.root}/${local.lib_dir}/${each.value}"
#         path   = "/${var.dbfs_lib_location}/${each.value}"
# }