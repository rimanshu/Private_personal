%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_AUG_15/Dat/Dsm/Codes/00_LibNames.sas ";


proc sql ;
create table mco_details as 
select a.n_pymnt_id,b.xc_mco_id,b.XM_MCO_NM
from data.dsm_base_pymnt_dtl a left join sra29.EWV_REPORTING_HIER_MCO b
on a.xc_mco_id = b.xc_mco_id;
run;

proc sort data=mco_details out=mco_details nodupkey;
by n_pymnt_id;
run;

proc sql;
create table mco_map as
SELECT
  CLM_OFC_CD,
 CLM_OFC_NM
FROM
  sra29.EWV_CLM_ALLOC_OFC_DIM;
  run;

proc sql;
create table sra29.mco_&version. as
select a.*,b.CLM_OFC_CD from mco_details a
left join mco_map b 
on a.XM_MCO_NM = b.CLM_OFC_NM;
run;