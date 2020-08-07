resource "aws_cloudwatch_log_group" "codepipeline" {
  name  = "/aws/codepipeline/${var.pipeline_name}"

  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "codebuild_build" {
  name  = "/aws/codebuild/${var.build_project_name}"

  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "codebuild_deploy" {
  name  = "/aws/codebuild/${var.deploy_project_name}"

  retention_in_days = 7
}