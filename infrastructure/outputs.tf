# outputs.tf
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web_instance.id
}

output "db_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.postgres_instance.id
}

#output "route53_zone_id" {
#  description = "The ID of the Route53 hosted zone"
#  value       = aws_route53_zone.main_zone.zone_id
#}
