# HBnB - Luxe Airbnb Clone

A portfolio‑grade, full‑stack Airbnb‑style marketplace built with React and Flask. Includes Stripe payments, JWT auth, host/guest flows, and a MySQL‑compatible TiDB Serverless database. Built to demonstrate real production deployment and end‑to‑end product flow.

**Live Demo:** https://hbnb-luxeairbnbclone.vercel.app  
**Backend API:** https://hbnb-backend.fly.dev

---

## Screenshots
![HBnB screenshot](frontend/public/hbnb.png)

---

## Stack
- **Frontend:** React 19 + Vite + Tailwind CSS (Vercel)
- **Backend:** Flask + SQLAlchemy + Gunicorn (Fly.io)
- **Database:** TiDB Serverless (MySQL‑compatible)
- **Payments:** Stripe Payment Intents

---

## Highlights
- Host dashboard with listings, revenue, and bookings
- Booking flow with availability checks and Stripe verification
- Reviews and ratings with business rules
- JWT auth with role‑based access
- `/health` endpoint for uptime checks

---

## Quick Start (Local)
```bash
# Backend
cd backend
cp .env.example .env
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt -c requirements-constraints.txt
python3 run.py

# Frontend
cd ../frontend
npm install
npm run dev
```

---

## Deployment
See `infrastructure/current/DEPLOYMENT.md` for end‑to‑end instructions (TiDB + Fly.io + Vercel).

---

## Tests
```bash
# Backend
cd backend
python3 -m pytest -v

# Frontend
cd frontend
npm test
```

---

**Author:** Xiaoling Cui
**License:** MIT
