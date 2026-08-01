/*
Inpatient Claims Analysis
*/

-- Note:
-- The source file primarily covers 2008 through 2010.
-- A small number of hospital stays began in late 2007 and ended in 2008.
-- Therefore, 2007 represents partial-year data and should not be compared
-- directly with the complete study years.

-- 1. How many inpatient claims occurred each year?

SELECT
    EXTRACT(YEAR FROM claim_from_date) AS claim_year,
    COUNT(*) AS inpatient_claim_count
FROM inpatient_claims
GROUP BY EXTRACT(YEAR FROM claim_from_date)
ORDER BY claim_year;


-- 2. What was the average inpatient claim payment by year?

SELECT
    EXTRACT(YEAR FROM claim_from_date) AS claim_year,
    ROUND(AVG(claim_payment_amount), 2) AS average_claim_payment
FROM inpatient_claims
GROUP BY EXTRACT(YEAR FROM claim_from_date)
ORDER BY claim_year;


-- 3. What was the average length of stay by year?

SELECT
    EXTRACT(YEAR FROM admission_date) AS admission_year,
    ROUND(AVG(utilization_day_count), 2) AS average_length_of_stay
FROM inpatient_claims
GROUP BY EXTRACT(YEAR FROM admission_date)
ORDER BY admission_year;


-- 4. What are the most common DRG codes?

SELECT
    drg_code,
    COUNT(*) AS claim_count
FROM inpatient_claims
WHERE drg_code IS NOT NULL
  AND drg_code <> ''
GROUP BY drg_code
ORDER BY claim_count DESC
LIMIT 10;


-- 5. What are the most common primary diagnosis codes?

SELECT
    diagnosis_code_1,
    COUNT(*) AS diagnosis_count
FROM inpatient_claims
WHERE diagnosis_code_1 IS NOT NULL
  AND diagnosis_code_1 <> ''
GROUP BY diagnosis_code_1
ORDER BY diagnosis_count DESC
LIMIT 10;


-- 6. Which providers had the most inpatient claims?

SELECT
    provider_number,
    COUNT(*) AS claim_count
FROM inpatient_claims
WHERE provider_number IS NOT NULL
  AND provider_number <> ''
GROUP BY provider_number
ORDER BY claim_count DESC
LIMIT 10;


-- 7. Which inpatient claims had the highest Medicare payments?

SELECT
    claim_id,
    beneficiary_id,
    provider_number,
    admission_date,
    discharge_date,
    utilization_day_count,
    drg_code,
    claim_payment_amount
FROM inpatient_claims
ORDER BY claim_payment_amount DESC
LIMIT 10;

/*
Query 8

Business Question:
What were the main inpatient utilization and payment measures
during the complete study years?

Purpose:
The source contains a small number of partial-year 2007 claims.
This query limits the comparison to the complete years 2008-2010.
*/

SELECT
    EXTRACT(YEAR FROM admission_date) AS admission_year,
    COUNT(*) AS inpatient_claims,
    ROUND(AVG(utilization_day_count), 2) AS average_length_of_stay,
    ROUND(AVG(claim_payment_amount), 2) AS average_claim_payment,
    ROUND(SUM(claim_payment_amount), 2) AS total_claim_payments
FROM inpatient_claims
WHERE admission_date >= DATE '2008-01-01'
  AND admission_date < DATE '2011-01-01'
GROUP BY EXTRACT(YEAR FROM admission_date)
ORDER BY admission_year;
