environment         = "dev"
cluster_name        = "aetush-dev-cluster"
aws_region          = "eu-central-1"
vpc_cidr            = "10.0.0.0/16"
node_instance_type  = "t3.micro"
desired_size        = 1
min_size            = 1
max_size            = 1
capacity_type       = "SPOT"  # Use SPOT for 60-90% cost savings in dev
# terraform apply -var="desired_size=0" -var="min_size=0" -var="max_size=1"