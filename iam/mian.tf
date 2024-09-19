variable "iam_role" {}
variable "instance-profile" {}
variable "eb_service_role" {}

output "aws-elasticbeanstalk-ec2-instance-profile" {
  value = aws_iam_instance_profile.eb_instance_profile.name
}

output "aws-elasticbeanstalk-service-role" {
  value = data.aws_iam_role.eb_service_role.arn
}

data "aws_iam_role" "eb_ec2_role" {
  name = var.iam_role
}

data "aws_iam_role" "eb_service_role" {
  name = var.eb_service_role
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = var.instance-profile
  role = data.aws_iam_role.eb_ec2_role.name
}
