-- Medicare Claims Utilization and Payment Analysis
-- File: 01_basic_exploration.sql
-- Purpose: Explore beneficiary counts, demographics, and reimbursement totals.

-- 1. Count all beneficiary-year records.
SELECT COUNT(*) AS total_records
FROM beneficiary_summary;


-- 2. Count records by year.
SELECT
    summary_year,
    COUNT(*) AS record_count
FROM beneficiary_summary
GROUP BY summary_year
ORDER BY summary_year;


-- 3. Count beneficiaries by sex code.
SELECT
    sex_code,
    COUNT(*) AS beneficiary_count
FROM beneficiary_summary
GROUP BY sex_code
ORDER BY sex_code;


-- 4. Count beneficiaries by race code.
SELECT
    race_code,
    COUNT(*) AS beneficiary_count
FROM beneficiary_summary
GROUP BY race_code
ORDER BY beneficiary_count DESC;


-- 5. Calculate average Medicare reimbursement by year.
SELECT
    summary_year,
    ROUND(AVG(inpatient_medicare_reimbursement), 2)
        AS avg_inpatient_reimbursement,
    ROUND(AVG(outpatient_medicare_reimbursement), 2)
        AS avg_outpatient_reimbursement,
    ROUND(AVG(carrier_medicare_reimbursement), 2)
        AS avg_carrier_reimbursement
FROM beneficiary_summary
GROUP BY summary_year
ORDER BY summary_year;


-- 6. Find the highest inpatient reimbursement values.
SELECT
    beneficiary_id,
    summary_year,
    inpatient_medicare_reimbursement
FROM beneficiary_summary
ORDER BY inpatient_medicare_reimbursement DESC
LIMIT 10;

-- 7. How many unique beneficiaries?
SELECT
    COUNT(DISTINCT beneficiary_id) AS unique_beneficiaries
FROM beneficiary_summary;


-- 8. How many years does each beneficiary appear in the dataset?
SELECT
    beneficiary_id,
    COUNT(*) AS years_in_dataset
FROM beneficiary_summary
GROUP BY beneficiary_id
ORDER BY years_in_dataset DESC
LIMIT 10;


-- 9. How many beneficiaries appear in all three years?
SELECT
    COUNT(*) AS beneficiaries_in_all_three_years
FROM (
    SELECT
        beneficiary_id
    FROM beneficiary_summary
    GROUP BY beneficiary_id
    HAVING COUNT(*) = 3
) AS three_year_beneficiaries;
