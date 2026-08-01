-- Medicare Claims Utilization and Payment Analysis
-- Purpose: Convert raw inpatient claims into an analysis-ready table.

DROP TABLE IF EXISTS inpatient_claims;

CREATE TABLE inpatient_claims AS
SELECT
    desynpuf_id AS beneficiary_id,
    clm_id AS claim_id,
    CAST(segment AS INTEGER) AS segment,

    -- Use the admission date when the claim start date is missing.
    CASE
        WHEN clm_from_dt IS NULL OR clm_from_dt = ''
            THEN TO_DATE(clm_admsn_dt, 'YYYYMMDD')
        ELSE TO_DATE(clm_from_dt, 'YYYYMMDD')
    END AS claim_from_date,

    -- Use the discharge date when the claim end date is missing.
    CASE
        WHEN clm_thru_dt IS NULL OR clm_thru_dt = ''
            THEN TO_DATE(nch_bene_dschrg_dt, 'YYYYMMDD')
        ELSE TO_DATE(clm_thru_dt, 'YYYYMMDD')
    END AS claim_through_date,

    prvdr_num AS provider_number,

    CAST(clm_pmt_amt AS NUMERIC(12, 2))
        AS claim_payment_amount,

    CAST(nch_prmry_pyr_clm_pd_amt AS NUMERIC(12, 2))
        AS primary_payer_payment_amount,

    at_physn_npi AS attending_physician_npi,
    op_physn_npi AS operating_physician_npi,
    ot_physn_npi AS other_physician_npi,

    TO_DATE(clm_admsn_dt, 'YYYYMMDD')
        AS admission_date,

    TO_DATE(nch_bene_dschrg_dt, 'YYYYMMDD')
        AS discharge_date,

    admtng_icd9_dgns_cd AS admitting_diagnosis_code,
    clm_drg_cd AS drg_code,

    CAST(clm_utlztn_day_cnt AS INTEGER)
        AS utilization_day_count,

    CAST(clm_pass_thru_per_diem_amt AS NUMERIC(12, 2))
        AS pass_through_per_diem_amount,

    CAST(nch_bene_ip_ddctbl_amt AS NUMERIC(12, 2))
        AS inpatient_deductible_amount,

    CAST(nch_bene_pta_coinsrnc_lblty_am AS NUMERIC(12, 2))
        AS coinsurance_liability_amount,

    CAST(nch_bene_blood_ddctbl_lblty_am AS NUMERIC(12, 2))
        AS blood_deductible_liability_amount,

    icd9_dgns_cd_1 AS diagnosis_code_1,
    icd9_dgns_cd_2 AS diagnosis_code_2,
    icd9_dgns_cd_3 AS diagnosis_code_3,

    icd9_prcdr_cd_1 AS procedure_code_1,
    icd9_prcdr_cd_2 AS procedure_code_2,
    icd9_prcdr_cd_3 AS procedure_code_3

FROM raw_inpatient_claims;

ALTER TABLE inpatient_claims
ADD PRIMARY KEY (claim_id, segment);
