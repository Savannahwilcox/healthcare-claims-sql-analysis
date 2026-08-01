-- Validate the raw outpatient claims import.

SELECT COUNT(*) AS total_outpatient_rows
FROM raw_outpatient_claims;

SELECT
    COUNT(*) AS total_rows,
    COUNT(clm_id) AS rows_with_claim_id,
    COUNT(desynpuf_id) AS rows_with_beneficiary_id,
    COUNT(clm_pmt_amt) AS rows_with_payment_amount
FROM raw_outpatient_claims;

SELECT
    COUNT(*) FILTER (
        WHERE clm_from_dt IS NULL OR clm_from_dt = ''
    ) AS missing_claim_from_date,

    COUNT(*) FILTER (
        WHERE clm_thru_dt IS NULL OR clm_thru_dt = ''
    ) AS missing_claim_through_date,

    COUNT(*) FILTER (
        WHERE clm_pmt_amt IS NULL OR clm_pmt_amt = ''
    ) AS missing_payment_amount,

    COUNT(*) FILTER (
        WHERE prvdr_num IS NULL OR prvdr_num = ''
    ) AS missing_provider_number
FROM raw_outpatient_claims;

SELECT
    desynpuf_id,
    clm_id,
    clm_from_dt,
    clm_thru_dt,
    prvdr_num,
    clm_pmt_amt,
    icd9_dgns_cd_1,
    hcpcs_cd_1
FROM raw_outpatient_claims
LIMIT 5;

-- Validate the clean outpatient table.

SELECT COUNT(*) AS total_clean_outpatient_rows
FROM outpatient_claims;

SELECT
    COUNT(*) FILTER (
        WHERE claim_from_date IS NULL
    ) AS missing_clean_start_dates,

    COUNT(*) FILTER (
        WHERE claim_through_date IS NULL
    ) AS missing_clean_end_dates,

    COUNT(*) FILTER (
        WHERE claim_payment_amount IS NULL
    ) AS missing_clean_payment_amounts
FROM outpatient_claims;

SELECT
    EXTRACT(YEAR FROM claim_from_date) AS claim_year,
    COUNT(*) AS claim_count
FROM outpatient_claims
GROUP BY EXTRACT(YEAR FROM claim_from_date)
ORDER BY claim_year;
