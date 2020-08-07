output "pipeline_log_group_arn" {
  value = aws_cloudwatch_log_group.codepipeline.arn
}

output "pipeline_log_group_name" {
  value = aws_cloudwatch_log_group.codepipeline.name
}

output "build_project_log_group_arn" {
  value = aws_cloudwatch_log_group.codebuild_build.arn
}

output "deployment_project_log_group_arn" {
  value = aws_cloudwatch_log_group.codebuild_deploy.arn
}
