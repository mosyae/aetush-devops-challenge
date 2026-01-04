environment         = "dev"
cluster_name        = "aetush-dev-cluster"
aws_region          = "eu-central-1"
vpc_cidr            = "10.0.0.0/16"
node_instance_type  = "t3.micro"
desired_size        = 1   # set to 0 when idle to avoid EC2 hours
min_size            = 1   # set to 0 when idle
max_size            = 1

# scale nodes to zero (control plane cost remains)
# terraform apply -var="desired_size=0" -var="min_size=0" -var="max_size=1"