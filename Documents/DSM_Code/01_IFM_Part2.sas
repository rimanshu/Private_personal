%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas";

/***********************IFM Data******************************/
data CPAT.ifm;
set lib.icf_&version._scored_data;
run;

/*to get percentile score*/
proc rank data= CPAT.ifm out = cpat.legacy groups = 100;
   var p_1;
   ranks percentile_score;
run;

data cpat.legacy 
(keep=
P_1
percentile_score
cpe_approve_ind
cpe_cd1_payee_address
cpe_cd1_payee_city
cpe_cd1_payee_state
cpe_cd1_payee_zip_code
cpe_cd1_payee_zip_plus4
cpe_mail_to_nm
cpe_cd1_mail_to_zip_code
cpe_cd1_mail_to_address
cpe_cd1_mail_to_city
cpe_cd1_mail_to_state
cpe_check_genr_t_cd
cpe_check_trans_dt
cpe_claim_id
cpe_claim_nbr
cpe_clm_check_amt
cpe_clm_check_nbr
cpe_clm_rep_id
cpe_payee_nm
cpv_cov_cd
emp_first_name
emp_last_name
pnm_insured_nm
wcm_loss_rpt_dt
wcm_mco_cd
);
set cpat.legacy;
run;

/*filter out ng payments*/
data cpat.legacy;
set cpat.legacy;
if cpe_claim_nbr ge 1000000000;
run;

/*copy address*/
	data cpat.legacy_pull_1(drop = cpe_claim_id rename = (cpe_claim_id_1 = cpe_claim_id));
	set cpat.legacy (rename=(P_1=model_score/*change in dsm also*/
	cpe_cd1_payee_address=payee_addr_ln
	cpe_cd1_payee_city=payee_city_nm
	cpe_cd1_payee_state=payee_st_cd
	cpe_cd1_payee_zip_code=payee_zip_cd
	cpe_check_trans_dt=d_issue_dt
	cpe_claim_nbr=N_CLAIM_NUMBER
	cpe_clm_check_amt=payment_amount
	cpe_clm_check_nbr=CHK_NBR
	cpe_clm_rep_id=m_alpha_id
	cpe_payee_nm=payee_nm
	cpv_cov_cd=c_line_type
	emp_first_name=emp_first_nm
	emp_last_name=emp_last_nm
	pnm_insured_nm=insured_name
	wcm_loss_rpt_dt=d_claim_entered
	wcm_mco_cd=MCO
	cpe_check_genr_t_cd=payment_method
	cpe_mail_to_nm = mail_to_nm
	cpe_cd1_mail_to_zip_code = mail_to_zip
	cpe_cd1_mail_to_address = mail_to_street
	cpe_cd1_mail_to_city = mail_to_city
	cpe_cd1_mail_to_state = mail_to_state
	));
	c_line_type_desc = c_line_type;
	cpe_claim_id_1 =  input (cpe_claim_id,13.);
run;

data cpat.legacy_pull_1;
set cpat.legacy_pull_1;
if mail_to_nm='MISSING' then mail_to_nm=payee_nm; else mail_to_nm=mail_to_nm;
if mail_to_zip='MISSING' then mail_to_zip=payee_zip_cd; else mail_to_zip=mail_to_zip;
if mail_to_street='MISSING' then mail_to_street=payee_addr_ln; else mail_to_street=mail_to_street;
if mail_to_city='MISSING' then mail_to_city=payee_city_nm; else mail_to_city=mail_to_city;
if mail_to_state='MISSING' then mail_to_state=payee_st_cd; else mail_to_state=mail_to_state;
run;
/*now legacy data also has mail to address coverage edscription and percentile score*/

/*pulling loss_year ,line_cd ,loss_st_code*/
proc sql ;
create table cpat.legacy_pull_try
as
select distinct a.cpe_claim_id,b.cpe_atomic_ts,b.cpe_pt_loss_yr as
n_pt_loss_yr ,b.cpe_pt_clm_line_cd as c_pt_clm_line_cd,b.cpe_pt_loss_st_cd as c_pt_loss_st_cd
from sra29.ewt_claim_payment as b , cpat.legacy_pull_1 as a
where a.cpe_claim_id = b.cpe_claim_id 
;
quit;

proc sort data =cpat.legacy_pull_try ;
by cpe_claim_id descending  cpe_atomic_ts ;
run;
proc sort data = cpat.legacy_pull_try out = cpat.map_lossyr nodupkey;
by cpe_claim_id;
run;
proc sort data = cpat.legacy_pull_1;
by cpe_claim_id;
run;
data  cpat.legacy_pull_1;
merge cpat.legacy_pull_1(in=a) cpat.map_lossyr(in =b);
by cpe_claim_id;
if a;
run;

/*merging with score_oversight*/
proc sort data = data.dsm_adjuster_rbi out = cpat.dsm_adjuster_rbi;
by m_alpha_id;
run;
proc sort data = cpat.legacy_pull_1;
by m_alpha_id;
run;
data cpat.legacy_pull_score_oversight;
merge cpat.legacy_pull_1(in =a) cpat.dsm_adjuster_rbi(in = b);
by m_alpha_id;
if a;
run;

/*pulling NTID using alpha id*/
/*legacy queries*/
/*pulling NTID and org_entity_id using alpha id*/

proc sql;
	create table cpat.legacy_id_pulls as
	select distinct 
			a.m_alpha_id,
			b.n_user_id,
			b.n_org_enty_id,
			b.E68_D_ATOMIC_TS
	from cpat.legacy_pull_1 as a,
		source.ewt_org_entity_ng as b
	where a.m_alpha_id = b.m_alpha_id
		and b.e68_c_adw_rcd_del = 'N'
	;
quit;

proc sort data=cpat.legacy_id_pulls ;
	by m_alpha_id  descending E68_D_ATOMIC_TS ;
	run;
proc sort data=cpat.legacy_id_pulls nodupkey ;
	by m_alpha_id   ;
	run;

	proc sql;
	create table cpat.legacy_pull_id_score as
	select a.* , (b.n_user_id) as ntid from 
	cpat.legacy_pull_score_oversight as a
	left join cpat.legacy_id_pulls as b
	on a.m_alpha_id = b.m_alpha_id;
	quit;

DATA CPAT.LEGACY_ONLY(drop = cpe_atomic_ts rename = (cpe_claim_id = claim_id));
SET CPAT.legacy_pull_id_score;
informat cpe_claim_id best32.;
format cpe_claim_id best32.;
source = 'IFM';
RUN;

data CPAT.LEGACY_ONLY (drop=payment_method);
set CPAT.LEGACY_ONLY;
if payment_method='01' then payment_method_1='SYSI';
else if payment_method='02' then payment_method_1='MANI';
else if payment_method='03' then payment_method_1='EFT';
else if payment_method='04' then payment_method_1='FCP';
run;

data CPAT.LEGACY_ONLY (rename=(payment_method_1=payment_method));
set CPAT.LEGACY_ONLY;
run;

data CPAT.LEGACY_ONLY;
set CPAT.LEGACY_ONLY;
format d_claim_entered mmddyy10.;
informat d_claim_entered mmddyy10.;
format d_issue_dt mmddyy10.;
informat d_issue_dt mmddyy10.;
run;

/*Taking IFM data set out for name match */
proc sql;
create table sra29.IFM_&version. as
(Select chk_nbr,payee_nm from CPAT.LEGACY_ONLY
where SOURCE = 'IFM');
quit;

/*legacy coverage open closed dates*/
proc sql;
create table data.legacy_cov_dates as
SELECT DISTINCT 
  cp.CPE_CLAIM_NBR,
  cpc.CPV_CLM_CHECK_NBR,
  COV_LG.D66_OPEN_DT,
  COV_LG.D66_CLOSE_DT,
  cpc.CPV_COV_CD,
  cpc.CPV_INVL_PARTY_ID,
  cp.CPE_CHECK_TRANS_DT,
  cp.CPE_CLM_CHECK_AMT,
  cpc.CPV_ITEM_CLMNT_AMT
FROM
  sra29.EWT_CLAIM_PAYMENT cp,
  sra29.EWT_CLM_PAY_COV cpc,
  sra29.EWT_CLAIM_IP_COV_IC COV_LG
WHERE 
    EWT_CLM_PAY_COV.CPV_CLAIM_ID=      EWT_CLAIM_PAYMENT.CPE_CLAIM_ID AND
    EWT_CLM_PAY_COV.CPV_CLM_CHECK_NBR= EWT_CLAIM_PAYMENT.CPE_CLM_CHECK_NBR AND 
    EWT_CLM_PAY_COV.CPV_EFT_INVOC_NBR= EWT_CLAIM_PAYMENT.CPE_EFT_INVOIC_NBR AND 
    EWT_CLM_PAY_COV.CPV_PT_CLM_LINE_CD=EWT_CLAIM_PAYMENT.CPE_PT_CLM_LINE_CD AND
    EWT_CLM_PAY_COV.CPV_PT_LOSS_ST_CD= EWT_CLAIM_PAYMENT.CPE_PT_LOSS_ST_CD AND
    EWT_CLM_PAY_COV.CPV_PT_LOSS_YR=    EWT_CLAIM_PAYMENT.CPE_PT_LOSS_YR    AND
    EWT_CLM_PAY_COV.CPV_CLAIM_ID=      COV_LG.D66_ADW_CLAIM_ID AND
    EWT_CLM_PAY_COV.CPV_COV_CD=        COV_LG.D66_LEG_CLM_COV_CD AND 
    EWT_CLM_PAY_COV.CPV_INVL_PARTY_ID= COV_LG.D66_LEG_INV_ID AND 
    EWT_CLM_PAY_COV.CPV_PT_CLM_LINE_CD=COV_LG.D66_PT_CLM_LINE_CD AND
    EWT_CLM_PAY_COV.CPV_PT_LOSS_ST_CD= COV_LG.D66_PT_LOSS_ST_CD AND
    EWT_CLM_PAY_COV.CPV_PT_LOSS_YR=    COV_LG.D66_PT_LOSS_YR  AND
	datepart(COV_LG.D66_END_ATOMIC_TS) gt '31DEC2050'D
	/*COV_LG.D66_END_ATOMIC_TS = TO_TIMESTAMP ('9999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF6')*/
	AND cpc.cpv_clm_check_nbr in (select distinct chk_nbr from cpat.legacy_only)
;
quit;

proc sort data = data.legacy_cov_dates out = data.legacy_cov_dates_payment_level (keep = 
  						  CPE_CLAIM_NBR
						  CPV_CLM_CHECK_NBR
						  D66_OPEN_DT
						  D66_CLOSE_DT
						  CPV_ITEM_CLMNT_AMT) nodupkey;
	by CPV_CLM_CHECK_NBR descending CPV_ITEM_CLMNT_AMT;
run;

proc sort data = data.legacy_cov_dates_payment_level (drop=CPV_ITEM_CLMNT_AMT) nodupkey; /*to merge with dsm_base_pymnts*/
	by CPV_CLM_CHECK_NBR;
run;

proc sql;
create table cpat.legacy_only_final as
select a.*, b.D66_OPEN_DT as coverage_open_date, b.D66_CLOSE_DT as coverage_closed_date
from cpat.legacy_only a left join data.legacy_cov_dates_payment_level b
on a.chk_nbr=b.CPV_CLM_CHECK_NBR
;
quit;
