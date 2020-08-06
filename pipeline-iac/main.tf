module "repository" {
  source = "./modules/repository"
}

module "s3" {
  source = "./modules/s3"
}

module "codebuild" {
  source = "./modules/codebuild"
  artifact_bucket_arn = module.s3.artifacts_bucket_arn
  repository_arn = module.repository.repository_arn
  pipeline_name = var.pipeline_name
}

module "codepipeline" {
  source = "./modules/codepipeline"
  artifact_bucket_arn = module.s3.artifacts_bucket_arn
  artifact_bucket_name = module.s3.artifacts_bucket_name
  repository_url = module.repository.repository_url
  repository_arn = module.repository.repository_arn
  repository_name = module.repository.repository_name
  codebuild_project = module.codebuild.project_name
  pipeline_name = var.pipeline_name
}