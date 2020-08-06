data "aws_caller_identity" "current" { }

resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = format("%s-pipeline-bucket", var.prefix)
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = merge(
    {
      "Name" = format("%sPipelineArtifactsBucket", var.prefix)
    },
    var.tags
  )
}