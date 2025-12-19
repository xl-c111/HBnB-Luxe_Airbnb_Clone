# Legacy AWS Infrastructure (Archived)

This folder contains the original AWS infrastructure setup using Terraform.

## Why We Migrated

**Previous AWS Stack:**
- Frontend: S3 + CloudFront
- Backend: EC2 t3.micro
- Database: RDS MySQL db.t3.micro
- **Cost:** ~$25-30/month

**Current Stack (Vercel + Fly.io + PlanetScale):**
- Frontend: Vercel
- Backend: Fly.io
- Database: PlanetScale MySQL
- **Cost:** $0/month

## Migration Reasons

1. **Cost Optimization:** Reduced from $25-30/month to $0/month
2. **Free Tier Limitations:** AWS free tier only lasts 12 months
3. **Better Developer Experience:** Serverless auto-scaling, global CDN
4. **Production Quality:** PlanetScale (Vitess), Fly.io edge network
5. **24/7 Uptime:** Permanent free tiers vs temporary AWS free tier

## AWS Infrastructure Details

The Terraform configuration in `terraform/main.tf` defines:
- EC2 instance (t3.micro, 8GB gp3 storage)
- RDS MySQL (db.t3.micro, 20GB storage, encrypted)
- S3 bucket for frontend hosting
- CloudFront distributions (frontend + backend)
- Security groups and VPC configuration

## Preservation Rationale

This infrastructure is preserved to demonstrate:
- AWS cloud platform expertise
- Infrastructure as Code (Terraform) skills
- Multi-cloud architecture experience
- Cost optimization decision-making

## Terraform Resources

If you want to reference or redeploy the AWS infrastructure:

```bash
cd infrastructure/legacy-aws/terraform

# Initialize Terraform
terraform init

# See what would be created
terraform plan

# Deploy (will incur costs!)
terraform apply
```

**Note:** Deploying this infrastructure will result in AWS charges.
