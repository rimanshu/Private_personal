%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas";

proc sql;
 create table cpat.legacy_cat_codes as (
select DISTINCT
D62_ADW_CLAIM_ID, D62_CLAIM_NBR, D62_LOSS_DT, D62_LEG_CAT_CD
FROM sra29.EWT_CLAIM_IC,CPAT.LEGACY_ONLY
WHERE D62_SOURCE_SYS_CD = 'L'
AND D62_LEG_CAT_CD IS NOT NULL
AND D62_ADW_CLAIM_ID = LEGACY_ONLY.claim_id);
quit;


 proc sort data = cpat.legacy_cat_codes nodupkey;
 by D62_ADW_CLAIM_ID;
 run;

 data cpat.legacy_cat_codes;
 set cpat.legacy_cat_codes;
 Format Loss_Date mmddyy10.;
 Loss_Date = datepart(D62_LOSS_DT);
 run;
 data cpat.legacy_cat_codes ;
 set cpat.legacy_cat_codes;
 cat_codes  = put(Loss_Date,mmddyy10.)||" "||D62_LEG_CAT_CD;
 run;

proc sql;
 create table cpat.final_upload_flags_cat as
(
select a.*, c.cat_code from 
cpat.final_upload_&version. a
left outer join 
(
select adw_claim_id, cat_code from 
(
select D62_ADW_CLAIM_ID as adw_claim_id, cat_codes as cat_code from cpat.legacy_cat_codes
union
select ADW_CLM_ID as adw_claim_id, FIN_CAT_DESC as cat_code  from cpat.ng_cat_codes
)) c
on CLAIM_ID = adw_claim_id
);
quit;




/*Check recon status name*/
proc sql;
create table tempchk as
select base.n_pymnt_id, cd.t_long_desc 
from cpat.final_upload_flags_cat base left outer join sra29.ewt_check_pymnt_ng chk
on base.n_pymnt_id = chk.N_CHK_PYMNT_ID inner join sra29.ewt_code_decode_ng cd
on CHK.C_RECON_STAT = CD.C_CODE
where
cd.c_category = 238 ;
quit;

proc sql;
create table cpat.final_upload_flags_iss_chk as
select base.*, chk.t_long_desc as check_reconcilation_Status
from cpat.final_upload_flags_cat base left outer join tempchk chk
on base.n_pymnt_id = chk.n_pymnt_id;
quit;

data sra29.dsm_dec_output_1;
set cpat.final_upload_flags_iss_chk;
run;



