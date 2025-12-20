# AWS Deployment Scripts (Legacy)

These scripts were used for the original AWS deployment (EC2 + RDS + S3 + CloudFront).

**Status**: No longer in use. The application has been migrated to:
- Frontend: Vercel
- Backend: Fly.io
- Database: PlanetScale

## Scripts

- **deploy-all.sh**: Full deployment script (frontend + backend)
- **deploy-backend.sh**: Deploy backend to EC2
- **deploy-frontend.sh**: Deploy frontend to S3
- **deploy_to_ec2.sh**: EC2 deployment helper script

## Note

These scripts are preserved for reference and to demonstrate the migration from AWS to the current free-tier stack.

For current deployment instructions, see `/infrastructure/current/DEPLOYMENT.md`
