-- Medicare Claims Utilization and Payment Analysis
-- File: 04_clean_beneficiary_data.sql
-- Purpose: Convert raw beneficiary data into analysis-ready data types.

DROP TABLE IF EXISTS beneficiary_summary;

CREATE TABLE beneficiary_summary AS
SELECT
    desynpuf_id AS beneficiary_id,
    summary_year,

    TO_DATE(bene_birth_dt, 'YYYYMMDD') AS birth_date,

    CASE
        WHEN bene_death_dt IS NULL OR bene_death_dt = ''
            THEN NULL
        ELSE TO_DATE(bene_death_dt, 'YYYYMMDD')
    END AS death_date,

    CAST(bene_sex_ident_cd AS INTEGER) AS sex_code,
    CAST(bene_race_cd AS INTEGER) AS race_code,
    bene_esrd_ind AS esrd_indicator,
    sp_state_code AS state_code,
    bene_county_cd AS county_code,

    CAST(bene_hi_cvrage_tot_mons AS INTEGER)
        AS hospital_insurance_months,

    CAST(bene_smi_cvrage_tot_mons AS INTEGER)
        AS medical_insurance_months,

    CAST(bene_hmo_cvrage_tot_mons AS INTEGER)
        AS hmo_coverage_months,

    CAST(plan_cvrg_mos_num AS INTEGER)
        AS prescription_plan_months,

    CAST(sp_alzhdmta AS INTEGER) AS alzheimer_indicator,
    CAST(sp_chf AS INTEGER) AS heart_failure_indicator,
    CAST(sp_chrnkidn AS INTEGER) AS chronic_kidney_disease_indicator,
    CAST(sp_cncr AS INTEGER) AS cancer_indicator,
    CAST(sp_copd AS INTEGER) AS copd_indicator,
    CAST(sp_depressn AS INTEGER) AS depression_indicator,
    CAST(sp_diabetes AS INTEGER) AS diabetes_indicator,
    CAST(sp_ischmcht AS INTEGER) AS ischemic_heart_disease_indicator,
    CAST(sp_osteoprs AS INTEGER) AS osteoporosis_indicator,
    CAST(sp_ra_oa AS INTEGER) AS rheumatoid_arthritis_indicator,
    CAST(sp_strketia AS INTEGER) AS stroke_tia_indicator,

    CAST(medreimb_ip AS NUMERIC(12, 2))
        AS inpatient_medicare_reimbursement,

    CAST(benres_ip AS NUMERIC(12, 2))
        AS inpatient_beneficiary_responsibility,

    CAST(pppymt_ip AS NUMERIC(12, 2))
        AS inpatient_primary_payer_payment,

    CAST(medreimb_op AS NUMERIC(12, 2))
        AS outpatient_medicare_reimbursement,

    CAST(benres_op AS NUMERIC(12, 2))
        AS outpatient_beneficiary_responsibility,

    CAST(pppymt_op AS NUMERIC(12, 2))
        AS outpatient_primary_payer_payment,

    CAST(medreimb_car AS NUMERIC(12, 2))
        AS carrier_medicare_reimbursement,

    CAST(benres_car AS NUMERIC(12, 2))
        AS carrier_beneficiary_responsibility,

    CAST(pppymt_car AS NUMERIC(12, 2))
        AS carrier_primary_payer_payment

FROM raw_beneficiary_summary;

ALTER TABLE beneficiary_summary
ADD PRIMARY KEY (beneficiary_id, summary_year);
