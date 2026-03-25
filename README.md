

# Terraform AWS Modules

**Terraform AWS Modules** is a personal, reusable library of Terraform modules designed for automation, testing, and rapid deployment of AWS infrastructure. Each module is **tested individually** and uses **placeholder values** to allow quick adaptation to new projects. This repository helps me provision, manage, and maintain AWS resources efficiently while ensuring modularity and reusability.

---

## Repository Structure

The repository is organized into multiple folders representing AWS services and resource types. Each folder contains its own `main.tf`, `variables.tf`, and `outputs.tf` for modularity:

| Folder / Module             | Description                                                                                      |
|-----------------------------|--------------------------------------------------------------------------------------------------|
| **VPC**                     | VPC, subnets, route tables, internet gateways, NAT gateways, and connectivity-related resources. |
| **Other Networking**        | VPC endpoints, Route 53, virtual private gateways, network ACLs, Direct Connect, and other advanced networking components. |
| **EC2**                     | EC2 instances including on-demand, spot, scheduled, and autoscaling configurations.             |
| **EKS**                     | Amazon EKS clusters, managed node groups, and IAM roles/policies for container orchestration.   |
| **ECS**                     | ECS clusters, task definitions, services, and related IAM roles for containerized workloads.    |
| **Storage**                  | S3 buckets of various types, versioning, lifecycle rules, analytics, and optional log buckets. |
| **Databases**               | RDS, Aurora, and DynamoDB modules with configurable credentials and instance types.             |
| **IAM**                      | IAM users, groups, roles, and policies with placeholders to demonstrate relationships and access control. |
| **Messaging & Queuing**      | SNS topics, SQS queues, and Kinesis streams for event-driven architectures.                     |
| **Monitoring & Logging**     | CloudWatch log groups, metrics, and optional S3 buckets for storing logs. General-purpose modules not tied to EKS/ECS. |
| **Security**                 | KMS keys, AWS Shield, GuardDuty, and other security-related modules.                             |
| **Analytics**                | Modules for Glue, Athena, and other analytics pipelines and storage.                             |
| **Lambda**                   | AWS Lambda functions, roles, and permissions for serverless processing.                          |
| **Load Balancer**            | ALB, NLB, and other load balancers for distributing traffic to compute resources.                |
| **README.md**                | This documentation file explaining the repository and its structure.                            |

---

## Purpose and Benefits

This repository provides:

- **Reusability** – Modules can be applied independently or combined to build complex AWS environments.  
- **Automation** – Reduces manual effort by providing pre-defined, tested infrastructure patterns.  
- **Rapid Testing** – Placeholder names allow modules to be deployed quickly for experimentation.  
- **Interdependencies Maintained** – Resources are linked where necessary (e.g., subnets attached to VPCs, IAM roles linked to ECS/EKS).  
- **Modular Organization** – Clear separation by AWS service for maintainability and scalability.  

---

## Usage Concept

- Modules can be applied individually for isolated testing.  
- Multiple modules can be combined to provision fully functional AWS environments.  
- Replace placeholder names and values with project-specific identifiers to deploy real infrastructure.  

---

## Summary

**Terraform AWS Modules** is a personal, reusable, and tested Terraform library covering networking, compute, storage, databases, security, messaging, analytics, monitoring, and container orchestration. Its modular design ensures fast, consistent, and reliable deployment of AWS resources, making it an **automation-first approach** to infrastructure management.