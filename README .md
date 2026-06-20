# 🏥 Healthcare Analytics: Predicting Hospital Readmissions for Diabetes Patients


## 📌 Project Overview

An end-to-end healthcare analytics project analyzing **101,766 real patient encounters** to identify key drivers of 30-day hospital readmissions among diabetes patients — a major cost and quality concern for hospitals.

> **Goal:** Use SQL-driven analysis and an interactive Power BI dashboard to help care teams identify and prioritize high-risk patients before discharge.

---

## 🎯 Problem Statement

Hospital readmissions within 30 days are a key healthcare quality metric and a major cost driver in the US healthcare system. This project analyzes a real-world diabetes dataset to:
- **Identify** clinical and demographic factors linked to readmission
- **Stratify** patients into risk tiers for targeted intervention
- **Visualize** findings through an interactive Power BI dashboard

---

## 📊 Dataset

| Attribute | Value |
|-----------|-------|
| Source | [UCI Machine Learning Repository — Diabetes 130-US Hospitals (1999–2008)](https://archive.ics.uci.edu/dataset/296/diabetes+130-us+hospitals+for+years+1999+2008) |
| Records | 101,766 real patient encounters |
| Features | 50 clinical & demographic variables |
| Target | `readmitted`: `<30` (within 30 days), `>30` (after 30 days), `NO` (not readmitted) |

**Key Features Used:** age, race, gender, time in hospital, number of medications, lab procedures, prior inpatient/emergency visits, HbA1c result, insulin dosage, diagnosis codes.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **MySQL 8.0** | Data storage, cleaning, and analysis (9 SQL views) |
| **Power BI** | Interactive 4-page dashboard |
| **MySQL Workbench** | Data import & query execution |

---


## 🚀 How to Run This Project

### 1. Set up the database
```bash
# Open MySQL Workbench and run:
healthcare_mysql.sql
```
This will:
- Create the `healthcare_db` database
- Create the `diabetes_patients` table
- Load the dataset (download separately — see below)
- Clean and analyze the data
- Create 9 analytical views for Power BI

### 2. Download the dataset
 download the dataset

Place `diabetic_data.csv` in your MySQL secure upload folder and update the `LOAD DATA INFILE` path in the SQL script accordingly.

### 3. Open the dashboard
Open `healthcare_dashboard.pbix` in Power BI Desktop, connect to your local `healthcare_db`, and refresh.

---

## 🔬 Methodology

### 1. Data Acquisition & Setup
- Imported 101,766 real patient records into MySQL
- Designed a 50-column relational table matching the source schema

### 2. Data Cleaning
- Replaced `?` placeholders with `'Unknown'` across categorical fields
- Standardized `A1Cresult` and `max_glu_serum` missing values to `'Not Tested'`
- Removed invalid/unknown gender records
- Identified and fixed hidden carriage-return characters (`\r`) corrupting the `readmitted` column post-import

### 3. Exploratory Data Analysis (SQL)
- Readmission rate by age, race, gender, A1C result, insulin type, admission type
- Clinical averages comparison: readmitted vs. not readmitted patients
- Hospital stay length and medication load cross-analysis

### 4. Risk Stratification
Patients segmented into 4 tiers using SQL `CASE` logic based on prior inpatient visits and A1C results:
- **Low Risk** | **Medium Risk** | **High Risk** | **Very High Risk**

### 5. Power BI Dashboard (4 Pages)
- **Executive Overview** — KPI cards, readmission by age/race/gender
- **Clinical Deep Dive** — A1C, insulin, hospital stay impact on readmission
- **Risk Stratification** — Treemap, funnel chart, color-coded patient table
- **Patient Explorer** — Interactive slicers, scatter plot, high-risk patient drill-down

---

## 📈 Key Findings

| Finding | Insight |
|---|---|
| **A1C Testing Gap** | Patients **not tested** for HbA1c had the *highest* readmission rate (11.4%) — even higher than poorly controlled diabetics (>8% at 9.9%), suggesting screening gaps matter as much as glycemic control |
| **Prior Inpatient Visits** | Patients with 3+ prior inpatient visits show substantially higher readmission rates |
| **Hospital Stay Length** | Longer hospital stays correlate with higher readmission risk |
| **Medication Load** | Higher medication counts combined with longer stays show compounding readmission risk |

---

## 💡 Business Impact

- Risk stratification enables care teams to **prioritize follow-up** for the highest-risk ~20% of patients
- Highlights an **actionable gap**: ensuring A1C testing occurs for all admitted diabetes patients
- Framework can be extended to other chronic disease readmission programs

---

## 🔭 Future Work

- [ ] Incorporate diagnosis codes (`diag_1/2/3`) for condition-specific risk analysis
- [ ] Analyze individual medication classes (not just insulin)
- [ ] Build a predictive ML model (Python) on top of this SQL-cleaned dataset
- [ ] Automate scheduled refresh via Power BI Service

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 🙋 Author

**Taskeen Firdous**
Aspiring Data Analyst

