

# 🌍 Project: azure-earthquake-analytics-pipeline

### *Automated Geospatial Data Engineering with Medallion Architecture*

## 📌 Project Overview

This project establishes a robust, automated Big Data pipeline on the **Microsoft Azure** ecosystem to monitor global earthquake activity. By integrating the **USGS Earthquake API** with a **Medallion Architecture**, the platform transforms high-velocity raw GeoJSON data into refined, enriched datasets ready for emergency response analysis and risk assessment.

---

## 🏛 Technical Architecture

The solution is built on four functional pillars:

1. **Orchestration (ADF):** A metadata-driven pipeline that manages schedules and dynamic date parameters.
2. **Storage (ADLS Gen2):** A hierarchical Data Lake providing cost-effective, tiered storage for raw, cleaned, and aggregated data.
3. **Processing (Databricks):** Distributed Spark compute handles the heavy lifting of JSON flattening and geospatial enrichment.
4. **Serving (Synapse Analytics):** A Serverless SQL interface allowing for high-speed relational queries directly on the Data Lake files.

---

## 🛠 The Data Lifecycle (Medallion Layers)

### 🥉 Bronze: Raw Ingestion

* **Source:** [USGS Earthquake API](https://earthquake.usgs.gov/fdsnws/event/1/)
* **Logic:** A Python-based ingestion engine fetches daily seismic events.
* **Metadata:** Data is stored in its native **GeoJSON** format to preserve the original source of truth.
* **Automation:** ADF passes dynamic `start_date` and `end_date` widgets to the ingestion notebook.

### 🥈 Silver: Validation & Cleaning

* **Schema Evolution:** Flattens complex, nested JSON objects into a structured tabular schema.
* **Data Integrity:** Implements rigorous type casting (`Unix` → `Timestamp`) and filters out records with invalid coordinates.
* **Storage:** Persisted in **Parquet format** for optimized Spark read/write performance.

### 🥇 Gold: Business Enrichment

* **Geospatial Intelligence:** Leverages the `reverse_geocoder` library to translate raw Latitude/Longitude into international **Country Codes**.
* **Feature Engineering:** * `intensity`: Categorical magnitude ranking.
* `depth_category`: Vertical seismic classification (Shallow, Intermediate, Deep).
* `sig_class`: Significance-based risk grouping.



---

## 🔐 Security & Governance

* **Managed Identities:** Uses **Azure Access Connector** for Databricks to authenticate with storage without the need for hardcoded keys or secrets.
* **Parameterization:** Entirely decoupled; storage paths and date ranges are passed as JSON objects between activities.
* **External Tables:** Leverages Synapse Serverless to query data without duplicating it into a dedicated SQL database, minimizing costs.

---

## 📊 Analytical Use Cases

Using **Synapse SQL**, stakeholders can immediately run complex seismic profiles:

```sql
-- Activity Report: Top 10 Most Active Regions
SELECT TOP 10
    country_code, 
    COUNT(*) as seismic_event_count,
    MAX(mag) as peak_magnitude
FROM earthquake_events_gold
GROUP BY country_code
ORDER BY seismic_event_count DESC;

-- Safety Analysis: Shallow vs. Deep Earthquake Intensity
SELECT 
    depth_category, 
    ROUND(AVG(mag), 2) as average_mag,
    COUNT(*) as total_events
FROM earthquake_events_gold
GROUP BY depth_category;

```

---

## 🚀 Deployment Guide

1. **Infrastructure:** Provision ADLS Gen2 with `bronze`, `silver`, and `gold` containers.
2. **Compute:** Deploy a Databricks Standard Cluster; install `reverse_geocoder` via PyPI.
3. **Permissions:** Assign `Storage Blob Data Contributor` to the Databricks Access Connector Managed Identity.
4. **Orchestration:** Import the ADF Pipeline JSON and configure the Databricks Linked Service.
5. **Serving:** Run the provided SQL DDL scripts in Synapse Serverless SQL Pool to create External Tables.

---

### 💡 Project Contributor

* **Role:** Data Engineer
* **Focus:** Azure Cloud Architecture, Spark Optimization, & Geospatial ETL.
