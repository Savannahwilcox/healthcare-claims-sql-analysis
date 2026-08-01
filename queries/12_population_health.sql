/*
Population Health Analysis

Business Questions:
1. Which chronic conditions are associated with the longest inpatient stays?
2. Which chronic conditions are associated with the highest average inpatient payments?
*/

-- Compare inpatient utilization across major chronic conditions.

SELECT
    'Ischemic Heart Disease' AS condition,
    COUNT(*) AS inpatient_claims,
    ROUND(AVG(i.utilization_day_count), 2) AS average_length_of_stay,
    ROUND(AVG(i.claim_payment_amount), 2) AS average_claim_payment
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.ischemic_heart_disease_indicator = 1

UNION ALL

SELECT
    'Diabetes',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.diabetes_indicator = 1

UNION ALL

SELECT
    'Heart Failure',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.heart_failure_indicator = 1

UNION ALL

SELECT
    'Chronic Kidney Disease',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.chronic_kidney_disease_indicator = 1

UNION ALL

SELECT
    'COPD',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.copd_indicator = 1

UNION ALL

SELECT
    'Depression',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.depression_indicator = 1

ORDER BY average_length_of_stay DESC;
