/**
 * Creates a cluster policy to set ENV variables necessary for connection to the external HMS
 */

locals {
  default_policy = {
    "spark_conf.spark.databricks.sql.initial.catalog.name" = { 
      "type": "fixed", 
      "value": "hive_metastore",
      "hidden": false
    },
    "spark_conf.spark.hadoop.javax.jdo.option.ConnectionURL": {
      "type": "fixed",
      "value": "{{secrets/${databricks_secret_scope.this.name}/${databricks_secret.hms_conn.key}}}",
      "hidden": false
    },
    "spark_conf.spark.hadoop.javax.jdo.option.ConnectionDriverName": {
      "type": "fixed",
      "value": "org.mariadb.jdbc.Driver",
      "hidden": false
    },
    "spark_conf.spark.databricks.delta.preview.enabled": {
      "type": "fixed",
      "value": "true",
      "hidden": false
    },
    "spark_conf.spark.hadoop.javax.jdo.option.ConnectionUserName": {
      "type": "fixed",
      "value": "{{secrets/${databricks_secret_scope.this.name}/${databricks_secret.hms_user.key}}}",
      "hidden": false
    },
    "spark_conf.spark.hadoop.javax.jdo.option.ConnectionPassword": {
      "type": "fixed",
      "value": "{{secrets/${databricks_secret_scope.this.name}/${databricks_secret.hms_pword.key}}}",
      "hidden": false
    },
    "spark_conf.spark.sql.hive.metastore.version": {
      "type": "fixed",
      "value": "${var.hive_version}",
      "hidden": false
    },
    "cluster_type": {
        "type": "allowlist",
        "values": ["all-purpose","jobs"]
        "hidden" : true
    } 
  }
}

resource "databricks_cluster_policy" "this" {
  name       = "metastore cluster policy"
  definition = jsonencode(local.default_policy)
}

resource "databricks_permissions" "can_use_cluster_policyinstance_profile" {
  cluster_policy_id = databricks_cluster_policy.this.id
  access_control {
    group_name       = "users"
    permission_level = "CAN_USE"
  }
}