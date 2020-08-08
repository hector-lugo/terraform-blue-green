data "aws_caller_identity" "current" {}

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
      "${var.pipeline_log_group_arn}:*",
      "${var.log_group_arn}:*"
    ]
  }

  statement {
    sid    = "AllowParamterStore"
    effect = "Allow"

    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]

    resources = [
      "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.account_id}:parameter/hlugo*"
    ]
  }

  statement {
    sid    = "AllowS3"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:Get*",
      "s3:List*"
    ]

    resources = [
      var.artifact_bucket_arn,
      "${var.artifact_bucket_arn}/*",
      var.terraform_backend_bucket_arn,
      "${var.terraform_backend_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "AllowCodeCommit"
    effect = "Allow"

    actions = [
      "codecommit:GitPull"
    ]

    resources = [
      var.repository_arn,
    ]
  }

  statement {
    sid    = "AllowEC2Access"
    effect = "Allow"

    actions = [
      "ec2:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowELBAccess"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "IAMAccess"
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "iam:CreateRole",
      "iam:PassRole",
      "iam:AttachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:ListAttachedRolePolicies",
      "iam:GetInstanceProfile"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AutoScalingAccess"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:CreateAutoScalingGroup"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "Route53Access"
    effect = "Allow"

    actions = [
      "route53:*"
    ]

    resources = [
      "*"
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
    buildspec = "deploy_buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name = var.pipeline_log_group_name
    }
  }
}
