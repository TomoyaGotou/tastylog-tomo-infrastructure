output "target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}
output "arn" {
  value = aws_lb.alb.arn
}

output "zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_arn_suffix" {
  value = aws_lb.alb.arn_suffix
}
