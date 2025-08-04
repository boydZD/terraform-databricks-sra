data "aws_iam_policy_document" "assume_role_for_ec2" {
  # allow classic compute clusters in the same AWS account to attach as an instance profile
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }

  # allow UC to use this role as a storage credential
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = [
        "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL",
        "arn:aws:iam::332745928618:role/shared-ec2-role-for-s3"
      ]
      type = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["${var.external_id}"]
    }
  }
  #depends_on = [ aws_iam_role.role_for_s3_access ]
}
resource "aws_iam_role" "role_for_s3_access" {
  name               = "shared-ec2-role-for-s3"
  description        = "Role for shared access"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_ec2.json
}
data "aws_iam_policy_document" "pass_role_for_s3_access" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.role_for_s3_access.arn]
  }
}
resource "aws_iam_policy" "pass_role_for_s3_access" {
  name   = "shared-pass-role-for-s3-access"
  path   = "/"
  policy = data.aws_iam_policy_document.pass_role_for_s3_access.json
}
resource "aws_iam_role_policy_attachment" "cross_account" {
  policy_arn = aws_iam_policy.pass_role_for_s3_access.arn
  role       = var.crossaccount_role_name
}
resource "aws_iam_instance_profile" "shared" {
  name = "shared-instance-profile"
  role = aws_iam_role.role_for_s3_access.name
}

resource "databricks_instance_profile" "this" {
  instance_profile_arn = aws_iam_instance_profile.shared.arn
}

data "databricks_group" "users" {
  display_name = "users"
}

resource "databricks_group_instance_profile" "all" {
  group_id            = data.databricks_group.users.id
  instance_profile_id = databricks_instance_profile.this.id
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "instance_profile_s3" {
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
  role = aws_iam_role.role_for_s3_access.name
}

resource "databricks_storage_credential" "external_hms" {
  name = "${var.resource_prefix}-external-hms-sc"
  aws_iam_role {
    role_arn = aws_iam_role.role_for_s3_access.arn
  }
  isolation_mode = "ISOLATION_MODE_ISOLATED"
  #depends_on = [module.databricks_mws_workspace, module.uc_assignment, module.instance_profile]
}

resource "databricks_external_location" "workspace_catalog_external_location" {
  name            = "${var.resource_prefix}-external-hms-el"
  url             = "s3://jboyd-bucket-west2/"
  credential_name = databricks_storage_credential.external_hms.id
  comment         = "External location for catalog HMS"
  isolation_mode  = "ISOLATION_MODE_ISOLATED"
  #depends_on      = [aws_iam_policy_attachment.unity_catalog_attach, time_sleep.wait_60_seconds]
}