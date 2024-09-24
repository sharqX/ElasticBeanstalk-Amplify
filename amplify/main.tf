variable "aws_amplify_app_name" {}
variable "repository" {}
variable "frontend_domain_name" {}
variable "domain_prefix" {}
variable "domain_prefix_2" {}
variable "branch_name" {}
variable "access_token" {}
variable "env_var" {}

resource "aws_amplify_app" "bookStoreFrontend" {
  name       = var.aws_amplify_app_name
  repository = var.repository
  access_token = var.access_token
  environment_variables = var.env_var
}

resource "aws_amplify_branch" "repo_branch" {
  app_id      = aws_amplify_app.bookStoreFrontend.id
  branch_name = var.branch_name
}

resource "aws_amplify_domain_association" "example" {
  app_id      = aws_amplify_app.bookStoreFrontend.id
  domain_name = var.frontend_domain_name

  sub_domain {
    branch_name = aws_amplify_branch.repo_branch.branch_name
    prefix      = var.domain_prefix
  }

  sub_domain {
    branch_name = aws_amplify_branch.repo_branch.branch_name
    prefix      = var.domain_prefix_2
  }
}