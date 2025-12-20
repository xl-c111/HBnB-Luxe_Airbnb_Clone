# Redeployment Guide

Quick reference for updating your production deployment.

---

## Frontend Updates (Vercel)

When you update React components, styles, or frontend code:

```bash
cd frontend
vercel --prod
```

Vercel automatically builds and deploys your changes with zero downtime.

**Alternative:** Enable auto-deploy in Vercel dashboard to deploy on every git push.

---

## Backend Updates (Fly.io)

When you update API endpoints, business logic, or backend code:

```bash
cd backend
flyctl deploy
```

Fly.io rebuilds your Docker container and performs a zero-downtime deployment.

**Update environment variables:**
```bash
flyctl secrets set VARIABLE_NAME=new_value
```

---

## Database Updates (PlanetScale)

### Adding/Updating Data
No redeployment needed - changes are instant through your application.

### Schema Changes (Tables/Columns)

**Manual SQL (small changes):**
```bash
pscale shell hbnb-db main
# Run your SQL commands
ALTER TABLE places ADD COLUMN image_url VARCHAR(255);
```

**Important:** After schema changes, update SQLAlchemy models and redeploy backend!

---

## Common Scenarios

### Fix Backend Bug
```bash
cd backend
flyctl deploy
```

### Update Frontend UI
```bash
cd frontend
vercel --prod
```

### Add New API Endpoint
```bash
# 1. Deploy backend
cd backend
flyctl deploy

# 2. Deploy frontend
cd ../frontend
vercel --prod
```

---

## Verification

```bash
# Frontend
curl https://hbnb-luxeairbnbclone.vercel.app

# Backend
curl https://hbnb-backend.fly.dev/api/v1/places/

# Backend logs
flyctl logs -a hbnb-backend

# Backend status
flyctl status -a hbnb-backend
```

---

## Quick Reference

| Component | Command | Location |
|-----------|---------|----------|
| Frontend | `vercel --prod` | `/frontend` |
| Backend | `flyctl deploy` | `/backend` |
| Secrets | `flyctl secrets set KEY=value` | `/backend` |
| Database Schema | `pscale shell hbnb-db main` | PlanetScale |

---

**Always test locally before deploying to production!**
