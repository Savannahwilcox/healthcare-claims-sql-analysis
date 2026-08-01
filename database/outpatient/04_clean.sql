-- Medicare Claims Utilization and Payment Analysis
-- Purpose: Convert raw outpatient claims into an analysis-ready table.

DROP TABLE IF EXISTS outpatient_claims;

CREATE TABLE outpatient_claims AS
SELECT
    desynpuf_id AS beneficiary_id,
    clm_id AS claim_id,
    CAST(segment AS INTEGER) AS segment,

    CASE
        WHEN clm_from_dt IS NULL OR clm_from_dt = ''
            THEN NULL
        ELSE TO_DATE(clm_from_dt, 'YYYYMMDD')
    END AS claim_from_date,

    CASE
        WHEN clm_thru_dt IS NULL OR clm_thru_dt = ''
            THEN NULL
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

    CAST(nch_bene_blood_ddctbl_lblty_am AS NUMERIC(12, 2))
        AS blood_deductible_liability_amount,

    CAST(nch_bene_ptb_ddctbl_amt AS NUMERIC(12, 2))
        AS part_b_deductible_amount,

    CAST(nch_bene_ptb_coinsrnc_amt AS NUMERIC(12, 2))
        AS part_b_coinsurance_amount,

    admtng_icd9_dgns_cd AS admitting_diagnosis_code,

    icd9_dgns_cd_1 AS diagnosis_code_1,
    icd9_dgns_cd_2 AS diagnosis_code_2,
    icd9_dgns_cd_3 AS diagnosis_code_3,

    icd9_prcdr_cd_1 AS procedure_code_1,
    icd9_prcdr_cd_2 AS procedure_code_2,
    icd9_prcdr_cd_3 AS procedure_code_3,

    hcpcs_cd_1 AS hcpcs_code_1,
    hcpcs_cd_2 AS hcpcs_code_2,
    hcpcs_cd_3 AS hcpcs_code_3

FROM raw_outpatient_claims;

ALTER TABLE outpatient_claims
ADD PRIMARY KEY (claim_id, segment);
