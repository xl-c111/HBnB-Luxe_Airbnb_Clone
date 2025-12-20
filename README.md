# HBnB - Luxe Airbnb Clone

A production-ready two-sided marketplace rental platform demonstrating full-stack development with React, Flask, and serverless deployment. Implements Stripe payment processing, JWT authentication, multi-tenant architecture, and real-time booking management with comprehensive host analytics.

<div align="center">

**🚀 [View Live Demo](https://hbnb-luxeairbnbclone.vercel.app)** | Vercel + Fly.io + PlanetScale - mobile-ready

![HBnB screenshot](frontend/public/hbnb.png)

</div>

---

## Architecture

**Production Infrastructure:**
- **Frontend:** Vercel (React + Vite, Global CDN)
- **Backend:** Fly.io (Flask + Gunicorn, containerized deployment)
- **Database:** PlanetScale (Serverless MySQL)

### Tech Stack
**Backend:**
- Python 3.9+, Flask, SQLAlchemy
- JWT authentication with bcrypt
- RESTful API with flask-restx
- MySQL database with multi-tenant schema
- Stripe Payment Intents API with server-side amount/metadata verification

**Frontend:**
- React 19 with modern hooks
- Vite build system
- Tailwind CSS for styling
- React Router for navigation
- Stripe Elements for payment UI
- React DatePicker for booking dates

**DevOps:**
- Vercel + Fly.io deployment (serverless/edge)
- Docker containerization for backend
- GitHub Actions CI/CD pipeline (automated testing on push/PR)
- Health monitoring endpoint at `/health`
- Environment-based configuration (.env files)
- Pinned Python dependencies via `requirements-constraints.txt` for reproducible deploys

---

## Quick Start

1. **Database**
   ```bash
   # Install MySQL if you don't have it yet
   brew install mysql

   # Start MySQL
   brew services start mysql
   mysql -u root

   # Inside MySQL prompt:
   CREATE USER IF NOT EXISTS 'hbnb_user'@'localhost' IDENTIFIED BY '1234';
   GRANT ALL PRIVILEGES ON *.* TO 'hbnb_user'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;

   # Import schema
   mysql -u root < docs/hbnb_db.sql
   ```

2. **Backend**
   ```bash
   cd backend

   # Setup environment variables
   cp .env.example .env
   # Add required secrets to .env:
   # SECRET_KEY=super-secret-string
   # JWT_SECRET_KEY=jwt-secret-string
   # STRIPE_SECRET_KEY=sk_test_...
   # STRIPE_PUBLISHABLE_KEY=pk_test_...
   # SQLALCHEMY_DATABASE_URI=mysql+pymysql://hbnb_user:1234@localhost:3306/hbnb_db

   # Install Python dependencies inside a virtual environment
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt

   # Add sample data (creates 3 hosts, 6 properties, 3 guests, 6 reviews)
   python3 ../scripts/add_sample_data.py

   # Start API server
   python3 run.py  # Runs at http://127.0.0.1:5000
   ```

3. **Frontend**
   ```bash
   cd frontend

   # Install dependencies
   npm install

   # Setup environment variables
   # Create .env.development (or copy from .env.example) with:
   # VITE_API_URL=http://localhost:5000
   # VITE_STRIPE_PUBLISHABLE_KEY=pk_test_...

   # Start development server
   npm run dev  # Runs at http://localhost:5173
   ```

---

## Key Features

### Multi-Tenant Property Management
- **Host Dashboard:** Manage multiple properties with individual analytics
- **Revenue Tracking:** Real-time upcoming revenue, total earnings, and top performers
- **Booking Management:** Confirm/decline booking requests with status tracking
- **Property CRUD:** Create, edit, and delete listings with validation

### Complete Booking System
- **Availability Checking:** Real-time date conflict detection
- **Booking Lifecycle:** Pending → Confirmed → Completed workflow
- **Payment Integration:** Stripe checkout with Payment Intents verification
- **Guest Management:** View upcoming guests and check-in dates

### Review & Rating System
- **Submit Reviews:** Authenticated users can rate and review properties
- **Display Reviews:** Property pages show all reviews with user names and ratings
- **Business Rules:** Users cannot review their own properties or duplicate reviews
- **Star Ratings:** Visual 5-star rating system with aggregated scores

### Authentication & Security
- **JWT Tokens:** Secure token-based authentication
- **Password Security:** Bcrypt hashing with strength validation
- **Role-Based Access:** Host vs guest permission separation
- **Payment Verification:** Server-side Stripe payment validation before booking creation
- **Hardening:** HTML sanitization on user content, rate limiting on auth/payments, security headers on all responses

### Performance & Monitoring
- **Database Indexing:** Optimized queries with indexes on foreign keys, email, price, and booking dates
- **Health Monitoring:** `/health` endpoint for uptime checks and database connectivity
- **CI/CD Pipeline:** Automated testing on every push/PR via GitHub Actions
- **Query Optimization:** Eager loading for relationships to prevent N+1 queries

### User Experience
- **Responsive Design:** Mobile-first UI with Tailwind CSS
- **Custom Date Picker:** Styled calendar matching site aesthetic
- **Real-time Feedback:** Loading states, error handling, success messages
- **Public Browsing:** View listings without authentication

---

## Live Demo Testing

**Test Accounts (All passwords: `Strongpass123!`):**

**Host Accounts:**
- `john.doe@example.com` - 3 luxury properties
- `sarah.chen@example.com` - 2 coastal/mountain properties
- `mike.johnson@example.com` - 1 cozy cabin

**Guest Accounts:**
- `emma.wilson@example.com`
- `alex.martinez@example.com`
- `lisa.anderson@example.com`

**Test Flow:**
1. **Host Flow:**
   - Login as a host → View "Host" page
   - See revenue dashboard (upcoming revenue, total earnings, top earner)
   - View incoming guests and booking requests
   - Confirm/decline bookings
   - Edit property details (title, description, price)

2. **Guest Flow:**
   - Login as a guest → Browse properties
   - Select property → Check availability for dates
   - Complete Stripe payment (test card: `4242 4242 4242 4242`)
   - View booking confirmation

3. **Review Flow:**
   - View property details → See existing reviews
   - Leave a review for properties you've stayed at
   - Star rating + written feedback

**Stripe Test Card:**
- Number: `4242 4242 4242 4242`
- Expiry: Any future date
- CVC: Any 3 digits

---

<details>
<summary><strong>Project Structure</strong></summary>

```
backend/
├── app/
│   ├── api/v1/
│   │   ├── auth.py          # Login/register endpoints
│   │   ├── users.py         # User management
│   │   ├── places.py        # Property listings with reviews
│   │   ├── bookings.py      # Booking lifecycle + availability
│   │   ├── payments.py      # Stripe payment intents
│   │   ├── reviews.py       # Review CRUD operations
│   │   └── amenities.py     # Amenity management
│   ├── models/              # SQLAlchemy models
│   ├── persistence/         # Repository pattern implementation
│   ├── services/            # Facade service layer
│   └── extensions.py        # Flask extensions (db, bcrypt, jwt)
├── tests/                   # Pytest test suite
└── run.py                  # Application entry point

frontend/
├── src/
│   ├── api/                # API client utilities
│   ├── components/
│   │   ├── navigation.tsx   # Main navigation
│   │   ├── property-detail.tsx       # Property page with booking
│   │   ├── property-reviews.tsx      # Review display
│   │   ├── booking-form.tsx          # Stripe payment integration
│   │   ├── stripe-checkout-form.tsx  # Payment form
│   │   └── listings-grid.tsx         # Property grid
│   ├── pages/
│   │   ├── HomePage.jsx     # Landing page
│   │   ├── PropertyPage.jsx # Property detail view
│   │   ├── BookingPage.jsx  # Checkout page
│   │   ├── HostPage.jsx     # Host dashboard
│   │   └── ProfilePage.jsx  # User profile
│   ├── contexts/
│   │   └── AuthContext.jsx  # Authentication state
│   ├── data/
│   │   └── properties.js    # Frontend metadata enrichment
│   └── styles/
│       └── datepicker-custom.css  # Custom calendar styling
├── index.html
└── vite.config.js

scripts/
├── add_sample_data.py      # Populate DB with test data
└── setup_and_run.sh        # Quick local development setup

infrastructure/
└── current/
    ├── fly.toml           # Fly.io backend configuration
    └── DEPLOYMENT.md      # Production deployment guide
```

</details>

---

## API Endpoints

### Health & Monitoring
- `GET /health` - Health check endpoint (returns database connectivity status)

### Authentication
- `POST /api/v1/auth/register` - Create new user
- `POST /api/v1/auth/login` - Get JWT token

### Properties
- `GET /api/v1/places/` - List all properties
- `POST /api/v1/places/` - Create property (JWT required)
- `GET /api/v1/places/{id}` - Get property details
- `PUT /api/v1/places/{id}` - Update property (owner only)
- `DELETE /api/v1/places/{id}` - Delete property (owner only)
- `GET /api/v1/places/{id}/reviews` - Get property reviews

### Bookings
- `GET /api/v1/bookings/` - Get user's bookings (JWT required)
- `POST /api/v1/bookings/` - Create booking with payment verification
- `POST /api/v1/bookings/availability/check` - Check date availability
- `PUT /api/v1/bookings/{id}/confirm` - Confirm booking (host only)
- `DELETE /api/v1/bookings/{id}` - Cancel booking

### Payments
- `POST /api/v1/payments/create-payment-intent` - Create Stripe payment (JWT required)

### Reviews
- `POST /api/v1/reviews/` - Submit review (JWT required)
- `GET /api/v1/reviews/` - List all reviews
- `PUT /api/v1/reviews/{id}` - Update review (author only)
- `DELETE /api/v1/reviews/{id}` - Delete review (author only)

---

## Deployment

**Complete deployment guide:** See [`infrastructure/current/DEPLOYMENT.md`](infrastructure/current/DEPLOYMENT.md) for step-by-step instructions.

**Quick Deploy:**

```bash
# 1. Deploy Database (PlanetScale)
pscale auth login
pscale database create hbnb-db --region us-east
# Import data and get connection string

# 2. Deploy Backend (Fly.io)
cd backend
fly auth login
fly launch --config ../infrastructure/current/fly.toml
fly secrets set SQLALCHEMY_DATABASE_URI="mysql+pymysql://..."
fly deploy

# 3. Deploy Frontend (Vercel)
cd ../frontend
vercel login
vercel --prod
# Set environment variables: VITE_API_URL, VITE_STRIPE_PUBLISHABLE_KEY
```

**Production Features:**
- 24/7 uptime with no cold starts
- Auto-scaling included
- Global CDN for frontend
- Containerized deployment

**Live URLs:**
- Frontend: https://hbnb-luxeairbnbclone.vercel.app
- Backend API: https://hbnb-backend.fly.dev

---

## Running Tests

### Backend Tests
```bash
cd backend
python3 -m pytest -v              # Run all tests (39 tests)
python3 -m pytest --cov=app -v    # With coverage report
```
**Coverage**: 39 tests across 10 suites covering auth, users, places, amenities, reviews, booking/payment validation, and business rules. Uses in-memory SQLite (no MySQL needed).

### Frontend Tests
```bash
cd frontend
npm test                 # Run all tests (38 tests)
npm run test:coverage    # With coverage report
```
**Coverage**: 38 tests across AuthContext, Navigation, BookingForm, LoginPage, SignUpPage, HostPage, and API utilities using Vitest + React Testing Library.

### Continuous Integration
GitHub Actions automatically runs both backend and frontend tests on every push and pull request:
```bash
# View CI status
git push  # Triggers automated testing

# Workflow includes:
# - Backend: pytest with coverage
# - Frontend: vitest + build validation
# - Security: npm audit + bandit
# - Linting: ESLint + Black formatting check
```

---

## API Documentation

Interactive Swagger UI with complete endpoint documentation, request/response examples, and built-in testing.

**Access**: http://localhost:5000/doc (when backend is running)

**Features**:
- 🔐 Built-in authentication (click "Authorize" button)
- 📝 Request/response examples for all endpoints
- 🧪 "Try it out" buttons to test endpoints in browser
- 📊 All response codes documented

**Quick Start**:
```bash
# Get JWT token easily
cd backend
python3 get_token.py

# Or use Swagger UI login endpoint
# Then click "Authorize" and paste: Bearer YOUR_TOKEN
```

See `API_DOCUMENTATION_GUIDE.md` for detailed usage.

---

## Troubleshooting

**Local Development:**
- **Reset DB**: `mysql -u root < docs/hbnb_db.sql && python3 scripts/add_sample_data.py`
- **Free port**: `lsof -ti:5000 | xargs kill -9` (backend) or `lsof -ti:5173 | xargs kill -9` (frontend)
- **Frontend won't start**: `cd frontend && rm -rf node_modules && npm install`
- **Get JWT token**: `cd backend && python3 get_token.py`
- **View API docs**: http://localhost:5000/doc

**Production:**
- **Frontend not updating?** `vercel --prod` to redeploy, check Vercel dashboard
- **Backend 502 error?** `fly logs` to check errors, `fly status` for app health
- **Database connection?** Verify PlanetScale connection string in `fly secrets list`
- **Payment failing?** Verify Stripe API keys in Fly.io secrets
- **CORS errors?** Update backend CORS config with Vercel domain
- See [`infrastructure/current/DEPLOYMENT.md`](infrastructure/current/DEPLOYMENT.md) for detailed troubleshooting

---

## Feature Roadmap

**✅ Completed:**
- Multi-tenant property management system
- Complete booking lifecycle (pending → confirmed → completed)
- Stripe payment integration with verification
- Host dashboard with revenue analytics
- Review submission and display system
- JWT authentication with role-based access
- Production deployment (Vercel + Fly.io + PlanetScale)
- Docker containerization for backend
- HTTPS with auto-SSL certificates
- Responsive React 19 UI with Tailwind CSS
- Real-time availability checking
- Comprehensive testing (77 total tests: 39 backend + 38 frontend)
- Interactive API documentation (Swagger UI)
- GitHub Actions CI/CD pipeline
- Database query optimization with indexes
- Health monitoring endpoint
- Security scanning (Bandit + npm audit)

**🚧 Future Enhancements:**
- Image uploads for properties
- Email notifications (booking confirmations)
- Real-time messaging between hosts and guests
- Advanced search with filters (location, amenities, price range)
- Calendar blocking for unavailable dates
- Database migrations (Flask-Migrate)
- React Query for better data fetching and caching

---

**Authors:** Xiaoling Cui

**License:** MIT
