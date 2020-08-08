data "aws_s3_bucket" "terraform_backend_bucket" {
  bucket = "xpresso-terraform"
}

module "repository" {
  source = "./modules/repository"
}

module "s3" {
  source = "./modules/s3"
}

module "cloudwatch_logs" {
  source = "./modules/cloudwatch_logs"
  pipeline_name = var.pipeline_name
}

module "build_app" {
  source = "./modules/build_app"
  artifact_bucket_arn = module.s3.artifacts_bucket_arn
  repository_arn = module.repository.repository_arn
  log_group_arn = module.cloudwatch_logs.build_project_log_group_arn
  pipeline_log_group_name = module.cloudwatch_logs.pipeline_log_group_name
  pipeline_log_group_arn = module.cloudwatch_logs.pipeline_log_group_arn
  pipeline_name = var.pipeline_name
  terraform_backend_bucket_arn = data.aws_s3_bucket.terraform_backend_bucket.arn
}

module "deploy_app" {
  source = "./modules/deploy_app"
  artifact_bucket_arn = module.s3.artifacts_bucket_arn
  repository_arn = module.repository.repository_arn
  log_group_arn = module.cloudwatch_logs.build_project_log_group_arn
  pipeline_log_group_name = module.cloudwatch_logs.pipeline_log_group_name
  pipeline_log_group_arn = module.cloudwatch_logs.pipeline_log_group_arn
  pipeline_name = var.pipeline_name
  terraform_backend_bucket_arn = data.aws_s3_bucket.terraform_backend_bucket.arn
}

module "codepipeline" {
  source = "./modules/codepipeline"
  artifact_bucket_arn = module.s3.artifacts_bucket_arn
  artifact_bucket_name = module.s3.artifacts_bucket_name
  repository_url = module.repository.repository_url
  repository_arn = module.repository.repository_arn
  repository_name = module.repository.repository_name
  build_project = module.build_app.project_name
  deployment_project = module.deploy_app.project_name
  pipeline_name = var.pipeline_name
}