/*
Provider Performance Export

Purpose:
Create a provider-level summary for Tableau.
*/

\pset format csv

\o outputs/tableau_exports/provider_performance.csv

SELECT
    provider_number,
    COUNT(*) AS inpatient_claims,
    ROUND(
        AVG(claim_payment_amount),
        2
    ) AS average_claim_payment,
    ROUND(
        SUM(claim_payment_amount),
        2
    ) AS total_medicare_payment,
    ROUND(
        AVG(utilization_day_count),
        2
    ) AS average_length_of_stay
FROM inpatient_claims
WHERE provider_number IS NOT NULL
  AND provider_number <> ''
GROUP BY provider_number
HAVING COUNT(*) >= 25
ORDER BY total_medicare_payment DESC;

\o
