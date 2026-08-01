/*
Business Question:
How does average inpatient length of stay differ by age group?

Purpose:
This analysis combines beneficiary demographic information
with inpatient utilization data using a JOIN.
*/

SELECT

CASE

WHEN EXTRACT(YEAR FROM AGE(admission_date,b.birth_date)) < 65
THEN 'Under 65'

WHEN EXTRACT(YEAR FROM AGE(admission_date,b.birth_date))
BETWEEN 65 AND 74
THEN '65-74'

WHEN EXTRACT(YEAR FROM AGE(admission_date,b.birth_date))
BETWEEN 75 AND 84
THEN '75-84'

ELSE '85+'

END AS age_group,

COUNT(*) AS inpatient_claims,

ROUND(AVG(i.utilization_day_count),2)
AS average_length_of_stay,

ROUND(AVG(i.claim_payment_amount),2)
AS average_claim_payment

FROM inpatient_claims i

INNER JOIN beneficiary_summary b

ON i.beneficiary_id = b.beneficiary_id
AND EXTRACT(YEAR FROM i.admission_date)=b.summary_year

GROUP BY age_group

ORDER BY average_length_of_stay DESC;

/*
Business Question:
Do inpatient utilization and payments differ by diabetes status?

Purpose:
This query combines chronic-condition information with
inpatient claims using beneficiary ID and summary year.
*/

SELECT
    CASE
        WHEN b.diabetes_indicator = 1 THEN 'Diabetes'
        WHEN b.diabetes_indicator = 2 THEN 'No Diabetes'
        ELSE 'Unknown'
    END AS diabetes_status,

    COUNT(*) AS inpatient_claims,

    ROUND(
        AVG(i.utilization_day_count),
        2
    ) AS average_length_of_stay,

    ROUND(
        AVG(i.claim_payment_amount),
        2
    ) AS average_claim_payment

FROM inpatient_claims i

INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year

GROUP BY b.diabetes_indicator

ORDER BY average_length_of_stay DESC;

/*
Validation Question:
How many inpatient claims do not match a beneficiary-year record?
*/

SELECT
    COUNT(*) AS unmatched_inpatient_claims
FROM inpatient_claims i
LEFT JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.beneficiary_id IS NULL;
