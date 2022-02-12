variable "cluster_name" {
  type = string
}
variable "ec2_subnet_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}

variable "ec2_key_name" {
  type = string
}
