/*
High-Cost Diagnosis Export

Purpose:
Identify diagnosis codes with the highest average Medicare payment.
*/

\pset format csv

\o outputs/tableau_exports/high_cost_diagnoses.csv

SELECT
    diagnosis_code_1 AS diagnosis_code,
    COUNT(*) AS claim_count,
    ROUND(AVG(claim_payment_amount), 2) AS average_claim_payment,
    ROUND(SUM(claim_payment_amount), 2) AS total_medicare_payment
FROM inpatient_claims
WHERE diagnosis_code_1 IS NOT NULL
  AND diagnosis_code_1 <> ''
GROUP BY diagnosis_code_1
HAVING COUNT(*) >= 25
ORDER BY average_claim_payment DESC;

\o
