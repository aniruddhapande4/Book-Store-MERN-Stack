#!/bin/bash
set -e

echo "Installing Node.js..."

# Clean metadata and update system packages
yum clean all
yum update -y

# Install Node.js 18 using NodeSource
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -

# Install Node.js and npm
yum install -y nodejs --skip-broken

# Create application directory if it doesn't exist
mkdir -p /var/www/book-store-mern-stack

# Install PM2 globally
npm install -g pm2

# Check versions
echo "Node.js version:"
node -v
echo "npm version:"
npm -v
echo "PM2 version:"
pm2 -v

echo "Node.js installation completed"
