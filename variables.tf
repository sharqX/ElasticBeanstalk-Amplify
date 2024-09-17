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

#S3

variable "bucket-name" {
  type        = string
  description = "S3 Bucket Name"
}

variable "app" {
  type        = string
  description = "App Name"
}