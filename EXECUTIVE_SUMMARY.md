# Executive Summary

## Healthcare Analytics: Predicting Hospital Readmissions for Diabetes Patients

\---

### Project Overview

**Objective:** Identify clinical and demographic factors driving 30-day hospital readmissions among diabetes patients, and stratify patients by risk to support proactive care management.

**Dataset:** UCI Diabetes 130-US Hospitals (1999–2008) — 101,766 real patient encounters

**Tools:** MySQL (data cleaning, analysis, 9 analytical views) + Power BI (4-page interactive dashboard)

\---

### Key Findings

1. **A1C Testing Gap is the Top Signal**
Patients who were **not tested** for HbA1c had the highest 30-day readmission rate (11.4%) — higher than patients with poorly controlled diabetes (A1C >8%, at 9.9%). This suggests that screening gaps may be as important a readmission driver as glycemic control itself.
2. **Prior Inpatient Visits Strongly Predict Readmission**
Patients with 3+ prior inpatient visits show markedly higher readmission rates than first-time patients, confirming that admission history is one of the strongest available signals.
3. **Hospital Stay Length Correlates with Risk**
Longer hospital stays are associated with higher readmission rates, likely reflecting greater illness severity and complexity of care.
4. **Medication Load Compounds Risk**
Patients with both high medication counts (>20) and long hospital stays (>6 days) show the highest readmission rates among all cross-analyzed segments.

\---

### Risk Stratification Framework

Patients were segmented into four actionable risk tiers using prior inpatient visit count and A1C result:

|Tier|Criteria|Recommended Action|
|-|-|-|
|**Very High Risk**|3+ inpatient visits AND A1C >8%|Intensive case management before discharge|
|**High Risk**|2+ inpatient visits OR A1C >8%|Mandatory care coordinator review|
|**Medium Risk**|1+ inpatient visit OR A1C >7%|Enhanced outpatient follow-up|
|**Low Risk**|None of the above|Routine discharge planning|

\---

### Business Recommendation

Hospitals should prioritize **closing the A1C testing gap** for all admitted diabetes patients — this single screening step is linked to a meaningfully lower readmission rate and is a low-cost, high-impact intervention compared to broader care redesign efforts.

\---

### Dashboard Pages

1. **Executive Overview** — KPI summary, readmission by age/race/gender
2. **Clinical Deep Dive** — A1C, insulin, and hospital stay analysis
3. **Risk Stratification** — Treemap and funnel views of patient risk tiers
4. **Patient Explorer** — Interactive filtering and high-risk patient drill-down

\---

*Generated as part of a healthcare analytics portfolio project. Dataset source: UCI Machine Learning Repository.*

