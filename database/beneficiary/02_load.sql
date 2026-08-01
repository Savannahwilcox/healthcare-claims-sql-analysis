-- Load the 2008 CMS beneficiary summary file.

TRUNCATE TABLE raw_beneficiary_summary;

\copy raw_beneficiary_summary (desynpuf_id, bene_birth_dt, bene_death_dt, bene_sex_ident_cd, bene_race_cd, bene_esrd_ind, sp_state_code, bene_county_cd, bene_hi_cvrage_tot_mons, bene_smi_cvrage_tot_mons, bene_hmo_cvrage_tot_mons, plan_cvrg_mos_num, sp_alzhdmta, sp_chf, sp_chrnkidn, sp_cncr, sp_copd, sp_depressn, sp_diabetes, sp_ischmcht, sp_osteoprs, sp_ra_oa, sp_strketia, medreimb_ip, benres_ip, pppymt_ip, medreimb_op, benres_op, pppymt_op, medreimb_car, benres_car, pppymt_car) FROM 'data/raw/DE1_0_2008_Beneficiary_Summary_File_Sample_1.csv' WITH (FORMAT CSV, HEADER TRUE);

UPDATE raw_beneficiary_summary
SET summary_year = 2008
WHERE summary_year IS NULL;

-- Load the 2009 CMS beneficiary summary file.

\copy raw_beneficiary_summary (desynpuf_id, bene_birth_dt, bene_death_dt, bene_sex_ident_cd, bene_race_cd, bene_esrd_ind, sp_state_code, bene_county_cd, bene_hi_cvrage_tot_mons, bene_smi_cvrage_tot_mons, bene_hmo_cvrage_tot_mons, plan_cvrg_mos_num, sp_alzhdmta, sp_chf, sp_chrnkidn, sp_cncr, sp_copd, sp_depressn, sp_diabetes, sp_ischmcht, sp_osteoprs, sp_ra_oa, sp_strketia, medreimb_ip, benres_ip, pppymt_ip, medreimb_op, benres_op, pppymt_op, medreimb_car, benres_car, pppymt_car) FROM 'data/raw/DE1_0_2009_Beneficiary_Summary_File_Sample_1.csv' WITH (FORMAT CSV, HEADER TRUE);

UPDATE raw_beneficiary_summary
SET summary_year = 2009
WHERE summary_year IS NULL;


-- Load the 2010 CMS beneficiary summary file.

\copy raw_beneficiary_summary (desynpuf_id, bene_birth_dt, bene_death_dt, bene_sex_ident_cd, bene_race_cd, bene_esrd_ind, sp_state_code, bene_county_cd, bene_hi_cvrage_tot_mons, bene_smi_cvrage_tot_mons, bene_hmo_cvrage_tot_mons, plan_cvrg_mos_num, sp_alzhdmta, sp_chf, sp_chrnkidn, sp_cncr, sp_copd, sp_depressn, sp_diabetes, sp_ischmcht, sp_osteoprs, sp_ra_oa, sp_strketia, medreimb_ip, benres_ip, pppymt_ip, medreimb_op, benres_op, pppymt_op, medreimb_car, benres_car, pppymt_car) FROM 'data/raw/DE1_0_2010_Beneficiary_Summary_File_Sample_1.csv' WITH (FORMAT CSV, HEADER TRUE);

UPDATE raw_beneficiary_summary
SET summary_year = 2010
WHERE summary_year IS NULL;
