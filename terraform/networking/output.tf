output "default_security_group_id" {
  value = aws_default_security_group.default.id
}
output "default_subnet_ids" {
  value = [aws_default_subnet.first.id, aws_default_subnet.second.id]
}
output "default_vpc_id" {
  value = aws_default_vpc.default.id
}
