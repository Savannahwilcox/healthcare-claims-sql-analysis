/*
Cost Drivers Analysis

Business Questions:
1. Which diagnosis codes generated the highest total Medicare reimbursement?
2. Which diagnosis codes had the highest average claim payment?
3. Which providers received the highest total Medicare reimbursement?
4. Which providers had the highest average inpatient payment?
*/

-- 1. Top diagnosis codes by total Medicare reimbursement.

SELECT
    diagnosis_code_1,
    COUNT(*) AS claim_count,
    ROUND(
        SUM(claim_payment_amount),
        2
    ) AS total_medicare_payment

FROM inpatient_claims

WHERE diagnosis_code_1 IS NOT NULL
  AND diagnosis_code_1 <> ''

GROUP BY diagnosis_code_1

ORDER BY total_medicare_payment DESC

LIMIT 10;


-- 2. Top diagnosis codes by average claim payment.

SELECT
    diagnosis_code_1,
    COUNT(*) AS claim_count,
    ROUND(
        AVG(claim_payment_amount),
        2
    ) AS average_claim_payment

FROM inpatient_claims

WHERE diagnosis_code_1 IS NOT NULL
  AND diagnosis_code_1 <> ''

GROUP BY diagnosis_code_1

HAVING COUNT(*) >= 25

ORDER BY average_claim_payment DESC

LIMIT 10;


-- 3. Providers receiving the largest total Medicare reimbursement.

SELECT
    provider_number,
    COUNT(*) AS inpatient_claims,
    ROUND(
        SUM(claim_payment_amount),
        2
    ) AS total_medicare_payment

FROM inpatient_claims

WHERE provider_number IS NOT NULL
  AND provider_number <> ''

GROUP BY provider_number

ORDER BY total_medicare_payment DESC

LIMIT 10;


-- 4. Providers with the highest average inpatient payment.

SELECT
    provider_number,
    COUNT(*) AS inpatient_claims,
    ROUND(
        AVG(claim_payment_amount),
        2
    ) AS average_claim_payment

FROM inpatient_claims

WHERE provider_number IS NOT NULL
  AND provider_number <> ''

GROUP BY provider_number

HAVING COUNT(*) >= 50

ORDER BY average_claim_payment DESC

LIMIT 10;
