output "cluster_id" {
  value = module.eks_cluster.cluster_id
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "configure_kubectl" {
  value = module.eks_cluster.configure_kubectl
}

output "oidc_provider_arn" {
  value = module.eks_cluster.oidc_provider_arn
}
