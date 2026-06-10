#ecs_cluster_nameという名前で、aws_ecs_cluster.ecs_cluster.nameの値を出力する。
output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app_service.name
}

output "cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "service_name" {
  value = aws_ecs_service.app_service.name
}
