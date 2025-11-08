# Car Price Predictor - Configuration Management

[![Ansible](https://img.shields.io/badge/Ansible-2.9+-red.svg)](https://www.ansible.com/)
[![AWS](https://img.shields.io/badge/AWS-EC2-orange.svg)](https://aws.amazon.com/ec2/)
[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)

Enterprise-grade Ansible automation for deploying full-stack Flask car price prediction application with backend ML API and frontend web interface to AWS EC2 infrastructure.

## Overview

This repository contains Infrastructure as Code (IaC) automation using Ansible to deploy and manage a full-stack Flask application on Amazon EC2 instances. The solution deploys both backend ML API and frontend web services with automated configuration management, service orchestration, and CI/CD pipeline integration.

## Prerequisites

### Required Software
- **Ansible**: >= 2.9
- **Terraform**: >= 1.0 (for infrastructure provisioning)
- **Python**: >= 3.8
- **AWS CLI**: >= 2.0

### Required Access
- AWS credentials with EC2 management permissions
- SSH key pair for EC2 instance access
- Terraform state backend access (S3)

### Environment Variables
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

## Project Structure

```
configManagement-carPrice/
├── roles/flask_app/              # Ansible role for Flask app deployment
│   ├── defaults/main.yml         # Default variables
│   ├── tasks/main.yml            # Deployment tasks
│   └── templates/
│       ├── app.service.j2        # Backend ML API service
│       ├── frontend.service.j2   # Frontend web service
│       └── start-production.sh.j2 # Production startup script
├── generate_inventory.sh         # Dynamic inventory generator
├── inventory.ini                # Ansible inventory file
└── playbook.yml                # Main Ansible playbook
```

## Quick Start

### 1. Infrastructure Preparation
Ensure Terraform infrastructure is deployed and accessible:
```bash
cd ../infra
terraform plan
terraform apply
```

### 2. Generate Dynamic Inventory
```bash
chmod +x generate_inventory.sh
./generate_inventory.sh
```

### 3. Deploy Application
```bash
# Dry run (check mode)
ansible-playbook -i inventory.ini playbook.yml --check

# Production deployment
ansible-playbook -i inventory.ini playbook.yml
```

### 4. Verify Deployment
```bash
# Backend service status
ssh ec2-user@$(terraform -chdir=../infra output -raw ec2_public_ip) 'systemctl status carprice'

# Frontend service status
ssh ec2-user@$(terraform -chdir=../infra output -raw ec2_public_ip) 'systemctl status carprice-frontend'

# Application endpoints
echo "Backend API: http://$(terraform -chdir=../infra output -raw ec2_public_ip):5002"
echo "Frontend Web: http://$(terraform -chdir=../infra output -raw ec2_public_ip):3000"
```

## Configuration

### Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `app_repo` | `https://github.com/andreaendigital/CarPricePredictor-Demo.git` | Source repository URL |
| `app_dest` | `/home/ec2-user/CarPricePredictor-Demo` | Application deployment path |
| `app_branch` | `main` | Git branch to deploy |
| `log_file` | `/var/log/carprice.log` | Application log file location |

### Service Specifications

#### Backend ML API Service
| Parameter | Value | Purpose |
|-----------|-------|---------|
| **Service Name** | `carprice` | Backend ML API service |
| **Runtime User** | `ec2-user` | Non-privileged execution context |
| **Network Binding** | `0.0.0.0:5002` | ML API endpoints |
| **Restart Policy** | `always` | Automatic recovery on failure |
| **Boot Behavior** | `enabled` | Auto-start on system boot |

#### Frontend Web Service
| Parameter | Value | Purpose |
|-----------|-------|---------|
| **Service Name** | `carprice-frontend` | Frontend web interface |
| **Runtime User** | `ec2-user` | Non-privileged execution context |
| **Network Binding** | `0.0.0.0:3000` | Web interface |
| **Restart Policy** | `always` | Automatic recovery on failure |
| **Boot Behavior** | `enabled` | Auto-start on system boot |

### Security Considerations
- Services run under non-root user (`ec2-user`)
- Virtual environment isolation for Python dependencies
- Systemd service hardening applied
- Network access controlled via AWS Security Groups

## Deployment Pipeline

### Automated Tasks
1. **System Preparation**
   - Package manager updates (YUM)
   - Essential tooling installation (Python3, pip, git, make)

2. **Application Deployment**
   - Source code retrieval from Git repository
   - Python virtual environment creation
   - Dependency installation with pip

3. **Service Configuration**
   - Backend ML API service deployment (port 5002)
   - Frontend web service deployment (port 3000)
   - Service enablement and startup
   - Health verification

### Idempotency
All tasks are designed to be idempotent, ensuring safe re-execution without side effects.

## System Requirements

### Target Platform
- **Operating System**: Amazon Linux 2 / RHEL 8+
- **Architecture**: x86_64
- **Python Runtime**: 3.8+
- **Package Manager**: YUM/DNF
- **Init System**: systemd

### Resource Requirements
- **CPU**: 1+ vCPU
- **Memory**: 1GB+ RAM
- **Storage**: 10GB+ available disk space
- **Network**: Internet connectivity for package downloads

## Operations & Maintenance

### Health Monitoring
```bash
# Backend service status
sudo systemctl status carprice

# Frontend service status
sudo systemctl status carprice-frontend

# Real-time logs
sudo journalctl -u carprice -f
sudo journalctl -u carprice-frontend -f

# Application logs
sudo tail -f /var/log/carprice.log
```

### Service Management
```bash
# Restart services
sudo systemctl restart carprice
sudo systemctl restart carprice-frontend

# Stop services
sudo systemctl stop carprice
sudo systemctl stop carprice-frontend

# Start services
sudo systemctl start carprice
sudo systemctl start carprice-frontend

# Reload systemd configuration
sudo systemctl daemon-reload
```

### Common Issues

| Issue | Symptom | Resolution |
|-------|---------|------------|
| Backend service fails | `failed (Result: exit-code)` | Check logs with `journalctl -u carprice` |
| Frontend service fails | `failed (Result: exit-code)` | Check logs with `journalctl -u carprice-frontend` |
| Port binding error | `Address already in use` | Verify ports 5002/3000 are available |
| Permission denied | `Permission denied` errors | Ensure `ec2-user` has proper file permissions |

## CI/CD Integration

This playbook integrates with Jenkins pipelines and supports:
- Automated inventory generation from Terraform state
- SSH agent forwarding for secure deployments
- Dual-service deployment (backend + frontend)
- Post-deployment verification steps
- Service health monitoring
- Rollback capabilities

## Application Access

After successful deployment, access the application at:
- **Backend ML API**: `http://EC2_PUBLIC_IP:5002`
  - Endpoints: `/current_value_market`, `/future_prediction`, `/publish_car`
- **Frontend Web Interface**: `http://EC2_PUBLIC_IP:3000`
  - Interactive web UI for car price predictions

## Contributing

1. Follow Ansible best practices and role conventions
2. Test changes in development environment first
3. Update documentation for any configuration changes
4. Ensure idempotency of all tasks

## License

Enterprise Internal Use Only

## Support

For technical support, contact the DevOps team or create an issue in the internal ticketing system.

---
**Version**: 2.0.0  
**Last Updated**: November 2024  
**Maintained by**: DevOps Engineering Team