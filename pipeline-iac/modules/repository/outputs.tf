output "repository_url" {
  value = aws_codecommit_repository.repository.clone_url_http
}

output "repository_name" {
  value = aws_codecommit_repository.repository.repository_name
}

output "repository_arn" {
  value = aws_codecommit_repository.repository.arn
}