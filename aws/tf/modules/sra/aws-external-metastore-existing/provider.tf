/**
 * External metastore pattern with AWS RDS
 * 
 * This reference architecture can be described as the following diagram:
 * 
 */
 terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}