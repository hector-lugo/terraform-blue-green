resource "aws_cloudwatch_log_group" "codepipeline" {
  name  = "/aws/codepipeline/${var.pipeline_name}"

  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "codebuild_planner" {
  name  = "/aws/codebuild/${var.project_name}"

  retention_in_days = 7
}

data "aws_iam_policy_document" "codebuild_assumerole" {
  statement {
    sid    = "AllowCodeBuildAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = format("%s-%s-role", var.project_name, var.prefix)
  assume_role_policy = data.aws_iam_policy_document.codebuild_assumerole.json
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid    = "AllowLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.codepipeline.arn}:*",
      "${aws_cloudwatch_log_group.codebuild_planner.arn}:*",
    ]
  }

  statement {
    sid    = "AllowS3"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
    ]

    resources = [
      var.artifact_bucket_arn,
      "${var.artifact_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "AllowCodeCommit"
    effect = "Allow"

    actions = [
      "codecommit:GitPull",
    ]

    resources = [
      var.repository_arn,
    ]
  }
}

resource "aws_iam_policy" "codebuild" {
  name        = format("%s-%s-policy", var.project_name, var.prefix)
  description = "CodeBuild access policy"
  policy      = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild.arn
}

resource "aws_codebuild_project" "project" {
  name           = var.project_name
  description    = "TF runner for pipeline"
  build_timeout  = "29"
  queued_timeout = "30"

  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type                = "CODEPIPELINE"
    name                = "pipeline-name"
    packaging           = "NONE"
    encryption_disabled = "false"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:4.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
  }

  source {
    type      = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codepipeline.name
    }
  }
}
