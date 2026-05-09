# Amazon Linux 2023
sudo dnf install -y nodejs npm git

### 3. Clone / Upload Project
# Option A: git clone
git clone https://github.com/your-repo/taskmanager.git
cd taskmanager

# Option B: SCP from local
scp -r ./taskmanager ec2-user@<EC2-IP>:~/

### 4. Install Dependencies
npm install

### 5. Configure Environment
cp .env.example .env
nano .env      # Fill in your RDS endpoint and credentials

### 6. Start the App
# Development
npm start

# Production (keep alive with PM2)
sudo npm install -g pm2
pm2 start app.js --name taskflow
pm2 startup
pm2 save