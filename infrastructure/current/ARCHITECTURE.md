# Production Architecture: Vercel + Fly.io + TiDB Serverless

Complete architecture overview showing how the three services work together to deliver HBnB.

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                           Internet                              │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ├──────────────────┬──────────────────────────┐
                     │                  │                          │
            ┌────────▼────────┐  ┌──────▼──────┐         ┌────────▼────────┐
            │   Vercel CDN    │  │  Fly.io     │         │   TiDB   │
            │   (Frontend)    │  │  (Backend)  │         │   (Database)    │
            │                 │  │             │         │                 │
            │  React + Vite   │  │Flask + Docker│        │ MySQL-compatible│
            │  Edge Network   │  │ 3 VMs       │         │ TLS enabled    │
            └────────┬────────┘  └──────┬──────┘         └────────▲────────┘
                     │                  │                          │
                     │   API Calls      │    SQL Queries           │
                     │   (HTTPS)        │    (MySQL Protocol)      │
                     │                  │                          │
                     └──────────────────┼──────────────────────────┘
                                        │
                                   Connection
                                   mysql+pymysql://
```

---

## Component Roles

### 1. Vercel (Frontend Layer)
**What it does:**
- Hosts the React application
- Serves static assets (HTML, CSS, JS)
- Provides global CDN for fast loading worldwide
- Handles client-side routing

**Technology:**
- React 19 + Vite
- Deployed as static site
- Edge functions available (not currently used)

**Environment Variables:**
```bash
VITE_API_URL=https://hbnb-backend.fly.dev
VITE_STRIPE_PUBLISHABLE_KEY=pk_test_...
```

---

### 2. Fly.io (Backend Layer)
**What it does:**
- Runs Flask API server
- Handles business logic and authentication
- Processes Stripe payments
- Manages database connections

**Technology:**
- Python 3.11 + Flask
- Gunicorn WSGI server
- Docker containers (3 VMs, 256MB each)
- Auto-restart on failure

**Environment Variables:**
```bash
DATABASE_URL=mysql+pymysql://user:pass@host:4000/database
SECRET_KEY=...
JWT_SECRET_KEY=...
STRIPE_SECRET_KEY=sk_test_...
FRONTEND_URL=https://hbnb-luxeairbnbclone.vercel.app
```

---

### 3. TiDB Serverless (Database Layer)
**What it does:**
- Stores all application data (users, places, bookings, reviews)
- Provides MySQL-compatible interface
- Serverless scaling based on usage
- TLS-secured connections

**Technology:**
- TiDB Serverless (MySQL-compatible)
- Serverless architecture
- 
**Connection:**
```
mysql+pymysql://username:password@host:4000/database
```

---

## Request Flow

### User Browsing Properties (GET Request)

```
┌──────┐      ①      ┌─────────┐      ②       ┌────────┐      ③     ┌────────────┐
│ User │─────────────▶│ Vercel  │─────────────▶│ Fly.io │────────────▶│ TiDB│
│      │  Visit site  │ (React) │  API Request │ (Flask)│ SQL Query   │  (MySQL)   │
└──────┘              └─────────┘              └────────┘             └────────────┘
   ▲                                                │                        │
   │                      ⑥ HTML                   │       ④ Results        │
   │                    rendered                    │◀───────────────────────┘
   │                                                │
   │                      ⑤ JSON                   │
   └────────────────────────────────────────────────┘
```

**Step-by-step:**
1. User visits `https://hbnb-luxeairbnbclone.vercel.app`
2. Vercel serves React app from edge CDN (instant load)
3. React app calls API: `GET https://hbnb-backend.fly.dev/api/v1/places/`
4. Fly.io backend connects to TiDB
5. TiDB executes: `SELECT * FROM places`
6. Results flow back: Database → Backend → Frontend → User

---

### User Making a Booking (POST Request with Payment)

```
┌──────┐   ①      ┌─────────┐     ②    ┌────────┐   ③   ┌─────────┐
│ User │──────────▶│ Vercel  │─────────▶│ Fly.io │───────▶│ Stripe  │
│      │Book+Pay   │ (React) │  Payment │ (Flask)│ Verify │   API   │
└──────┘           └─────────┘  Intent  └────────┘        └─────────┘
                                             │                   │
                                             │      ④ Verified   │
                                             │◀──────────────────┘
                                             │
                                             │ ⑤ Save Booking
                                             ▼
                                        ┌────────────┐
                                        │ TiDB│
                                        │  (MySQL)   │
                                        └────────────┘
```

**Step-by-step:**
1. User fills booking form and enters payment info
2. Frontend creates Stripe Payment Intent via backend
3. Backend validates payment with Stripe API
4. Stripe confirms payment succeeded
5. Backend saves booking to TiDB database
6. Success message returned to user

---

## Data Flow Architecture

### Write Operations (Create/Update/Delete)

```
Frontend (Vercel)
    │
    │ HTTP POST/PUT/DELETE
    ▼
Backend (Fly.io)
    │
    ├─► Validate JWT token
    ├─► Check permissions
    ├─► Validate data
    ├─► Sanitize input (bleach)
    │
    │ SQL INSERT/UPDATE/DELETE
    ▼
Database (TiDB)
    │
    └─► Transaction committed
         (Auto-replicated across regions)
```

### Read Operations (List/Get)

```
Frontend (Vercel)
    │
    │ HTTP GET
    ▼
Backend (Fly.io)
    │
    ├─► Optional: Check JWT (for protected routes)
    ├─► Build SQL query
    │
    │ SQL SELECT with JOINs
    ▼
Database (TiDB)
    │
    ├─► Execute query
    ├─► Return results
    │
    ▼
Backend (Fly.io)
    │
    ├─► Serialize to JSON
    ├─► Apply business rules
    │
    ▼
Frontend (Vercel)
    │
    └─► Render UI components
```

---

## Security & Communication

### HTTPS Everywhere

```
User Browser
    ↕ HTTPS (TLS 1.3)
Vercel CDN (hbnb-luxeairbnbclone.vercel.app)
    ↕ HTTPS (TLS 1.3)
Fly.io API (hbnb-backend.fly.dev)
    ↕ MySQL over TLS
TiDB (TiDB Cloud)
```

### Authentication Flow

```
┌──────────────────────────────────────────────────────────┐
│ 1. Login: POST /api/v1/auth/login                        │
│    Frontend → Backend: {email, password}                 │
│    Backend: Verify bcrypt hash                           │
│    Backend → Frontend: {access_token: "eyJ..."}          │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ 2. Authenticated Request: GET /api/v1/bookings/          │
│    Frontend → Backend: Header: "Authorization: Bearer eyJ...│
│    Backend: Verify JWT signature                         │
│    Backend: Extract user_id from token                   │
│    Backend → Database: SELECT * WHERE user_id=...        │
└──────────────────────────────────────────────────────────┘
```

---

## CORS Configuration

Backend allows requests only from the frontend domain:

```python
# Backend: app/__init__.py
CORS(app, resources={
    r"/api/*": {
        "origins": "https://hbnb-luxeairbnbclone.vercel.app"
    }
})
```

This prevents unauthorized websites from calling your API.

---

## Deployment Workflow

### Developer Workflow

```
┌──────────────────────────────────────────────────────────────┐
│ Developer                                                    │
│   │                                                          │
│   ├─► Code changes locally                                   │
│   ├─► Test: npm run dev (frontend)                           │
│   ├─► Test: python3 run.py (backend)                         │
│   │                                                          │
│   └─► Ready to deploy                                        │
└──────────────────────────┬───────────────────────────────────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
     ┌─────▼─────┐   ┌─────▼─────┐   ┌────▼──────┐
     │  Vercel   │   │  Fly.io   │   │TiDB│
     │  Deploy   │   │  Deploy   │   │  Migrate  │
     │           │   │           │   │           │
     │ Build     │   │ Docker    │   │ SQL       │
     │ React     │   │ Build     │   │ Scripts   │
     │ Vite      │   │ Deploy    │   │           │
     └───────────┘   └───────────┘   └───────────┘
           │               │               │
           └───────────────┼───────────────┘
                           │
                    ┌──────▼──────┐
                    │ Production  │
                    │    Live     │
                    └─────────────┘
```

---

## Scaling Behavior

### Frontend (Vercel)
- **Auto-scales globally:** Cached at 275+ edge locations worldwide
- **No limit:** Handles unlimited concurrent users
- **Performance:** ~50ms response time globally

### Backend (Fly.io)
- **Current:** 3 VMs (256MB each)
- **Auto-restart:** Failed instances restart automatically
- **Manual scale:** Can increase to more VMs if needed
- **Load balancing:** Fly.io distributes requests across VMs

### Database (TiDB)
- **Serverless:** Auto-scales connections based on usage
- **Connection pooling:** Handles bursts efficiently
- **Read replicas:** Automatic for performance
- **Limits:** 1B row reads/month, 10M row writes/month (free tier)

---

## Monitoring & Logs

```bash
# Frontend (Vercel)
vercel logs --prod

# Backend (Fly.io)
flyctl logs -a hbnb-backend
flyctl status -a hbnb-backend

# Database (TiDB)
# Via TiDB dashboard: Insights tab
```

---

## Summary

**Three-tier architecture:**
1. **Presentation:** Vercel serves React UI globally
2. **Application:** Fly.io runs Flask API with business logic
3. **Data:** TiDB stores and manages all data

**Communication:**
- Frontend ↔ Backend: REST API over HTTPS
- Backend ↔ Database: MySQL protocol over TLS

**Benefits:**
- Geographic distribution (fast worldwide)
- Independent scaling per layer
- Zero-downtime deployments
- Automatic SSL/TLS encryption
- Built-in DDoS protection
