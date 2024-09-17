variable "eb-app-name" {}
variable "bucket" {}
variable "object" {}

resource "aws_elastic_beanstalk_application" "mern-backend" {
  name = var.eb-app-name
}

resource "aws_elastic_beanstalk_application_version" "mern-backend-version" {
  name = "mern-app-backend-version"
  application = var.eb-app-name
  bucket = var.bucket
  key = var.object
}

resource "aws_elastic_beanstalk_environment" "mern-backend-env" {
  
}
