# 🛡️ Secure 3-Tier Web Application on AWS with Terraform

> **⚠️ Project Status: Under Development**  
> This project is currently in the active development phase. At the moment, **only the `DEV` environment is fully configured and ready to be deployed.** The `PROD` environment will be available in future updates.

Welcome to the Secure 3-Tier Web Application project! This project automatically builds a complete, secure, and scalable web application infrastructure on Amazon Web Services (AWS) using **Terraform**. 

---

## 📖 What is a 3-Tier Architecture?

<p align="center">
  <img src="assets/secure3tierwebapp.drawio.svg" alt="Architecture" width="800">
</p>

A 3-tier architecture divides the application into three logical parts (tiers). This makes the system more secure, easier to manage, and scalable.

| Tier | Component | Description |
| :--- | :--- | :--- |
| **Presentation Tier (Web)** | `Application Load Balancer` | Receives traffic from the users (the internet) and securely sends it to our servers. |
| **Application Tier (App)** | `Auto Scaling Group (EC2)` | This is where the actual web application (like a Python Flask app) runs. It scales up or down depending on the traffic. |
| **Database Tier (Data)** | `Amazon RDS` | This is where all the application data is securely stored. It is hidden in private networks so the internet cannot directly access it. |

---

## 🏗️ Project Architecture & Features

When you run this Terraform project, it creates the following AWS resources. Here is a breakdown of what gets created and why:

| AWS Resource | Purpose |
| :--- | :--- |
|  **VPC (Virtual Private Cloud)** | A private, secure network just for this project. |
|  **Public & Private Subnets** | **Public subnets** are for the Load Balancer (internet accessible). ‼️Important: In this project I used EC2's in public subnet for reduce NAT GW cost, but don't worry EC2's are not accesable on the internet they just allowed for outgoind traffic and just allow traffic from ALB SG.<br>**Private subnets** are for the App Servers (EC2) and the Database (RDS) to keep them secure. |
|  **Security Groups** | Firewalls that control who can talk to what. For example, only the Load Balancer can talk to the App Servers, and only the App Servers can talk to the Database. |
|  **Application Load Balancer** | Distributes incoming user traffic evenly across multiple web servers. |
|  **Auto Scaling Group** | Automatically creates new EC2 instances (servers) if there is a lot of traffic, and removes them when traffic is low. |
|  **Amazon RDS** | A managed MySQL/PostgreSQL database to store data securely. |

---

## 📂 Folder Structure

This project is organized using **Terraform Modules** to keep the code clean and reusable.

```text
├── environments/
│   ├── DEV/         #  Configuration for the Development environment (Currently Active)
│   └── PROD/        #  Configuration for the Production environment (WIP)
├── global/          #  Global resources like IAM roles or S3 backends
├── modules/
│   ├── asg/         #  Creates the Auto Scaling Group and EC2 templates
│   ├── elb/         #  Creates the Application Load Balancer
│   ├── rds/         #  Creates the Database
│   └── vpc/         #  Creates the Network, Subnets, and Security Groups
└── scripts/         #  Bash scripts that install the app on the servers (User Data)
```

---

## 🚀 How to Deploy the Project

Deploying this project is very easy. As mentioned, currently only the `DEV` (Development) environment is supported.

### Step 1: Clone the Repository
First, clone this project to your local machine:
```bash
git clone https://github.com/your-username/Secure3TierWebApp-AWS.git
cd Secure3TierWebApp-AWS
```
*(Note: Replace the URL with your actual repository URL)*

### Step 2: Go to the environment folder
Open your terminal and navigate to the DEV folder:
```bash
cd environments/DEV
```

### Step 3: Initialize Terraform
This command downloads the necessary provider plugins (like the AWS plugin) and prepares the folder.
```bash
terraform init
```

### Step 4: Check the Plan
This command shows you exactly what Terraform is going to create in your AWS account. It does NOT create anything yet.
```bash
terraform plan
```

### Step 5: Apply and Build
If you are happy with the plan, run this command to build the infrastructure. Terraform will ask you to type `yes` to confirm.
```bash
terraform apply
```
> ⏳ *(Wait a few minutes. AWS takes some time to create the Database and the Servers).*

### Step 6: View your App
When the `terraform apply` command finishes, it will print a **"Load Balancer DNS Name"** (a URL) on your screen. Copy that URL and paste it into your web browser to see your working application!

---

## 🧹 How to Delete the Project (Clean Up)

When you are done testing and want to avoid paying AWS bills, you must destroy the resources. 

Make sure you are still in the `environments/DEV` folder, then run:
```bash
terraform destroy
```
> ⚠️ Terraform will ask you to type `yes` to confirm. This will safely delete everything created by this project.

---

## Roadmap & Future Features

This project is constantly being improved. In upcoming updates, a comprehensive **Security and Monitoring Layer** will be added to the infrastructure, which will include:

- [x]  **Amazon CloudWatch:** For monitoring resources, collecting logs, and setting up alarms.
- [ ]  **Amazon GuardDuty:** Intelligent threat detection to continuously monitor for malicious activity and unauthorized behavior.
- [ ]  **AWS CloudTrail:** To track user activity and API usage across the AWS infrastructure.
- [x]  **VPC Flow Logs:** To capture information about the IP traffic going to and from network interfaces in the VPC.

---

## 📝 Notes

> 🛑 **IMPORTANT:** Do not commit sensitive passwords to GitHub. Use AWS Secrets Manager for production environments.
