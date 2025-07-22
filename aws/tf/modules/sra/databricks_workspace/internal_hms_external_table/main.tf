data "aws_iam_policy_document" "assume_role_for_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
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