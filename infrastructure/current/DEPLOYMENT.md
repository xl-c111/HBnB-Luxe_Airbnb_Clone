# Deployment Guide: Vercel + Fly.io + PlanetScale

Complete guide to deploy HBnB on a $0/month free tier stack with 24/7 uptime.

## Architecture Overview

```
Frontend: Vercel (React + Vite)
  ├─ 100GB bandwidth/month
  ├─ Global CDN
  └─ Auto-scaling

Backend: Fly.io (Flask + Gunicorn)
  ├─ 3 shared VMs (256MB RAM each)
  ├─ 3GB outbound bandwidth/month
  └─ 160GB inbound bandwidth

Database: PlanetScale (MySQL)
  ├─ 5GB storage
  ├─ 1B row reads/month
  └─ 10M row writes/month
```

**Total Cost:** $0/month
**Uptime:** 24/7
**Free Forever:** Yes

---

## Prerequisites

Install required tools:

```bash
# Fly.io CLI
curl -L https://fly.io/install.sh | sh

# PlanetScale CLI
brew install planetscale/tap/pscale

# Vercel CLI
npm install -g vercel

# Verify installations
fly version
pscale version
vercel --version
```

---

## Step 1: Set Up PlanetScale Database

### 1.1 Create Account & Database

```bash
# Login to PlanetScale
pscale auth login

# Create database (US East region for low latency with Fly.io)
pscale database create hbnb-db --region us-east

# Create main branch
pscale branch create hbnb-db main
```

### 1.2 Export Current MySQL Data

From your current AWS RDS or local MySQL:

```bash
# If using AWS RDS
mysqldump -h [RDS_ENDPOINT] -u admin -p hbnb_db > hbnb_backup.sql

# If using local MySQL
mysqldump -u hbnb_user -p hbnb_db > hbnb_backup.sql
```

### 1.3 Import to PlanetScale

```bash
# Open connection proxy
pscale connect hbnb-db main --port 3309

# In another terminal, import data
mysql -h 127.0.0.1 -P 3309 < hbnb_backup.sql
```

### 1.4 Get Production Connection String

```bash
# Create production password
pscale password create hbnb-db main production-password

# Copy the connection string shown
# Format: mysql://[user]:[password]@aws.connect.psdb.cloud/hbnb-db?ssl={"ssl_mode":"VERIFY_IDENTITY"}
```

**Save this connection string!** You'll need it for Fly.io secrets.

---

## Step 2: Deploy Backend to Fly.io

### 2.1 Initialize Fly.io App

```bash
cd backend

# Login to Fly.io
fly auth login

# Create app (will use ../infrastructure/current/fly.toml)
fly launch --config ../infrastructure/current/fly.toml --no-deploy

# Note: Choose 'No' when asked to deploy now (we need to set secrets first)
```

### 2.2 Set Environment Secrets

```bash
# Required secrets
fly secrets set \
  SECRET_KEY="your-super-secret-key-here" \
  JWT_SECRET_KEY="your-jwt-secret-key-here" \
  SQLALCHEMY_DATABASE_URI="mysql+pymysql://[user]:[password]@aws.connect.psdb.cloud/hbnb-db?ssl_mode=VERIFY_IDENTITY" \
  STRIPE_SECRET_KEY="sk_test_..." \
  STRIPE_PUBLISHABLE_KEY="pk_test_..."

# Optional: Set any other environment variables
fly secrets set FLASK_ENV="production"
```

**Important:** Replace the PlanetScale connection string format:
- PlanetScale gives: `mysql://user:pass@host/db?ssl={"ssl_mode":"VERIFY_IDENTITY"}`
- Fly.io needs: `mysql+pymysql://user:pass@host/db?ssl_mode=VERIFY_IDENTITY`

Changes:
1. Add `+pymysql` after `mysql`
2. Change `?ssl={...}` to `?ssl_mode=VERIFY_IDENTITY`

### 2.3 Deploy Backend

```bash
# Deploy from infrastructure/current directory
cd ../infrastructure/current
fly deploy

# Check deployment status
fly status

# View logs
fly logs

# Get backend URL
fly info
# Save the hostname (e.g., hbnb-backend.fly.dev)
```

### 2.4 Test Backend

```bash
# Health check
curl https://hbnb-backend.fly.dev/api/v1/status

# Test login endpoint
curl -X POST https://hbnb-backend.fly.dev/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john.doe@example.com","password":"Strongpass123!"}'
```

---

## Step 3: Deploy Frontend to Vercel

### 3.1 Login to Vercel

```bash
cd ../../frontend
vercel login
```

### 3.2 Deploy Frontend

```bash
# Deploy
vercel

# Follow prompts:
# - Set up and deploy? Yes
# - Scope: Your personal account
# - Link to existing project? No
# - Project name: hbnb-frontend (or your choice)
# - Directory: ./ (current directory)
# - Override settings? No
```

### 3.3 Set Environment Variables

After deployment, add environment variables in Vercel dashboard:

```bash
# Or set via CLI
vercel env add VITE_API_URL production
# Enter value: https://hbnb-backend.fly.dev

vercel env add VITE_STRIPE_PUBLISHABLE_KEY production
# Enter value: pk_test_...
```

### 3.4 Deploy to Production

```bash
# Production deployment
vercel --prod

# Save the production URL shown (e.g., hbnb-frontend.vercel.app)
```

### 3.5 Update CORS in Backend

Update your backend to allow the Vercel domain:

```python
# backend/app/__init__.py or wherever CORS is configured
CORS(app, origins=[
    "https://hbnb-frontend.vercel.app",  # Your Vercel domain
    "http://localhost:5173",  # Local development
])
```

Redeploy backend:
```bash
cd ../infrastructure/current
fly deploy
```

---

## Step 4: Verify Deployment

### 4.1 Test Full Stack

1. **Frontend:** Visit `https://hbnb-frontend.vercel.app`
2. **Backend API:** `https://hbnb-backend.fly.dev/api/v1/status`
3. **Database:** Login with test account to verify PlanetScale connection

### 4.2 Test User Flow

1. Browse properties (no auth required)
2. Login with test account: `john.doe@example.com` / `Strongpass123!`
3. View host dashboard
4. Create a test booking with Stripe test card: `4242 4242 4242 4242`

---

## Step 5: Destroy AWS Resources

**IMPORTANT:** Only do this after verifying the new deployment works!

### 5.1 Backup Current Data

```bash
# Already done in Step 1.2, but verify you have the backup
ls -lh hbnb_backup.sql
```

### 5.2 Destroy Terraform Infrastructure

```bash
cd infrastructure/legacy-aws/terraform

# Preview what will be destroyed
terraform plan -destroy

# Destroy all AWS resources
terraform destroy

# Type 'yes' when prompted
```

This will delete:
- EC2 instance
- RDS database
- S3 bucket (if not in use)
- CloudFront distributions
- Security groups

**Cost Savings:** ~$25-30/month → $0/month

### 5.3 Verify Cleanup

Check AWS console to ensure all resources are terminated:
- EC2 Dashboard: No running instances
- RDS Dashboard: No database instances
- S3: Buckets deleted (or empty)
- CloudFront: Distributions disabled/deleted

---

## Ongoing Maintenance

### Monitoring

**Fly.io:**
```bash
# View logs
fly logs

# Check status
fly status

# SSH into machine (if needed)
fly ssh console
```

**Vercel:**
```bash
# View deployments
vercel ls

# Check logs
vercel logs [deployment-url]
```

**PlanetScale:**
```bash
# Check database insights
pscale database show hbnb-db

# View branches
pscale branch list hbnb-db
```

### Updates

**Backend updates:**
```bash
cd backend
git pull origin main
cd ../infrastructure/current
fly deploy
```

**Frontend updates:**
```bash
cd frontend
git pull origin main
vercel --prod
```

### Database Migrations

PlanetScale supports safe schema changes with branching:

```bash
# Create dev branch
pscale branch create hbnb-db dev

# Make schema changes on dev branch
pscale connect hbnb-db dev

# Test changes
# ...

# Create deploy request
pscale deploy-request create hbnb-db dev

# Deploy to main
pscale deploy-request deploy hbnb-db [number]
```

---

## Troubleshooting

### Backend Issues

**Problem:** Backend not responding
```bash
fly logs  # Check for errors
fly status  # Check if app is running
fly doctor  # Diagnose issues
```

**Problem:** Database connection errors
```bash
# Verify connection string
fly secrets list

# Test PlanetScale connection
pscale connect hbnb-db main --port 3309
mysql -h 127.0.0.1 -P 3309 -e "SELECT 1"
```

### Frontend Issues

**Problem:** API calls failing (CORS)
- Update backend CORS configuration with Vercel domain
- Redeploy backend: `fly deploy`

**Problem:** Environment variables not loading
```bash
# Check environment variables
vercel env ls

# Pull latest env vars
vercel env pull
```

### Cost Monitoring

Check usage to stay within free tiers:

**Fly.io:**
```bash
fly dashboard
# Check: Bandwidth usage (<3GB/month outbound)
```

**Vercel:**
- Visit Vercel dashboard → Usage
- Check: Bandwidth (<100GB/month)

**PlanetScale:**
- Visit PlanetScale dashboard → Database insights
- Check: Storage (<5GB), Reads (<1B/month), Writes (<10M/month)

---

## Performance Tips

### Optimize Fly.io Response Time

```bash
# Add more regions (still free tier)
fly regions add ord  # Chicago
fly regions add sjc  # San Jose
```

### Optimize Vercel Caching

Already configured in `vercel.json`:
- Static assets cached for 1 year
- HTML cached with revalidation

### Optimize PlanetScale Queries

```sql
-- Add indexes for frequently queried fields
ALTER TABLE places ADD INDEX idx_price (price_per_night);
ALTER TABLE bookings ADD INDEX idx_user (user_id);
```

---

## Summary

**Deployed URLs:**
- Frontend: `https://hbnb-frontend.vercel.app`
- Backend: `https://hbnb-backend.fly.dev`
- Database: PlanetScale `hbnb-db` (internal)

**Cost:** $0/month (was $25-30/month on AWS)

**Free Tier Limits:**
- Fly.io: 3GB bandwidth/month, 3 VMs
- Vercel: 100GB bandwidth/month
- PlanetScale: 5GB storage, 1B reads, 10M writes

**Next Steps:**
- Monitor usage dashboards
- Set up custom domain (optional)
- Configure CI/CD for auto-deployment
- Add monitoring/alerting
