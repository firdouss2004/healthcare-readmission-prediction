--  HEALTHCARE ANALYTICS PROJECT
--  Predicting Hospital Readmissions — Diabetes Patients
--  Stack: MySQL  + Power BI (Dashboard)
--  Author: Taskeen Firdous


-- SEGMENT 1: DATABASE & TABLE SETUP

CREATE DATABASE IF NOT EXISTS healthcare_db;
USE healthcare_db;
DROP TABLE IF EXISTS diabetes_patients;

CREATE TABLE diabetes_patients (
    encounter_id              VARCHAR(50),
    patient_nbr               VARCHAR(50),
    race                      VARCHAR(50),
    gender                    VARCHAR(50),
    age                       VARCHAR(50),
    weight                    VARCHAR(50),
    admission_type_id         VARCHAR(50),
    discharge_disposition_id  VARCHAR(50),
    admission_source_id       VARCHAR(50),
    time_in_hospital          VARCHAR(50),
    payer_code                VARCHAR(50),
    medical_specialty         VARCHAR(100),
    num_lab_procedures        VARCHAR(50),
    num_procedures            VARCHAR(50),
    num_medications           VARCHAR(50),
    number_outpatient         VARCHAR(50),
    number_emergency          VARCHAR(50),
    number_inpatient          VARCHAR(50),
    diag_1                    VARCHAR(50),
    diag_2                    VARCHAR(50),
    diag_3                    VARCHAR(50),
    number_diagnoses          VARCHAR(50),
    max_glu_serum             VARCHAR(50),
    A1Cresult                 VARCHAR(50),
    metformin                 VARCHAR(50),
    repaglinide               VARCHAR(50),
    nateglinide               VARCHAR(50),
    chlorpropamide            VARCHAR(50),
    glimepiride               VARCHAR(50),
    acetohexamide             VARCHAR(50),
    glipizide                 VARCHAR(50),
    glyburide                 VARCHAR(50),
    tolbutamide               VARCHAR(50),
    pioglitazone              VARCHAR(50),
    rosiglitazone             VARCHAR(50),
    acarbose                  VARCHAR(50),
    miglitol                  VARCHAR(50),
    troglitazone              VARCHAR(50),
    tolazamide                VARCHAR(50),
    examide                   VARCHAR(50),
    citoglipton               VARCHAR(50),
    insulin                   VARCHAR(50),
    glyburide_metformin       VARCHAR(50),
    glipizide_metformin       VARCHAR(50),
    glimepiride_pioglitazone  VARCHAR(50),
    metformin_rosiglitazone   VARCHAR(50),
    metformin_pioglitazone    VARCHAR(50),
    change_med                VARCHAR(50),
    diabetesMed               VARCHAR(50),
    readmitted                VARCHAR(50)
);
 

-- SEGMENT 2: LOAD REAL DATASET
 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/diabetic_data.csv'
INTO TABLE diabetes_patients
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
 
-- Verify load
SELECT COUNT(*) AS total_rows FROM diabetes_patients;
-- Expected: 101,766 rows
 
 
-- SEGMENT 3: DATA CLEANING

 
SET SQL_SAFE_UPDATES = 0;
 
-- 3.1 Replace unknown/invalid values
UPDATE diabetes_patients SET race             = 'Unknown' WHERE race             = '?';
UPDATE diabetes_patients SET medical_specialty= 'Unknown' WHERE medical_specialty= '?';
UPDATE diabetes_patients SET payer_code       = 'Unknown' WHERE payer_code       = '?';
UPDATE diabetes_patients SET weight           = 'Unknown' WHERE weight           = '?';
UPDATE diabetes_patients SET A1Cresult        = 'Not Tested' WHERE A1Cresult     = 'None';
UPDATE diabetes_patients SET max_glu_serum    = 'Not Tested' WHERE max_glu_serum = 'None';
 
-- 3.2 Remove invalid gender rows
DELETE FROM diabetes_patients WHERE gender = 'Unknown/Invalid';
 
SET SQL_SAFE_UPDATES = 1;
 
-- 3.3 Data quality check
SELECT
    COUNT(*)                                                          AS total_records,
    SUM(CASE WHEN race = 'Unknown' THEN 1 ELSE 0 END)                AS unknown_race,
    SUM(CASE WHEN A1Cresult = 'Not Tested' THEN 1 ELSE 0 END)        AS a1c_not_tested,
    SUM(CASE WHEN max_glu_serum = 'Not Tested' THEN 1 ELSE 0 END)    AS glucose_not_tested,
    SUM(CASE WHEN medical_specialty = 'Unknown' THEN 1 ELSE 0 END)   AS unknown_specialty,
    SUM(CASE WHEN weight = 'Unknown' THEN 1 ELSE 0 END)              AS unknown_weight
FROM diabetes_patients;
 
-- 3.4 Summary statistics
SELECT
    COUNT(*)                                  AS total_patients,
    ROUND(AVG(time_in_hospital), 2)           AS avg_hospital_days,
    MIN(time_in_hospital)                     AS min_days,
    MAX(time_in_hospital)                     AS max_days,
    ROUND(AVG(num_medications), 2)            AS avg_medications,
    ROUND(AVG(num_lab_procedures), 2)         AS avg_lab_procedures,
    ROUND(AVG(number_diagnoses), 2)           AS avg_diagnoses
FROM diabetes_patients;
 
 select * from diabetes_patients;
 

-- SEGMENT 4: EXPLORATORY DATA ANALYSIS



 
-- 4.1 Overall readmission breakdown
SELECT
    readmitted,
    COUNT(*)                                                              AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM diabetes_patients), 1) AS pct
FROM diabetes_patients
GROUP BY readmitted;

SET SQL_SAFE_UPDATES = 0;

UPDATE diabetes_patients
SET readmitted = TRIM(REPLACE(REPLACE(readmitted, CHAR(13), ''), CHAR(10), ''));

SET SQL_SAFE_UPDATES = 1;
 
-- 4.2 Readmission rate by age group
SELECT
    age,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY age
ORDER BY age;
 
-- 4.3 Readmission rate by race
SELECT
    race,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY race
ORDER BY readmission_rate_pct DESC;
 
-- 4.4 Readmission rate by A1C result
SELECT
    A1Cresult,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY A1Cresult
ORDER BY readmission_rate_pct DESC;
 
-- 4.5 Readmission rate by insulin
SELECT
    insulin,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY insulin
ORDER BY readmission_rate_pct DESC;
 
-- 4.6 Readmission rate by admission type
SELECT
    admission_type_id,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY admission_type_id
ORDER BY readmission_rate_pct DESC;
 
-- 4.7 Readmission by medication change
SELECT
    CASE WHEN change_med = 'Ch' THEN 'Changed' ELSE 'No Change' END      AS med_change,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY change_med;
 
-- 4.8 Clinical averages: readmitted vs not
SELECT
    readmitted,
    COUNT(*)                                  AS total,
    ROUND(AVG(time_in_hospital), 2)           AS avg_hospital_days,
    ROUND(AVG(num_medications), 2)            AS avg_medications,
    ROUND(AVG(num_lab_procedures), 2)         AS avg_lab_procedures,
    ROUND(AVG(number_inpatient), 2)           AS avg_prior_inpatient,
    ROUND(AVG(number_emergency), 2)           AS avg_prior_emergency,
    ROUND(AVG(number_diagnoses), 2)           AS avg_diagnoses
FROM diabetes_patients
GROUP BY readmitted;
 
-- 4.9 Prior inpatient visits bucket
SELECT
    CASE
        WHEN number_inpatient = '0' THEN '0 visits'
        WHEN number_inpatient = '1' THEN '1 visit'
        WHEN number_inpatient = '2' THEN '2 visits'
        ELSE '3+ visits'
    END                                                                   AS inpatient_bucket,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY inpatient_bucket
ORDER BY inpatient_bucket;
 
-- 4.10 Hospital stay length bucket
SELECT
    CASE
        WHEN time_in_hospital <= 2 THEN '1-2 days'
        WHEN time_in_hospital <= 5 THEN '3-5 days'
        WHEN time_in_hospital <= 8 THEN '6-8 days'
        ELSE '9+ days'
    END                                                                   AS stay_length,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY stay_length
ORDER BY stay_length;
 
-- 4.11 Gender breakdown
SELECT
    gender,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_30days,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY gender;
 
-- 4.12 High meds + long stay cross analysis
SELECT
    CASE WHEN num_medications > 20 THEN 'High Meds (>20)' ELSE 'Normal Meds' END AS med_load,
    CASE WHEN time_in_hospital > 6  THEN 'Long Stay (>6d)' ELSE 'Short Stay'     END AS stay_type,
    COUNT(*)                                                              AS total,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY med_load, stay_type
ORDER BY readmission_rate_pct DESC;
 
 

-- SEGMENT 5: RISK STRATIFICATION

 
-- 5.1 Risk tier per patient
SELECT
    encounter_id,
    patient_nbr,
    age,
    race,
    gender,
    A1Cresult,
    insulin,
    number_inpatient,
    number_emergency,
    time_in_hospital,
    num_medications,
    readmitted,
    CASE
        WHEN number_inpatient >= 3 AND A1Cresult = '>8' THEN 'Very High Risk'
        WHEN number_inpatient >= 2 OR  A1Cresult = '>8' THEN 'High Risk'
        WHEN number_inpatient >= 1 OR  A1Cresult = '>7' THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_tier
FROM diabetes_patients
ORDER BY number_inpatient DESC, number_emergency DESC;
 
-- 5.2 Risk tier summary
SELECT
    CASE
        WHEN number_inpatient >= 3 AND A1Cresult = '>8' THEN 'Very High Risk'
        WHEN number_inpatient >= 2 OR  A1Cresult = '>8' THEN 'High Risk'
        WHEN number_inpatient >= 1 OR  A1Cresult = '>7' THEN 'Medium Risk'
        ELSE 'Low Risk'
    END                                                                   AS risk_tier,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_count,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY risk_tier
ORDER BY FIELD(risk_tier, 'Very High Risk','High Risk','Medium Risk','Low Risk');
 
 

-- SEGMENT 6: VIEWS FOR POWER BI

 
CREATE OR REPLACE VIEW vw_kpi_summary AS
SELECT
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS total_readmissions,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct,
    ROUND(AVG(time_in_hospital), 2)                                       AS avg_hospital_days,
    ROUND(AVG(num_medications), 2)                                        AS avg_medications,
    ROUND(AVG(number_diagnoses), 2)                                       AS avg_diagnoses
FROM diabetes_patients;
 
CREATE OR REPLACE VIEW vw_readmission_by_age AS
SELECT
    age,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_count,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY age ORDER BY age;
 
CREATE OR REPLACE VIEW vw_readmission_by_race AS
SELECT
    race,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_count,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY race ORDER BY readmission_rate_pct DESC;
 
CREATE OR REPLACE VIEW vw_readmission_by_a1c AS
SELECT
    A1Cresult,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_count,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY A1Cresult ORDER BY readmission_rate_pct DESC;
 
CREATE OR REPLACE VIEW vw_readmission_by_insulin AS
SELECT
    insulin,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_count,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY insulin ORDER BY readmission_rate_pct DESC;
 
CREATE OR REPLACE VIEW vw_clinical_comparison AS
SELECT
    readmitted                                AS patient_group,
    ROUND(AVG(time_in_hospital), 2)           AS avg_hospital_days,
    ROUND(AVG(num_medications), 2)            AS avg_medications,
    ROUND(AVG(num_lab_procedures), 2)         AS avg_lab_procedures,
    ROUND(AVG(number_inpatient), 2)           AS avg_prior_inpatient,
    ROUND(AVG(number_emergency), 2)           AS avg_prior_emergency,
    ROUND(AVG(number_diagnoses), 2)           AS avg_diagnoses
FROM diabetes_patients
GROUP BY readmitted;
 
CREATE OR REPLACE VIEW vw_risk_stratification AS
SELECT
    CASE
        WHEN number_inpatient >= 3 AND A1Cresult = '>8' THEN 'Very High Risk'
        WHEN number_inpatient >= 2 OR  A1Cresult = '>8' THEN 'High Risk'
        WHEN number_inpatient >= 1 OR  A1Cresult = '>7' THEN 'Medium Risk'
        ELSE 'Low Risk'
    END                                                                   AS risk_tier,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_count,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY risk_tier
ORDER BY FIELD(risk_tier, 'Very High Risk','High Risk','Medium Risk','Low Risk');
 
CREATE OR REPLACE VIEW vw_patient_risk_detail AS
SELECT
    encounter_id, patient_nbr, age, race, gender,
    admission_type_id, time_in_hospital, num_medications,
    number_inpatient, number_emergency, A1Cresult, insulin,
    readmitted,
    CASE
        WHEN number_inpatient >= 3 AND A1Cresult = '>8' THEN 'Very High Risk'
        WHEN number_inpatient >= 2 OR  A1Cresult = '>8' THEN 'High Risk'
        WHEN number_inpatient >= 1 OR  A1Cresult = '>7' THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_tier
FROM diabetes_patients;
 
CREATE OR REPLACE VIEW vw_stay_bucket AS
SELECT
    CASE
        WHEN time_in_hospital <= 2 THEN '1-2 days'
        WHEN time_in_hospital <= 5 THEN '3-5 days'
        WHEN time_in_hospital <= 8 THEN '6-8 days'
        ELSE '9+ days'
    END                                                                   AS stay_length,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_count,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY stay_length;
 
CREATE OR REPLACE VIEW vw_admission_readmission AS
SELECT
    admission_type_id,
    discharge_disposition_id,
    COUNT(*)                                                              AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)                  AS readmitted_count,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY admission_type_id, discharge_disposition_id
ORDER BY readmission_rate_pct DESC;
 
 

-- SEGMENT 7: FINAL BUSINESS QUERIES
-
 
-- Top 10 highest risk patient profiles
SELECT
    age, race, A1Cresult, insulin,
    COUNT(*)                                                              AS patient_count,
    ROUND(AVG(number_inpatient), 1)                                       AS avg_prior_inpatient,
    ROUND(AVG(num_medications), 1)                                        AS avg_medications,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS readmission_rate_pct
FROM diabetes_patients
GROUP BY age, race, A1Cresult, insulin
HAVING COUNT(*) >= 10
ORDER BY readmission_rate_pct DESC
LIMIT 10;
 
-- Patients needing immediate intervention
SELECT
    encounter_id, age, race, gender, A1Cresult,
    insulin, number_inpatient, num_medications, time_in_hospital
FROM diabetes_patients
WHERE readmitted != '<30'
  AND number_inpatient >= 2
  AND A1Cresult IN ('>8', '>7')
ORDER BY number_inpatient DESC, num_medications DESC
LIMIT 50;