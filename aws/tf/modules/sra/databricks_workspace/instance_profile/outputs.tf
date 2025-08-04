output "instance_profile_arn" {
  value = aws_iam_instance_profile.shared.arn
}

output "role_arn" {
  value = aws_iam_role.role_for_s3_access.arn
}