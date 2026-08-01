-- Medicare Claims Utilization and Payment Analysis
-- Purpose: Load the raw CMS outpatient claims CSV.

TRUNCATE TABLE raw_outpatient_claims;

\copy raw_outpatient_claims FROM 'data/raw/DE1_0_2008_to_2010_Outpatient_Claims_Sample_1.csv' WITH (FORMAT CSV, HEADER TRUE);
