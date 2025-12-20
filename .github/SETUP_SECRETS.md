# GitHub Secrets Setup for CI/CD

Configure these secrets in your GitHub repository to enable automatic deployment.

---

## Required Secrets

Go to: **GitHub Repository → Settings → Secrets and variables → Actions → New repository secret**

### 1. Fly.io Secrets

#### `FLY_API_TOKEN`
**Get your token:**
```bash
flyctl auth token
```

**Value:** Copy the entire token output

---

### 2. Vercel Secrets

#### `VERCEL_TOKEN`
**Get your token:**
1. Go to https://vercel.com/account/tokens
2. Click "Create Token"
3. Name it "GitHub Actions"
4. Copy the token

**Value:** The generated token (starts with `vercel_...`)

#### `VERCEL_ORG_ID`
**Get your org ID:**
```bash
cd frontend
vercel link
cat .vercel/project.json
```

**Value:** The `orgId` from the JSON file

#### `VERCEL_PROJECT_ID`
**Get your project ID:**
```bash
cd frontend
cat .vercel/project.json
```

**Value:** The `projectId` from the JSON file

---

## Quick Setup Commands

```bash
# 1. Get Fly.io token
flyctl auth token

# 2. Get Vercel IDs
cd frontend
vercel link
cat .vercel/project.json | grep -E "(orgId|projectId)"

# 3. Get Vercel token
# Visit: https://vercel.com/account/tokens
```

---

## Secrets Summary

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `FLY_API_TOKEN` | Fly.io authentication | `flyctl auth token` |
| `VERCEL_TOKEN` | Vercel authentication | https://vercel.com/account/tokens |
| `VERCEL_ORG_ID` | Your Vercel team/org ID | `.vercel/project.json` |
| `VERCEL_PROJECT_ID` | Your Vercel project ID | `.vercel/project.json` |

---

## Verify Setup

After adding all secrets:

1. Go to: **GitHub Repository → Actions**
2. You should see "Deploy to Production" workflow
3. Click "Run workflow" to manually trigger
4. Or push to `main` branch to auto-deploy

---

## Security Notes

- ✅ Never commit these tokens to your repository
- ✅ Tokens are encrypted by GitHub
- ✅ Only workflows can access these secrets
- ✅ Rotate tokens periodically for security

---

## Troubleshooting

**Deployment fails with "401 Unauthorized":**
- Check that tokens are correct
- Verify tokens haven't expired
- Try regenerating tokens

**Vercel deployment fails:**
- Ensure `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID` match your project
- Run `vercel link` in frontend directory to get correct IDs

**Fly.io deployment fails:**
- Verify `FLY_API_TOKEN` is valid
- Check that you have access to the `hbnb-backend` app
- Run `flyctl auth whoami` to verify authentication
