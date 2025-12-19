# HBnB - Luxe Airbnb Clone

A production-ready two-sided marketplace rental platform demonstrating full-stack development with React, Flask, and serverless deployment. Implements Stripe payment processing, JWT authentication, multi-tenant architecture, and real-time booking management with comprehensive host analytics. **Deployed on a $0/month free tier stack** with 24/7 uptime.

<div align="center">

**🚀 [View Live Demo](https://hbnb-frontend.vercel.app)** | Vercel + Fly.io + PlanetScale - mobile-ready

![HBnB screenshot](frontend/public/hbnb.png)

</div>

---

## Architecture

### Current Infrastructure (2025) - **$0/month**

**Production Stack:**
- **Frontend:** Vercel (React + Vite, Global CDN, 100GB bandwidth/month)
- **Backend:** Fly.io (Flask + Gunicorn, 3 VMs, 24/7 uptime)
- **Database:** PlanetScale (Serverless MySQL, 5GB storage, 1B reads/month)
- **Cost:** **$0/month** (permanent free tier)
- **Uptime:** 24/7 with no cold starts

**Why This Stack:**
- ✅ Free forever (not just 12-month trial)
- ✅ Production-grade infrastructure (powers companies like GitHub, Slack)
- ✅ Auto-scaling and global edge network
- ✅ Zero maintenance overhead
- ✅ Better developer experience than traditional cloud

### Legacy AWS Infrastructure (Archived)

Previous deployment used AWS with Terraform (EC2, RDS, S3, CloudFront). Migrated to reduce costs from $25-30/month to $0/month while maintaining production quality and 24/7 uptime. See [`infrastructure/legacy-aws/`](infrastructure/legacy-aws/) for details.

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
- **Current:** Vercel + Fly.io deployment (serverless/edge)
- **Legacy:** Terraform for AWS infrastructure as code (archived)
- Multi-cloud experience (AWS, Vercel, Fly.io, PlanetScale)
- Environment-based configuration (.env files)
- Pinned Python dependencies via `requirements-constraints.txt` for reproducible deploys
- Docker containerization for backend

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
└── cleanup_test_places.py  # Remove test properties

terraform/
├── main.tf                 # AWS infrastructure (EC2, RDS, S3, CloudFront)
└── .gitignore             # Exclude providers and state files
```

</details>

---

## API Endpoints

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

### Current Production Deployment (Vercel + Fly.io + PlanetScale)

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

**Benefits:**
- ✅ **$0/month cost** (vs $25-30/month on AWS)
- ✅ **24/7 uptime** with no cold starts
- ✅ **Auto-scaling** included
- ✅ **Global CDN** for frontend
- ✅ **Free forever** (not trial)

**Live URLs:**
- Frontend: `https://hbnb-frontend.vercel.app`
- Backend API: `https://hbnb-backend.fly.dev`

---

### Legacy AWS Deployment (Archived)

<details>
<summary><strong>Previous AWS deployment with GitHub Actions CI/CD</strong></summary>

The project previously used automated deployment via GitHub Actions to AWS:

**Setup:**
1. Follow the guide in `.github/SETUP_SECRETS.md` to configure GitHub secrets
2. Push to `main` branch to trigger automatic deployment
3. Or manually trigger from the Actions tab

**What it did:**
- ✅ Runs backend tests
- ✅ Deploys backend to EC2
- ✅ Builds and deploys frontend to S3
- ✅ Invalidates CloudFront cache

**Manual AWS Deployment:**

```bash
# Deploy Frontend
cd frontend
npm run build
aws s3 sync dist/ s3://hbnb-frontend/ --delete
aws cloudfront create-invalidation --distribution-id YOUR_ID --paths "/*"

# Deploy Backend
ssh -i your-key.pem ubuntu@YOUR_EC2_IP
cd /home/ubuntu/holbertonschool-hbnb
git pull origin main
sudo systemctl restart hbnb
```

**Migration Rationale:**
- AWS free tier expires after 12 months
- Ongoing cost: $25-30/month
- New stack achieves same production quality at $0/month permanently

See [`infrastructure/legacy-aws/`](infrastructure/legacy-aws/) for Terraform configuration.

</details>

---

## Running Tests

### Backend Tests
```bash
cd backend
python3 -m pytest -v              # Run all tests
python3 -m pytest --cov=app -v    # With coverage report
```
**Coverage**: 10 suites covering auth, users, places, amenities, reviews, booking/payment validation, and business rules. Uses in-memory SQLite (no MySQL needed).

### Frontend Tests
```bash
cd frontend
npm test                 # Run all tests
npm run test:coverage    # With coverage report
```
**Coverage**: 15 tests across AuthContext, BookingForm, Navigation, and Host dashboard auth/listings flows using Vitest + React Testing Library.

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

**Production (Vercel + Fly.io + PlanetScale):**
- **Frontend not updating?** `vercel --prod` to redeploy, check Vercel dashboard
- **Backend 502 error?** `fly logs` to check errors, `fly status` for app health
- **Database connection?** Verify PlanetScale connection string in `fly secrets list`
- **Payment failing?** Verify Stripe API keys in Fly.io secrets
- **CORS errors?** Update backend CORS config with Vercel domain
- See [`infrastructure/current/DEPLOYMENT.md`](infrastructure/current/DEPLOYMENT.md) for detailed troubleshooting

**Legacy AWS Production:**
- See collapsed section in [Deployment](#deployment) for AWS troubleshooting

---

## Feature Roadmap

**✅ Completed:**
- Multi-tenant property management system
- Complete booking lifecycle (pending → confirmed → completed)
- Stripe payment integration with verification
- Host dashboard with revenue analytics
- Review submission and display system
- JWT authentication with role-based access
- **Production deployment on $0/month free tier** (Vercel + Fly.io + PlanetScale)
- **Infrastructure migration** (AWS → Serverless, $25-30/month → $0/month)
- Multi-cloud deployment experience (AWS, Vercel, Fly.io, PlanetScale)
- Docker containerization for backend
- AWS deployment with Terraform (archived in `infrastructure/legacy-aws/`)
- HTTPS with auto-SSL certificates
- Responsive React 19 UI with Tailwind CSS
- Real-time availability checking
- Comprehensive testing (Backend: Pytest, Frontend: Vitest)
- Interactive API documentation (Swagger UI)
- CI/CD pipeline (GitHub Actions for AWS deployment)

**🚧 Future Enhancements:**
- Image uploads for properties (S3 integration)
- Email notifications (booking confirmations)
- Real-time messaging between hosts and guests
- Advanced search with filters (location, amenities, price range)
- Calendar blocking for unavailable dates
- Increase test coverage to 80%+
- Database migrations (Flask-Migrate)
- Rate limiting and input sanitization

---

**Authors:** Xiaoling Cui

**License:** MIT
