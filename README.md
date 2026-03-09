<div align="center">
  
# 🏗️ AWS Governed Data Lakehouse

**Secure, Scalable Analytics with Lake Formation & Apache Iceberg**

A governed data lakehouse on AWS that ingests operational data from multiple sources, transforms it through medallion-architecture zones (Landing → Curated → Presentation), and enforces fine-grained access control with Lake Formation all backed by Apache Iceberg for ACID transactions and schema evolution.

[![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![CloudFormation](https://img.shields.io/badge/IaC-CloudFormation-FF4F00?logo=amazonaws&logoColor=white)](https://aws.amazon.com/cloudformation/)
[![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![Lake Formation](https://img.shields.io/badge/Governance-Lake%20Formation-232F3E?logo=amazonaws&logoColor=white)](https://aws.amazon.com/lake-formation/)
[![Iceberg](https://img.shields.io/badge/Table%20Format-Apache%20Iceberg-4291E2?logo=apache&logoColor=white)](https://iceberg.apache.org/)
[![Glue](https://img.shields.io/badge/ETL-AWS%20Glue-1A73E8?logo=amazonaws&logoColor=white)](https://aws.amazon.com/glue/)
[![Athena](https://img.shields.io/badge/Query-Amazon%20Athena-232F3E?logo=amazonaws&logoColor=white)](https://aws.amazon.com/athena/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## 💡 Problem Statement

Organizations need to decouple analytical workloads from production OLTP databases while maintaining strict data governance. Running ad-hoc queries directly on transactional systems degrades performance, and opening up data lake access without governance creates compliance and security risks.

### **This project solves both problems by implementing:**

1. **Governed Data Lakehouse** — A three-zone architecture (Landing → Curated → Presentation) where every resource is governed by **AWS Lake Formation** with tag-based access control (TBAC), ensuring only authorized roles and users access specific data.

2. **ACID-Compliant Table Format** — **Apache Iceberg** tables registered with the AWS Glue Catalog enable MERGE INTO upserts, schema evolution (ALTER TABLE ADD COLUMNS), and time-travel queries — going beyond immutable Parquet-on-S3.

3. **Role-Separated Access** — Distinct IAM roles for Lake Formation registration, data lake administration, Glue ETL execution, and ML consumer access — enforcing the principle of least privilege at every layer.

## 🏛️ Architecture

![Lakehouse Architecture](./images/architecture.png)

**End-to-End Data Flow:**

The system ingests data from two sources — an **RDS MySQL** transactional database (batch CSV) and a **streaming JSON** source (ratings data). Both flows land in the **Landing Zone** on S3, are transformed by **AWS Glue PySpark** jobs with schema enforcement and metadata enrichment into the **Curated Zone**, and surface as Iceberg tables registered in the **Glue Catalog** for **Athena** queries — all governed by **Lake Formation** permissions.

## 📝 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

> ### 🌟 Contributions Welcome  
> Built with ❤️ on AWS to make governed data analytics feel effortless.
