resource "aws_iam_role" "codecommit-event-role" {
  name = format("%s-%s-codecommit-event-role", var.pipeline_name, var.prefix)

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

# Allow CloudWatch Events to start a CodePipline pipeline
resource "aws_iam_policy" "codecommit-event-policy" {
  name        = format("%s-%s-codecommit-event-policy", var.pipeline_name, var.prefix)
  description = "cloud-native-codepipeline-policy-2"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codepipeline:StartPipelineExecution"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "cloud-native-codepipeline-attach-2" {
  name       = "cloud-native-codepipeline-attach-2"
  roles      = [aws_iam_role.codecommit-event-role.name]
  policy_arn = aws_iam_policy.codecommit-event-policy.arn
}

resource "aws_cloudwatch_event_rule" "client-donation-reports-codepipeline-notifications" {
  name        = "client-donation-reports-codepipeline-notifications"
  description = "CodePipeline notifications for client-donation-reports"

  event_pattern = <<PATTERN
{
  "source": [ "aws.codecommit" ],
  "detail-type": [ "CodeCommit Repository State Change" ],
  "resources": [ "${var.repository_arn}" ],
  "detail": {
     "event": [
       "referenceCreated",
       "referenceUpdated"],
     "referenceType":["branch"],
     "referenceName": ["master"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "client-donation-reports-ecr-target" {
  rule      = aws_cloudwatch_event_rule.client-donation-reports-codepipeline-notifications.name
  role_arn  = aws_iam_role.codecommit-event-role.arn
  arn       = aws_codepipeline.main.arn
}

data "aws_iam_policy_document" "codepipeline_assumerole" {
  statement {
    sid    = "AllowCodePipelineAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codepipeline.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = format("%s-%s-role", var.pipeline_name, var.prefix)
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assumerole.json
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    sid    = "AllowS3"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
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
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
    ]

    resources = [
      var.repository_arn,
    ]
  }

  statement {
    sid    = "AllowCodeBuild"
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds", # TODO: *
      "codebuild:StartBuild",     # TODO: specific
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatch"
    effect = "Allow"

    actions = [
      "cloudwatch:*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "codepipeline" {
  name        = format("%s-%s-policy", var.pipeline_name, var.prefix)
  description = "CodePipeline access policy"
  policy      = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}

resource "aws_codepipeline" "main" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    type     = "S3"
    location = var.artifact_bucket_name
  }

  stage {
    name = "Source"

    action {
      name             = "FetchCode"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      run_order        = 1
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName       = var.repository_name
        BranchName           = "master"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["ApplicationArtifacts"]

      configuration = {
        ProjectName          = var.codebuild_project
      }
    }
  }
}