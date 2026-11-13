# Freshfood – MERN Stack with DevSecOps

## Overview

Freshfood is a MERN stack food delivery application originally developed as a group project during my bachelor's degree.

At that time, I was responsible for frontend development and database-related work. Later, as I started learning DevOps and Cloud Computing, I revisited the application and experimented with modern DevOps practices, cloud infrastructure, containerization, Kubernetes and security automation.

## Architecture

The application follows a three-tier architecture:

1. **Frontend:** React-based customer application and admin panel.
2. **Backend:** Node.js and Express REST APIs.
3. **Database:** MongoDB Atlas.

### DevOps Architecture

- Docker for containerizing frontend, admin and backend.
- Amazon ECR for storing container images.
- Amazon EKS for Kubernetes orchestration.
- Terraform for AWS infrastructure provisioning.
- GitHub Actions for CI/CD automation.
- Kubernetes Deployments and Services for application management.
- AWS Secrets Manager and Secrets Store CSI Driver for application secrets.
- IAM and IRSA for AWS access management.
- Amazon S3 for image storage integration.
- Nginx for frontend routing and backend API proxying.

## Technology Stack

| Category | Technologies |
|---|---|
| Frontend | React, Vite |
| Backend | Node.js, Express |
| Database | MongoDB Atlas |
| Containers | Docker |
| Orchestration | Kubernetes, Amazon EKS |
| Cloud | AWS |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions |
| Container Registry | Amazon ECR |
| Security | Gitleaks, Trivy, CodeQL, npm audit |
| Secrets Management | AWS Secrets Manager, Secrets Store CSI Driver |
| Storage | Amazon S3 |

## CI/CD Workflow

The GitHub Actions pipeline is organized into three stages:

1. **Terraform:** Infrastructure provisioning and validation.
2. **Security Checks:** Application builds, linting, dependency auditing, secret scanning, code analysis and container vulnerability scanning.
3. **Deployment:** Deploying application containers to Amazon EKS after the previous stages pass.

## Challenges and Learnings

During implementation, I encountered and worked through several real-world issues:

- MongoDB Atlas connectivity failures caused by NAT Gateway egress IP restrictions.
- Kubernetes RBAC permission issues affecting Secrets Store CSI secret synchronization.
- Backend container startup failures due to missing production startup configuration.
- Kubernetes Service discovery and internal API connectivity troubleshooting.
- Managing application secrets without including environment files in the repository.
- Coordinating Terraform infrastructure, CI/CD workflows and Kubernetes deployments.

These challenges helped me understand how application development connects with cloud infrastructure, security and production deployment.

## Future Improvements

This project will continue to evolve as I learn more DevOps practices.

Planned improvements include:

- Implementing monitoring and observability.
- Setting up metrics collection and dashboards.
- Configuring alerts for application and infrastructure health.
- Improving centralized logging and operational visibility.

## Project Outcome

This project helped me revisit an application I developed during my bachelor's degree and apply the DevOps concepts I learned afterward.

It provided hands-on experience with containerization, infrastructure automation, Kubernetes, CI/CD, cloud security and troubleshooting.

**Note:** AWS infrastructure was used for experimentation and deployment. It may not be running currently. Monitoring and observability improvements are planned for future iterations.
