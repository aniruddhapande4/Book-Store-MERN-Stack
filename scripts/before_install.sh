#!/bin/bash
set -e

echo "Installing Node.js..."

# Enable Node.js 18 using amazon-linux-extras
amazon-linux-extras enable nodejs18
yum clean metadata
yum install -y nodejs

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
