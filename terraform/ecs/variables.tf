variable "app_name" {
  type = string
}
variable "ec2_subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type        = list(string)
  description = "extra security groups for the cluster"
}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}


