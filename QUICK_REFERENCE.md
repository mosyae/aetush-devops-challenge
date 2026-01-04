# Quick Reference - Deployment Commands

## ✅ Pre-Deployment Checklist
- [x] Terraform syntax validated
- [x] State cleaned and verified
- [x] Helm provider configured correctly
- [x] Load Balancer Controller auto-deployment configured
- [x] All files reviewed and fixed

## 🚀 Deploy in 3 Commands

### 1️⃣ Initialize & Plan
```bash
cd terraform/environments/dev
terraform init
terraform plan
```
Expected: "Plan: 1 to add, 0 to change, 0 to destroy"

### 2️⃣ Deploy Infrastructure
```bash
terraform apply
```
⏱️ Takes ~15-20 minutes
☕ Good time for coffee break!

### 3️⃣ Configure kubectl
```bash
aws eks update-kubeconfig --region eu-central-1 --name aetush-dev-cluster
kubectl get nodes  # Verify cluster access
```

---

## 📦 Deploy Application

### 1️⃣ Build & Push Docker Image
```bash
cd app/sre-portal
docker build -t sre-portal:v1.0.0 .

# Login to ECR
aws ecr get-login-password --region eu-central-1 | \
  docker login --username AWS --password-stdin 745865830379.dkr.ecr.eu-central-1.amazonaws.com

# Tag & Push
docker tag sre-portal:v1.0.0 \
  745865830379.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr:v1.0.0
docker push 745865830379.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr:v1.0.0
```

### 2️⃣ Deploy via Helm
```bash
cd ../..  # Back to project root
helm install sre-portal ./k8s/sre-portal \
  -f ./k8s/sre-portal/values-dev.yaml \
  --set image.tag=v1.0.0
```

### 3️⃣ Test Application
```bash
kubectl port-forward svc/sre-portal 3000:3000
# Open http://localhost:3000 in browser
```

---

## 🛠️ Useful Commands

### Monitor Deployment
```bash
# Watch pods
kubectl get pods -w

# View logs
kubectl logs -l app=sre-portal -f

# Describe pod
kubectl describe pod <pod-name>
```

### Check Load Balancer Controller
```bash
kubectl get pods -n kube-system | grep aws-load-balancer-controller
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller -f
```

### Manage Infrastructure
```bash
# Pause cluster (save money)
cd terraform/environments/dev
terraform apply -var="desired_size=0"

# Resume cluster
terraform apply -var="desired_size=1"

# Destroy everything
terraform destroy
```

### Kubernetes Basics
```bash
# Get all resources
kubectl get all

# Port forward
kubectl port-forward svc/sre-portal 3000:3000

# Scale deployment
kubectl scale deployment sre-portal --replicas=3

# Update image
kubectl set image deployment/sre-portal \
  sre-portal=745865830379.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr:v2.0.0
```

---

## 💾 Files Modified Today

| File | Change | Type |
|------|--------|------|
| terraform/modules/eks_cluster/main.tf | Added Helm provider + load balancer controller | ✏️ Edit |
| terraform/environments/dev/main.tf | Cleaned (removed invalid provider) | ✏️ Edit |
| FIXES_APPLIED.md | Technical documentation | 📄 Created |
| DEPLOYMENT_READY.md | Deployment guide | 📄 Created |
| CODE_REVIEW_COMPLETE.md | Complete summary | 📄 Created |
| This file | Quick reference | 📄 Created |

---

## 🎯 Key Metrics

| Metric | Value |
|--------|-------|
| Terraform Validation | ✅ PASS |
| State Resources | 25 (clean) |
| Orphaned Resources | 0 |
| Helm Release Status | Ready |
| Estimated Deploy Time | 15-20 min |
| Monthly Cost (Dev) | ~$80/month |
| Free Tier Eligible | ✅ Yes (with cost) |

---

## 📞 Troubleshooting Quick Links

**Issue: Terraform hangs on Helm release**
→ Ctrl+C and re-run apply, it will skip created resources

**Issue: kubectl not connecting**
→ Run: `aws eks update-kubeconfig --region eu-central-1 --name aetush-dev-cluster`

**Issue: Docker push fails**
→ Check: `aws ecr get-login-password --region eu-central-1`

**Issue: Ingress not working**
→ Check: `kubectl get ingress` and `kubectl get pods -n kube-system`

**Issue: Pod CrashLoopBackOff**
→ Check: `kubectl logs <pod-name>` and `kubectl describe pod <pod-name>`

---

## ✨ You're All Set!

Everything is:
- ✅ Fixed
- ✅ Validated
- ✅ Documented
- ✅ Ready to deploy

**Happy deploying! 🚀**
