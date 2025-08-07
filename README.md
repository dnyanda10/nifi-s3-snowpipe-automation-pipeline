# NiFi-S3-Snowpipe Automation Pipeline

This project demonstrates an end-to-end **data pipeline using Apache NiFi, AWS S3, and Snowflake**, implementing **SCD Type 2** handling and **automated ingestion with Snowpipe**. It is designed to handle customer data ingestion, historical tracking, and real-time updates using cloud-native tools.


## 📌 Project Overview

**Goal:** Automate the ingestion of customer data files from a local directory → upload to S3 via NiFi → auto-load into Snowflake using Snowpipe → apply SCD Type 2 logic to track changes historically.


## 🧱 Architecture Diagram

![NiFi S3 Snowpipe Architecture](image/architecture.png)


## 🛠️ Tools & Technologies

- **Apache NiFi 2.5**
- **AWS S3** (Data Lake)
- **AWS IAM** (for access control)
- **AWS SQS** (for Snowpipe notifications)
- **Snowflake** (Data warehouse)
- **Snowpipe** (Continuous data loading)
- **SQL (Merge, Stream, Task)** for SCD Type 2 handling


## 🔄 Pipeline Flow

1. **Local File Upload:**
   - Customer `.csv` files are placed in a monitored folder.

2. **Apache NiFi Flow:**
   - `ListFile` → `FetchFile` → `PutS3Object`
   - Automatically pushes files from the local system to a designated S3 bucket.

3. **AWS S3 Bucket:**
   - Organized folder structure for raw data.
   - Triggers **SQS notifications** on new file upload.

4. **Snowpipe Integration:**
   - Uses SQS to trigger **Snowpipe**.
   - Snowpipe loads data into the `customer_raw` table in Snowflake.

5. **Snowflake Processing:**
   - `STREAM` tracks changes in the raw table.
   - A **view** (`v_customer_change_data`) holds CDC logic.
   - A **TASK** runs every 1 minute to merge into:
     - `customer` (current table)
     - `customer_history` (historical table)

## 🧾 Snowflake Objects Used

- Tables: `customer`, `customer_history`, `customer_raw`
- View: `v_customer_change_data`
- Stream: `customer_table_changes`
- Task: `tsk_scd_hist`
- Snowpipe: `snowpipe_customer`
- Integration: `s3_snowpipe_integration`


## 🔐 IAM & Security

- **IAM User** with S3 access created.
- **Custom Policy** attached for:
  - S3 read/write
  - SQS read
- Trust relationship established for **Snowflake external stage**.
- Used `sqs_notification_config.json` for automated Snowpipe triggers.

---

## 📂 Project Structure

```bash
Snowflake-NIFI real Project/
│
├── AWS S3/
│   ├── S3_bucket_structure.txt
│   ├── s3_policy.json
│   └── sqs_notification_config.json
│
├── snowflake/
│   ├── Table Creation.sql
│   ├── Load data.sql
│   ├── streams.sql
│   ├── Merge data SCD1.sql
│   └── SCD 2.sql
│
├── NIFI_Template/
│   └── nifi-s3-to-snowflake.xml
│
├── Image/
│   └── architecture_diagram.png
│
├── .gitignore
├── README.md
└── LICENSE





