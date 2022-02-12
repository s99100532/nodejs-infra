variable "app_name" {
  type = string
}
variable "ec2_subnet_ids" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}


