#!/bin/bash
# System Update
yum update -y

# Install Python and Pip
yum install -y python3 python3-pip

# Create App Directory
mkdir /home/ec2-user/flask_app
cd /home/ec2-user/flask_app

# Install Flask
pip3 install flask

# Create the Flask Application
cat <<EOF > app.py
from flask import Flask, render_template_string
import socket
import datetime

app = Flask(__name__)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>AWS Web Server Test</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card { border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-top: 50px; }
        .status-pill { padding: 5px 15px; border-radius: 20px; background-color: #28a745; color: white; font-weight: bold; }
        .info-label { color: #6c757d; font-weight: 600; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card p-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="text-primary m-0">AWS Elastic Server</h2>
                        <span class="status-pill">LIVE</span>
                    </div>
                    <hr>
                    <div class="row g-3">
                        <div class="col-6">
                            <p class="info-label mb-1">Hostname</p>
                            <p class="fs-5 text-dark fw-bold">{{ hostname }}</p>
                        </div>
                        <div class="col-6">
                            <p class="info-label mb-1">Local IP Address</p>
                            <p class="fs-5 text-dark fw-bold">{{ ip_address }}</p>
                        </div>
                        <div class="col-12">
                            <p class="info-label mb-1">Request Timestamp</p>
                            <p class="text-muted">{{ timestamp }}</p>
                        </div>
                    </div>
                    <div class="mt-4 pt-3 border-top text-center text-secondary">
                        <small>Infrastructure managed by <strong>ASG & ALB</strong></small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
"""

@app.route('/')
def index():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return render_template_string(HTML_TEMPLATE, hostname=hostname, ip_address=ip_address, timestamp=timestamp)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF

# Run the app in background
python3 app.py &