-- Validate the raw inpatient claims import.

-- Total imported rows.
SELECT COUNT(*) AS total_inpatient_rows
FROM raw_inpatient_claims;


-- Confirm that key fields are populated.
SELECT
    COUNT(*) AS total_rows,
    COUNT(clm_id) AS rows_with_claim_id,
    COUNT(desynpuf_id) AS rows_with_beneficiary_id,
    COUNT(clm_pmt_amt) AS rows_with_payment_amount
FROM raw_inpatient_claims;


-- Review five example records.
SELECT
    desynpuf_id,
    clm_id,
    clm_from_dt,
    clm_thru_dt,
    prvdr_num,
    clm_pmt_amt,
    clm_utlztn_day_cnt,
    clm_drg_cd,
    icd9_dgns_cd_1
FROM raw_inpatient_claims
LIMIT 5;

-- Validate the clean inpatient table.

SELECT COUNT(*) AS total_clean_inpatient_rows
FROM inpatient_claims;

SELECT
    COUNT(*) FILTER (
        WHERE claim_from_date IS NULL
    ) AS missing_clean_start_dates,

    COUNT(*) FILTER (
        WHERE claim_through_date IS NULL
    ) AS missing_clean_end_dates,

    COUNT(*) FILTER (
        WHERE admission_date IS NULL
    ) AS missing_admission_dates,

    COUNT(*) FILTER (
        WHERE discharge_date IS NULL
    ) AS missing_discharge_dates
FROM inpatient_claims;

SELECT
    EXTRACT(YEAR FROM claim_from_date) AS claim_year,
    COUNT(*) AS claim_count
FROM inpatient_claims
GROUP BY EXTRACT(YEAR FROM claim_from_date)
ORDER BY claim_year;
