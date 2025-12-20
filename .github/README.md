# CI/CD Pipeline

Automated testing and deployment for HBnB using GitHub Actions.

---

## Workflows

### 1. `deploy.yml` - Production Deployment
**Triggers:**
- Push to `main` branch
- Manual trigger via GitHub UI

**What it does:**
1. ✅ Runs backend tests (Python 3.11)
2. ✅ Deploys backend to Fly.io
3. ✅ Deploys frontend to Vercel
4. ✅ Reports deployment status

**Duration:** ~3-5 minutes

---

### 2. `tests.yml` - Test Suite
**Triggers:**
- Pull requests to `main`
- Push to any branch except `main`

**What it does:**
1. ✅ Backend tests on Python 3.9, 3.10, 3.11
2. ✅ Frontend tests with coverage
3. ✅ Generates test reports

**Duration:** ~2-3 minutes

---

## Setup

### First Time Setup
1. Read [SETUP_SECRETS.md](./SETUP_SECRETS.md)
2. Add required secrets to GitHub repository
3. Push to `main` or trigger workflow manually

### Required Secrets
- `FLY_API_TOKEN` - Fly.io deployment
- `VERCEL_TOKEN` - Vercel deployment
- `VERCEL_ORG_ID` - Vercel organization
- `VERCEL_PROJECT_ID` - Vercel project

---

## Usage

### Automatic Deployment
```bash
git add .
git commit -m "Update feature"
git push origin main
# Automatically deploys to production!
```

### Manual Deployment
1. Go to GitHub → Actions
2. Select "Deploy to Production"
3. Click "Run workflow"
4. Select `main` branch
5. Click "Run workflow"

### Check Status
- GitHub → Actions → View latest workflow run
- See logs for each step
- Check deployment URLs in the summary

---

## Workflow Diagram

```
Push to main
    │
    ├─► Run Tests (Python 3.11)
    │       │
    │       ├─► ✅ Pass → Continue
    │       └─► ❌ Fail → Stop
    │
    ├─► Deploy Backend (Fly.io)
    │       │
    │       └─► Build Docker → Deploy
    │
    ├─► Deploy Frontend (Vercel)
    │       │
    │       └─► Build React → Deploy
    │
    └─► Report Status
            │
            └─► Show URLs
```

---

## Monitoring

### View Deployment Logs
```bash
# Backend logs
flyctl logs -a hbnb-backend

# Check deployment status
flyctl status -a hbnb-backend

# Frontend logs
vercel logs --prod
```

### Rollback
If deployment fails:

**Backend:**
```bash
# Via Fly.io dashboard or CLI
flyctl releases -a hbnb-backend
flyctl releases rollback -a hbnb-backend
```

**Frontend:**
```bash
# Via Vercel dashboard
# Deployments → Select previous deployment → Promote to Production
```

---

## Benefits

- ✅ **Automated:** No manual deployment steps
- ✅ **Safe:** Tests run before deployment
- ✅ **Fast:** Deploys in ~3-5 minutes
- ✅ **Reliable:** Rollback available if issues occur
- ✅ **Visible:** See deployment status in GitHub UI

---

## Troubleshooting

**"Deployment failed" error:**
1. Check GitHub Actions logs
2. Verify secrets are correct
3. Check Fly.io/Vercel dashboards

**Tests pass locally but fail in CI:**
1. Check Python version compatibility
2. Verify all dependencies in requirements.txt
3. Check environment variables

**Frontend deployment succeeds but site doesn't update:**
- Vercel might be serving cached version
- Hard refresh: Ctrl+Shift+R (or Cmd+Shift+R on Mac)
- Check Vercel deployment URL in workflow logs
