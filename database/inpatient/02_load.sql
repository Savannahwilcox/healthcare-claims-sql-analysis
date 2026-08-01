-- Medicare Claims Utilization and Payment Analysis
-- Purpose: Load the raw CMS inpatient claims CSV.

TRUNCATE TABLE raw_inpatient_claims;

\copy raw_inpatient_claims FROM 'data/raw/DE1_0_2008_to_2010_Inpatient_Claims_Sample_1.csv' WITH (FORMAT CSV, HEADER TRUE);
