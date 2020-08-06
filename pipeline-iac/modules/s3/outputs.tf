output "artifacts_bucket_arn" {
  value = aws_s3_bucket.artifacts_bucket.arn
}

output "artifacts_bucket_id" {
  value = aws_s3_bucket.artifacts_bucket.id
}

output "artifacts_bucket_name" {
  value = aws_s3_bucket.artifacts_bucket.bucket
}