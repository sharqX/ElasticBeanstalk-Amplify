#IAM
variable "iam_role" {
  type        = string
  description = "EC2 IAM Role"
}

variable "eb_service_role" {
  type        = string
  description = "ElasticBeanstalk Service Role"
}

variable "instance-profile" {
  type        = string
  description = "Instance Profile"
}

#VPC
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Range"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "Private CIDR Range"
}

variable "ap_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "Public CIDR Range"
}

#TargetGroup
variable "tg_port" {
  type        = number
  default     = 80
  description = "Port for Target Group"
}

variable "tg_protocol" {
  type        = string
  default     = "HTTP"
  description = "Protocol for Target Group"
}

#S3
# variable "bucket-name" {
#   type        = string
#   description = "S3 Bucket Name"
# }

# variable "app" {
#   type        = string
#   description = "App Name"
# }

#ElasticBeanstalk
variable "solution_stack_name" {
  type        = string
  description = "Solution Stack Name"
}

variable "InstanceType" {
  type        = string
  description = "Instace Type"

}

variable "mongourl" {
  type        = string
  description = "URL to connect to mongo atlas"
}

#HostedZone
variable "subdomain" {
  type        = string
  description = "Domain Name for app"
}

#ACM
variable "domain_name" {
  type        = string
  description = "Domain Name for ACM"
}

#Amplify
variable "repo" {
  type        = string
  description = "Repo url for the app"
}

variable "frontend_domain_name" {
  type        = string
  description = "Domain Name for the frontend"
}

variable "domain_prefix" {
  type        = string
  description = "Prefix 1st for domain name"
}

variable "domain_prefix_2" {
  type        = string
  description = "Prefix 2nd for domain name"
}

variable "branch_name" {
  type        = string
  default     = "main"
  description = "Repo Branch for Amplify"
}

variable "access_token" {
  type = string
  description = "github access token"
}

variable "env_var" {
  type = map(string)
  description = "Environment Variable for the frontend"

}