/*
Demographic Analysis

Business Questions:
1. How does Medicare spending vary by age group?
2. How does Medicare spending vary by sex?
3. How does Medicare spending vary by race?
*/

-- 1. Spending by age group.

SELECT
    CASE
        WHEN EXTRACT(YEAR FROM AGE(i.admission_date, b.birth_date)) < 65
            THEN 'Under 65'
        WHEN EXTRACT(YEAR FROM AGE(i.admission_date, b.birth_date)) BETWEEN 65 AND 74
            THEN '65-74'
        WHEN EXTRACT(YEAR FROM AGE(i.admission_date, b.birth_date)) BETWEEN 75 AND 84
            THEN '75-84'
        ELSE '85+'
    END AS age_group,

    COUNT(*) AS inpatient_claims,

    ROUND(SUM(i.claim_payment_amount), 2) AS total_medicare_payment,

    ROUND(AVG(i.claim_payment_amount), 2) AS average_claim_payment

FROM inpatient_claims i

JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
   AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year

GROUP BY age_group

ORDER BY total_medicare_payment DESC;


-- 2. Spending by sex.

SELECT
    CASE
        WHEN b.sex_code = 1 THEN 'Male'
        WHEN b.sex_code = 2 THEN 'Female'
        ELSE 'Unknown'
    END AS sex,

    COUNT(*) AS inpatient_claims,

    ROUND(SUM(i.claim_payment_amount),2) AS total_medicare_payment,

    ROUND(AVG(i.claim_payment_amount),2) AS average_claim_payment

FROM inpatient_claims i

JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
   AND EXTRACT(YEAR FROM i.admission_date)=b.summary_year

GROUP BY sex

ORDER BY total_medicare_payment DESC;


-- 3. Spending by race.

SELECT
    CASE
        WHEN b.race_code = 1 THEN 'White'
        WHEN b.race_code = 2 THEN 'Black'
        WHEN b.race_code = 3 THEN 'Other'
        WHEN b.race_code = 5 THEN 'Hispanic'
        ELSE 'Unknown'
    END AS race,

    COUNT(*) AS inpatient_claims,

    ROUND(SUM(i.claim_payment_amount),2) AS total_medicare_payment,

    ROUND(AVG(i.claim_payment_amount),2) AS average_claim_payment

FROM inpatient_claims i

JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
   AND EXTRACT(YEAR FROM i.admission_date)=b.summary_year

GROUP BY race

ORDER BY total_medicare_payment DESC;
