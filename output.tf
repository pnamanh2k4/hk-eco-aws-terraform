output "instance_ip_addr_public" {
  value = module.compute.instance_ip_addr_public
}

output "instance_ip_addr_private" {
  value = module.compute.instance_ip_addr_private
}

output "ecr_url" {
  value = aws_ecr_repository.hk_eco_repo.repository_url
}
