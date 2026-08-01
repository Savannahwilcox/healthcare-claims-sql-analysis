/*
Outpatient Claims Analysis
*/

-- 1. How many outpatient claims occurred each year?

SELECT
    EXTRACT(YEAR FROM claim_from_date) AS claim_year,
    COUNT(*) AS outpatient_claim_count
FROM outpatient_claims
WHERE claim_from_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM claim_from_date)
ORDER BY claim_year;


-- 2. What was the average outpatient claim payment by year?

SELECT
    EXTRACT(YEAR FROM claim_from_date) AS claim_year,
    ROUND(AVG(claim_payment_amount), 2) AS average_claim_payment
FROM outpatient_claims
WHERE claim_from_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM claim_from_date)
ORDER BY claim_year;


-- 3. What were total outpatient payments during the complete study years?

SELECT
    EXTRACT(YEAR FROM claim_from_date) AS claim_year,
    COUNT(*) AS outpatient_claims,
    ROUND(AVG(claim_payment_amount), 2) AS average_claim_payment,
    ROUND(SUM(claim_payment_amount), 2) AS total_claim_payments
FROM outpatient_claims
WHERE claim_from_date >= DATE '2008-01-01'
  AND claim_from_date < DATE '2011-01-01'
GROUP BY EXTRACT(YEAR FROM claim_from_date)
ORDER BY claim_year;


-- 4. What are the most common primary diagnosis codes?

SELECT
    diagnosis_code_1,
    COUNT(*) AS diagnosis_count
FROM outpatient_claims
WHERE diagnosis_code_1 IS NOT NULL
  AND diagnosis_code_1 <> ''
GROUP BY diagnosis_code_1
ORDER BY diagnosis_count DESC
LIMIT 10;


-- 5. What are the most common HCPCS codes?

SELECT
    hcpcs_code_1,
    COUNT(*) AS procedure_count
FROM outpatient_claims
WHERE hcpcs_code_1 IS NOT NULL
  AND hcpcs_code_1 <> ''
GROUP BY hcpcs_code_1
ORDER BY procedure_count DESC
LIMIT 10;


-- 6. Which providers had the most outpatient claims?

SELECT
    provider_number,
    COUNT(*) AS claim_count
FROM outpatient_claims
WHERE provider_number IS NOT NULL
  AND provider_number <> ''
GROUP BY provider_number
ORDER BY claim_count DESC
LIMIT 10;


-- 7. Which outpatient claims had the highest payments?

SELECT
    claim_id,
    beneficiary_id,
    provider_number,
    claim_from_date,
    claim_through_date,
    diagnosis_code_1,
    hcpcs_code_1,
    claim_payment_amount
FROM outpatient_claims
ORDER BY claim_payment_amount DESC
LIMIT 10;
