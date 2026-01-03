# AWS Deployment Documentation (Archived)

This directory contains documentation for the original AWS deployment that has been migrated to Vercel + Fly.io + TiDB Serverless.

## Contents

### Migration Documentation
- **INFRASTRUCTURE_MIGRATION.md** - Complete migration guide from AWS to serverless stack

### CI/CD Documentation
- **ci-cd-setup.md** - GitHub Actions setup for automated AWS deployment
- **SETUP_SECRETS.md** - GitHub secrets configuration guide
- **QUICK_START.md** - Quick start guide for AWS deployment

## GitHub Workflows

The GitHub Actions workflows for AWS deployment are archived in:
`/infrastructure/legacy-aws/github-workflows/`

- **deploy.yml** - Automated deployment to EC2 and S3
- **tests.yml** - Automated testing workflow
- **code-quality.yml** - Code quality checks

## Current Deployment

For current deployment documentation, see:
- **Production:** `/infrastructure/current/DEPLOYMENT.md`
- **README:** `/README.md`

## Note

These files are preserved for reference and to document the infrastructure evolution of this project.
