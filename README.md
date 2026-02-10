# HBnB Luxe — Airbnb Clone (Full‑Stack)

A portfolio‑grade, end‑to‑end Airbnb‑style marketplace with **host/guest flows**, **JWT auth**, **Stripe payments**, and a **MySQL‑compatible TiDB Serverless** database. Built to demonstrate production deployment, API design, and real user journeys (browse → book → pay → review).

- **Live Demo:** https://hbnb-luxeairbnbclone.vercel.app
- **Backend Health:** https://hbnb-backend.fly.dev/health

## Screenshot
![HBnB screenshot](frontend/public/hbnb.png)

## Tech Stack
- **Frontend:** React 19 + TypeScript + Vite + Tailwind CSS (Vercel)
- **Backend:** Flask + Flask‑RESTX (Swagger) + SQLAlchemy + Gunicorn (Fly.io)
- **Database:** TiDB Serverless (MySQL‑compatible)
- **Payments:** Stripe Payment Intents
- **CI/CD:** GitHub Actions (tests/lint + deploy workflows)

## Key Features 
- **Two‑sided marketplace:** hosts create/manage listings; guests browse/book/review
- **Booking safety:** availability checks + status lifecycle (`pending/confirmed/cancelled/completed`)
- **Payments:** server‑created PaymentIntent + verification endpoint
- **Auth & security:** JWT + bcrypt password hashing, CORS allowlist, rate limiting, security headers
- **Data hygiene:** server‑side input sanitization for free‑form text (`bleach`)
- **API DX:** Swagger UI at `/doc` for interactive API exploration

## Architecture
Three‑tier deployment with clear separation of concerns:
- **Vercel** serves the React SPA
- **Fly.io** runs the Flask REST API
- **TiDB Serverless** stores persistent data (MySQL protocol + TLS)

See `infrastructure/current/ARCHITECTURE.md` for diagrams and request flows.

## API
- **Swagger UI (local):** http://localhost:5000/doc
- **Health check:** `GET /health`
- **Auth:** `POST /api/v1/auth/login`
- **Core resources:** `/api/v1/places`, `/api/v1/bookings`, `/api/v1/reviews`, `/api/v1/amenities`, `/api/v1/payments`

Example login:
```bash
curl -sS -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john.doe@example.com","password":"Strongpass123!"}'
```

## Quick Start (Local)
### Prereqs
- **Python:** 3.11+ (backend)
- **Node:** 20+ (frontend)
- **Database:** MySQL/TiDB connection string (see `backend/.env.example`)
- **Stripe:** test keys (see `backend/.env.example` and `frontend/.env.example`)

### Backend
```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python3 run.py
```

Optional (create tables + seed sample data):
```bash
# From repo root (recommended)
FLASK_CONFIG=config.DevelopmentConfig python3 backend/init_db.py
python3 scripts/add_sample_data.py
```

### Frontend
```bash
cd frontend
cp .env.example .env
npm install
npm run dev
```

## Tests
```bash
# Backend
cd backend
python3 -m pytest -v

# Frontend
cd frontend
npm test
```

## Documentation
- `API_DOCUMENTATION_GUIDE.md` — how to use Swagger UI effectively
- `infrastructure/current/DEPLOYMENT.md` — end‑to‑end deployment (TiDB + Fly.io + Vercel)
- `infrastructure/current/REDEPLOYMENT.md` — quick redeploy checklist
- `docs/` — diagrams + interview prep notes

## Repo Structure
- `backend/` — Flask API, models, services, persistence, tests
- `frontend/` — React SPA (Vite), components/pages, tests
- `infrastructure/` — deployment + architecture docs
- `docs/` — system diagrams, DB SQL, interview notes
- `scripts/` — local utilities (seed data, checks)

## License
MIT (see `LICENSE`).

## Author
Xiaoling Cui
