%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas ";

proc sql;
connect to oracle as sra29q(user='sra29' password='Page@724' path='@ewsop000'); 
	create table data.dsm_pymnt_datapull AS select * from connection to sra29q (
	select distinct
		fe.n_fin_ent_id as n_pymnt_id, 
		fe.n_prfmr_org_enty as n_org_enty_id, 
		fe.a_fin_ent_amt,
		pt.c_pymnt_meth, 
		pt.c_pymnt_typ,	
		pt.D_ISSUE_DT,
		pd.e19_n_pt_loss_yr,
		pd.e19_c_pt_clm_line_cd,
		pd.e19_c_pt_loss_st_cd,
		pd.e19_n_adw_claim_id,
		pd.n_pymnt_dtl_id,
		pd.n_line_id, 
		pd.c_after_close_ind, 
		pd.c_method_stlmt_cd,

		cp.N_PYMNT_NBR as chk_nbr, 	
		cp.M_MAIL_TO_NAME as mail_to_nm,
		cp.M_PAYEE_NAME as payee_nm, 
		cp.C_ZIP as payee_zip,
		cp.m_city as payee_city,
		cp.c_state as payee_state,
		cp.t_street as payee_street

	from 
		ngprod.ewt_financial_entity_ng fe,
		ngprod.ewt_payment_ng pt,
		ngprod.ewt_payment_dtl_ng pd,
		ngprod.ewt_check_pymnt_ng cp
	where	
		
		pt.d_issue_dt >= '01-DEC-12'
		and pt.D_ISSUE_DT <= '30-NOV-14'
/*		pd.e19_n_adw_claim_id = 632400000108*/

		and fe.n_fin_ent_id = pt.n_pymnt_id /*join financial entity and payment*/
		and pt.n_pymnt_id = pd.n_pymnt_id /*join payment detail to payment*/
		and pd.n_pymnt_id = cp.N_CHK_PYMNT_ID /*join check payment to payment*/

		and fe.e65_c_adw_rcd_del = 'N'
		and pt.e71_c_adw_rcd_del = 'N'
		and pd.e19_c_adw_rcd_del = 'N'
		and cp.E53_C_ADW_RCD_DEL = 'N'
);
disconnect from sra29q;
quit;



/* Extracting data to oracle for issuer title and name match */  

/*data dsm_base;*/
/*set data.dsm_pymnt_datapull;*/
/* length dt $29 ;*/
/*    dt=TRANWRD(put(d_issue_dt,is8601dt.),'T',' ');*/
/*run;*/

/*proc sql;*/
/* create table sra29.DSM_Base_&version. as */
/**/
/*select dt , n_pymnt_id ,chk_nbr ,payee_nm*/
/*FROM dsm_base*/
/*quit;*/


/* Employee details from ewt_claim_employee.This table is used to create Payee Employee Address and Name match flag.
No info is joined for Employees */
proc sql;
create table data.ewt_claim_employee_total_&version. as 
select distinct (UPPER(ECE.CLE_EMP_FIRST_NM)||' '||UPPER(ECE.CLE_EMP_LAST_NM)) as employee_name,
	ece.*
from sra29.ewt_claim_employee ECE
where ECE.CLE_EMP_FIRST_NM is not null and ECE.CLE_EMP_LAST_NM is not null and
ECE.CLE_EMP_JOB_DESC <> 'INDEP AGENCY' AND
ECE.CLE_EMP_JOB_DESC <> 'R3000 AGT UN' AND
ECE.CLE_EMP_JOB_DESC <> 'R3000 AGENT' AND
ECE.CLE_EMP_JOB_DESC <> 'EXC AGENT' AND
ECE.CLE_EMP_JOB_DESC <> 'INDEP. AGENCY' AND
ECE.CLE_EMP_JOB_DESC <> 'EXCL AGENT' AND
ECE.CLE_EMP_JOB_DESC <> 'EXCL. AGENT' AND
ECE.CLE_EMP_JOB_DESC <> 'EXCL FINL SPECL' AND
ECE.CLE_EMP_JOB_DESC <> 'MKT BUS CONSULT' AND
ECE.CLE_EMP_JOB_DESC <> 'EXCL FINL SPEC' AND
ECE.CLE_EMP_JOB_DESC <> 'PARALEGAL' AND
ECE.CLE_EMP_JOB_DESC <> 'NY FINL SPEC' AND
ECE.CLE_EMP_JOB_DESC <> 'LEAD COUNSEL' AND
ECE.CLE_EMP_JOB_DESC <> 'AGENCY CONS' AND
ECE.CLE_EMP_JOB_DESC <> 'COUNSEL' AND
ECE.CLE_EMP_JOB_DESC <> 'PART TIME AGENT' AND
ECE.CLE_EMP_JOB_DESC <> 'PAYT ANNTY SPST' AND
ECE.CLE_EMP_JOB_DESC <> 'MANAGING ATTNY' AND
ECE.CLE_EMP_JOB_DESC <> 'AGENCY SLS MGR' AND
ECE.CLE_EMP_JOB_DESC <> 'ASSOC MKTG MGR' AND
ECE.CLE_EMP_JOB_DESC <> 'BUS CONSULT' AND
ECE.CLE_EMP_JOB_DESC <> 'SR SALES MGR' AND
ECE.CLE_EMP_JOB_DESC <> 'NEW AGV SPEC' AND
ECE.CLE_EMP_JOB_DESC <> 'TRNG SPECIALIST' AND
ECE.CLE_EMP_JOB_DESC <> 'SLS OPS MANAGER' AND
ECE.CLE_EMP_JOB_DESC <> 'SR MKTG ANALYST' AND
ECE.CLE_EMP_JOB_DESC <> 'TECH COORDR' AND
ECE.CLE_EMP_JOB_DESC <> 'HR DIV MGR' AND
ECE.CLE_EMP_JOB_DESC <> 'MKT DIST LDR' AND
ECE.CLE_EMP_JOB_DESC <> 'NEW AGV SPEC' AND
ECE.CLE_EMP_JOB_DESC <> 'TRNG SPECIALIST' AND
ECE.CLE_EMP_JOB_DESC <> 'SLS OPS MANAGER' AND
ECE.CLE_EMP_JOB_DESC <> 'SR MKTG ANALYST' AND
ECE.CLE_EMP_JOB_DESC <> 'TECH COORDR' AND
ECE.CLE_EMP_JOB_DESC <> 'HR DIV MGR' AND
ECE.CLE_EMP_JOB_DESC <> 'MKT DIST LDR' AND
ECE.CLE_EMP_JOB_DESC <> 'STFCONSL ADM AST' AND
ECE.CLE_EMP_JOB_DESC <> 'MARKETING MGR' AND
ECE.CLE_EMP_JOB_DESC <> 'AGENT';
quit;

data sra29.ewt_claim_employee_a_&version. sra29.ewt_claim_employee_b_&version.  sra29.ewt_claim_employee_c_&version. 
	sra29.ewt_claim_employee_d_&version. sra29.ewt_claim_employee_e_&version. sra29.ewt_claim_employee_f_&version.
    sra29.ewt_claim_employee_g_&version. sra29.ewt_claim_employee_h_&version. sra29.ewt_claim_employee_i_&version.
sra29.ewt_claim_employee_j_&version.;
set data.ewt_claim_employee_total_&version.;
if 0 < _N_ <= 3500 then output sra29.ewt_claim_employee_a_&version.;
else if 3500 < _N_ <= 7000 then output sra29.ewt_claim_employee_b_&version.;
else if 7000 < _N_ <= 10500 then output sra29.ewt_claim_employee_c_&version.;
else if 10500 < _N_ <= 14000 then output sra29.ewt_claim_employee_d_&version.;
else if 14000 < _N_ <= 17500 then output sra29.ewt_claim_employee_e_&version.;
else if 21000< _N_ <= 24500 then output sra29.ewt_claim_employee_f_&version.;
else if 24500< _N_ <= 28000 then output sra29.ewt_claim_employee_g_&version.;
else if 28000< _N_<= 31500 then output sra29.ewt_claim_employee_h_&version.;
else if 31500< _N_<= 34000 then output sra29.ewt_claim_employee_i_&version.;
else if 34000< _N_ then output sra29.ewt_claim_employee_j_&version.;
run;

/* After this chek point Name Match Query can be run */


/*=====================================================================
* QUERRY TO PULL ATTRIBUTES FROM ORG ENTITY (CHAINED TABLE, SO TAKE 
* LATEST RECORD)
========================================================================*/
proc sql;
	create table data.dsm_pymnt_org_base as
	select distinct
		n_org_enty_id
	from data.dsm_pymnt_datapull
	;
quit;

proc sql;
	create table data.dsm_org_entity as
	select distinct
		base.n_org_enty_id,

		oe.m_alpha_id,
		oe.m_org_first_uc as emp_first_nm,
		oe.m_org_last_uc as emp_last_nm,
		oe.n_user_id,
		oe.E68_D_ATOMIC_TS
	from data.dsm_pymnt_org_base as base,
		source.ewt_org_entity_ng as oe
	where base.n_org_enty_id = oe.n_org_enty_id
		and oe.e68_c_adw_rcd_del = 'N'
	;
quit;

proc sort data=data.dsm_org_entity;
	by n_org_enty_id descending e68_d_atomic_ts;
run;
proc sort data = data.dsm_org_entity (drop=e68_d_atomic_ts) nodupkey;
	by n_org_enty_id;
run;

******************************************************
* Merge the org entity details with payments base
*******************************************************;
/*=========================================================================
* DSM_BASE_PYMNTS
===========================================================================*/
proc sort data=data.dsm_pymnt_datapull(keep = 
										e19_n_adw_claim_id
										e19_n_pt_loss_yr
										e19_c_pt_clm_line_cd
										e19_c_pt_loss_st_cd
										n_pymnt_id
										n_org_enty_id
										a_fin_ent_amt
										c_pymnt_meth 
										c_pymnt_typ	
										D_ISSUE_DT
										chk_nbr	
										mail_to_nm
										payee_nm
										payee_zip
										payee_city
										payee_street
										payee_state) out=data.dsm_base_pymnts nodupkey;
	by	n_pymnt_id;
run;
proc sort data = data.dsm_base_pymnts;
	by n_org_enty_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts(in=a) data.dsm_org_entity(in=b);
	by n_org_enty_id;
	if a;
run;

/*=========================================================================
* DSM_BASE_PYMNT_DTL
===========================================================================*/
/*=========================================================================
* PULL COVERAGE HANDLING CODE FROM EWT_LINE_NG (CREATE DSM_BASE_PYMNT_DTL)
===========================================================================*/
proc sql;
	create table data.dsm_base_line as
	select distinct 
				e19_n_adw_claim_id,
				e19_n_pt_loss_yr,
				e19_c_pt_clm_line_cd,
				e19_c_pt_loss_st_cd,
				n_line_id, 
				n_pymnt_dtl_id,
				n_pymnt_id,
				c_after_close_ind,
				C_METHOD_STLMT_CD
	from data.dsm_pymnt_datapull
;
quit;
proc sql;
	create table data.dsm_base_pymnt_dtl as
	select distinct
		base.*,
		line.c_cov_hndlng_cd,
		line.c_line_type
	from data.dsm_base_line as base,
		source.ewt_line_ng as line
	where base.n_line_id = line.n_line_id
		and line.e24_c_adw_rcd_del = 'N'
;
quit;

/*============================================================================================================
* EWT_FINANCIAL_TX_NG -- TO GET THE D_FIN_TX_POST_DATE 
===============================================================================================================*/
proc sql;
	create table data.dsm_fin_dt_pymnt_dtl as
	select distinct
		fin.D_FIN_TX_POST_DT,
		base.*
	from
		source.EWT_FINANCIAL_TX_NG fin,
		data.dsm_base_pymnt_dtl base
	where
		fin.E17_n_PT_LOSS_YR = base.e19_n_PT_LOSS_YR
        AND fin.E17_c_PT_CLM_LINE_CD = base.e19_c_PT_CLM_LINE_CD
        AND fin.e17_c_PT_LOSS_ST_CD = base.e19_c_PT_LOSS_ST_CD
        AND fin.e17_n_ADW_CLAIM_ID = base.e19_n_ADW_CLAIM_ID

		and fin.N_FIN_DTL_ID = base.n_pymnt_dtl_id
		and fin.e17_c_adw_rcd_del = 'N'
;
quit;
proc sort data=data.dsm_fin_dt_pymnt_dtl out = data.dsm_base_pymnt_dtl nodupkey;
	by n_pymnt_dtl_id;
run;

/*=========================================================================
* TO GET THE AMOUNT AT A PAYMENT DETAIL LEVEL -- A_FIN_TX_AMT
===========================================================================*/
data data.dsm_pymnt_dtl;
set data.dsm_base_pymnt_dtl (keep= e19_n_adw_claim_id
									e19_n_pt_loss_yr
									e19_c_pt_clm_line_cd
									e19_c_pt_loss_st_cd
									n_pymnt_dtl_id);
run;
proc sql;
	create table data.dsm_amnt_pymnt_dtl as
	select distinct
		sum(fin.A_FIN_TX_AMT * ref.N_BAL_MULTIPLIER) as a_fin_tx_amt,
		base.e19_n_ADW_CLAIM_ID,
		base.e19_n_PT_LOSS_YR,
		base.e19_c_PT_CLM_LINE_CD,
		base.e19_c_PT_LOSS_ST_CD,		
		base.n_pymnt_dtl_id
	from
		source.EWT_FINANCIAL_TX_NG fin,
		data.dsm_pymnt_dtl base,
		source.ewt_ref_entry_offset_ng ref
	where
		fin.E17_n_PT_LOSS_YR = base.e19_n_PT_LOSS_YR
        and fin.E17_c_PT_CLM_LINE_CD = base.e19_c_PT_CLM_LINE_CD
        and fin.e17_c_PT_LOSS_ST_CD = base.e19_c_PT_LOSS_ST_CD
        and fin.e17_n_ADW_CLAIM_ID = base.e19_n_ADW_CLAIM_ID
		and fin.N_FIN_DTL_ID = base.n_pymnt_dtl_id
		and fin.e17_c_adw_rcd_del = 'N'
		and ref.C_ENTRY_TYP = fin.C_FIN_TX_ENTRY_TYP
	group by
		base.e19_n_ADW_CLAIM_ID,
		base.e19_n_PT_LOSS_YR,
		base.e19_c_PT_CLM_LINE_CD,
		base.e19_c_PT_LOSS_ST_CD,		
		base.n_pymnt_dtl_id
;
quit;

****************************************************************************************
* MERGING AMOUNT TO DSM_BASE_PYMNT_DTL -- HAS n_line_id, n_pymnt_dtl_id, D_fin_tx_post_dt
* c_after_close_ind, C_METHOD_STLMT_CD, a_fin_tx_amt, c_cov_hndlng_cd, line.c_line_type
***************************************************************************************;
proc sort data = data.dsm_base_pymnt_dtl nodupkey;
	by e19_n_adw_claim_id
		e19_n_pt_loss_yr
		e19_c_pt_clm_line_cd
		e19_c_pt_loss_st_cd
		n_pymnt_dtl_id;
run;
proc sort data = data.dsm_amnt_pymnt_dtl nodupkey;
	by e19_n_adw_claim_id
		e19_n_pt_loss_yr
		e19_c_pt_clm_line_cd
		e19_c_pt_loss_st_cd
		n_pymnt_dtl_id;
run;
data data.dsm_base_pymnt_dtl;
	merge data.dsm_base_pymnt_dtl (in=a) data.dsm_amnt_pymnt_dtl (in=b);
	by e19_n_adw_claim_id
		e19_n_pt_loss_yr
		e19_c_pt_clm_line_cd
		e19_c_pt_loss_st_cd
		n_pymnt_dtl_id;
	if a;
run;

/*=========================================================================
* DSM_BASE_CLAIMS
===========================================================================*/
/*=========================================================================
* PULLING POLICY DETAILS AND CREATING CLAIM LEVEL TABLE
* PULLING CLAIM INCEPTION DATA (D_CLAIM_ENTERED)
===========================================================================*/
proc sql;
	create table data.claim_id as
	select distinct e19_n_adw_claim_id, 
					e19_n_pt_loss_yr,
					e19_c_pt_clm_line_cd,
					e19_c_pt_loss_st_cd
	from data.dsm_pymnt_datapull
;
proc sql;
	create table data.dsm_base_policy as
	select distinct
		base.*,
		pol.n_policy,
		pol.d_pol_inception_dt
	from 
		data.claim_id as base left join
		source.ewt_policy_ng as pol on base.e19_n_adw_claim_id = pol.E32_N_ADW_CLAIM_ID
	where pol.E32_C_ADW_RCD_DEL = 'N'
;
quit;
proc sort data=data.dsm_base_policy nodupkey;
	by e19_n_adw_claim_id;
run;
proc sql;
	create table data.dsm_base_claims as
	select distinct 
		base.e19_n_adw_claim_id, 
		base.e19_n_pt_loss_yr,
		base.e19_c_pt_clm_line_cd,
		base.e19_c_pt_loss_st_cd,
		claim.d_claim_entered,
		claim.n_claim_number,
		claim.c_lob
	from 
		data.dsm_pymnt_datapull as base,
		source.ewt_claim_ng as claim
	where claim.E38_N_ADW_CLAIM_ID = base.E19_N_ADW_CLAIM_ID
		and claim.E38_C_ADW_RCD_DEL = 'N'	
;
quit;
proc sort data=data.dsm_base_claims nodupkey;
	by e19_n_adw_claim_id;
run;

/*=========================================================================
* NUMBER OF PARTICIPANTS CREATED
===========================================================================*/
proc sql;
	create table data.dsm_invl_part_cnt as
	select distinct
		base.E19_N_ADW_CLAIM_ID,
		base.E19_N_PT_LOSS_YR,
		base.E19_C_PT_CLM_LINE_CD,
		base.E19_C_PT_LOSS_ST_CD,
		
		inv.n_ins_invl_id,
		inv.d_create_ts as invl_create_ts,

		inr.C_INVL_ROLE,
		inr.N_INVL_ROLE_ID
	from
		source.ewt_ins_involvement_ng inv,
		source.ewt_involvement_role_ng inr,
		data.dsm_base_claims base
	where
		inr.n_ins_invl_id = inv.n_ins_invl_id /*joining ins_involvement_ng to involvement_role_ng*/
		and inv.e44_n_pt_loss_yr = inr.e43_n_pt_loss_yr
		and inv.e44_c_pt_clm_line_cd = inr.e43_c_pt_clm_line_cd
		and inv.e44_c_pt_loss_st_cd = inr.e43_c_pt_loss_st_cd
		and inv.e44_n_adw_claim_id = inr.e43_n_adw_claim_id

		and inv.e44_n_pt_loss_yr = base.e19_n_pt_loss_yr
		and inv.e44_c_pt_clm_line_cd = base.e19_c_pt_clm_line_cd
		and inv.e44_c_pt_loss_st_cd = base.e19_c_pt_loss_st_cd
		and inv.e44_n_adw_claim_id = base.e19_n_adw_claim_id

		and inv.E44_C_ADW_RCD_DEL = 'N'
		and inr.E43_C_ADW_RCD_DEL = 'N'
;
quit;

/*=============================================================================================
* MAXIMUM PARTICIPANT ADD DATE -- AT A CLAIM LEVEL
===============================================================================================*/
proc sort data =  data.dsm_invl_part_cnt;
	by E19_N_PT_LOSS_yr E19_C_PT_CLM_LINE_CD E19_C_PT_LOSS_ST_CD E19_N_ADW_CLAIM_ID;
run;

proc sort data =  data.dsm_base_claims nodupkey;
	by E19_N_PT_LOSS_yr E19_C_PT_CLM_LINE_CD E19_C_PT_LOSS_ST_CD E19_N_ADW_CLAIM_ID;
run;

data data.dsm_invl_part_cnt;
	merge data.dsm_invl_part_cnt(in=a) data.dsm_base_claims(in=b keep = E19_N_PT_LOSS_yr E19_C_PT_CLM_LINE_CD 
																	E19_C_PT_LOSS_ST_CD E19_N_ADW_CLAIM_ID
																	d_claim_entered);
	by E19_N_PT_LOSS_yr E19_C_PT_CLM_LINE_CD E19_C_PT_LOSS_ST_CD E19_N_ADW_CLAIM_ID;
	if a;
	part_add_fnol_days = datepart(invl_create_ts) - datepart(d_claim_entered);
run;

/*=============================================================================================
* NUM_PART_FNOLPLUS30 -- AT A CLAIM LEVEL
===============================================================================================*/
proc sql;
	create table dsm_invl_num_part_fnolplus30
	as select E19_N_PT_LOSS_yr, 
			E19_C_PT_CLM_LINE_CD, 
			E19_C_PT_LOSS_ST_CD, 
			E19_N_ADW_CLAIM_ID,
			count(distinct n_ins_invl_id) as num_part_fnolplus30
	from data.dsm_invl_part_cnt
	where part_add_fnol_days le 30
	group by E19_N_PT_LOSS_yr, 
			E19_C_PT_CLM_LINE_CD, 
			E19_C_PT_LOSS_ST_CD, 
			E19_N_ADW_CLAIM_ID;
quit;

/*=============================================================================================
* NUM_PARTICIPANTS -- AT A CLAIM LEVEL
===============================================================================================*/
proc sql;
	create table dsm_invl_num_part
	as select E19_N_PT_LOSS_yr, 
			E19_C_PT_CLM_LINE_CD, 
			E19_C_PT_LOSS_ST_CD, 
			E19_N_ADW_CLAIM_ID,
			count(distinct n_ins_invl_id) as num_participant
	from data.dsm_invl_part_cnt
	group by E19_N_PT_LOSS_yr, 
			E19_C_PT_CLM_LINE_CD, 
			E19_C_PT_LOSS_ST_CD, 
			E19_N_ADW_CLAIM_ID;
quit;

/*=============================================================================================
* NUM_PASS_FNOLPLUS30 -- AT A CLAIM LEVEL
===============================================================================================*/
proc sql;
	create table dsm_invl_num_pass_fnolplus30
	as select E19_N_PT_LOSS_yr, 
			E19_C_PT_CLM_LINE_CD, 
			E19_C_PT_LOSS_ST_CD, 
			E19_N_ADW_CLAIM_ID,
			count(distinct n_ins_invl_id) as num_pass_fnolplus30
	from data.dsm_invl_part_cnt
	where part_add_fnol_days le 30
		and c_invl_role in ('PASC', 'PASI', 'PASS')
	group by E19_N_PT_LOSS_yr, 
			E19_C_PT_CLM_LINE_CD, 
			E19_C_PT_LOSS_ST_CD, 
			E19_N_ADW_CLAIM_ID;
quit;

/*=============================================================================================
* NUM_PASSENGERS -- AT A CLAIM LEVEL
===============================================================================================*/
proc sql;
	create table dsm_invl_num_pass
	as select E19_N_PT_LOSS_yr, 
			E19_C_PT_CLM_LINE_CD, 
			E19_C_PT_LOSS_ST_CD, 
			E19_N_ADW_CLAIM_ID,
			count(distinct n_ins_invl_id) as num_passenger
	from data.dsm_invl_part_cnt
		where c_invl_role in ('PASC', 'PASI', 'PASS')
	group by E19_N_PT_LOSS_yr, 
			E19_C_PT_CLM_LINE_CD, 
			E19_C_PT_LOSS_ST_CD, 
			E19_N_ADW_CLAIM_ID;
quit;

********************************************************************************
* MERGING IT WITH DSM_BASE_CLAIMS --HAS max_part_add_date, num_passenger, 
* num_pass_fnloplus30, num_participant, num_part_fnolplus30
* 4 partition keys, d_claim_entered,n_policy, d_pol_inception_dt, company code
*******************************************************************************;
proc sql;
	create table temp as
	select E19_N_PT_LOSS_yr,
			E19_C_PT_CLM_LINE_CD,
			E19_C_PT_LOSS_ST_CD,
			E19_N_ADW_CLAIM_ID,
			max(part_add_fnol_days) as max_part_add_date
	from data.dsm_invl_part_cnt
	group by 
			E19_N_PT_LOSS_yr,
			E19_C_PT_CLM_LINE_CD,
			E19_C_PT_LOSS_ST_CD,
			E19_N_ADW_CLAIM_ID
;
quit;
data data.dsm_base_claims;
	merge data.dsm_base_claims (in=a) temp (in=b) dsm_invl_num_part_fnolplus30 (in=c) dsm_invl_num_part (in=d)
										dsm_invl_num_pass_fnolplus30 (in=e) dsm_invl_num_pass (in=f);
	by E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
	if a;
run;

/*=============================================================================================
* COMPANY CODE -- AT A CLAIM LEVEL
===============================================================================================*/
proc sql;
create table data.company_code as
	select distinct 
			p.e32_n_adw_claim_id, 
			p.n_policy_co_nbr as company_code, 
			c.t_long_desc as company
	from source.ewt_policy_ng as p, 
			source.ewt_code_decode_ng as c
	where p.e32_n_adw_claim_id in (select distinct e19_n_adw_claim_id from data.dsm_base_claims) 
			and p.n_policy_co_nbr = c.c_code
			and c.c_category = 264
			and p.e32_c_adw_rcd_del = 'N';
quit;

proc sort data=data.company_code out=company_code (rename = (e32_n_adw_claim_id = e19_n_adw_claim_id)) nodupkey;
	by e32_n_adw_claim_id;
run;
proc sort data=data.dsm_base_claims;
	by e19_n_adw_claim_id;
run;
data data.dsm_base_claims;
	merge data.dsm_base_claims (in=a) company_code (in=b);
	by e19_n_adw_claim_id;
	if a;
run;
/*=========================================================================
* PULLING EMPLOYEE LEVEL DETAILS
==========================================================================*/
data data.employee_data;
    infile "&employee_details." 
	delimiter=',' MISSOVER DSD lrecl=32767 firstobs=2 termstr=crlf ;
	informat Pernr $3.;
	informat NTID $20.;
	informat E_Name $100.;
	informat E_Yrs_Service 3.;
	informat E_Street $50.;
	informat E_City $50.;
	informat E_Region $3.;
	informat employee_Zip $10.; 
/*	informat scrap 1.;*/

	format Pernr $3.;
	format NTID $20.;
	format E_Name $100.;
	format E_Yrs_Service 3.;
	format E_Street $50.;
	format E_City $50.;
	format E_Region $3.;
	format employee_Zip $10.; 
/*	format scrap 1.;*/

	input
	Pernr $
	NTID $
	E_Name $
	E_Yrs_Service
	E_Street $
	E_City $
	E_Region $
	employee_zip
/*	scrap*/
	;
run;


************************************************
* MERGING EMPLOYEE DETAILS WITH DSM_BASE_PYMNTS
************************************************;
proc sort data = data.employee_data(rename=(ntid = n_user_id)) out=sorted  nodupkey;
	by n_user_id;
run;
proc sort data = data.dsm_base_pymnts;
	by n_user_id;
run;

data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) sorted (in=b keep = n_user_id employee_zip);
	by n_user_id;
	if a;
run;

/***************************************************************************************************** 
* dsm_base_pymtns now have: 4 partition keys, n_org_enty_id, a_fin_ent_amt, c_pymnt_meth, c_pymnt_typ 
* d_issue_dt, n_pymnt_id, chk_nbr, mail_to_nm, payee_nm, payee_zip, payee_state, m_alpha_id,
* emp_first_nm, emp_last_nm, n_user_id, employee_zip
******************************************************************************************************/

********************************************************************
* CODES FOR MCO ID, COMPANY CODE, ESTIMATES AND RBI SCORE COMES HERE
*********************************************************************;
/*=============================================================================================
* MCO ID -- 1.CARTESIAN OF EWT_ORG_ENTITY_NG 2.CH OFFICE 3.CO OFFICE
===============================================================================================*/
proc sql;
create table data.mco_name as 
select distinct OE1.N_ORG_ENTY_ID as n_org_enty_id, OE2.N_ORG_ENTY_ID as xc_MCO_ID
from source.ewt_org_entity_ng oe1,
     source.ewt_org_entity_ng oe2,
     source.EWT_ORG_ENTITY_RELSHP_NG oer
where OER.N_ORG_ENTY_ID1 = OE1.N_ORG_ENTY_ID
and   OER.N_ORG_ENTY_ID2 = OE2.N_ORG_ENTY_ID
and   OE2.N_TYPE_ID = '2241B4EF55285115'
and datepart(OE1.E68_D_END_ATOMIC_TS) gt '31DEC2050'D
and datepart(OE2.E68_D_END_ATOMIC_TS) gt '31DEC2050'D
and oe1.E68_C_ADW_RCD_DEL = 'N' and oe1.C_RCD_DEL = 'N'
and oe2.E68_C_ADW_RCD_DEL = 'N' and oe2.C_RCD_DEL = 'N'
and oer.E69_C_ADW_RCD_DEL = 'N' and oer.C_RCD_DEL = 'N';
quit;

proc sort data=data.dsm_base_pymnts;
	by n_org_enty_id;
run;
proc sort data=data.mco_name nodupkey;
	by n_org_enty_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) data.mco_name (in=b);
	by n_org_enty_id;
	if a;
	if xc_mco_id = '' then flag_missing_mco = 1;
	else flag_missing_mco = 0;
run;

proc sort data = data.dsm_base_pymnts (keep = n_pymnt_id xc_mco_id n_user_id flag_missing_mco m_alpha_id
									n_org_enty_id d_issue_dt) out = to_merge_dtl;
	by n_pymnt_id;
run;

proc sort data = data.dsm_base_pymnt_dtl;
	by n_pymnt_id;
run;
data data.dsm_base_pymnt_dtl;
	merge data.dsm_base_pymnt_dtl (in=a) to_merge_dtl (in=b);
	by n_pymnt_id;
	if a;
run;
/*dsm_base_pymnt_dtl now has xc_mco_id, flag_missing_mco, m_alpha_id and n_user_id d_issue_dt n_org_enty_id*/
****************************************************************************************
* DSM_BASE_PTMNT_DTL HAS D_FIN_TX_POST_DT, 4 PARTITION KEYS, N_LINE_ID, N_PYMNT_DTL_ID, 
* N_PYMNT_ID, C_AFTER_CLOSE_IND, MOS, COV HANDLING CODE, C_LINE_TYPE, A_FIN_TX_AMT, 
* N_ORG_ENTY_ID, D_ISSUE_DT, M_ALPHA_ID, N_USER_ID, XC_MCO_ID, FLAG_MISSING_MCO
******************************************************************************************;
data data.missing_mco;
	set data.dsm_base_pymnt_dtl;
	if flag_missing_mco = 1;
run;	
	
/* MISSING MCO*/
proc sql;
create table data.dsm_ch_mco_v1 as 
select distinct b.e19_n_adw_claim_id, p.n_line_id, a.n_user_id, a.n_org_enty_id, a.mco_id,p.d_deactivation,
p.d_activation
from
data.dsm_base_pymnt_dtl b,
source.ewt_performer_ng p,
(select oe1.n_user_id, oe1.n_org_enty_id , oe2.n_org_enty_id as mco_id, oe2.m_corporate
from source.ewt_org_entity_ng oe1,
     source.ewt_org_entity_ng oe2,
     source.ewt_org_entity_relshp_ng oer
where oer.n_org_enty_id1 = oe1.n_org_enty_id
and   oer.n_org_enty_id2 = oe2.n_org_enty_id
and   oe2.n_type_id = '2241B4EF55285115' 
and   datepart(oe1.e68_d_end_atomic_ts) ge '31DEC2050'd 
and   datepart(oe2.e68_d_end_atomic_ts) ge '31DEC2050'd 
and oe1.e68_c_adw_rcd_del = 'N'
and oe2.e68_c_adw_rcd_del = 'N'
and oer.e69_c_adw_rcd_del = 'N'
and OER.C_RPT_OFFICE_IND = 'Y'
) a
where b.e19_n_adw_claim_id = p.e14_n_adw_claim_id
and p.n_org_enty_id = a.n_org_enty_id
and b.n_line_id = p.n_line_id
and p.c_prfmr_role = 'CH'
and p.E14_C_ADW_RCD_DEL = 'N'
and datepart(b.d_fin_tx_post_dt) ge datepart(p.d_activation)
and ((datepart(b.d_fin_tx_post_dt) le datepart(p.d_deactivation)) OR (datepart(p.d_deactivation) = '1Jan1800'd));
quit;

proc sql;
create table data.dsm_ch_mco_v2 as 
select b.e19_n_adw_claim_id, b.n_pymnt_id,  b.n_pymnt_dtl_id, b.n_line_id, b.d_fin_tx_post_dt, 
a.n_org_enty_id, a.mco_id,a.d_deactivation,a.d_activation
from  data.missing_mco b left join data.dsm_ch_mco_v1 a 
on a.e19_n_adw_claim_id = b.e19_n_adw_claim_id
and a.n_line_id = b.n_line_id
and b.d_fin_tx_post_dt ge a.d_activation
and ((b.d_fin_tx_post_dt le a.d_deactivation) OR (datepart(a.d_deactivation) = '1Jan1800'd));
;
quit;

/*missing office*/
proc sql;
create table data.miss_office_temp as select * from data.dsm_ch_mco_v2 where mco_id = '';
quit;

proc sql;
create table data.miss_office_temp_out as select p.*,
miss.n_pymnt_id,miss.n_pymnt_dtl_id, miss.n_line_id as miss_line_id, miss.d_fin_tx_post_dt
from source.ewt_performer_ng p,data.miss_office_temp miss
where miss.e19_n_adw_claim_id = p.e14_n_adw_claim_id
and p.c_prfmr_role = 'CO'
and p.E14_C_ADW_RCD_DEL = 'N'
and miss.d_fin_tx_post_dt ge P.d_activation
and ((miss.d_fin_tx_post_dt le P.d_deactivation) OR (datepart(P.d_deactivation) = '1Jan1800'd))
;
quit;

proc sql;
create table data.miss_office_temp_out1 as select * from data.miss_office_temp_out
where c_prfmr_role = 'CO'
and E14_C_ADW_RCD_DEL = 'N'
and d_fin_tx_post_dt ge d_activation
and ((d_fin_tx_post_dt le d_deactivation) OR (datepart(d_deactivation) = '1Jan1800'd))
;
quit;

proc sql;
create table data.miss_office_temp_out2 as select distinct * from data.miss_office_temp_out1;
quit;

proc sql;
create table data.miss_office_temp_out2_co as select * from data.miss_office_temp where n_pymnt_dtl_id
not in (select distinct n_pymnt_dtl_id from data.miss_office_temp_out2);
quit;

proc sql;
create table data.miss_office_temp_out3 as select p.*,
miss.n_pymnt_id,miss.n_pymnt_dtl_id, miss.n_line_id as miss_line_id, miss.d_fin_tx_post_dt
from source.ewt_performer_ng p,data.miss_office_temp_out2_co miss
where miss.e19_n_adw_claim_id = p.e14_n_adw_claim_id
and p.c_prfmr_role = 'CO'
and p.E14_C_ADW_RCD_DEL = 'N'
and datepart(P.d_deactivation) = '1Jan1800'd
;
quit;

proc sql;
create table data.org_entity
as select oe1.n_user_id, oe1.n_org_enty_id , oe2.n_org_enty_id as mco_id, oe2.m_corporate
from source.ewt_org_entity_ng oe1,
     source.ewt_org_entity_ng oe2,
     source.ewt_org_entity_relshp_ng oer
where oer.n_org_enty_id1 = oe1.n_org_enty_id
and   oer.n_org_enty_id2 = oe2.n_org_enty_id
and   oe2.n_type_id = '2241B4EF55285115' 
and   datepart(oe1.e68_d_end_atomic_ts) ge '31DEC2050'd 
and   datepart(oe2.e68_d_end_atomic_ts) ge '31DEC2050'd 
and oe1.e68_c_adw_rcd_del = 'N'
and oe2.e68_c_adw_rcd_del = 'N'
and oer.e69_c_adw_rcd_del = 'N'
and OER.C_RPT_OFFICE_IND = 'Y'
;
quit;

proc sql;
create table data.dsm_co_miss_v1 as 
select distinct b.e14_n_adw_claim_id,b.n_pymnt_id,
b.n_pymnt_dtl_id, b.miss_line_id,
b.d_fin_tx_post_dt, a.n_org_enty_id, a.mco_id,b.d_deactivation,b.d_activation
from
data.miss_office_temp_out2 b,
data.org_entity a
where b.n_org_enty_id = a.n_org_enty_id;
quit;

proc sql;
create table data.office_temp_out2_miss_co as select * from data.miss_office_temp_out2 where n_pymnt_dtl_id
not in (select distinct n_pymnt_dtl_id from data.dsm_co_miss_v1);
quit;

proc sql;
create table data.dsm_co_miss_v2 as 
select distinct b.e14_n_adw_claim_id,b.n_pymnt_id,
b.n_pymnt_dtl_id, b.miss_line_id,
b.d_fin_tx_post_dt, a.n_org_enty_id, a.mco_id,b.d_deactivation,b.d_activation
from
data.miss_office_temp_out3 b,
data.org_entity a
where b.n_org_enty_id = a.n_org_enty_id;
quit;

proc sql;
create table data.office_temp_out3_miss_co as select * from data.miss_office_temp_out3 where n_pymnt_dtl_id
not in (select distinct n_pymnt_dtl_id from data.dsm_co_miss_v2);
quit;

proc sql;
create table data.org_entity_1
as select oe1.n_user_id, oe1.n_org_enty_id , oe2.n_org_enty_id as mco_id, oe2.m_corporate
from source.ewt_org_entity_ng oe1,
     source.ewt_org_entity_ng oe2,
     source.ewt_org_entity_relshp_ng oer
where oer.n_org_enty_id1 = oe1.n_org_enty_id
and   oer.n_org_enty_id2 = oe2.n_org_enty_id
and   oe2.n_type_id = '2241B4EF55285115' 
and   datepart(oe1.e68_d_end_atomic_ts) ge '31DEC2050'd 
and   datepart(oe2.e68_d_end_atomic_ts) ge '31DEC2050'd 
and oe1.e68_c_adw_rcd_del = 'N'
and oe2.e68_c_adw_rcd_del = 'N'
and oer.e69_c_adw_rcd_del = 'N'
/*and OER.C_RPT_OFFICE_IND = 'Y'*/
;
quit;

proc sql;
create table data.dsm_co_miss_v3 as 
select distinct b.e14_n_adw_claim_id,b.n_pymnt_id,
b.n_pymnt_dtl_id, b.miss_line_id,
b.d_fin_tx_post_dt, a.n_org_enty_id, a.mco_id,b.d_deactivation,b.d_activation
from
data.office_temp_out2_miss_co b,
data.org_entity_1 a
where b.n_org_enty_id = a.n_org_enty_id;
quit;

proc sql;
create table data.office_temp_out4_miss_co as select * from data.office_temp_out2_miss_co where n_pymnt_dtl_id
not in (select distinct n_pymnt_dtl_id from data.dsm_co_miss_v3);
quit;

proc sql;
create table data.org_entity_2
as select oe1.n_user_id, oe1.n_org_enty_id , oe2.n_org_enty_id as mco_id, oe2.m_corporate,oer.D_last_updt_TS
from source.ewt_org_entity_ng oe1,
     source.ewt_org_entity_ng oe2,
     source.ewt_org_entity_relshp_ng oer
where oer.n_org_enty_id1 = oe1.n_org_enty_id
and   oer.n_org_enty_id2 = oe2.n_org_enty_id
and   oe2.n_type_id = '2241B4EF55285115' 
and   datepart(oe1.e68_d_end_atomic_ts) ge '31DEC2050'd 
and   datepart(oe2.e68_d_end_atomic_ts) ge '31DEC2050'd 
and oe1.e68_c_adw_rcd_del = 'N'
and oe2.e68_c_adw_rcd_del = 'N'
/*and oer.e69_c_adw_rcd_del = 'N'*/
and OER.C_RPT_OFFICE_IND = 'Y'
;
quit;

proc sql;
create table data.dsm_co_miss_v4 as 
select distinct b.e14_n_adw_claim_id,b.n_pymnt_id,
b.n_pymnt_dtl_id, b.miss_line_id,
b.d_fin_tx_post_dt, a.n_org_enty_id, a.mco_id,b.d_deactivation,b.d_activation,a.D_last_updt_TS
from
data.office_temp_out4_miss_co b,
data.org_entity_2 a
where b.n_org_enty_id = a.n_org_enty_id;
quit;


proc sql;
create table mco1
as select n_pymnt_id,n_pymnt_dtl_id,mco_id
from data.dsm_ch_mco_v2
where mco_id ne "";
quit;

proc sql;
create table mco2
as select n_pymnt_id,n_pymnt_dtl_id,mco_id
from data.dsm_co_miss_v1
where mco_id ne "";
quit;

proc sql;
create table mco3
as select n_pymnt_id,n_pymnt_dtl_id,mco_id
from data.dsm_co_miss_v2
where mco_id ne "";
quit;

proc sql;
create table mco4
as select n_pymnt_id,n_pymnt_dtl_id,mco_id
from data.dsm_co_miss_v3
where mco_id ne "";
quit;

proc sql;
create table mco5
as select n_pymnt_id,n_pymnt_dtl_id,mco_id
from data.dsm_co_miss_v4
where mco_id ne "";
quit;

data data.mco_prefinal;
	set mco1 mco2 mco3 mco4 mco5;
run;

proc sort data = data.mco_prefinal nodupkey out = data.mco_final(keep = n_pymnt_id n_pymnt_dtl_id mco_id);
by n_pymnt_id n_pymnt_dtl_id;
run;
proc sort data=data.dsm_base_pymnt_dtl;
	by n_pymnt_id n_pymnt_dtl_id;
run;
data data.dsm_base_pymnt_dtl (drop = mco_id);
	merge data.dsm_base_pymnt_dtl (in=a) data.mco_final (in=b);
	by n_pymnt_id n_pymnt_dtl_id;
	if a;
	if xc_mco_id = '' and mco_id ne '' then xc_mco_id = mco_id;
	else if xc_mco_id = '' and mco_id = '' then xc_mco_id = "Missing";
run;
/*=============================================================================================
* AVERAGE RBI SCORE -- MERGED WITH DSM_BASE_PYMNTS
===============================================================================================*/
%macro test();
proc sql;
select max(next_to_date) into:to_date from rundates.nxt_run_dates;
quit;
proc sql;
select max(next_from_date) into:from_date from rundates.nxt_run_dates;
quit;
%put &to_date. &from_date.;
proc sql;
create table data.all_estimates_1 as
	SELECT   
         est.d70_pt_loss_yr AS d70_pt_loss_yr, est.d70_pt_clm_line_cd AS d70_pt_clm_line_cd, est.d70_pt_loss_st_cd AS d70_pt_loss_st_cd,
         est.d70_adw_claim_id AS d70_adw_claim_id, est.claim_number AS claim_number, est.involved_party_id AS involved_party_id,
         est.coverage_code AS coverage_code,
         SUBSTR (est.sw_supplement_number, 1, 1) AS est_type,
         MAX(est.upload_package_received_date) AS upload_package_received_date,
         est.estimate_id
        FROM source.ewv_or_all_estimates est
        WHERE est.is_final = 1
        AND est.moi_id in (1, 2)  
        AND SUBSTR (est.sw_supplement_number, 1, 1) = 'E'
		AND DATEPART(est.upload_package_received_date) ge &from_date.
        AND DATEPART(est.upload_package_received_date) le &to_date.
	GROUP BY est.d70_pt_loss_yr,
         est.d70_pt_clm_line_cd,
         est.d70_pt_loss_st_cd,
         est.d70_adw_claim_id,
         est.claim_number,
         est.involved_party_id,
         est.coverage_code,
         SUBSTR (est.sw_supplement_number, 1, 1),
         est.estimate_id;
quit;
%mend;
%test();

%macro test();
proc sql;
select max(next_to_date) into:to_date from rundates.nxt_run_dates;
quit;
proc sql;
select max(next_from_date) into:from_date from rundates.nxt_run_dates;
quit;
%put &to_date. &from_date.;
proc sql;
	create table data.all_estimates_2 as
	SELECT   
         est.d70_pt_loss_yr, est.d70_pt_clm_line_cd, est.d70_pt_loss_st_cd,
         est.d70_adw_claim_id, est.claim_number, est.involved_party_id,
         est.coverage_code, SUBSTR (est.sw_supplement_number, 1, 1) AS est_type,
         MAX (est.upload_package_received_date) AS upload_package_received_date,
		 est.estimate_id
        FROM source.ewv_or_all_estimates est
        WHERE est.is_final = 1
        AND est.moi_id in (1, 2)
        AND SUBSTR (est.sw_supplement_number, 1, 1) = 'S'
		AND DATEPART (est.upload_package_received_date) ge &from_date.
        AND DATEPART (est.upload_package_received_date) le &to_date.
	GROUP BY est.d70_pt_loss_yr,
         est.d70_pt_clm_line_cd,
         est.d70_pt_loss_st_cd,
         est.d70_adw_claim_id,
         est.claim_number,
         est.involved_party_id,
         est.coverage_code,
         SUBSTR (est.sw_supplement_number, 1, 1),
		 est.estimate_id;
quit;
quit;
%mend;
%test();
data data.all_estimates;
	set data.all_estimates_1 data.all_estimates_2;
run; 

/*data set est*/

%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas ";

/*data set est*/

proc sql;

create table data.est as 
SELECT 
               adj_mco.mco_id as mco_id,
               allest.claim_number as claim_number, 
               upc.xm_org_entity_nm AS adjuster_wrote_est,
               upc.xm_alpha_id AS adjuster_alpha_id,
               est.uploaded_by_user_id AS uploaded_by_user_id,
               jcl.t_long_desc AS perf_job_title,
               allest.coverage_code AS coverage_code,
               est.estimate_id AS estimate_id,
               allest.est_type AS est_type,               
               CASE 
                    WHEN est_type='E' THEN est.est_sw_ttl_gross_total_amount
                    WHEN est_type='S' THEN est.est_sw_ttl_net_supplement_amou
               END AS est_or_supp_amt,               
               est.back_end_audit_score AS rbi_score,
               reip.cnt_reinsp as cnt_reinsp,       
               excp_nd.cnt_exnd as cnt_exnd,
               excp_nvd.cnt_exnvd as cnt_exnvd,
               excp_rp.cnt_exrp as cnt_exrp
            FROM data.all_estimates allest INNER JOIN source.ewv_or_all_estimates est
            ON allest.d70_pt_loss_yr = est.d70_pt_loss_yr
            AND allest.d70_pt_clm_line_cd = est.d70_pt_clm_line_cd
            AND allest.d70_pt_loss_st_cd = est.d70_pt_loss_st_cd
            AND allest.d70_adw_claim_id = est.d70_adw_claim_id
            AND allest.estimate_id = est.estimate_id
            AND allest.upload_package_received_date = est.upload_package_received_date    
            INNER JOIN source.ewv_user_pc upc ON est.uploaded_by_user_id = upc.xc_user_id 
            INNER JOIN (SELECT n_org_enty_id1 AS n_org_enty_id, n_org_enty_id2 AS mco_id
                    FROM source.ewt_org_entity_relshp_ng oer
/*                    WHERE n_org_enty_id2 = '8E1ED38343FB45A2'    */
/*										--Put org id over here*/
                    where c_rpt_office_ind = 'Y'
                    AND e69_c_adw_rcd_del  = 'N'                    
                    AND c_rcd_del = 'N'                    
                    ) adj_mco
                    ON upc.n_org_enty_id = adj_mco.n_org_enty_id
            INNER JOIN source.ewt_org_entity_ng oe
             ON upc.n_org_enty_id = oe.n_org_enty_id
             AND datepart(oe.d_org_deactive) EQ '01JAN1800'D
             AND oe.c_rcd_del = 'N'
            AND datepart(oe.e68_d_end_atomic_ts) GT '31DEC2100'D                      
            INNER JOIN source.ewv_job_code_lkup jcl on oe.c_job_code = jcl.c_code
            LEFT OUTER JOIN 
                    (   SELECT 
                            reip.d72_pt_loss_yr, reip.d72_pt_clm_line_cd, reip.d72_pt_loss_st_cd, 
                            reip.d72_adw_claim_id, reip.estimate_id, reip.xc_rein_type_cd,
                            COUNT(reip.estimate_id) as cnt_reinsp
                        FROM source.ewv_or_reinspection_ng reip
                        WHERE reip.xc_rein_type_cd=2
                        GROUP BY reip.d72_pt_loss_yr, reip.d72_pt_clm_line_cd, reip.d72_pt_loss_st_cd, 
                        reip.d72_adw_claim_id, reip.estimate_id, reip.xc_rein_type_cd
                    ) reip
                    ON est.d70_pt_loss_yr = reip.d72_pt_loss_yr
                    AND est.d70_pt_clm_line_cd = reip.d72_pt_clm_line_cd
                    AND est.d70_pt_loss_st_cd = reip.d72_pt_loss_st_cd
                    AND est.d70_adw_claim_id = reip.d72_adw_claim_id
                    AND est.estimate_id = reip.estimate_id
            
            LEFT OUTER JOIN 
                    (
                        select  
                        exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, exnd.d76_adw_claim_id, reip.estimate_id,
                        count(exnd.reinspection_id) as cnt_exnd
                        from source.ewv_or_reinspection_ng reip inner join source.ewv_or_reinspect_excpt exnd
                        on reip.reinspection_id = exnd.reinspection_id
                        and reip.xc_rein_type_cd=2
                        where  exnd.reinspection_excptn_subtype_id = 215                
                        group by exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, exnd.d76_adw_claim_id, reip.estimate_id 
                    ) excp_nd
                    ON est.d70_pt_loss_yr = excp_nd.d76_pt_loss_yr
                    AND est.d70_pt_clm_line_cd = excp_nd.d76_pt_clm_line_cd
                    AND est.d70_pt_loss_st_cd = excp_nd.d76_pt_loss_st_cd
                    AND est.d70_adw_claim_id = excp_nd.d76_adw_claim_id
                    AND est.estimate_id = excp_nd.estimate_id            
            
            LEFT OUTER JOIN 
                    (
                        select  
                        exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, exnd.d76_adw_claim_id, reip.estimate_id,
                        count(exnd.reinspection_id) as cnt_exnvd
                        from source.ewv_or_reinspection_ng reip inner join source.ewv_or_reinspect_excpt exnd
                        on reip.reinspection_id = exnd.reinspection_id
                        and reip.xc_rein_type_cd=2
                        where  exnd.reinspection_excptn_subtype_id = 216                
                        group by exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, exnd.d76_adw_claim_id, reip.estimate_id 
                    ) excp_nvd
                    ON est.d70_pt_loss_yr = excp_nvd.d76_pt_loss_yr
                    AND est.d70_pt_clm_line_cd = excp_nvd.d76_pt_clm_line_cd
                    AND est.d70_pt_loss_st_cd = excp_nvd.d76_pt_loss_st_cd
                    AND est.d70_adw_claim_id = excp_nvd.d76_adw_claim_id
                    AND est.estimate_id = excp_nvd.estimate_id
            
            LEFT OUTER JOIN 
                    (
                        select  
                        exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, exnd.d76_adw_claim_id, reip.estimate_id,
                        count(exnd.reinspection_id) as cnt_exrp
                        from source.ewv_or_reinspection_ng reip inner join source.ewv_or_reinspect_excpt exnd
                        on reip.reinspection_id = exnd.reinspection_id
                        and reip.xc_rein_type_cd=2
                        where  exnd.reinspection_excptn_subtype_id = 229                
                        group by exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, exnd.d76_adw_claim_id, reip.estimate_id 
                    ) excp_rp
                    ON est.d70_pt_loss_yr = excp_rp.d76_pt_loss_yr
                    AND est.d70_pt_clm_line_cd = excp_rp.d76_pt_clm_line_cd
                    AND est.d70_pt_loss_st_cd = excp_rp.d76_pt_loss_st_cd
                    AND est.d70_adw_claim_id = excp_rp.d76_adw_claim_id
                    AND est.estimate_id = excp_rp.estimate_id ;
					


quit;

/*Data set Est_1*/
proc sql;
create table data.est_1 as
SELECT
            est.mco_id AS mco_id,  
            est.adjuster_wrote_est AS adjuster_wrote_est,
            est.adjuster_alpha_id AS adjuster_alpha_id,
            est.uploaded_by_user_id AS uploaded_by_user_id,
            est.perf_job_title AS perf_job_title,
            COUNT (est.est_type) AS total_est_count,        
            SUM (CASE WHEN ((est.est_type = 'E') AND (est.coverage_code = 'HH')) THEN 1 ELSE 0 END) AS total_cmp_est_cnt,
            SUM (est.est_or_supp_amt) AS total_est_or_supp_amt,
            SUM (CASE WHEN est.est_type = 'S' THEN 1 ELSE 0 END) AS total_supp,
            SUM (CASE WHEN est.est_type = 'S' THEN est.est_or_supp_amt ELSE 0 END) AS total_supp_amt,
            SUM (CASE WHEN est.rbi_score IS NULL THEN 0 ELSE 1 END) AS total_nbr_rbi_score,
            SUM (CASE WHEN est.rbi_score IS NULL THEN 0 ELSE est.rbi_score END) AS total_rbi_score,
            SUM(est.cnt_reinsp)  AS rei_count,       
            SUM(est.cnt_exnd) AS cnt_nd_rei_exceptions,
            SUM(est.cnt_exnvd) AS cnt_nvd_rei_exceptions,
            SUM(est.cnt_exrp) AS cnt_rp_rei_exceptions
    FROM data.est
    Group by est.mco_id, est.adjuster_wrote_est, est.adjuster_alpha_id, est.uploaded_by_user_id, est.perf_job_title;
quit;

proc sql;
create table data.est_2 as
SELECT
       mco_id AS mco_id, 
       adjuster_wrote_est AS adjuster,
       adjuster_alpha_id AS adjuster_alpha_id,
       perf_job_title AS perf_job_title,
       total_est_count AS nbr_of_est_and_supp_written,
       total_cmp_est_cnt AS nbr_of_comp_est,
       case WHEN total_cmp_est_cnt <> 0 THEN ((total_cmp_est_cnt/total_est_count) * 100) ELSE 0 END AS pct_cmp_est,
       CASE WHEN total_est_count <> 0 THEN (total_est_or_supp_amt / total_est_count) ELSE 0 END AS average_estimate,
       total_supp AS number_of_supplements,
       CASE WHEN total_supp <> 0 THEN (total_supp_amt / total_supp) ELSE 0 END AS average_supplement,
       CASE WHEN total_est_count <> 0 THEN (total_supp / total_est_count) ELSE 0 END AS supplement_frequency,
       CASE WHEN total_nbr_rbi_score <> 0 THEN (total_rbi_score / total_nbr_rbi_score) ELSE 0 END AS average_rbi_score,
       CASE WHEN rei_count IS NOT NULL THEN rei_count ELSE 0 END AS rei_count,
       CASE WHEN total_est_count <> 0 THEN (rei_count / total_est_count) ELSE 0 END AS oversight_rei_percentage,
       CASE WHEN (cnt_nd_rei_exceptions + cnt_nvd_rei_exceptions) IS NOT NULL THEN (cnt_nd_rei_exceptions + cnt_nvd_rei_exceptions) 
       ELSE 0 END AS nbr_nd_or_nvd_rei_excep,
       CASE WHEN cnt_rp_rei_exceptions IS NOT NULL THEN cnt_rp_rei_exceptions ELSE 0 END AS nbr_recycled_parts_rei_excep
FROM data.est_1;
quit;

proc sql;
create table data.dsm_adjuster_rbi as
select distinct
       adjuster AS adjuster,
       adjuster_alpha_id AS m_alpha_id,
       perf_job_title AS perf_job_title,
       nbr_of_est_and_supp_written AS nbr_of_est_and_supp_written,
       nbr_of_comp_est AS nbr_of_comp_est,
       pct_cmp_est AS pct_cmp_est,
       average_estimate AS average_estimate,
       number_of_supplements AS number_of_supplements,
       average_supplement AS average_supplement,
       supplement_frequency AS supplement_frequency,
       average_rbi_score AS average_rbi_score,
       rei_count AS rei_count,
       CASE WHEN oversight_rei_percentage IS NOT NULL THEN oversight_rei_percentage ELSE 0 END AS oversight_rei_percentage,
       nbr_nd_or_nvd_rei_excep AS nbr_nd_or_nvd_rei_excep,
       nbr_recycled_parts_rei_excep AS nbr_recycled_parts_rei_excep
FROM data.est_2;
quit;

/*TO MERGE*/
proc sort data=data.dsm_adjuster_rbi nodupkey;
	by m_alpha_id descending average_rbi_score;
run;
proc sort data=data.dsm_adjuster_rbi nodupkey;
	by m_alpha_id;
run;

data data.dsm_adjuster_rbi (drop = m_alpha_id rename = (m_alpha_id_1 = m_alpha_id));
	length m_alpha_id_1 $4;
	set data.dsm_adjuster_rbi;
	informat m_alpha_id_1 $4.;
	format m_alpha_id_1 $4.;
	m_alpha_id_1 = m_alpha_id;
run;

proc sort data=data.dsm_base_pymnts;
	by m_alpha_id;
run;

data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) data.dsm_adjuster_rbi (in=b);
	by m_alpha_id;
	if a;
run;

/* ESTIMATES*/
**********************************************************************************************
* ESTIMATES -- MOI_ID, FLAG_SPPLMNT_GT_3
*********************************************************************************************;
proc sql;
create table data.dsm_est_pymnt_1 AS 
select inv.e44_n_pt_loss_yr,
            inv.e44_c_pt_loss_st_cd,
            inv.e44_c_pt_clm_line_cd,
            inv.e44_n_adw_claim_id,
            inv.n_ins_invl_id,
            inv.m_leg_inv_id,
            cpr.n_item_invl_id
       from source.ewt_ins_involvement_ng inv,
            source.ewt_involvement_role_ng invr,
            source.ewt_claimant_role_ng cr,
            source.claim_party_role cpr
      where cr.n_claimant_role_id = invr.n_invl_role_id
        and cr.e39_n_pt_loss_yr = inv.e44_n_pt_loss_yr
        and cr.e39_c_pt_loss_st_cd = inv.e44_c_pt_loss_st_cd
        and cr.e39_c_pt_clm_line_cd = inv.e44_c_pt_clm_line_cd
        and cr.e39_n_adw_claim_id = inv.e44_n_adw_claim_id
        and invr.n_ins_invl_id = inv.n_ins_invl_id
        and invr.e43_n_pt_loss_yr = inv.e44_n_pt_loss_yr
        and invr.e43_c_pt_loss_st_cd = inv.e44_c_pt_loss_st_cd
        and invr.e43_c_pt_clm_line_cd = inv.e44_c_pt_clm_line_cd
        and invr.e43_n_adw_claim_id = inv.e44_n_adw_claim_id
        and invr.n_invl_role_id = cpr.n_invl_role_id
        and invr.e43_n_pt_loss_yr = cpr.r05_n_pt_loss_yr
        and invr.e43_c_pt_loss_st_cd = cpr.r05_c_pt_loss_st_cd
        and invr.e43_c_pt_clm_line_cd = cpr.r05_c_pt_clm_line_cd
        and invr.e43_n_adw_claim_id = cpr.r05_n_adw_claim_id
        and cpr.r05_d_end_atomic_ts > '31-DEC-2100'd
/*      and inv.e44_n_adw_claim_id = 632400000108*/
        and cr.e39_c_adw_rcd_del = 'N'
        and inv.e44_c_adw_rcd_del = 'N'
        and invr.e43_c_adw_rcd_del = 'N'
        and cpr.r05_c_adw_rcd_del = 'N'
        and cpr.c_rcd_del = 'N'
        and invr.c_rcd_del = 'N'
        and inv.c_rcd_del = 'N'     
        and cr.c_rcd_del = 'N';
		
        quit;
 
proc sql;
create table data.dsm_est_pymnt_2 as
	SELECT d71_pt_loss_yr, 
		d71_pt_clm_line_cd, 
		d71_pt_loss_st_cd,
        d71_adw_claim_id, 
		e.estimate_id, 
		e.moi_id,
		e.VEHICLE_YEAR as N_MODEL_YEAR_NBR,
		e.VEHICLE_MAKE_DESCRIPTION as M_MAKE_NM,
		e.VEHICLE_MODEL as M_MODEL_NM,
		c.involved_party_id,
		upload_package_received_date as upr_date
    FROM data.dsm_base_claims base, 
		source.ewt_estimate_pc e, 
		source.ewt_claim_pc c, 
		source.ewt_upload_package_pc upc
    WHERE  is_final = 1
         AND base.e19_n_adw_claim_id = e.d71_adw_claim_id
         and c.claim_id = e.claim_id
         AND c.d70_adw_claim_id = e.d71_adw_claim_id
         AND c.d70_pt_clm_line_cd = e.d71_pt_clm_line_cd
         AND c.d70_pt_loss_st_cd = e.d71_pt_loss_st_cd
         AND c.d70_pt_loss_yr = e.d71_pt_loss_yr
         AND e.upload_package_guid = upc.upload_package_guid
         AND e.d71_adw_claim_id = upc.d75_adw_claim_id
         AND e.d71_pt_clm_line_cd = upc.d75_pt_clm_line_cd
         AND e.d71_pt_loss_st_cd = upc.d75_pt_loss_st_cd    
         AND e.d71_pt_loss_yr = upc.d75_pt_loss_yr
         and e.EST_SW_SUPPLEMENT_NUMBER = 'E01';
quit;

/*sort the data by upr_date*/
proc sort data = data.dsm_est_pymnt_2;
by estimate_id upr_date;
run;
/*to get the initial estimate*/
proc sort data=data.dsm_est_pymnt_2 nodupkey;
	by estimate_id;
run;

/*final code to get estimates joined to payments*/

proc sql;
create table data.dsm_est_pymnt_final as
	Select distinct 
		pd.e19_n_ADW_CLAIM_ID,
		pd.N_PYMNT_DTL_ID, 
		pd.N_PYMNT_ID, 
		temp2.estimate_id, 
		temp2.moi_id,
		temp2.N_MODEL_YEAR_NBR,
		temp2.M_MAKE_NM,
		temp2.M_MODEL_NM
	from 
		source.ewt_payment_dtl_ng pd,
		source.ewt_line_ng line, 
		source.ewt_damage_ng dmg,
		source.ewt_item_involvement_ng itinv,
		data.dsm_est_pymnt_1 temp1,
		data.dsm_est_pymnt_2 temp2
	where pd.E19_N_PT_LOSS_YR = line.E24_N_PT_LOSS_YR
		and pd.E19_C_PT_CLM_LINE_CD = line.E24_C_PT_CLM_LINE_CD
		and pd.E19_C_PT_LOSS_ST_CD = line.E24_C_PT_LOSS_ST_CD
		and pd.E19_n_ADW_CLAIM_ID = line.E24_N_ADW_CLAIM_ID
		and pd.n_line_id = line.n_line_id
		and line.E24_N_PT_LOSS_YR = D52_N_PT_LOSS_YR
		and line.E24_C_PT_CLM_LINE_CD = D52_C_PT_CLM_LINE_CD
		and line.E24_C_PT_LOSS_ST_CD = D52_C_PT_LOSS_ST_CD
		and line.e24_n_ADW_CLAIM_ID = D52_N_ADW_CLAIM_ID
		and line.N_DAMAGE_ID =  dmg.N_DAMAGE_ID
		and D52_N_PT_LOSS_YR = E33_N_PT_LOSS_YR
		and D52_C_PT_CLM_LINE_CD = E33_C_PT_CLM_LINE_CD
		and D52_C_PT_LOSS_ST_CD = E33_C_PT_LOSS_ST_CD
		and D52_N_ADW_CLAIM_ID = e33_n_ADW_CLAIM_ID
		and dmg.N_ITEM_INVL_ID = itinv.N_ITEM_INVL_ID
		and E33_N_PT_LOSS_YR = temp1.E44_N_PT_LOSS_YR
		and E33_C_PT_LOSS_ST_CD = temp1.E44_C_PT_LOSS_ST_CD
		and E33_C_PT_CLM_LINE_CD = temp1.E44_C_PT_CLM_LINE_CD
		and E33_N_ADW_CLAIM_ID = temp1.E44_N_ADW_CLAIM_ID
		and itinv.N_ITEM_INVL_ID = temp1.N_ITEM_INVL_ID
		and temp1.E44_N_PT_LOSS_YR  = temp2.d71_pt_loss_yr
		and temp1.E44_C_PT_LOSS_ST_CD = temp2.d71_pt_loss_st_cd
		and temp1.E44_C_PT_CLM_LINE_CD =  temp2.d71_pt_clm_line_cd
		and temp1.E44_N_ADW_CLAIM_ID = temp2.d71_adw_claim_id
		and temp1.m_leg_inv_id = temp2.involved_party_id 
		and pd.E19_C_ADW_RCD_DEL = 'N'
		and line.E24_C_ADW_RCD_DEL = 'N'
		and dmg.D52_C_ADW_RCD_DEL = 'N'
		and itinv.e33_C_ADW_RCD_DEL = 'N';
quit;
**********************************************************************************************
* To merge dsm_est_pymnt_final has--pd.e19_n_ADW_CLAIM_ID, pd.N_PYMNT_DTL_ID, pd.N_PYMNT_ID, 
* estimate_id, moi_id, d_issue_dt
*********************************************************************************************;
proc sort data = data.dsm_est_pymnt_final nodupkey;
	by n_pymnt_dtl_id;
run;
proc sort data = data.dsm_base_pymnts out=dsm_date (keep=n_pymnt_id d_issue_dt);
	by n_pymnt_id;
run;
proc sort data=data.dsm_est_pymnt_final;
	by n_pymnt_id;
run;
data data.dsm_est_pymnt_final;
	merge data.dsm_est_pymnt_final (in=a) dsm_date (in=b);
	by n_pymnt_id;
	if a;
run;

/*===================================================================================================
* CREATE A FLAG FOR A PAYMENT IF THE NUMBER OF SUPPLEMENTS IS GREATER THAN OR EQUAL TO 3 .. 
* WE ARE FLAGGING ALL THE PAYMENTS THAT ARE MADE AFTER THE PACKAGE UPLOAD DATE OF SUPPLEMENT NUMBER
* S03 FOR THE RESPECTIVE CLAIM
====================================================================================================*/
proc sql;
	create table data.nbr_of_supplements_dates_amnts as
	select 
		est.D71_PT_LOSS_YR,
		est.D71_PT_CLM_LINE_CD,
		est.D71_PT_LOSS_ST_CD,
		est.D71_ADW_CLAIM_ID,
		est.EST_SW_SUPPLEMENT_NUMBER,
		est.estimate_id,
		est.net_amount,
		pck.upload_package_received_date as supplement_date		
	from source.ewt_estimate_pc est, 
		 source.ewt_upload_package_pc pck
	where est.IS_FINAL = 1
		and est.upload_package_guid = pck.upload_package_guid
		and est.D71_PT_LOSS_YR = pck.D75_PT_LOSS_YR 
		and est.D71_PT_CLM_LINE_CD = pck.D75_PT_CLM_LINE_CD
		and est.D71_PT_LOSS_ST_CD = pck.D75_PT_LOSS_ST_CD
		and est.D71_ADW_CLAIM_ID = pck.D75_ADW_CLAIM_ID 
;
quit;

/*===================================================================================================
*  NUMBER OF SUPPLEMENTS IN AN ESTIMATE -- AT A CLAIM LEVEL
====================================================================================================*/
proc sort data= data.nbr_of_supplements_dates_amnts;
	by d71_adw_claim_id
		EST_SW_SUPPLEMENT_NUMBER;
run;

data supplement_number;
	set data.nbr_of_supplements_dates_amnts (keep = d71_adw_claim_id EST_SW_SUPPLEMENT_NUMBER);
	if est_sw_supplement_number ne 'E01';
run;

proc sort data = supplement_number;
	by d71_adw_claim_id
		descending EST_SW_SUPPLEMENT_NUMBER;
run;
proc sort data = supplement_number(rename= (d71_adw_claim_id= e19_n_adw_claim_id)) nodupkey;
	by e19_n_adw_claim_id;
run;
proc sort data= data.dsm_est_pymnt_final;
	by e19_n_adw_claim_id;
run;

data data.dsm_est_pymnt_final;
	merge data.dsm_est_pymnt_final (in=a) supplement_number (in=b);
	by e19_n_adw_claim_id;
	if a;
run;

/* to find the date of 3rd supplement*/
proc sql;
	create table dsm_nbr_of_supplements_dates_1 as
	select distinct * 
	from data.nbr_of_supplements_dates_amnts
	where EST_SW_SUPPLEMENT_NUMBER = 'S03';
quit;

proc sort data=dsm_nbr_of_supplements_dates_1 ;
	by d71_adw_claim_id
		supplement_date;
run;
proc sort data = dsm_nbr_of_supplements_dates_1 out = dsm_nbr_of_supplements_dates 
									(rename= (d71_adw_claim_id= e19_n_adw_claim_id
									supplement_date=supplmnt_03_date)
									drop = EST_SW_SUPPLEMENT_NUMBER d71_pt_loss_yr 
											d71_pt_clm_line_cd d71_pt_loss_st_cd) nodupkey;
	by d71_adw_claim_id;
run;

proc sort data=data.dsm_est_pymnt_final;
	by e19_n_adw_claim_id;
run;
data data.dsm_est_pymnt_final;
	merge data.dsm_est_pymnt_final (in=a) dsm_nbr_of_supplements_dates (in=b);
	by e19_n_adw_claim_id;
	if a;
run;

data data.dsm_est_pymnt_final;
	set data.dsm_est_pymnt_final;
	if EST_SW_SUPPLEMENT_NUMBER ge 'S03' and d_issue_dt ge supplmnt_03_date and supplmnt_03_date ne '' 
		then flag_supplmnt_gt_3 =1;
	else if EST_SW_SUPPLEMENT_NUMBER ge 'S03' and supplmnt_03_date = '' then flag_supplmnt_gt_3 = 1;
	else flag_supplmnt_gt_3 = 0;	
run;

/*merging moi_id, flag_supplmnt_gt_3 (v72), est_sw_supplement_number to dsm_base_pymnt_dtl*/
proc sort data =data.dsm_base_pymnt_dtl;
	by n_pymnt_dtl_id;
run;
proc sort data =data.dsm_est_pymnt_final(keep= n_pymnt_dtl_id 
										moi_id 
										N_MODEL_YEAR_NBR
										M_MAKE_NM
										M_MODEL_NM 
										est_sw_supplement_number 
										flag_supplmnt_gt_3)	nodupkey;
	by n_pymnt_dtl_id;
run;	
data data.dsm_basE_pymnt_dtl;
	merge data.dsm_base_pymnt_dtl (in=a) data.dsm_est_pymnt_final (in=b);
	by n_pymnt_dtl_id;
	if a;
run;

/*============================================================================
* ROLLING UP PAYMENT DETAIL LEVEL ATTRIBUTES TO PAYMENT LEVEL
=============================================================================*/
****************************************************
* METHOD OF SETTLEMENT
***************************************************;
data dsm_mos_1;
	set data.dsm_base_pymnt_dtl;
	if c_line_type ='NHH21' then flag=2;
	else if c_line_type ='NDD21' then flag=1;
	else flag=0;
run;
proc sort data=dsm_mos_1 out=dsm_mos(keep=n_pymnt_id c_method_stlmt_cd) nodupkey dupout=dups;
	by n_pymnt_id
		descending flag
		descending a_fin_tx_amt;
run;
proc sort data = dsm_mos nodupkey; /*to merge with dsm_base_pymnts*/
	by n_pymnt_id;
run;

**************************************************
* for coverage handling code at payment level
*************************************************;
data dsm_coverage_hndlng;
set data.dsm_base_pymnt_dtl;
run;
proc sort data = data.dsm_base_pymnt_dtl out=dsm_roll_up_amnt(keep = n_pymnt_id
						a_fin_tx_amt
						moi_id
						N_MODEL_YEAR_NBR
						M_MAKE_NM
						M_MODEL_NM 
						est_sw_supplement_number
						flag_supplmnt_gt_3
						c_cov_hndlng_cd 
						xc_mco_id
						c_line_type) nodupkey;
	by n_pymnt_id descending a_fin_tx_amt;
run;
proc sort data = dsm_roll_up_amnt(drop=a_fin_tx_amt) nodupkey; /*to merge with dsm_base_pymnts*/
	by n_pymnt_id;
run;

/*for PAC to get at payment level -- if any coverage is PAC, then entire payment is PAC*/
proc sort data = data.dsm_base_pymnt_dtl out=dsm_pac (keep = n_pymnt_id c_after_close_ind);
	by n_pymnt_id descending c_after_close_ind;
run;
proc sort data = dsm_pac nodupkey; /*to merge with dsm_base_pymnts*/
	by n_pymnt_id;
run;

/* merging all the above to dsm_base_pymnts*/
proc sort data =data.dsm_base_pymnts;
	by n_pymnt_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in = a drop=xc_mco_id) dsm_mos(in=b) dsm_roll_up_amnt(in=c) dsm_pac(in=d);
	by n_pymnt_id;
	if a;
run;

************************************************************************
* DSM_BASE_PYMNTS NOW HAVE ALL PAYMENT DETAIL LEVEL ATTRIBUTES
***********************************************************************;
*************************************************************************
* Number of payments after closure in a claim - CLAIM LEVEL ATTRIBUTE
************************************************************************;
proc sql;
	create table data.pymnt_aft_closure as select 
		E19_N_PT_LOSS_yr,
		E19_C_PT_CLM_LINE_CD,
		E19_C_PT_LOSS_ST_CD,
		E19_N_ADW_CLAIM_ID,
		count(*) as num_pymnt_aft_closure
	from data.dsm_base_pymnts
	where c_after_close_ind = 'Y'
	group by E19_N_PT_LOSS_yr,
			 E19_C_PT_CLM_LINE_CD,
			 E19_C_PT_LOSS_ST_CD,
			 E19_N_ADW_CLAIM_ID;
quit;

proc sort data = data.pymnt_aft_closure nodupkey;
	by 	E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
run;

/*============================================================================
* GETTING NUMBER OF SUPPLEMENTS GREATER THAN 1.5 TIMES INITIAL ESTIMATE
* AT A CLAIM LEVEL -- MERGED TO DSM_BASE_PYMNTS
=============================================================================*/
proc sql;
	create table nbr_spplmnt_dates_amnts as
	select * 
	from data.nbr_of_supplements_dates_amnts 
	where d71_adw_claim_id in 
						(select e19_n_adw_claim_id from data.dsm_base_claims)
;
quit;

data nbr_spplmnt_dates_amnts;
	set nbr_spplmnt_dates_amnts ( rename= (d71_adw_claim_id= e19_n_adw_claim_id
									d71_pt_loss_yr = e19_n_pt_loss_yr
									d71_pt_clm_line_cd = e19_c_pt_clm_line_cd
									d71_pt_loss_st_cd = e19_c_pt_loss_st_cd));
run;

proc sort data=nbr_spplmnt_dates_amnts;
	by E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID
		EST_SW_SUPPLEMENT_NUMBER
		supplement_date;
run;

data nbr_spplmnt_dates_amnts output_claim_level (drop=estimate_id supplement_date count amnt 
												net_amount EST_SW_SUPPLEMENT_NUMBER);
	set nbr_spplmnt_dates_amnts;
	output nbr_spplmnt_dates_amnts;
	by E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
	retain count amnt;
	if first.e19_n_adw_claim_id then amnt=net_amount;
	if first.e19_n_adw_claim_id then count=0;
	if net_amount ge 1.5*amnt and EST_SW_SUPPLEMENT_NUMBER ne 'E01' then count= count+1;
	if last.e19_n_adw_claim_id then flag_nbr_spplmt_gt_50pct_int_est = count;
	if last.e19_n_adw_claim_id then output output_claim_level;
run;

proc sort data=data.dsm_base_claims;
	by E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
run;
proc sort data=output_claim_level nodupkey;
	by E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
run;
/*merging payments after closure and nbr of supplements with amnt gt 1.5 initial estimate to dsm_base_claims*/
data data.dsm_base_claims;
	merge data.dsm_base_claims (in=a) output_claim_level (in=b) data.pymnt_aft_closure (in=c);
	by E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
	if a;
run;
/*============================================================================
* MERGING CLAIM LEVEL ATTRIBUTES TO DSM_BASE_PYMNTS
=============================================================================*/
proc sort data=data.dsm_base_claims nodupkey;
	by E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
run;
proc sort data=data.dsm_base_pymnts;
	by 	E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
run;
/*merge claim level attributes and create some flags*/
data data.dsm_base_pymnts (drop=payee_zip_clean employee_zip_clean);
	merge data.dsm_base_pymnts (in=a) data.dsm_base_claims (in=b);
	by E19_N_PT_LOSS_yr
		E19_C_PT_CLM_LINE_CD
		E19_C_PT_LOSS_ST_CD
		E19_N_ADW_CLAIM_ID;
	if a;
	if length(employee_zip)=3 then employee_zip_clean = cat("00",employee_ZIP);
	else if length(employee_zip)=4 then employee_zip_clean = cat("0",employee_ZIP);
	else if length(employee_zip)=5 then employee_zip_clean = employee_zip;
	else if length(employee_zip)=7 then employee_zip_clean = substr(cat("00",employee_ZIP),1,5);
	else if length(employee_zip)=8 then employee_zip_clean = substr(cat("0",employee_ZIP),1,5);
	else if length(employee_zip)=9 then employee_zip_clean = substr(employee_ZIP,1,5);
	employee_zip_final = input(employee_zip_clean,5.);

	if length(payee_zip) lt 3 then payee_zip_clean = "00000";
	else if length(payee_zip)=3 then payee_zip_clean = "00"||compress(payee_ZIP);
	else if length(payee_zip)=4 then payee_zip_clean = "0"||compress(payee_ZIP);
	else if length(payee_zip)=5 then payee_zip_clean = payee_zip;
	else if length(payee_zip)=6 then payee_zip_clean = substr(compress(payee_ZIP),1,5);
	else if length(payee_zip)=7 then payee_zip_clean = "00000";
	else if length(payee_zip)=8 then payee_zip_clean = "00000";
	else if length(payee_zip)=9 then payee_zip_clean = substr(compress(payee_ZIP),1,5);
	else if length(payee_zip)=10 then payee_zip_clean = substr(compress(payee_ZIP),1,5);
	payee_zip_final = input(payee_zip_clean,5.);
run;

/*============================================================================================
* MERGING WITH SASHELP.ZIPCODE TO GET THE CORRESPONDING LATITUDE AND LONGITUDE FOR ZIP CODES
=============================================================================================*/
proc sql;
	create table employee_lat as
	select a.*,
	b.y as employee_lat,
		b.x as employee_long
	from data.dsm_base_pymnts as a left join
		sashelp.zipcode as b on a.employee_zip_final = b.zip
	;
	create table payee_lat as
	select a.*,
	b.y as payee_lat,
		b.x as payee_long
	from employee_lat as a left join
		sashelp.zipcode as b on a.payee_zip_final = b.zip
	;
quit;
data data.dsm_base_pymnts;
	set payee_lat;
	employee_lat_rad = atan(1)/45 * employee_lat;
    employee_long_rad = atan(1)/45 * employee_long;
	payee_lat_rad = atan(1)/45 * payee_lat;
	payee_long_rad = atan(1)/45 * payee_long;
	Dist_payee_emp = abs (round(3949.99 * arcos( sin( employee_lat_rad ) * sin( payee_lat_rad ) +
                 cos( employee_lat_rad ) * cos( payee_lat_rad ) *
                 cos( employee_long_rad - payee_long_rad ) )) );
	/*bucketing levels of method of settlement and coverage handling code*/
	if C_METHOD_STLMT_CD = 'ADR' then b_C_METHOD_STLMT_CD = 'Legal' ;
	else if C_METHOD_STLMT_CD = 'ARB' then b_C_METHOD_STLMT_CD = 'Legal' ;
	else if C_METHOD_STLMT_CD = 'BAM' then b_C_METHOD_STLMT_CD = 'Legal' ;
	else if C_METHOD_STLMT_CD = 'MAA' then b_C_METHOD_STLMT_CD = 'Legal' ;
	else if C_METHOD_STLMT_CD = 'NBAM' then b_C_METHOD_STLMT_CD = 'Legal' ;
	else if C_METHOD_STLMT_CD = 'NBAMA' then b_C_METHOD_STLMT_CD = 'Legal' ;
	else if C_METHOD_STLMT_CD = 'VPAT' then b_C_METHOD_STLMT_CD = 'Legal' ;
	else if C_METHOD_STLMT_CD = 'DRI' then b_C_METHOD_STLMT_CD = 'Drive In' ;
	else if C_METHOD_STLMT_CD = 'SDI' then b_C_METHOD_STLMT_CD = 'Drive In' ;
	else if C_METHOD_STLMT_CD = 'LG' then b_C_METHOD_STLMT_CD = 'Glass' ;
	else if C_METHOD_STLMT_CD = 'PRO' then b_C_METHOD_STLMT_CD = 'DRP' ;
	else if C_METHOD_STLMT_CD = 'STG' then b_C_METHOD_STLMT_CD = 'DRP' ;
	else if C_METHOD_STLMT_CD = 'RENT' then b_C_METHOD_STLMT_CD = 'Rental' ;
	else if C_METHOD_STLMT_CD = 'BSR' then b_C_METHOD_STLMT_CD = 'Inside Handling' ;
	else if C_METHOD_STLMT_CD = 'PPR' then b_C_METHOD_STLMT_CD = 'Inside Handling' ;
	else if C_METHOD_STLMT_CD = 'WAIV' then b_C_METHOD_STLMT_CD = 'Inside Handling' ;
	else if C_METHOD_STLMT_CD = 'FT' then b_C_METHOD_STLMT_CD = 'Inside Handling' ;
	else if C_METHOD_STLMT_CD = 'NAPI' then b_C_METHOD_STLMT_CD = 'Inside Handling' ;
	else if C_METHOD_STLMT_CD = 'NAPNI' then b_C_METHOD_STLMT_CD = 'Inside Handling' ;
	else if C_METHOD_STLMT_CD = 'NSD' then b_C_METHOD_STLMT_CD = 'Inside Handling' ;
	else if C_METHOD_STLMT_CD = 'INHA' then b_C_METHOD_STLMT_CD = 'Inside Handling' ;
	else if C_METHOD_STLMT_CD = 'ES' then b_C_METHOD_STLMT_CD = 'Vendor' ;
	else if C_METHOD_STLMT_CD = 'MITI' then b_C_METHOD_STLMT_CD = 'Vendor' ;
	else if C_METHOD_STLMT_CD = 'QVPD' then b_C_METHOD_STLMT_CD = 'Vendor' ;
	else if C_METHOD_STLMT_CD = 'NCND' then b_C_METHOD_STLMT_CD = 'Vendor' ;
	else if C_METHOD_STLMT_CD = 'LTIG' then b_C_METHOD_STLMT_CD = 'LTIG' ;
	else if C_METHOD_STLMT_CD = 'FC' then b_C_METHOD_STLMT_CD = 'Express' ;
	else if C_METHOD_STLMT_CD = 'FLD' then b_C_METHOD_STLMT_CD = 'Field' ;
	else if C_METHOD_STLMT_CD = 'FNS' then b_C_METHOD_STLMT_CD = 'Field' ;
	else if C_METHOD_STLMT_CD = 'FSOS' then b_C_METHOD_STLMT_CD = 'Field' ;
	else if C_METHOD_STLMT_CD = 'FSTN' then b_C_METHOD_STLMT_CD = 'Field' ;
	else if C_METHOD_STLMT_CD = 'OH' then b_C_METHOD_STLMT_CD = 'Field' ;
	else if C_METHOD_STLMT_CD = 'TL' then b_C_METHOD_STLMT_CD = 'Field' ;
	else if C_METHOD_STLMT_CD = 'SUP' then b_C_METHOD_STLMT_CD = 'Field' ;
	else if C_METHOD_STLMT_CD = 'TREB' then b_C_METHOD_STLMT_CD = 'Tech Review' ;
	else if C_METHOD_STLMT_CD = 'TRIA' then b_C_METHOD_STLMT_CD = 'Tech Review' ;
	else if C_METHOD_STLMT_CD = 'TRNAE' then b_C_METHOD_STLMT_CD = 'Tech Review' ;
	else if C_METHOD_STLMT_CD = 'TRS' then b_C_METHOD_STLMT_CD = 'Tech Review' ;
	else if C_METHOD_STLMT_CD = 'TRSD' then b_C_METHOD_STLMT_CD = 'Tech Review' ;
	else if C_METHOD_STLMT_CD = 'TRSDI' then b_C_METHOD_STLMT_CD = 'Tech Review' ;
	else if C_METHOD_STLMT_CD = 'TTRR' then b_C_METHOD_STLMT_CD = 'Total Theft' ;
	else if C_METHOD_STLMT_CD = 'TTRTL' then b_C_METHOD_STLMT_CD = 'Total Theft' ;
	else if C_METHOD_STLMT_CD = 'TTUR' then b_C_METHOD_STLMT_CD = 'Total Theft' ;
	else if C_METHOD_STLMT_CD = 'RE' then b_C_METHOD_STLMT_CD = 'Expense' ;
	else if C_METHOD_STLMT_CD = 'SE' then b_C_METHOD_STLMT_CD = 'Expense' ;
	else if C_METHOD_STLMT_CD = 'SS' then b_C_METHOD_STLMT_CD = 'Expense' ;
	else if C_METHOD_STLMT_CD = 'AO' then b_C_METHOD_STLMT_CD = 'Advance' ;
	else if C_METHOD_STLMT_CD = 'APIA' then b_C_METHOD_STLMT_CD = 'Advance' ;
	else if C_METHOD_STLMT_CD = 'INDE' then b_C_METHOD_STLMT_CD = 'Independent' ;
	else if C_METHOD_STLMT_CD = 'NR' then b_C_METHOD_STLMT_CD = 'Non-Referral' ;

	if C_COV_HNDLNG_CD = 'A1' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'A2' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'A3' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'A4' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'A5' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'A6' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'A7' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'A8' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'AB' then b_C_COV_HNDLNG_CD = 'Arbitration' ;
	else if C_COV_HNDLNG_CD = 'C1' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'C2' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'C3' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'C4' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'IC' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'ID' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'IE' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'IF' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'U1' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'U2' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'U3' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'U4' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'UL' then b_C_COV_HNDLNG_CD = 'BI' ;
	else if C_COV_HNDLNG_CD = 'L1' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'L2' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'L3' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'L4' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'L5' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'L6' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'L7' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'L8' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'LG' then b_C_COV_HNDLNG_CD = 'Litigation' ;
	else if C_COV_HNDLNG_CD = 'OAC' then b_C_COV_HNDLNG_CD = 'Property' ;
	else if C_COV_HNDLNG_CD = 'OAS' then b_C_COV_HNDLNG_CD = 'Property' ;
	else if C_COV_HNDLNG_CD = 'MC' then b_C_COV_HNDLNG_CD = 'Property' ;
	else if C_COV_HNDLNG_CD = 'WNDEX' then b_C_COV_HNDLNG_CD = 'Property' ;
	else if C_COV_HNDLNG_CD = 'CI' then b_C_COV_HNDLNG_CD = 'PIP/Med Pay' ;
	else if C_COV_HNDLNG_CD = 'CM' then b_C_COV_HNDLNG_CD = 'PIP/Med Pay' ;
	else if C_COV_HNDLNG_CD = 'RP' then b_C_COV_HNDLNG_CD = 'PIP/Med Pay' ;
	else if C_COV_HNDLNG_CD = 'PM' then b_C_COV_HNDLNG_CD = 'PIP/Med Pay' ;
	else if C_COV_HNDLNG_CD = 'CCX' then b_C_COV_HNDLNG_CD = 'Coor' ;
	else if C_COV_HNDLNG_CD = 'CSD' then b_C_COV_HNDLNG_CD = 'Coor' ;
	else if C_COV_HNDLNG_CD = 'CC' then b_C_COV_HNDLNG_CD = 'Auto' ;
	else if C_COV_HNDLNG_CD = 'CL' then b_C_COV_HNDLNG_CD = 'Auto' ;
	else if C_COV_HNDLNG_CD = 'CP' then b_C_COV_HNDLNG_CD = 'Auto' ;
	else if C_COV_HNDLNG_CD = 'RR' then b_C_COV_HNDLNG_CD = 'Auto' ;
	else if C_COV_HNDLNG_CD = 'CPA' then b_C_COV_HNDLNG_CD = 'Auto' ;
	else if C_COV_HNDLNG_CD = 'ESI' then b_C_COV_HNDLNG_CD = 'Auto' ;
	else if C_COV_HNDLNG_CD = 'EXC' then b_C_COV_HNDLNG_CD = 'Auto' ;
	else if C_COV_HNDLNG_CD = 'FCS' then b_C_COV_HNDLNG_CD = 'Auto' ;
	else if C_COV_HNDLNG_CD = 'INV' then b_C_COV_HNDLNG_CD = 'Auto' ;

	/* Creating dummys for method of settlement, payment method and moi id*/
	if C_METHOD_STLMT_CD = 'DRI' then f_v13_DRI = 1;
	else f_v13_DRI = 0; /*for interaction*/
	if b_C_METHOD_STLMT_CD = 'Expense' then f_v134_Expen = 1;
	else f_v134_Expen = 0;
	if b_C_METHOD_STLMT_CD = 'Field' then f_v134_Field = 1;
	else f_v134_Field = 0;

	if moi_id = 1 then f_v81_1 = 1;
	else f_v81_1 = 0;

	if c_pymnt_meth = 'FCP' then f_v9_FCP = 1;
	else f_v9_FCP = 0;
	if c_pymnt_meth = 'MANI' then f_v9_MANI = 1;
	else f_v9_MANI = 0;
	/*flags for payee zip eq employee zip and the log of distance */
	if employee_zip_final = payee_zip_final then flag_emp_zip_eq_payee = 1;
	else flag_emp_zip_eq_payee =0;
	if dist_payee_emp = 0 then log_dist_payee_emp = 0;
	else if dist_payee_emp = . then log_dist_payee_emp = .;
	else log_dist_payee_emp = log(dist_payee_emp);

	/*number of payments after closure -- bucket*/
	if num_pymnt_aft_closure = . then num_pymnt_aft_closure = 0;
	if num_pymnt_aft_closure lt 4 then b_num_pymnt_aft_closure = "< 4";
	else b_num_pymnt_aft_closure = ">= 4";

	/*flag for company code = 063*/
	if company_code = "063" then f_v94_063=1;
	else f_v94_063 = 0;

	emp_name_clean = catx(" ",emp_first_nm, emp_last_nm);
	mail_to_nm_clean = trim(left(upcase(mail_to_nm)));

	/*outlier treatment for a_fin_ent_amt*/
	if a_fin_ent_amt = . then v6_new = 0;
	else if a_fin_ent_amt gt 7000 then v6_new = 7000;
	else v6_new = a_fin_ent_amt;
run;	

/*============================================================================================
* TO GET NEW_NUM_PYMNTS_CLM (PULL DATA AGAIN FROM ADW TABLE)
=============================================================================================*/
proc sql;
	create table data.num_pymnts as
	select base.e19_n_adw_claim_id, 
			count (distinct dtl.n_pymnt_id) as num_pymnts_clm
	from source.ewt_payment_dtl_ng dtl,
		data.dsm_base_claims base
	where dtl.e19_n_adw_claim_id = base.e19_n_adw_claim_id
		and dtl.e19_c_adw_rcd_del = 'N'
	group by base.e19_n_adw_claim_id;
quit;
proc sort data = data.dsm_base_pymnts;
	by e19_n_adw_claim_id;
run;
proc sort data = data.num_pymnts;
	by e19_n_adw_claim_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) data.num_pymnts(in=b);
	by e19_n_adw_claim_id;
	if a;
	if num_pymnts_clm = 1 then flag_one_pay = 1;
	else flag_one_pay = 0;
	/*outlier analysis for num_pymnts_clm*/
	if num_pymnts_clm gt 80 then do; 
		new_num_pymnts_clm = 80; 
		flag_cap_num_pymnts_clm = 1;
	end;
	else do;
		new_num_pymnts_clm = num_pymnts_clm;
		flag_cap_num_pymnts_clm = 0;
	end;
run;

/*============================================================================================
* TO GET rel_pymnt_payee_offc
=============================================================================================*/
data temp_address;
	set data.dsm_base_pymnts;
	emp_name_clean = catx(" ",emp_first_nm, emp_last_nm);
	mail_to_nm_clean = trim(left(upcase(mail_to_nm)));
	payee_full_address = compress(upcase(payee_street))||compress(upcase(payee_zip))||
							compress(upcase(payee_city))||compress(upcase(payee_state));
run;
proc sort data = temp_address;
	by mail_to_nm_clean payee_full_address n_user_id D_issue_DT;
run;
data temp_address(keep = n_pymnt_id num_pymnt_rep_payee);
	set temp_address;
		by mail_to_nm_clean payee_full_address n_user_id;
		where mail_to_nm_clean ne '' and n_user_id ne '' and payee_full_address ne '';
		retain num_pymnt_rep_payee;
		if first.n_user_id then num_pymnt_rep_payee = 1;
		else num_pymnt_rep_payee = num_pymnt_rep_payee + 1;
run;
proc sort data = data.dsm_base_pymnts;
	by n_pymnt_id;
run;
proc sort data = temp_address;
	by n_pymnt_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts(in=a) temp_address(in=b);
	by n_pymnt_id;
	if a;
run;
/* dsm_base_pymtns now have num_pymnt_rep_payee now */

proc sql;
	create table offc_avg as
	select xc_mco_id, mean(num_pymnt_rep_payee) as mean_offc_nomiss
	from data.dsm_base_pymnts
	where flag_missing_mco = 0
	group by xc_mco_id
	;
	create table offc_avg_miss as
	select xc_mco_id, mean(num_pymnt_rep_payee) as mean_offc_miss
	from data.dsm_base_pymnts
	where flag_missing_mco = 1
	group by xc_mco_id;
quit;
proc sort data = data.dsm_base_pymnts;
	by xc_mco_id;
run;
data data.dsm_base_pymnts (drop = mean_offc_nomiss mean_offc_miss);
	merge data.dsm_base_pymnts(in = a) offc_avg(in=b) offc_avg_miss (in=c);
	by xc_mco_id;
	if a;
	if flag_missing_mco = 0 then rel_pymnt_payee_offc = num_pymnt_rep_payee/mean_offc_nomiss;	
	else rel_pymnt_payee_offc = num_pymnt_rep_payee/mean_offc_miss;
	if mean_offc_nomiss = 0 then rel_pymnt_payee_offc = 0;
	if mean_offc_nomiss = 0 then rel_pymnt_payee_offc = 0;
	if mean_offc_nomiss = . then rel_pymnt_payee_offc = 0;
	if mean_offc_nomiss = . then rel_pymnt_payee_offc = 0;
run;

/*============================================================================================
* TO GET rel_pymnt_payee_offc
=============================================================================================*/
proc sql;
	create table data.num_pymnt_clm_rep_in_clm as select 
		E19_N_PT_LOSS_yr,
		E19_C_PT_CLM_LINE_CD,
		E19_C_PT_LOSS_ST_CD,
		E19_N_ADW_CLAIM_ID,
		n_user_id,
		sum(a_fin_ent_amt) as dollar_pymnt_clm_rep_in_clm
	from data.dsm_base_pymnts
	group by E19_N_PT_LOSS_yr,
		 E19_C_PT_CLM_LINE_CD,
		 E19_C_PT_LOSS_ST_CD,
		 E19_N_ADW_CLAIM_ID,
		 n_user_id;
	create table data.num_pymnt_in_clm as select 
		E19_N_PT_LOSS_yr,
		E19_C_PT_CLM_LINE_CD,
		E19_C_PT_LOSS_ST_CD,
		E19_N_ADW_CLAIM_ID,
		sum(a_fin_ent_amt) as dollar_pymnt_in_clm
	from data.dsm_base_pymnts
	group by E19_N_PT_LOSS_yr,
		 E19_C_PT_CLM_LINE_CD,
		 E19_C_PT_LOSS_ST_CD,
		 E19_N_ADW_CLAIM_ID;
quit;
proc sort data = data.dsm_base_pymnts;
	by 	E19_N_PT_LOSS_yr E19_C_PT_CLM_LINE_CD E19_C_PT_LOSS_ST_CD E19_N_ADW_CLAIM_ID;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts(in=b) data.num_pymnt_in_clm(in =a) ;
	by E19_N_PT_LOSS_yr E19_C_PT_CLM_LINE_CD E19_C_PT_LOSS_ST_CD E19_N_ADW_CLAIM_ID;
	if b;
run;
proc sort data = data.dsm_base_pymnts;
	by 	E19_N_PT_LOSS_yr E19_C_PT_CLM_LINE_CD E19_C_PT_LOSS_ST_CD E19_N_ADW_CLAIM_ID n_user_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts(in=b) data.num_pymnt_clm_rep_in_clm(in =a);
	by E19_N_PT_LOSS_yr E19_C_PT_CLM_LINE_CD E19_C_PT_LOSS_ST_CD E19_N_ADW_CLAIM_ID n_user_id;
	if b;
	if dollar_pymnt_in_clm = 0 then per_dollar_pymnt_clm_rep = 0;
	else per_dollar_pymnt_clm_rep = dollar_pymnt_clm_rep_in_clm / dollar_pymnt_in_clm;
run;
proc sql;
	create table dsm_base_pymnts_merge_nomiss as
	select xc_mco_id, 
		mean(per_dollar_pymnt_clm_rep) as avg_per_dolar_pymnt_rep_nomiss
	from data.dsm_base_pymnts
	where flag_missing_mco = 0
	group by xc_mco_id;
	create table dsm_base_pymnts_merge_miss as
	select xc_mco_id, 
		mean(per_dollar_pymnt_clm_rep) as avg_per_dollar_pymnt_rep_miss
	from data.dsm_base_pymnts
	where flag_missing_mco = 1
	group by xc_mco_id;
quit;
proc sort data=data.dsm_base_pymnts;
	by xc_mco_id;
run;
data data.dsm_base_pymnts (drop = avg_per_dolar_pymnt_rep_nomiss avg_per_dollar_pymnt_rep_miss);
	merge data.dsm_base_pymnts (in=a) dsm_base_pymnts_merge_nomiss (in=b) dsm_base_pymnts_merge_miss (in=c);
	by xc_mco_id;
	if a;
	if flag_missing_mco = 0 then avg_per_dollar_pymnt_clm_rep = avg_per_dolar_pymnt_rep_nomiss;	
	else avg_per_dollar_pymnt_clm_rep = avg_per_dollar_pymnt_rep_miss;
run;

/*============================================================================================
* TO GET v125 -- log_avg_rel_last_pay
=============================================================================================*/
proc sql;
	create table num_pymnt as
	select distinct 
				E19_C_PT_CLM_LINE_CD,
				c_line_type,
				xc_mco_id,
				n_user_id,
				count(distinct n_pymnt_id) as num_pymnt_alpha_id
	from data.dsm_base_pymnt_dtl
	group by
		E19_C_PT_CLM_LINE_CD,
		c_line_type,
		xc_mco_id,
		n_user_id
;
quit;
proc sort data= data.dsm_basE_pymnt_dtl;
 	by E19_C_PT_CLM_LINE_CD c_line_type xc_mco_id n_user_id;
run;
data data.dsm_base_pymnt_dtl;
	merge data.dsm_base_pymnt_dtl (in=a) num_pymnt (in=b);
	by E19_C_PT_CLM_LINE_CD c_line_type xc_mco_id n_user_id;
	if a;
run;
proc sql;
	create table avg_pymnt as
	select distinct 
				E19_C_PT_CLM_LINE_CD,
				c_line_type,
				xc_mco_id,
				mean(num_pymnt_alpha_id) as avg_pymnt_line
	from num_pymnt
	group by
		E19_C_PT_CLM_LINE_CD,
		c_line_type,
		xc_mco_id
;
quit;
proc sort data= data.dsm_basE_pymnt_dtl;
 	by E19_C_PT_CLM_LINE_CD c_line_type xc_mco_id;
run;
data data.dsm_base_pymnt_dtl;
	merge data.dsm_base_pymnt_dtl (in=a) avg_pymnt (in=b);
	by E19_C_PT_CLM_LINE_CD c_line_type xc_mco_id;
	if a;
run;
data data.dsm_base_pymnt_dtl;
	set data.dsm_base_pymnt_dtl;
	rel_last_pay = (num_pymnt_alpha_id/avg_pymnt_line);
	if avg_pymnt_line = 0 then rel_last_pay = 0;
run;
proc sql;
	create table pymnt_to_merge as
	select
		n_pymnt_id,
		mean(rel_last_pay) as avg_rel_last_pay
	from data.dsm_base_pymnt_dtl
	where xc_mco_id ne '' and E19_C_PT_CLM_LINE_CD ne ''
	group by n_pymnt_id;
quit;
proc sort data=pymnt_to_merge;
	by n_pymnt_id;
run;
proc sort data=data.dsm_base_pymnts;
	by n_pymnt_id;
run;
data data.dsm_base_pymnts (rename = (log_avg_rel_last_pay = v125));
	merge data.dsm_base_pymnts (in=a) pymnt_to_merge (in=b);
	by n_pymnt_id;
	if a;
	if xc_mco_id ne '' and e19_c_pt_clm_line_cd ne '' and avg_rel_last_pay = . then avg_rel_last_pay=0;
	if avg_rel_last_pay le 0 then log_avg_rel_last_pay = -11;
	else log_avg_rel_last_pay = log(avg_rel_last_pay);
	if log_avg_rel_last_pay = . then log_avg_rel_last_pay = -11;
run;

/*============================================================================================
* TO GET F_CONTINGENT
=============================================================================================*/
*********************************************************************************
* CONTINGENT EMPLOYEES FLAG
*********************************************************************************;
proc sort data=data.dsm_base_pymnts(keep = n_user_id) out = data.ntid_final nodupkey;
	by n_user_id;
run;

proc sql;
	create table data.contingent_temp
	as select * from source.ewt_org_entity_ng;
quit;

proc sql;
	create table data.contingent_temp1
	as select b.* 
	from data.ntid_final a,
		data.contingent_temp b
	where a.n_user_id = b.n_user_id
		and b.E68_C_ADW_RCD_DEL = 'N'
		and a.n_user_id ne '';
quit;

proc sql;
create table data.contingent_temp2
as select *
from data.contingent_temp1
where  year(datepart(E68_D_END_ATOMIC_TS)) gt 9998;
quit;

proc sql;
	create table data.cont as 
	select distinct n_user_id, C_CONTINGENT_IND
	from data.contingent_temp2;
quit;

proc sort data = data.cont out = cont_sorted nodupkey dupout=cont_dups;
	by n_user_id;
run;

proc sql;
	create table cont_to_merge as
	select * from cont_sorted
	where n_user_id not in (select n_user_id from cont_dups);
quit;

proc sort data=cont_to_merge;
	by n_user_id;
run;
proc sort data=data.dsm_base_pymnts;
	by n_user_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) cont_to_merge (in=b);
	by n_user_id;
	if a;
	if C_CONTINGENT_IND = 'Y' then f_CONTINGENT = 1;
	else f_CONTINGENT = 0;
run;

/*============================================================================================
* TO GET flag_auth_exp
=============================================================================================*/
proc sql;
	create table data.dsm_pymnt_dtl_fin_codes as
	select distinct
		fin.N_FIN_DTL_ID,
		fin.C_FIN_TX_ENTRY_TYP,
		fin.a_fin_tx_amt
	from 
		source.EWT_FINANCIAL_TX_NG fin
	where
		fin.n_fin_dtl_id in (select n_pymnt_dtl_id from data.dsm_base_pymnt_dtl)
		and fin.e17_c_adw_rcd_del = 'N'
		and fin.C_FIN_TX_ENTRY_TYP in ('510', '520', '600', '620', '652', '654', '678', '694', '730', '740',
   										'745', '800', '805', '820', '825', '840', '845', '860', '865')
;
quit;

/*******************************************************************************************************
* AUTHORITY LIMIT
*******************************************************************************************************/

proc sql;
	create table data.auth_table as
	select 
		a.n_fin_dtl_id as n_pymnt_dtl_id,
		a.c_fin_tx_entry_typ,
		a.a_fin_tx_amt,
		b.n_pymnt_id,
		b.n_line_id,
		b.c_line_type,
		b.n_org_enty_id,
		b.m_alpha_id,
		b.d_issue_dt
	from
		data.dsm_pymnt_dtl_fin_codes as a,
		data.dsm_base_pymnt_dtl as b
	where
		a.n_fin_dtl_id = b.n_pymnt_dtl_id
;
quit;

proc sql;
	create table pymnt_dtl as
	select distinct n_pymnt_dtl_id, n_pymnt_id, n_line_id
	from data.auth_table
	;
quit;

data auth_table_expense auth_table_loss;
	set data.auth_table;
	if c_fin_tx_entry_typ = 600 then output auth_table_loss;
	else if c_fin_tx_entry_typ = 620 then output auth_table_expense;
run;
/*taking the sum of the amounts for the tables auth_table_expense and auth_table_loss*/
data tr1;
	set auth_table_expense;
run;
data tr2;
	set auth_table_loss;
run;
proc sql;
	create table auth_table_expense as
	select n_pymnt_dtl_id,
		c_fin_tx_entry_typ,
		n_pymnt_id,
		n_line_id,
		c_line_type,
		n_org_enty_id,
		m_alpha_id,
		sum(a_fin_tx_amt) as a_fin_tx_amt
	from tr1
	group by
		n_pymnt_dtl_id,
		c_fin_tx_entry_typ,
		n_pymnt_id,
		n_line_id,
		c_line_type,
		n_org_enty_id,
		m_alpha_id
;
proc sql;
	create table auth_table_loss as
	select n_pymnt_dtl_id,
		c_fin_tx_entry_typ,
		n_pymnt_id,
		n_line_id,
		c_line_type,
		n_org_enty_id,
		m_alpha_id,
		sum(a_fin_tx_amt) as a_fin_tx_amt
	from tr2
	group by
		n_pymnt_dtl_id,
		c_fin_tx_entry_typ,
		n_pymnt_id,
		n_line_id,
		c_line_type,
		n_org_enty_id,
		m_alpha_id
;	
quit;		

/* data pull code for data.auth_limit_001*/
proc sql;
create table data.auth_limit_001 as
	select distinct 
		a.N_ORG_ENTY_ID, 
		a.C_LINE_TYPE, 
		a.C_AUTH_LVL, 
		a.N_AUTH_ID, 
		a.c_fin_ctgy,
		a.d_create_ts,
		b.N_AUTH_LMT, 
		c.M_ALPHA_ID 
	from 
		source.ewt_authority_ng as a inner join source.ewt_ref_auth_lvl_ng as b on  a.C_AUTH_LVL = b.C_AUTH_LVL
			inner join source.ewt_org_entity_ng as c on a.N_ORG_ENTY_ID = c.N_ORG_ENTY_ID
where a.D51_C_ADW_RCD_DEL = 'N'
;
quit;
	
data expense loss;
	set data.auth_limit_001;
	if c_fin_ctgy = 600 then output loss;
	if c_fin_ctgy = 620 then output expense;
run;

/*taking the maximum of n_auth_limit for each adjuster for the tables expense and loss*/
data tr1;
	set expense;
run;
data tr2;
	set loss;
run;
proc sql;
	create table expense as
	select 
		c_fin_ctgy,		
		c_line_type,
		n_org_enty_id,
		m_alpha_id,
		max(n_auth_lmt) as n_auth_lmt
	from tr1
	group by
		c_fin_ctgy,		
		c_line_type,
		n_org_enty_id,
		m_alpha_id
;
proc sql;
	create table loss as
	select 
		c_fin_ctgy,		
		c_line_type,
		n_org_enty_id,
		m_alpha_id,
		max(n_auth_lmt) as n_auth_lmt
	from tr2
	group by
		c_fin_ctgy,		
		c_line_type,
		n_org_enty_id,
		m_alpha_id
;	
quit;		

proc sql;
	create table expense_pymnt_dtl as
	select 
		a.n_pymnt_dtl_id,
		(a.a_fin_tx_amt/b.n_auth_lmt)*100 as auth_pct_expense
	from
		auth_table_expense as a,
		expense as b
		where a.n_org_enty_id = b.n_org_enty_id
		and a.c_line_type=b.c_line_type
		and a.m_alpha_id = b.m_alpha_id;
proc sql;
	create table loss_pymnt_dtl as
	select 
		a.n_pymnt_dtl_id,
		(a.a_fin_tx_amt/b.n_auth_lmt)*100 as auth_pct_loss
	from
		auth_table_loss as a inner join
		loss as b 
		on	a.n_org_enty_id = b.n_org_enty_id
		and a.c_line_type=b.c_line_type
		and a.m_alpha_id = b.m_alpha_id;
		
proc sql;
	create table pymnt_dtl_expense as
	select a.*,
			b.auth_pct_expense
	from 
		pymnt_dtl as a left join 
		expense_pymnt_dtl as b
		on a.n_pymnt_dtl_id = b.n_pymnt_dtl_id;
proc sql;
	create table pymnt_dtl_expense_loss as
	select a.*,
		b.auth_pct_loss
	from 
		pymnt_dtl_expense as a
		left join loss_pymnt_dtl as b
		on a.n_pymnt_dtl_id = b.n_pymnt_dtl_id;
quit;
data data.auth_table_1;
	set pymnt_dtl_expense_loss;
run;

/*authority limit from the second table -- line level */
/*data pull code: */
proc sql;
create table data.auth_table_2_datapull as
	select b.n_line_id,
		b.n_pymnt_dtl_id, 
		a.a_approved, 
		a.d_auth_exp_dt,
		a.c_fin_ctgy,
		a.d_create_ts
	from source.ewt_line_authority_ng a ,
		data.auth_table b
	where a.n_line_id = b.n_line_id
		and datepart(a.d_create_ts) < datepart(b.d_issue_dt)
		and a.c_rcd_del = 'N'
		and a.c_fin_ctgy in ('600', '620');
quit;

proc sort data=data.auth_table_2_datapull;
	by n_line_id
		n_pymnt_dtl_id
		descending d_create_ts;
run;
proc sort data=data.auth_table_2_datapull(drop=d_create_ts) nodupkey;
	by n_line_id
		n_pymnt_dtl_id;
run;

/*end of data pull*/
proc sql;
	create table auth_limit_for_2 as
	select n_pymnt_dtl_id, n_line_id, c_fin_tx_entry_typ, a_fin_tx_amt, n_pymnt_id
	from data.auth_table
	where n_pymnt_dtl_id in (select distinct n_pymnt_dtl_id from data.auth_table_1 
										where auth_pct_loss is null 
											and auth_pct_expense is null);
;
quit;
proc sql;
	create table pymnt_dtl_new as
	select distinct n_pymnt_id, n_pymnt_dtl_id
	from data.auth_table_1
	where auth_pct_loss is null 
		and auth_pct_expense is null
	;
quit;
proc sql;
	create table auth_table_2_expense as
	select n_pymnt_dtl_id,
		n_pymnt_id,
		n_line_id,
		c_fin_tx_entry_typ,
		sum(a_fin_tx_amt) as a_fin_tx_amt
	from auth_limit_for_2
	where c_fin_tx_entry_typ = '620'
	group by
		n_pymnt_dtl_id,
		n_line_id,
		c_fin_tx_entry_typ
	;
proc sql;
	create table auth_table_2_loss as
	select n_pymnt_dtl_id,
		n_pymnt_id,
		n_line_id,
		c_fin_tx_entry_typ,
		sum(a_fin_tx_amt) as a_fin_tx_amt
	from auth_limit_for_2
	where c_fin_tx_entry_typ = '600'
	group by
		n_pymnt_dtl_id,
		n_line_id,
		c_fin_tx_entry_typ;
quit;

/*taking the sum of the amounts for the tables auth_table_expense and auth_table_loss*/
data expense loss;
	set data.auth_table_2_datapull;
	if c_fin_ctgy = 600 then output loss;
	if c_fin_ctgy = 620 then output expense;
run;
/*get the auth limit for 600 in loss table and 620 is expense table at line level ..
* these 2 tables shud have n_line_id and auth limit */

proc sql;
	create table expense_pymnt_dtl as
	select 
		a.n_pymnt_dtl_id,
		(a.a_fin_tx_amt/b.a_approved)*100 as auth_pct_expense_new
	from
		auth_table_2_expense as a,
		expense as b
		where a.n_line_id = b.n_line_id
		and a.n_pymnt_dtl_id=b.n_pymnt_dtl_id
;
proc sql;
	create table loss_pymnt_dtl as
	select 
		a.n_pymnt_dtl_id,
		(a.a_fin_tx_amt/b.a_approved)*100 as auth_pct_loss_new
	from
		auth_table_2_loss as a inner join
		loss as b 
		on	a.n_line_id = b.n_line_id
		and a.n_pymnt_dtl_id=b.n_pymnt_dtl_id;
		
proc sql;
	create table pymnt_dtl_expense as
	select a.n_pymnt_dtl_id,
			b.auth_pct_expense_new
	from 
		pymnt_dtl_new as a left join 
		expense_pymnt_dtl as b
		on a.n_pymnt_dtl_id = b.n_pymnt_dtl_id;
proc sql;
	create table pymnt_dtl_expense_loss as
	select a.*,
		b.auth_pct_loss_new
	from 
		pymnt_dtl_expense as a
		left join loss_pymnt_dtl as b
		on a.n_pymnt_dtl_id = b.n_pymnt_dtl_id;
quit;

data data.auth_table_2;
	set pymnt_dtl_expense_loss;
	if auth_pct_loss_new ^='' or auth_pct_expense_new ^='';
run;

proc sort data=data.auth_table_1;
	by n_pymnt_dtl_id;
run;
proc sort data=data.auth_table_2;
	by n_pymnt_dtl_id descending auth_pct_expense_new descending auth_pct_loss_new;
run;
proc sort data=data.auth_table_2 nodupkey;
	by n_pymnt_dtl_id;
run;
data data.auth_table_final_to_merge (drop = auth_pct_loss_new auth_pct_expense_new n_line_id);
	merge data.auth_table_1 (in=a) data.auth_table_2 (in=b);
	by n_pymnt_dtl_id;
	if a;
	if auth_pct_loss = '' and auth_pct_expense = '' then do;
		auth_pct_loss = auth_pct_loss_new;
		auth_pct_expense = auth_pct_expense_new;
	end;
run;
proc sql;
	create table auth_table_final_to_merge as
	select a.*,
		b.a_fin_tx_amt
	from
		data.auth_table_final_to_merge as a,
		data.dsm_base_pymnt_dtl as b
	where 
		a.n_pymnt_dtl_id = b.n_pymnt_dtl_id;
quit;

proc sort data=auth_table_final_to_merge;
	by n_pymnt_id 
	descending a_fin_tx_amt;
run;
proc sort data=auth_table_final_to_merge(drop=a_fin_tx_amt n_pymnt_dtl_id) nodupkey;
	by n_pymnt_id;
run;
proc sort data=data.dsm_base_pymnts;
	by n_pymnt_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) auth_table_final_to_merge (in=b);
	by n_pymnt_id;
	if a;
	if auth_pct_expense ge 1 then flag_auth_exp = 1; 
	else flag_auth_exp = 0;
run;

/*data data.dsm_base_pymnts (drop=c_lob);*/
/*set data.dsm_base_pymnts;*/
/*run;*/
/**/
/*proc sort data=c_lob(rename=(e38_n_adw_claim_id=e19_n_adw_claim_id)) nodupkey;*/
/*	by e38_n_adw_claim_id;*/
/*run;*/
/**/
/*proc sort data=data.dsm_base_pymnts;*/
/*	by e19_n_adw_claim_id;*/
/*run;*/
/**/
/*data data.dsm_base_pymnts;*/
/*	merge data.dsm_base_pymnts (in=a) c_lob (in=b);*/
/*	by e19_n_adw_claim_id;*/
/*	if a;*/
/*run;*/

/*===========================================================
* DATA PREP IS DONE BY NOW 
* MISSING VALUE TREATMENT AND OUTLIER ANALYSIS FOLLOWS
============================================================*/
/************************************************************************************************/
/*For treatment of Avg. RBI Score																*/
/************************************************************************************************/

/*Univariate Analyses for average RBI score*/
proc univariate data=data.dsm_base_pymnts noprint;
	var average_rbi_score;
	output out=data.proc_RBI pctlpts = 25 50 75 pctlpre= p p p;
run;

/*Take the percentile values as cut offs for creating flags*/
proc sql noprint;
	select p25 into :rbi_p25 from data.proc_RBI;
quit;

proc sql noprint;
	select p50 into :rbi_p50 from data.proc_RBI;
quit;

proc sql noprint;
	select p75 into :rbi_p75 from data.proc_RBI;
quit;
**************************************************************************************
* MISSING VALUE TREATMENT FOR EMPLOYEE ATTRIBUTES -- TO OFFICE AVERAGES
*************************************************************************************;
proc sql;
	create table averages as
	select distinct xc_mco_id, mean(dist_payee_emp) as avg_dist_mco
	from data.dsm_base_pymnts
	where dist_payee_emp ne .
		and dist_payee_emp le 500
	group by xc_mco_id;
quit;
proc sort data =data.dsm_base_pymnts;
	by xc_mco_id;
run;
proc sql noprint;
	select mean(dist_payee_emp) into: mean_dist 
	from data.dsm_base_pymnts
	where dist_payee_emp ne .
	and dist_payee_emp le 500
;
quit;
data data.dsm_base_pymnts (drop= avg_dist_mco);
	merge data.dsm_base_pymnts (in=a) averages (in=b);
	by xc_mco_id;
	if a;
	if dist_payee_emp = . and avg_dist_mco ne . then do;
		dist_payee_emp = avg_dist_mco;
		fm_dist_payee_emp = 1;
	end;
	else if dist_payee_emp = . then do; 
		dist_payee_emp = &mean_dist.;
		fm_dist_payee_emp = 1;
	end;
	else fm_dist_payee_emp = 0;

	/*outlier treatment for dist_payee_emp*/
	if Dist_payee_emp gt 500 then do; 
		new_Dist_payee_emp = 500; 
		flag_cap_Dist_payee_emp = 1;
	end;
	else do;
		new_Dist_payee_emp = Dist_payee_emp;
	    flag_cap_Dist_payee_emp = 0;
	 end;

	/*high_average_rbi_score*/
	if average_rbi_score = . then do;
		high_average_rbi_score = 0;
		fm_average_rbi_score = 1;
	end;
	else if average_rbi_score ge &rbi_p75. then do;
		high_average_rbi_score = 1;
		fm_average_rbi_score = 0;
	end;
	else do;
		high_average_rbi_score = 0;
		fm_average_rbi_score = 0;
	end;

	/*JUST A CHECK SO THAT THERE WON'T BE ANY MISSINGS IN THE MODEL VARIABLES*/
	if f_v134_Field = . then f_v134_Field = 0;
	if flag_auth_exp = . then flag_auth_exp = 0;
	if flag_emp_zip_eq_payee = . then flag_emp_zip_eq_payee = 0;
	if f_v9_MANI = . then f_v9_MANI = 0;
	if f_v9_FCP = . then f_v9_FCP = 0;
	if f_v94_063 = . then f_v94_063 = 0;
	if f_v13_FLD = . then f_v13_FLD = 0;
	if f_v13_DRI = . then f_v13_DRI = 0;
	if f_CONTINGENT = . then f_CONTINGENT = 0;
	if v72 = . then v72 = 0;
	if f_v81_1 = . then f_v81_1 = 0;
	if f_v134_Expen = . then f_v134_Expen = 0;
	if v125 = . then v125 = -11;
	if new_dist_payee_emp = . then new_dist_payee_emp = &mean_dist.;
run;

************************************************************************************************
* MERGING MCO NUMBER to DSM_BASE_PYMNTS
************************************************************************************************;
proc sql;
 create table data.mco_number as
 select distinct base.xc_mco_id,
				org.N_ORG_REFN
 from
  source.ewt_org_entity_ng org,
  data.dsm_base_pymnts base
 where 
  base.xc_mco_id = org.n_org_enty_id
  and org.e68_c_adw_rcd_del = 'N'
  and org.E68_D_END_ATOMIC_TS gt '01Jan2100'd
;
quit;
proc sort data=data.mco_number nodupkey;
	by XC_MCO_ID;
run;
proc sort data=data.dsm_base_pymnts;
	by xc_mco_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts(in=a) data.mco_number(in=b);
	by xc_mco_id;
	if a;
run;

/*====================================================================================================
* GETTING THE PERIL CODES AND LOSS CODES FROM EWT_LOSS_NG AND MERGING WITH BASE CLAIMS TO SUB-SET THE
* CLAIMS --PROPERTY CLAIMS
======================================================================================================*/
proc sql;
	create table data.dsm_loss_peril_final as
	select distinct
		base.E19_N_ADW_CLAIM_ID,
		base.E19_N_PT_LOSS_YR,
		base.E19_C_PT_CLM_LINE_CD,
		base.E19_C_PT_LOSS_ST_CD,

		loss.c_loss_type, /* for auto*/
		loss.c_loss_cd, /* for auto*/
		loss.c_loss_detail_cd, /* for auto*/
		loss.c_org_peril_cd, /* for property */
		loss.c_org_sub_peril_cd /* for property*/
	from
		source.ewt_loss_ng as loss,
		data.dsm_base_claims as base
	where
		loss.E45_N_ADW_CLAIM_ID = base.E19_N_ADW_CLAIM_ID
		and loss.E45_N_PT_LOSS_YR = base.E19_N_PT_LOSS_YR
		and loss.E45_C_PT_CLM_LINE_CD = base.E19_C_PT_CLM_LINE_CD
		and loss.E45_C_PT_LOSS_ST_CD = base.E19_C_PT_LOSS_ST_CD 
		and loss.E45_C_ADW_RCD_DEL = 'N'		
;
quit;
/*====================================================================================================
* GETTING THE LOSS DATE AND REPORTED BY
======================================================================================================*/
proc sql;
create table data.dsm_loss_codes as
	select distinct
		base.e19_n_pt_loss_yr,
		base.e19_c_pt_clm_line_cd,
		base.e19_c_pt_loss_st_cd,
		base.e19_n_adw_claim_id,

		loss.D_DATE as loss_date,	
		loss.T_OTH_REPORTED_BY,	
		code.t_long_desc as reported_by
	from 
		source.ewt_loss_ng loss, 
		source.ewt_code_decode_ng code,
		data.dsm_base_claims base
	where
		loss.E45_N_ADW_CLAIM_ID = base.E19_N_ADW_CLAIM_ID
		and loss.E45_N_PT_LOSS_YR = base.E19_N_PT_LOSS_YR
		and loss.E45_C_PT_CLM_LINE_CD = base.E19_C_PT_CLM_LINE_CD
		and loss.E45_C_PT_LOSS_ST_CD = base.E19_C_PT_LOSS_ST_CD 
		and loss.C_REPORTED_BY = code.c_code 
		and code.c_category = 514 /* for reported_by */

		and loss.e45_c_adw_rcd_del = 'N'
;
quit;
************************************************************************************************
* PULLING INSURED NAME to DSM_BASE_PYMNTS
* MERGING INSURED NAME AND LOSS AND PERIL CODES TO DSM BASE PYMNTS
************************************************************************************************;
proc sql;
	create table invl_role 
	as Select 
			ir.n_ins_invl_id,
			ir.E43_N_PT_LOSS_YR,
			ir.E43_C_PT_LOSS_ST_CD,
			ir.E43_C_PT_CLM_LINE_CD,
			ir.E43_N_ADW_CLAIM_ID
      from source.EWT_involvement_role_NG ir Left Join 
            source.claim_party_role cpr
		   on cpr.N_INVL_ROLE_ID = ir.N_INVL_ROLE_ID
	       and cpr.R05_N_PT_LOSS_YR = ir.E43_N_PT_LOSS_YR
	       and cpr.R05_C_PT_LOSS_ST_CD = ir.E43_C_PT_LOSS_ST_CD
	       and cpr.R05_C_PT_CLM_LINE_CD = ir.E43_C_PT_CLM_LINE_CD
	       and cpr.R05_N_ADW_CLAIM_ID = ir.E43_N_ADW_CLAIM_ID
	  where 
		   datepart(cpr.R05_D_END_ATOMIC_TS) gt '01Jan2100'd
		   and cpr.C_RCD_DEL = 'N'
		   and ir.C_INVL_ROLE in('PIN')
           and ir.C_RCD_DEL = 'N';
quit;
data claims; 
	set data.dsm_base_claims
			(keep = e19_n_adw_claim_id e19_n_pt_loss_yr e19_c_pt_clm_line_cd e19_c_pt_loss_st_cd);
run;
proc sql;
 create table data.insured_name2 as
 Select distinct base.e19_n_adw_claim_id,
 				base.e19_n_pt_loss_yr,
  				base.e19_c_pt_clm_line_cd,
  				base.e19_c_pt_loss_st_cd,
				clnt_nm.N_CLIENT_ID,
				clnt_nm.M_first_name,
				clnt_nm.M_last_name
     from claims base,
		   source.EWT_ins_involvement_NG inv, 
           source.ewt_client_name_ng clnt_nm,
		   invl_role temp
     where base.e19_n_adw_claim_id = inv.e44_n_adw_claim_id
	   and inv.n_ins_invl_id = temp.n_ins_invl_id
       and inv.E44_N_PT_LOSS_YR = temp.E43_N_PT_LOSS_YR
       and inv.E44_C_PT_LOSS_ST_CD = temp.E43_C_PT_LOSS_ST_CD
       and inv.E44_C_PT_CLM_LINE_CD = temp.E43_C_PT_CLM_LINE_CD
       and inv.E44_N_ADW_CLAIM_ID = temp.E43_N_ADW_CLAIM_ID
	   and inv.C_RCD_DEL = 'N'       
       and inv.n_client_id = clnt_nm.n_client_id
       and inv.m_leg_inv_id = '01'
       and inv.e44_c_adw_rcd_del = 'N'
       and clnt_nm.e58_c_adw_rcd_del = 'N'
       and clnt_nm.n_default_flag = 'Y'
;
quit;
proc sort data = data.dsm_base_pymnts;
	by e19_n_adw_claim_id
		e19_n_pt_loss_yr
	  	e19_c_pt_clm_line_cd
	  	e19_c_pt_loss_st_cd;
run;
proc sort data = data.insured_name2 nodupkey;
	by e19_n_adw_claim_id
		e19_n_pt_loss_yr
	  	e19_c_pt_clm_line_cd
	  	e19_c_pt_loss_st_cd ;
run;
proc sort data=data.dsm_loss_peril_final nodupkey;
by e19_n_adw_claim_id
	e19_n_pt_loss_yr
  	e19_c_pt_clm_line_cd
  	e19_c_pt_loss_st_cd ;
run;
proc sort data=data.dsm_loss_codes nodupkey;
by e19_n_adw_claim_id
	e19_n_pt_loss_yr
  	e19_c_pt_clm_line_cd
  	e19_c_pt_loss_st_cd ;
run;

data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) data.insured_name2 (in=b) 
			data.dsm_loss_peril_final (in=c) data.dsm_loss_codes (in=d);
	by e19_n_adw_claim_id
		e19_n_pt_loss_yr
  		e19_c_pt_clm_line_cd
  		e19_c_pt_loss_st_cd;
	if a;
run;

/*====================================================================================
* TO PULL AND MERGE THE AGENT CODE TO DSM_BASE_PYMNTS
======================================================================================*/
proc sql;
	create table data.agent_name as
	select
        base.e19_n_adw_claim_id,
        a.n_agt_code as Agent_Code,
        a.m_agt_name as Agent_Name
    FROM source.ewt_claim_ng c 
	    INNER JOIN data.dsm_base_claims base 
		   ON C.e38_N_adw_CLAIM_ID = base.e19_n_adw_claim_id
		INNER JOIN source.ewt_loss_ng l
          ON c.n_loss_id = l.n_loss_id and
            C.E38_N_ADW_CLAIM_ID = L.E45_N_ADW_CLAIM_ID and
            C.E38_N_PT_LOSS_YR = L.E45_N_PT_LOSS_YR and
            C.E38_C_PT_CLM_LINE_CD = L.E45_C_PT_CLM_LINE_CD and
            C.E38_C_PT_LOSS_ST_CD = L.E45_C_PT_LOSS_ST_CD
        INNER JOIN source.ewt_policy_ng p
          ON p.n_policy_id = c.n_policy_id and
             C.E38_N_ADW_CLAIM_ID = p.e32_N_ADW_CLAIM_ID and
             C.E38_N_PT_LOSS_YR = p.E32_N_PT_LOSS_YR and
             C.E38_C_PT_CLM_LINE_CD = p.E32_C_PT_CLM_LINE_CD and
             C.E38_C_PT_LOSS_ST_CD = p.E32_C_PT_LOSS_ST_CD
        INNER JOIN source.ewt_agent_ng a
           ON a.n_policy_id = p.n_policy_id and
              a.e01_N_ADW_CLAIM_ID = p.e32_N_ADW_CLAIM_ID and
              a.E01_N_PT_LOSS_YR = p.E32_N_PT_LOSS_YR and
              a.E01_C_PT_CLM_LINE_CD = p.E32_C_PT_CLM_LINE_CD and
              a.E01_C_PT_LOSS_ST_CD = p.E32_C_PT_LOSS_ST_CD
		 
      WHERE c.E38_C_ADW_RCD_DEL = 'N'
	  	and p.E32_C_ADW_RCD_DEL = 'N'
		and a.E01_C_ADW_RCD_DEL = 'N'
;
quit;
/*frist filter -- agent code should not be blank*/
data data.agent_name_1;
	set data.agent_name;
	where agent_code is not null;
run;
/*in case of duplicates -- take those where agent name is not blank*/
proc sort data = data.agent_name_1 out=sorted nodupkey dupout = dups;
by e19_n_adw_claim_id descending agent_name;
run;
proc sort data=sorted out=data.agent_to_merge nodupkey;
	by e19_n_adw_claim_id;
run;
proc sort data=data.dsm_base_pymnts;
	by e19_n_adw_claim_id;
run;
data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) data.agent_to_merge (in=b);
	by e19_n_adw_claim_id;
	if a;
run;

/*====================================================================================
* TO PULL AND MERGE THE PAYEE ADDRESS TO DSM_BASE_PYMNTS
* ALSO DO ALL THE DATA STEP MANIPULATIONS -- MAPPING LEVELS OF VARIABLES AND ALL
======================================================================================*/
data temp;
	set data.dsm_base_pymnts (keep = N_CLAIM_NUMBER chk_nbr);
	N_CLAIM_NUMBER_sub = substr(N_CLAIM_NUMBER,3,10);
run;
proc sort data = temp nodup;
	by N_CLAIM_NUMBER;
run;
proc sql;
 	create table data.payee_address as
 	select distinct 
		base.N_CLAIM_NUMBER,
		base.N_CLAIM_NUMBER_sub,
		base.chk_nbr,
		clm_pay.CPE_PAYEE_ADDR_LN,
 		clm_pay.CPE_PAYEE_CITY_NM,
		clm_pay.CPE_PAYEE_ST_CD,
		clm_pay.CPE_PAYEE_ZIP_CD
 from
  source.ewt_claim_payment clm_pay,
  temp base
 where 
  base.N_CLAIM_NUMBER_sub = clm_pay.CPE_CLAIM_NBR
  and base.chk_nbr = clm_pay.CPE_CLM_CHECK_NBR
;
quit;
proc sort data = data.payee_address nodupkey;
	by N_CLAIM_NUMBER chk_nbr;
run;

proc sort data = data.dsm_base_pymnts;
	by N_CLAIM_NUMBER chk_nbr;
run;

data data.dsm_base_pymnts;
	length C_LOSS_CD_desc $50.;
	length C_ORG_PERIL_CD_desc $50.;
	length C_LOSS_DETAIL_CD_desc $50.;
	length C_ORG_SUB_PERIL_CD_desc $50.;
	length line_of_business $10.;
	length Coverage_Handling_Strategy $50.;
	length c_pymnt_meth $50.;

		merge data.dsm_base_pymnts (in=a) data.payee_address(in=b drop = N_CLAIM_NUMBER_sub);
		by N_CLAIM_NUMBER chk_nbr;
		if a;

	informat C_LOSS_CD_desc $50.;
	informat C_ORG_PERIL_CD_desc $50.;
	informat C_LOSS_DETAIL_CD_desc $50.;
	informat C_ORG_SUB_PERIL_CD_desc $50.;
	informat line_of_business $10.;
	informat Coverage_Handling_Strategy $50.;
	informat payment_method $50.;

	format D_ISSUE_DT date9.; 
	format D_CLAIM_ENTERED date9.;
	format loss_Date date9.;

	informat D_ISSUE_DT date9.; 
	informat D_CLAIM_ENTERED date9.;
	informat loss_Date date9.;

	if c_loss_cd = '01' then C_LOSS_CD_desc = 'Animal';
	else if c_loss_cd = '02' then C_LOSS_CD_desc = 'Contact With Other Vehicle/Property/Other Party';
	else if c_loss_cd = '04' then C_LOSS_CD_desc = 'Miscellaneous';
	else if c_loss_cd = '05' then C_LOSS_CD_desc = 'Nature - Related Incident';
	else if c_loss_cd = '06' then C_LOSS_CD_desc = 'PIP/Medical Payments';
	else if c_loss_cd = '07' then C_LOSS_CD_desc = 'Theft';
	else if c_loss_cd = '08' then C_LOSS_CD_desc = 'Vandalism/Malicious Mischief';

	if c_loss_detail_cd = '01' then 
		C_LOSS_DETAIL_CD_desc = ' Animal - No Impact Animal Damaged Asset Not Due To Impact';
	else if c_loss_detail_cd = '02' then C_LOSS_DETAIL_CD_desc = 'Insured Hit An Animal';
	else if c_loss_detail_cd = '06' then C_LOSS_DETAIL_CD_desc = 'Backing accident - both parties moving';
	else if c_loss_detail_cd = '07' then C_LOSS_DETAIL_CD_desc = 'Intersection accident';
	else if c_loss_detail_cd = '08' then C_LOSS_DETAIL_CD_desc = 'Insured drove into standing water';
	else if c_loss_detail_cd = '09' then C_LOSS_DETAIL_CD_desc = 'Changing lanes';
	else if c_loss_detail_cd = '11' then C_LOSS_DETAIL_CD_desc = 'Head-on collision';
	else if c_loss_detail_cd = '14' then C_LOSS_DETAIL_CD_desc = 'Insured hit a fixed object';
	else if c_loss_detail_cd = '15' then C_LOSS_DETAIL_CD_desc = 'Insured Hit a Pedestrian/Bicycle';
	else if c_loss_detail_cd = '17' then C_LOSS_DETAIL_CD_desc = 'Making a turn';
	else if c_loss_detail_cd = '19' then C_LOSS_DETAIL_CD_desc = 'Parked Vehicle - insured hit parked vehicle.';
	else if c_loss_detail_cd = '20' then 
		C_LOSS_DETAIL_CD_desc = 'Parked Vehicle - Other Party hit parked Insured';
	else if c_loss_detail_cd = '21' then 
		C_LOSS_DETAIL_CD_desc = 'Rear-end accident - insured rear-ended other party';
	else if c_loss_detail_cd = '22' then C_LOSS_DETAIL_CD_desc = 'Rear-end accident - multiple cars';
	else if c_loss_detail_cd = '23' then 
		C_LOSS_DETAIL_CD_desc = 'Rear-end accident - Other party rear-ended insured';
	else if c_loss_detail_cd = '24' then C_LOSS_DETAIL_CD_desc = 'Sideswipe accident ';
	else if c_loss_detail_cd = '26' then C_LOSS_DETAIL_CD_desc = 'Unknown loss facts';
	else if c_loss_detail_cd = '32' then C_LOSS_DETAIL_CD_desc = 'Insured vehicle hit by falling/flying object';
	else if c_loss_detail_cd = '36' then C_LOSS_DETAIL_CD_desc = 'Damage while being towed';
	else if c_loss_detail_cd = '37' then C_LOSS_DETAIL_CD_desc = 'Other - comprehensive';
	else if c_loss_detail_cd = '39' then C_LOSS_DETAIL_CD_desc = 'Shopping cart';
	else if c_loss_detail_cd = '41' then C_LOSS_DETAIL_CD_desc = 'Tire blew - insured safe stop';
	else if c_loss_detail_cd = '42' then C_LOSS_DETAIL_CD_desc = 'Vehicle burned';
	else if c_loss_detail_cd = '43' then C_LOSS_DETAIL_CD_desc = 'Earthquake';
	else if c_loss_detail_cd = '44' then 
		C_LOSS_DETAIL_CD_desc = 'Insured/resident relative - hit as pedestrian/bicyclist';
	else if c_loss_detail_cd = '45' then C_LOSS_DETAIL_CD_desc = 'Driver assault - car jack';
	else if c_loss_detail_cd = '46' then 
		C_LOSS_DETAIL_CD_desc = 'Insured/resident relative - passenger in other vehicle';
	else if c_loss_detail_cd = '49' then 
		C_LOSS_DETAIL_CD_desc = 'Insured/resident relative - injured entering/exiting';
	else if c_loss_detail_cd = '50' then C_LOSS_DETAIL_CD_desc = 'Insured injured loading/unloading Vehicle';
	else if c_loss_detail_cd = '51' then C_LOSS_DETAIL_CD_desc = 'Other';
	else if c_loss_detail_cd = '52' then C_LOSS_DETAIL_CD_desc = 'Total theft not recovered';
	else if c_loss_detail_cd = '53' then C_LOSS_DETAIL_CD_desc = 'Total theft recovered';
	else if c_loss_detail_cd = '54' then C_LOSS_DETAIL_CD_desc = 'Attempted theft';
	else if c_loss_detail_cd = '55' then C_LOSS_DETAIL_CD_desc = 'Partial theft';
	else if c_loss_detail_cd = '56' then C_LOSS_DETAIL_CD_desc = 'Vandalism';
	else if c_loss_detail_cd = '57' then C_LOSS_DETAIL_CD_desc = 'Wild fire';
	else if c_loss_detail_cd = '58' then C_LOSS_DETAIL_CD_desc = 'Flood';
	else if c_loss_detail_cd = '59' then C_LOSS_DETAIL_CD_desc = 'Hail';
	else if c_loss_detail_cd = '60' then C_LOSS_DETAIL_CD_desc = 'Hurricane';
	else if c_loss_detail_cd = '61' then C_LOSS_DETAIL_CD_desc = 'Storm/windstorm/rainstorm';
	else if c_loss_detail_cd = '62' then C_LOSS_DETAIL_CD_desc = 'Lightning';
	else if c_loss_detail_cd = '63' then C_LOSS_DETAIL_CD_desc = 'Tornado';

	if c_org_peril_cd = '01' then C_ORG_PERIL_CD_desc = 'Aircraft';
	else if c_org_peril_cd = '03' then C_ORG_PERIL_CD_desc = 'Earthquake';
	else if c_org_peril_cd = '04' then C_ORG_PERIL_CD_desc = 'Explosion';
	else if c_org_peril_cd = '05' then C_ORG_PERIL_CD_desc = 'Fire';
	else if c_org_peril_cd = '07' then C_ORG_PERIL_CD_desc = 'Freezing';
	else if c_org_peril_cd = '08' then C_ORG_PERIL_CD_desc = 'Lightning';
	else if c_org_peril_cd = '09' then C_ORG_PERIL_CD_desc = 'Mysterious Disappearance (On Premises)';
	else if c_org_peril_cd = '10' then C_ORG_PERIL_CD_desc = 'Removal';
	else if c_org_peril_cd = '11' then C_ORG_PERIL_CD_desc = 'Riot, Civil Commotion';
	else if c_org_peril_cd = '12' then C_ORG_PERIL_CD_desc = 'Theft (On Premises)';
	else if c_org_peril_cd = '13' then C_ORG_PERIL_CD_desc = 'Vandalism Or Malicious Mischief';
	else if c_org_peril_cd = '14' then C_ORG_PERIL_CD_desc = 'Vehicles';
	else if c_org_peril_cd = '15' then C_ORG_PERIL_CD_desc = 'Water';
	else if c_org_peril_cd = '16' then C_ORG_PERIL_CD_desc = 'Windstorm, Hail';
	else if c_org_peril_cd = '17' then C_ORG_PERIL_CD_desc = 'All Other Perils Not Enumerated';
	else if c_org_peril_cd = '26' then C_ORG_PERIL_CD_desc = 'Sewer Backup';
	else if c_org_peril_cd = '27' then C_ORG_PERIL_CD_desc = 'Sinkhole';
	else if c_org_peril_cd = '28' then C_ORG_PERIL_CD_desc = 'Smoke';
	else if c_org_peril_cd = '31' then C_ORG_PERIL_CD_desc = 'Theft From Unattended Automobile';
	else if c_org_peril_cd = '43' then C_ORG_PERIL_CD_desc = 'Burglary';
	else if c_org_peril_cd = '45' then C_ORG_PERIL_CD_desc = 'Credit Card Fidelity';
	else if c_org_peril_cd = '46' then C_ORG_PERIL_CD_desc = 'Glass Breakage';
	else if c_org_peril_cd = '47' then C_ORG_PERIL_CD_desc = 'Mysterious Disappearance (Off Premises)';
	else if c_org_peril_cd = '48' then C_ORG_PERIL_CD_desc = 'Theft (Off Premises)';
	else if c_org_peril_cd = '49' then C_ORG_PERIL_CD_desc = 'Mine Subsidence';
	else if c_org_peril_cd = '61' then C_ORG_PERIL_CD_desc = 'Water - Other';
	else if c_org_peril_cd = '62' then C_ORG_PERIL_CD_desc = 'Water - Damage To Slab';
	else if c_org_peril_cd = '63' then C_ORG_PERIL_CD_desc = 'Glass - Additional Extended Coverage';
	else if c_org_peril_cd = '64' then C_ORG_PERIL_CD_desc = 'Glass - Broad Form';
	else if c_org_peril_cd = '65' then C_ORG_PERIL_CD_desc = 'Glass - Special Form';
	else if c_org_peril_cd = '66' then C_ORG_PERIL_CD_desc = 'Smoke - Extended Coverage';
	else if c_org_peril_cd = '68' then C_ORG_PERIL_CD_desc = 'Smoke - Special Form';
	else if c_org_peril_cd = '69' then 
		C_ORG_PERIL_CD_desc = 'Vandalism Or Malicious Mischief - Extended Coverage';
	else if c_org_peril_cd = '70' then C_ORG_PERIL_CD_desc = 'Vndlism and MM - BF';
	else if c_org_peril_cd = '71' then C_ORG_PERIL_CD_desc = 'Vandalism Or Malicious Mischief - Special Form';
	else if c_org_peril_cd = '72' then C_ORG_PERIL_CD_desc = 'Vehicles (NOOBT)';
	else if c_org_peril_cd = '73' then C_ORG_PERIL_CD_desc = 'Fire Internal';
	else if c_org_peril_cd = '74' then C_ORG_PERIL_CD_desc = 'Fire External';
	else if c_org_peril_cd = '75' then C_ORG_PERIL_CD_desc = 'Windstorm';
	else if c_org_peril_cd = '76' then C_ORG_PERIL_CD_desc = 'Hail';
	else if c_org_peril_cd = '77' then C_ORG_PERIL_CD_desc = 'Freezing - Damage To Slab';
	else if c_org_peril_cd = '78' then C_ORG_PERIL_CD_desc = 'Freezing - Other';
	else if c_org_peril_cd = '79' then 
		C_ORG_PERIL_CD_desc = 'Vandalism Or Malicious Mischief - Additional Extended Coverage';
	else if c_org_peril_cd = '80' then C_ORG_PERIL_CD_desc = 'Flood';
	else if c_org_peril_cd = '81' then C_ORG_PERIL_CD_desc = 'Fire - Hostile';
	else if c_org_peril_cd = '82' then C_ORG_PERIL_CD_desc = 'Fire Unknown';
	else if c_org_peril_cd = '83' then C_ORG_PERIL_CD_desc = 'Water (Accidental Leakage) Broad Form';
	else if c_org_peril_cd = '84' then C_ORG_PERIL_CD_desc = 'Water (Accidental Leakage) Special Form';
	else if c_org_peril_cd = '85' then C_ORG_PERIL_CD_desc = 'All Other Perils Not Enumerated Broad Form';
	else if c_org_peril_cd = '86' then C_ORG_PERIL_CD_desc = 'All Other Perils Not Enumerated Special Form';
	else if c_org_peril_cd = '87' then C_ORG_PERIL_CD_desc = 'Vehicle (Off Premise)';
	else if c_org_peril_cd = '91' then C_ORG_PERIL_CD_desc = 'Vehicle (On Premise)';
	else if c_org_peril_cd = 'NFI' then C_ORG_PERIL_CD_desc = 'National Flood';

	if C_ORG_SUB_PERIL_CD = 'ABG' then C_ORG_SUB_PERIL_CD_desc = 'Accidental Breakage Of Gl';
	else if C_ORG_SUB_PERIL_CD = 'ADNR' then C_ORG_SUB_PERIL_CD_desc = 'Auto Driven by Non-Reside';
	else if C_ORG_SUB_PERIL_CD = 'ADR' then C_ORG_SUB_PERIL_CD_desc = 'Auto Driven by Resident';
	else if C_ORG_SUB_PERIL_CD = 'BCC' then C_ORG_SUB_PERIL_CD_desc = 'Burning Candles Caused Fi';
	else if C_ORG_SUB_PERIL_CD = 'BPF' then C_ORG_SUB_PERIL_CD_desc = 'Burst Pipes From Freezing';
	else if C_ORG_SUB_PERIL_CD = 'BT' then C_ORG_SUB_PERIL_CD_desc = 'Bike Theft';
	else if C_ORG_SUB_PERIL_CD = 'BU' then C_ORG_SUB_PERIL_CD_desc = 'Burglary';
	else if C_ORG_SUB_PERIL_CD = 'CPM' then C_ORG_SUB_PERIL_CD_desc = 'Children Played With Matc';
	else if C_ORG_SUB_PERIL_CD = 'CSC' then C_ORG_SUB_PERIL_CD_desc = 'Cigarette Smoking Caused';
	else if C_ORG_SUB_PERIL_CD = 'DDEE' then C_ORG_SUB_PERIL_CD_desc = 'Damage Due To External Ex';
	else if C_ORG_SUB_PERIL_CD = 'DNC' then C_ORG_SUB_PERIL_CD_desc = 'Damage By Neighborhood Ch';
	else if C_ORG_SUB_PERIL_CD = 'DS' then C_ORG_SUB_PERIL_CD_desc = 'Hail Damage To Structure';
	else if C_ORG_SUB_PERIL_CD = 'DTD' then C_ORG_SUB_PERIL_CD_desc = 'Damage To Dwelling';
	else if C_ORG_SUB_PERIL_CD = 'EF' then C_ORG_SUB_PERIL_CD_desc = 'Electrical Fire';
	else if C_ORG_SUB_PERIL_CD = 'ESCS' then C_ORG_SUB_PERIL_CD_desc = 'Eletrical Short Causing S';
	else if C_ORG_SUB_PERIL_CD = 'FCB' then C_ORG_SUB_PERIL_CD_desc = 'Fire Caused By Electrical';
	else if C_ORG_SUB_PERIL_CD = 'FE' then C_ORG_SUB_PERIL_CD_desc = 'Furnace Explosion';
	else if C_ORG_SUB_PERIL_CD = 'FEF' then C_ORG_SUB_PERIL_CD_desc = 'Fire Erupted From Brush H';
	else if C_ORG_SUB_PERIL_CD = 'FEP' then C_ORG_SUB_PERIL_CD_desc = 'Fireplace Explosion';
	else if C_ORG_SUB_PERIL_CD= 'FORF' then C_ORG_SUB_PERIL_CD_desc = 'Fire Originated From Fire';
	else if C_ORG_SUB_PERIL_CD= 'FOT' then C_ORG_SUB_PERIL_CD_desc = 'Fire Other Than Grease';
	else if C_ORG_SUB_PERIL_CD= 'FPF' then C_ORG_SUB_PERIL_CD_desc = 'Missing Property From Gar';
	else if C_ORG_SUB_PERIL_CD= 'GB' then C_ORG_SUB_PERIL_CD_desc = 'Glass Breakage';
	else if C_ORG_SUB_PERIL_CD= 'GF' then C_ORG_SUB_PERIL_CD_desc = 'Grease Fire From Kitchen';
	else if C_ORG_SUB_PERIL_CD= 'GI' then C_ORG_SUB_PERIL_CD_desc = 'Glass Broken By Ice Build';
	else if C_ORG_SUB_PERIL_CD= 'GL' then C_ORG_SUB_PERIL_CD_desc = 'Gas Leakage From Stove Of';
	else if C_ORG_SUB_PERIL_CD= 'HD' then C_ORG_SUB_PERIL_CD_desc = 'Hail Damage To Roof';
	else if C_ORG_SUB_PERIL_CD= 'HE' then C_ORG_SUB_PERIL_CD_desc = 'Heater Exploded';
	else if C_ORG_SUB_PERIL_CD= 'HM' then C_ORG_SUB_PERIL_CD_desc = 'Hotel Or Motel';
	else if C_ORG_SUB_PERIL_CD= 'JMF' then C_ORG_SUB_PERIL_CD_desc = 'Jewelry Missing From Home';
	else if C_ORG_SUB_PERIL_CD= 'LMF' then C_ORG_SUB_PERIL_CD_desc = 'Lost Money From Wallet';
	else if C_ORG_SUB_PERIL_CD= 'LSA' then C_ORG_SUB_PERIL_CD_desc = 'Lightning Struck Aerial';
	else if C_ORG_SUB_PERIL_CD= 'LSS' then C_ORG_SUB_PERIL_CD_desc = 'Lightning Struck Structur';
	else if C_ORG_SUB_PERIL_CD= 'MONEY' then C_ORG_SUB_PERIL_CD_desc = 'Theft Of Money';
	else if C_ORG_SUB_PERIL_CD= 'MPF' then C_ORG_SUB_PERIL_CD_desc = 'Missing Property From Air';
	else if C_ORG_SUB_PERIL_CD= 'MPH' then C_ORG_SUB_PERIL_CD_desc = 'Missing Property From Hot';
	else if C_ORG_SUB_PERIL_CD= 'MPP' then C_ORG_SUB_PERIL_CD_desc = 'Missing Property From Pub';
	else if C_ORG_SUB_PERIL_CD= 'MS' then C_ORG_SUB_PERIL_CD_desc = 'Mattress Smolder';
	else if C_ORG_SUB_PERIL_CD= 'OTH' then C_ORG_SUB_PERIL_CD_desc = 'Other - Narrative Require';
	else if C_ORG_SUB_PERIL_CD= 'PB' then C_ORG_SUB_PERIL_CD_desc = 'Pipe Burst';
	else if C_ORG_SUB_PERIL_CD= 'POB' then C_ORG_SUB_PERIL_CD_desc = 'Place Of Business';
	else if C_ORG_SUB_PERIL_CD= 'PPM' then C_ORG_SUB_PERIL_CD_desc = 'Pers Prop Missing After P';
	else if C_ORG_SUB_PERIL_CD= 'RD' then C_ORG_SUB_PERIL_CD_desc = 'Rain Damage';
	else if C_ORG_SUB_PERIL_CD= 'RT' then C_ORG_SUB_PERIL_CD_desc = 'Robbery Or Threat Of Viol';
	else if C_ORG_SUB_PERIL_CD= 'SBST' then C_ORG_SUB_PERIL_CD_desc = 'Sewer Back-Up from Sink,';
	else if C_ORG_SUB_PERIL_CD= 'SBUA' then C_ORG_SUB_PERIL_CD_desc = 'Sewer Back-Up from Applic';
	else if C_ORG_SUB_PERIL_CD= 'SD' then C_ORG_SUB_PERIL_CD_desc = 'School Or Dorm';
	else if C_ORG_SUB_PERIL_CD= 'SDFK' then C_ORG_SUB_PERIL_CD_desc = 'Smoke Damage From Kitchen';
	else if C_ORG_SUB_PERIL_CD= 'SDHF' then C_ORG_SUB_PERIL_CD_desc = 'Smoke Damage From Hostile';
	else if C_ORG_SUB_PERIL_CD= 'SFF' then C_ORG_SUB_PERIL_CD_desc = 'Smoke From Fireplace';
	else if C_ORG_SUB_PERIL_CD= 'SV' then C_ORG_SUB_PERIL_CD_desc = 'Stolen Vehicle';
	else if C_ORG_SUB_PERIL_CD= 'TFD' then C_ORG_SUB_PERIL_CD_desc = 'Theft From Dwelling';
	else if C_ORG_SUB_PERIL_CD= 'TFLV' then C_ORG_SUB_PERIL_CD_desc = 'Theft from Locked Vehicle';
	else if C_ORG_SUB_PERIL_CD= 'TFUV' then C_ORG_SUB_PERIL_CD_desc = 'Theft from Unlocked Vehic';
	else if C_ORG_SUB_PERIL_CD= 'TJW' then C_ORG_SUB_PERIL_CD_desc = 'Theft Of Jewelry, Watches';
	else if C_ORG_SUB_PERIL_CD= 'TMLV' then C_ORG_SUB_PERIL_CD_desc = 'Theft Motor Land Vehicle';
	else if C_ORG_SUB_PERIL_CD= 'TSF' then C_ORG_SUB_PERIL_CD_desc = 'Theft Of Silverware, Flat';
	else if C_ORG_SUB_PERIL_CD= 'TSSO' then C_ORG_SUB_PERIL_CD_desc = 'Toilet, Shower Or Sink Ov';
	else if C_ORG_SUB_PERIL_CD= 'UA' then C_ORG_SUB_PERIL_CD_desc = 'Unknown Act Of Vandalism';
	else if C_ORG_SUB_PERIL_CD= 'UD' then C_ORG_SUB_PERIL_CD_desc = 'Unoccupied Dwelling';
	else if C_ORG_SUB_PERIL_CD= 'VLE' then C_ORG_SUB_PERIL_CD_desc = 'Volatile Liquid Exploded';
	else if C_ORG_SUB_PERIL_CD= 'WB' then C_ORG_SUB_PERIL_CD_desc = 'Waterbed Burst';
	else if C_ORG_SUB_PERIL_CD= 'WCBS' then C_ORG_SUB_PERIL_CD_desc = 'Wood Or Coal Burning Stov';
	else if C_ORG_SUB_PERIL_CD= 'WD' then C_ORG_SUB_PERIL_CD_desc = 'Wind Damage To Chimney';
	else if C_ORG_SUB_PERIL_CD= 'WF' then C_ORG_SUB_PERIL_CD_desc = 'Wind Damage To Fence Or W';
	else if C_ORG_SUB_PERIL_CD= 'WH' then C_ORG_SUB_PERIL_CD_desc = 'Water Heater Leak';
	else if C_ORG_SUB_PERIL_CD= 'WM' then C_ORG_SUB_PERIL_CD_desc = 'Washing Machine Or Applia';
	else if C_ORG_SUB_PERIL_CD= 'WR' then C_ORG_SUB_PERIL_CD_desc = 'Wind Damage To Roof';
	else if C_ORG_SUB_PERIL_CD= 'WS' then C_ORG_SUB_PERIL_CD_desc = 'Wind Damage To Structure';
	else if C_ORG_SUB_PERIL_CD= 'WSBG' then C_ORG_SUB_PERIL_CD_desc = 'Wind Storm Broke Glass';
	if c_lob = "LB01" then line_of_business = "Auto";
	else if c_lob = "LB04" then line_of_business = "Property";
	if c_cov_hndlng_cd = 'A1' then Coverage_Handling_Strategy = 'Arbitration-Clear' ;
	else if c_cov_hndlng_cd = 'A2' then Coverage_Handling_Strategy = 'Arbitration-Unclear' ;
	else if c_cov_hndlng_cd = 'A3' then Coverage_Handling_Strategy = 'Arbitration-Clear-Major' ;
	else if c_cov_hndlng_cd = 'A4' then Coverage_Handling_Strategy = 'Arbitration-Unclear-Major' ;
	else if c_cov_hndlng_cd = 'A5' then Coverage_Handling_Strategy = 'Arbitration-Clear-Moderate' ;
	else if c_cov_hndlng_cd = 'A6' then Coverage_Handling_Strategy = 'Arbitration-Unclear-Moderate' ;
	else if c_cov_hndlng_cd = 'A7' then Coverage_Handling_Strategy = 'Arbitration-Clear-ICST' ;
	else if c_cov_hndlng_cd = 'A8' then Coverage_Handling_Strategy = 'Arbitration-Unclear-ICST' ;
	else if c_cov_hndlng_cd = 'AB' then Coverage_Handling_Strategy = 'Arbitration' ;
	else if c_cov_hndlng_cd = 'C1' then Coverage_Handling_Strategy = 'Clear-Rep-Major' ;
	else if c_cov_hndlng_cd = 'C2' then Coverage_Handling_Strategy = 'Clear-Rep-Moderate' ;
	else if c_cov_hndlng_cd = 'C3' then Coverage_Handling_Strategy = 'Clear-Unrep-Major' ;
	else if c_cov_hndlng_cd = 'C4' then Coverage_Handling_Strategy = 'Clear-Unrep-Moderate' ;
	else if c_cov_hndlng_cd = 'CC' then Coverage_Handling_Strategy = 'Comp Loss W/Collision/PD' ;
	else if c_cov_hndlng_cd = 'CCX' then Coverage_Handling_Strategy = 'Coor. High' ;
	else if c_cov_hndlng_cd = 'CI' then Coverage_Handling_Strategy = 'Clear W/PIP/Med Pay' ;
	else if c_cov_hndlng_cd = 'CL' then Coverage_Handling_Strategy = 'Clear Liability' ;
	else if c_cov_hndlng_cd = 'CM' then Coverage_Handling_Strategy = 'Comp W/PIP/Med Pay' ;
	else if c_cov_hndlng_cd = 'CP' then Coverage_Handling_Strategy = 'Comprehensive' ;
	else if c_cov_hndlng_cd = 'CPA' then Coverage_Handling_Strategy = 'CPA' ;
	else if c_cov_hndlng_cd = 'CSD' then Coverage_Handling_Strategy = 'Coor. Low' ;
	else if c_cov_hndlng_cd = 'ESI' then Coverage_Handling_Strategy = 'Express' ;
	else if c_cov_hndlng_cd = 'EXC' then Coverage_Handling_Strategy = 'Exception' ;
	else if c_cov_hndlng_cd = 'FCS' then Coverage_Handling_Strategy = 'First Call Closure' ;
	else if c_cov_hndlng_cd = 'IC' then Coverage_Handling_Strategy = 'Unclear-Rep-ICST' ;
	else if c_cov_hndlng_cd = 'ID' then Coverage_Handling_Strategy = 'Clear-Rep-ICST' ;
	else if c_cov_hndlng_cd = 'IE' then Coverage_Handling_Strategy = 'Unclear-Unrep-ICST' ;
	else if c_cov_hndlng_cd = 'IF' then Coverage_Handling_Strategy = 'Clear-Unrep-ICST' ;
	else if c_cov_hndlng_cd = 'INV' then Coverage_Handling_Strategy = 'Investigate' ;
	else if c_cov_hndlng_cd = 'L1' then Coverage_Handling_Strategy = 'Litigation -Clear' ;
	else if c_cov_hndlng_cd = 'L2' then Coverage_Handling_Strategy = 'Litigation-Unclear' ;
	else if c_cov_hndlng_cd = 'L3' then Coverage_Handling_Strategy = 'Litigation-Clear-Major' ;
	else if c_cov_hndlng_cd = 'L4' then Coverage_Handling_Strategy = 'Litigation-Unclear-Major' ;
	else if c_cov_hndlng_cd = 'L5' then Coverage_Handling_Strategy = 'Litigation-Clear-Moderate' ;
	else if c_cov_hndlng_cd = 'L6' then Coverage_Handling_Strategy = 'Litigation-Unclear-Moderate' ;
	else if c_cov_hndlng_cd = 'L7' then Coverage_Handling_Strategy = 'Litigation-Clear-ICST' ;
	else if c_cov_hndlng_cd = 'L8' then Coverage_Handling_Strategy = 'Litigation-Unclear-ICST' ;
	else if c_cov_hndlng_cd = 'LG' then Coverage_Handling_Strategy = 'Litigation' ;
	else if c_cov_hndlng_cd = 'MC' then Coverage_Handling_Strategy = 'Mortgage - Investigative' ;
	else if c_cov_hndlng_cd = 'OAC' then Coverage_Handling_Strategy = 'Out. Adj. Complex' ;
	else if c_cov_hndlng_cd = 'OAS' then Coverage_Handling_Strategy = 'Out. Adj. Standard' ;
	else if c_cov_hndlng_cd = 'PM' then Coverage_Handling_Strategy = 'PIP/Med Pay' ;
	else if c_cov_hndlng_cd = 'RP' then Coverage_Handling_Strategy = 'Rental W/PIP/Med Pay' ;
	else if c_cov_hndlng_cd = 'RR' then Coverage_Handling_Strategy = 'Rental Reimbursement' ;
	else if c_cov_hndlng_cd = 'U1' then Coverage_Handling_Strategy = 'Unclear-Rep-Major' ;
	else if c_cov_hndlng_cd = 'U2' then Coverage_Handling_Strategy = 'Unclear-Rep-Moderate' ;
	else if c_cov_hndlng_cd = 'U3' then Coverage_Handling_Strategy = 'Unclear-Unrep-Major' ;
	else if c_cov_hndlng_cd = 'U4' then Coverage_Handling_Strategy = 'Unclear-Unrep-Moderate' ;
	else if c_cov_hndlng_cd = 'UL' then Coverage_Handling_Strategy = 'Unclear Liability' ;
	else if c_cov_hndlng_cd = 'WNDEX' then Coverage_Handling_Strategy = 'Wind Exclusion' ;

	if c_pymnt_meth = 'CAP' then payment_method = 'Canadian Accommodation' ;
	else if c_pymnt_meth = 'EFT' then payment_method = 'EFT' ;
	else if c_pymnt_meth = 'FCP' then payment_method = 'FCP Payment' ;
	else if c_pymnt_meth = 'MANI' then payment_method = 'Manual Issued' ;
	else if c_pymnt_meth = 'NGFCP' then payment_method = 'Next Gen FCP' ;
	else if c_pymnt_meth = 'SSC' then payment_method = 'System Correction' ;
	else if c_pymnt_meth = 'SYSI' then payment_method = 'System Issued' ;

	D_ISSUE_DT = datepart(D_ISSUE_DT);
	D_CLAIM_ENTERED = datepart(D_CLAIM_ENTERED);
	loss_Date = datepart(loss_date);

	/*creating flag_fraud*/
	v84 = 0;

run;

data data.dsm_pymnt_vehicle_info;
set sra29.dsm_pymnt_vehicle_info_final;
run;

proc sql;
	create table dsm_pymnt_vehicle_info as
	select a.*,
		b.a_fin_tx_amt
	from
		data.dsm_pymnt_vehicle_info as a,
		data.dsm_base_pymnt_dtl as b
	where 
		a.n_pymnt_dtl_id = b.n_pymnt_dtl_id;
quit;

proc sort data =data.dsm_base_pymnts (drop=N_MODEL_YEAR_NBR
						M_MAKE_NM
						M_MODEL_NM);
	by n_pymnt_id;
run;

proc sort data=dsm_pymnt_vehicle_info;
	by n_pymnt_id 
	descending a_fin_tx_amt;
run;

proc sort data=dsm_pymnt_vehicle_info (drop=a_fin_tx_amt n_pymnt_dtl_id) nodupkey;
	by n_pymnt_id;
run;

data data.dsm_base_pymnts;
	merge data.dsm_base_pymnts (in=a) dsm_pymnt_vehicle_info (in=b keep=n_pymnt_id N_MODEL_YEAR_NBR	M_MAKE_NM M_MODEL_NM);
	by n_pymnt_id;
	if a;
run;



/*DSM Enhancements*/

proc sql;
create table cpat.ng_cat_codes as (
SELECT
  EWV_CLM_DIM.ADW_CLM_ID,
  EWV_CLM_DIM.CLM_NBR,
  CASE WHEN ( EWV_CLM_GP_DIM.CAT_LEG_CD ) in ('Undefined','Invalid Data','Not Applicable') THEN 'Non CAT' ELSE 'CAT' END,
  EWV_CLM_GP_DIM.FIN_CAT_DESC
  
FROM
  source.EWV_CLM_DIM,
  source.EWV_CLM_GP_DIM,
  source.EWV_CLM_COV_SNPSHT_FACT,
  data.dsm_base_claims dsm
  
WHERE
  ( EWV_CLM_GP_DIM.CLM_GP_SK_ID=EWV_CLM_COV_SNPSHT_FACT.CLM_GP_SK_ID  )
  AND  ( EWV_CLM_COV_SNPSHT_FACT.CLM_SK_ID=EWV_CLM_DIM.CLM_SK_ID  )
  AND dsm.e19_n_adw_claim_id = EWV_CLM_DIM.ADW_CLM_ID
  );
 quit;

 proc sort data = cpat.ng_cat_codes nodupkey;
 by ADW_CLM_ID;
 run;
