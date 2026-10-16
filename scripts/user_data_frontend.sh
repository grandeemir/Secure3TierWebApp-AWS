#!/bin/bash
# Amazon Linux 2023 EC2 User Data Script - FRONTEND ONLY
# Nginx Static File Hosting with Reverse Proxy for ToDo App

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting Frontend setup for Amazon Linux 2023..."

# Update system
dnf update -y

# Install Nginx and git
dnf install -y nginx git

# Create application directory
APP_DIR="/var/www/todoapp/frontend"
mkdir -p $APP_DIR

# Clone the repository
git clone https://github.com/grandeemir/ToDoAPP.git /tmp/todoapp_repo
cp -r /tmp/todoapp_repo/frontend/* $APP_DIR/
rm -rf /tmp/todoapp_repo

# --- Configuration ---
# Set the BACKEND_URL to the local proxy path (/api)
sed -i "s|const BACKEND_URL = '';|const BACKEND_URL = '/api';|g" $APP_DIR/index.html

# # sed -i "s|const BACKEND_URL = '';|const BACKEND_URL = 'http://${backend_alb_dns}';|g" $APP_DIR/index.html

# Configure Nginx to serve the frontend and proxy API requests
cat <<EOF > /etc/nginx/conf.d/todoapp.conf
server {
    listen 80;
    server_name _;

    # Serve static frontend files
    location / {
        root $APP_DIR;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # Reverse Proxy for Backend API
    location /api/ {
        proxy_pass http://${backend_alb_dns}:8080/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Remove default nginx config if exists
rm -f /etc/nginx/nginx.conf.default

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

echo "Frontend setup completed successfully. Web interface is running on port 80 with Reverse Proxy to Backend."
