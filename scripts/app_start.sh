#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

APP_DIR="/var/www/book-store-mern-stack"

# Navigate to the application directory where code was deployed
cd $APP_DIR

echo "Starting Node application from $APP_DIR..."

# Create .env file from AWS Parameter Store values
echo "Fetching environment variables from AWS Parameter Store..."

# Use parameter names EXACTLY as they appear in Parameter Store
MONGODB_URL_PARAM="/book-store-mern-stack/prod/mongodb-url"
PORT_PARAM="/book-store-mern-stack/port"

# Fetch parameters - with error handling
echo "Fetching MongoDB URI..."
MONGODB_URL=$(aws ssm get-parameter --name "$MONGODB_URL_PARAM" --with-decryption --query Parameter.Value --output text) || { echo "Failed to fetch MongoDB URI parameter"; exit 1; }

echo "Fetching port setting..."
PORT=$(aws ssm get-parameter --name "$PORT_PARAM" --query Parameter.Value --output text) || { echo "Failed to fetch port parameter"; exit 1; }

# Write to .env file
echo "Writing .env file..."
cat > "$APP_DIR/.env" << EOF
MONGODB_URL=${MONGODB_URL}
PORT=${PORT}
EOF

echo "Starting application with PM2..."

# Check if PM2 is installed globally
if ! command -v pm2 &> /dev/null; then
    echo "PM2 not found. Installing PM2 globally..."
    npm install -g pm2
fi

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "Node.js not found. Please ensure Node.js is installed."
    exit 1
fi

# Start the application with PM2 using global path
pm2 start "$APP_DIR/index.js" --name "book-store-mern-stack" --env production

# Ensure PM2 restarts on server reboot
pm2 startup | bash || echo "PM2 startup script failed, you may need to configure it manually"
pm2 save || echo "PM2 save command failed"

echo "Application started successfully."