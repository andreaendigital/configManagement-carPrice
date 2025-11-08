#!/bin/bash

# Deployment verification script
set -e

echo "🔍 Verifying Car Price Predictor deployment..."

# Get EC2 IP from Terraform
cd infra
EC2_IP=$(terraform output -raw ec2_public_ip)
cd ..

if [[ -z "$EC2_IP" ]]; then
  echo "❌ Could not get EC2 IP address"
  exit 1
fi

echo "📍 Target server: $EC2_IP"

# Check service status
echo "🔧 Checking carprice service status..."
ssh -i ~/.ssh/demoCar-jenkins_key.pem ec2-user@$EC2_IP 'sudo systemctl status carprice --no-pager'

# Check if application is responding
echo "🌐 Testing application health..."
sleep 5
curl -f "http://$EC2_IP:5002/health" || echo "⚠️  Health endpoint not available"

# Test prediction endpoint
echo "🧠 Testing ML prediction endpoint..."
curl -f "http://$EC2_IP:5002/current_value_market?model_year=2020&age=4&fuel_type=Gasoline&transmission=Automatic&clean_title=1" || echo "⚠️  Prediction endpoint not available"

echo "✅ Deployment verification completed"