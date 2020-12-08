%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas";

data data.ds_new_model_attrs_fin (keep= n_pymnt_id
									var_actl_moi_field
									var_clm_cov_gp_coll
									var_csa_nrthwest
									var_ded_rtn_part_recy
									var_inj_party
									var_exp
									var_ls_peril_amls
									var_ls_peril_van
									var_ls_peril_wind
									var_fcp_pymnt
									var_man_issued
									var_ng_fcp_pymnt
									var_auth_req
									var_hgh_auto_pmt_no_sub
									var_high_techrvw
									var_pmt_lt_auth_lmt
									var_freq_pymnt_nm
									var_freq_pymnt_add
									var_flag_known_fraud);
set cpat.ds_high_techrvw cpat.ds_mvar_pymnt_authlmt
cpat.dsm_other_atts_fin cpat.ds_hgh_auto_pymnt;
	if upcase(actl_meth_of_insp_nm) = 'FIELD' then var_actl_moi_field = 1; else var_actl_moi_field = 0;
	if upcase(clm_cov_gp_nm) = 'COLLISION' then var_clm_cov_gp_coll = 1; else var_clm_cov_gp_coll = 0;
	if upcase(ofc_clm_Srv_area_nm) = 'NORTHWEST' then var_csa_nrthwest = 1; else var_csa_nrthwest = 0;
	if upcase(cur_ded_rtn_sts_nm) = 'PARTIAL RECOVERY' then var_ded_rtn_part_recy = 1; else var_ded_rtn_part_recy = 0;
	if upcase(inj_ind) = 'INJURED PARTY' then var_inj_party = 1; else var_inj_party = 0;
	if upcase(ls_exp_cd) = 'EXP' then var_exp = 1; else var_exp=0;
	if upcase(ls_peril_ty_nm) = 'ANIMALS' then var_ls_peril_amls = 1; else var_ls_peril_amls = 0;
	if upcase(ls_peril_ty_nm) = 'VANDALISM' then var_ls_peril_van = 1; else var_ls_peril_van = 0;
	if upcase(ls_peril_ty_nm) = 'WINDSTORM' then var_ls_peril_wind = 1; else var_ls_peril_wind = 0;
	if upcase(pmt_meth_nm) = 'FCP PAYMENT' then var_fcp_pymnt = 1; else var_fcp_pymnt = 0;
	if upcase(pmt_meth_nm) = 'MANUAL ISSUED' then var_man_issued = 1; else var_man_issued = 0;
	if upcase(pmt_meth_nm) = 'NEXTGEN FCP PAYMENT' then var_ng_fcp_pymnt = 1; else var_ng_fcp_pymnt = 0;
	if PMT_REQ_ADDL_AUTHRTY_IND = 'Payment Required Additional Authority' then var_auth_req = 1; else var_auth_req = 0;
	if var_hgh_auto_pmt_no_sub = '' then var_hgh_auto_pmt_no_sub = 0;
	if var_high_techrvw = '' then var_high_techrvw = 0;
	if var_pmt_lt_auth_lmt = '' then var_pmt_lt_auth_lmt = 0;
	var_freq_pymnt_nm = 0;
	var_freq_pymnt_add = 0;
	var_flag_known_fraud = 0;
run;
	

proc sql;
create table data.ds_new_model_attrs_fin_max as 
select n_pymnt_id,max (var_actl_moi_field) as var_actl_moi_field,
max (var_clm_cov_gp_coll) as var_clm_cov_gp_coll,
max (var_csa_nrthwest) as var_csa_nrthwest,
max (var_ded_rtn_part_recy) as var_ded_rtn_part_recy,
max (var_inj_party) as var_inj_party,
max (var_exp) as var_exp,
max (var_ls_peril_amls) as var_ls_peril_amls,
max (var_ls_peril_van) as var_ls_peril_van,
max (var_ls_peril_wind) as var_ls_peril_wind,
max (var_fcp_pymnt) as var_fcp_pymnt,
max (var_man_issued) as var_man_issued,
max (var_ng_fcp_pymnt) as var_ng_fcp_pymnt,
max (var_auth_req) as var_auth_req,
max (var_hgh_auto_pmt_no_sub) as var_hgh_auto_pmt_no_sub,
max (var_high_techrvw) as var_high_techrvw,
max (var_pmt_lt_auth_lmt) as var_pmt_lt_auth_lmt,
max (var_freq_pymnt_nm) as var_freq_pymnt_nm,
max (var_freq_pymnt_add) as var_freq_pymnt_add,
max (var_flag_known_fraud) as var_flag_known_fraud
from data.ds_new_model_attrs_fin group by n_pymnt_id; 
quit;

proc sql;
create table data.dsm_total_scored_merged_fin as
select distinct base.*,
									var_actl_moi_field,
									var_clm_cov_gp_coll,
									var_csa_nrthwest,
									var_ded_rtn_part_recy,
									var_inj_party,
									var_exp,
									var_ls_peril_amls,
									var_ls_peril_van,
									var_ls_peril_wind,
									var_fcp_pymnt,
									var_man_issued,
									var_ng_fcp_pymnt,
									var_auth_req,
									var_hgh_auto_pmt_no_sub,
									var_high_techrvw,
									var_pmt_lt_auth_lmt,
									var_freq_pymnt_nm,
									var_freq_pymnt_add
from data.dsm_base_pymnts base left outer join data.ds_new_model_attrs_fin_max new on base.n_pymnt_id = new.n_pymnt_id;
run;

proc sql;
create table data.dsm_total_scored_merged_fin_2 as
select distinct base.*,a.var_supp_g_est from 
data.dsm_total_scored_merged_fin base left join cpat.ds_supp_g_est a on base.e19_n_adw_claim_id=a.D70_ADW_CLAIM_ID;
run;
/*data data.dsm_total_scored_merged_fin_2; */
/*set data.dsm_total_scored_merged_fin_2;*/
/*if var_supp_g_est = '' then var_supp_g_est = 0;*/
/*run;*/

proc sql;
create table data.dsm_total_scored_merged_fin_3 as
select distinct base.*,a.var_supp_cnt_g_2 from 
data.dsm_total_scored_merged_fin_2 base left join cpat.ds_supp_cnt_g_2 a on base.e19_n_adw_claim_id=a.D70_ADW_CLAIM_ID;
run;
data data.dsm_total_scored_merged_fin_3; 
set data.dsm_total_scored_merged_fin_3;
if var_supp_cnt_g_2 = '' then var_supp_cnt_g_2 = 0;
if var_supp_g_est = '' then var_supp_g_est = 0;
run;

%macro level();
proc sql;
select next_to_date into:to_date from rundates.nxt_run_dates;
quit;

proc sql;
select next_from_date into:from_date from rundates.nxt_run_dates;
quit;

proc sql;
select next_run_key into:run_key from rundates.nxt_run_dates;
quit;

data _NULL_;
date=&to_date. + 1;
call symput('monthname',substr(put(intnx('month',date,0),monyy.),1,3)||'20'||substr(put(intnx('month',date,0),monyy.),4,2)); 
run;

%let version=&monthname.;
%let run_description = &monthname;
data data.dsm_total_scored_fin_&version.;
	set data.dsm_total_scored_merged_fin_3;
	ebeta1 =  -12.73205633 + (var_actl_moi_field	*	0.81361136	+var_clm_cov_gp_coll	*	1.47927698	+
				var_csa_nrthwest	*	0.79191017	+var_ded_rtn_part_recy	*	0.59507952	+
				var_pmt_lt_auth_lmt	*	1.43774534	+var_hgh_auto_pmt_no_sub	*	0.89945268	+
				var_freq_pymnt_add	*	2.96174683	+var_freq_pymnt_nm	*	2.66594999	+
				var_high_techrvw	*	5.31498907	+var_supp_cnt_g_2	*	1.06283296	+
				var_supp_g_est	*	1.39806171	+var_inj_party	*	-0.5812315	+
				var_exp	*	1.0550334	+var_ls_peril_amls	*	-0.7443416	+
				var_ls_peril_van	*	1.81697806	+var_ls_peril_wind	*	2.35420857	+
				var_fcp_pymnt	*	2.07971847	+var_man_issued	*	3.21654512	+
				var_ng_fcp_pymnt	*	1.26707053	+var_auth_req	*	-1.1625199	);
	ebeta=exp(-ebeta1);
p_1 = 1/(1+ebeta);

	actl_moi_field = var_actl_moi_field	*	0.81361136;
	clm_cov_gp_coll = var_clm_cov_gp_coll	*	1.47927698;
	csa_nrthwest = var_csa_nrthwest * 0.79191017;
	ded_rtn_part_recy = var_ded_rtn_part_recy	*	0.59507952;
	pmt_lt_auth_lmt = var_pmt_lt_auth_lmt	*	1.43774534;
	hgh_auto_pmt_no_sub = var_hgh_auto_pmt_no_sub	*	0.89945268;
	freq_pymnt_add = var_freq_pymnt_add	*	2.96174683;
	freq_pymnt_nm = var_freq_pymnt_nm	*	2.66594999 ;
	high_techrvw = var_high_techrvw	*	5.31498907;
	supp_cnt_g_2 = var_supp_cnt_g_2	*	1.06283296;
	supp_g_est = var_supp_g_est	*	1.39806171;
	inj_party = var_inj_party	*	-0.5812315;
	exp = var_exp	*	1.0550334;
	ls_peril_amls = var_ls_peril_amls	*	-0.7443416;
	ls_peril_van = var_ls_peril_van	*	1.81697806;
	ls_peril_wind = var_ls_peril_wind	*	2.35420857;
	fcp_pymnt = var_fcp_pymnt	*	2.07971847;
	man_issued = var_man_issued	*	3.21654512;
	ng_fcp_pymnt = var_ng_fcp_pymnt	*	1.26707053;
	auth_req = var_auth_req	*	-1.1625199;
run;

data data.dsm_total_scored_fin_&version.;
set data.dsm_total_scored_fin_&version.;
%do j=1 %to 20;
level&j.=largest(&j.,actl_moi_field,
		clm_cov_gp_coll,
		csa_nrthwest,
		ded_rtn_part_recy,
		pmt_lt_auth_lmt,
		hgh_auto_pmt_no_sub,
		freq_pymnt_add,
		freq_pymnt_nm,
		high_techrvw,
		supp_cnt_g_2,
		supp_g_est,
		inj_party,
		exp,
		ls_peril_amls,
		ls_peril_van,
		ls_peril_wind,
		fcp_pymnt,
		man_issued,
		ng_fcp_pymnt,
		auth_req);
%end;
run;
%mend level;
%level;
%macro contributor();
proc sql;
select next_to_date into:to_date from rundates.nxt_run_dates;
quit;

proc sql;
select next_from_date into:from_date from rundates.nxt_run_dates;
quit;

proc sql;
select next_run_key into:run_key from rundates.nxt_run_dates;
quit;

data _NULL_;
date=&to_date. + 1;
call symput('monthname',substr(put(intnx('month',date,0),monyy.),1,3)||'20'||substr(put(intnx('month',date,0),monyy.),4,2)); 
run;

%let version=&monthname.;
%let run_description = &monthname;

	data data.dsm_total_scored_fin_&version.;
	set data.dsm_total_scored_fin_&version.;
%do j=1 %to 20;

format contributor&j. $50.;
	informat contributor&j. $50.;
	if level&j. le 0 then contributor&j.="";
	else if level&j.=actl_moi_field then contributor&j.="ACTUAL_MOI_FIELD;";
	else if level&j.=clm_cov_gp_coll then contributor&j.="CLAIM_COVERAGE_GROUP_COLLISION;";
	else if level&j.=csa_nrthwest then contributor&j.="CLAIM_CSA_NORTHWEST;";
	else if level&j.=ded_rtn_part_recy then contributor&j.="DEDUCTIBLE_RETURN_STS_PARTIAL_RECOVERY;";
	else if level&j.=pmt_lt_auth_lmt then contributor&j.="PAYMENT_CLOSE_TO_AUTHORITY_LIMIT;";
	else if level&j.=hgh_auto_pmt_no_sub then contributor&j.="HIGH_AUTO_COLL_PYMNT_NO_SUBSEQUENT;";
	else if level&j.=fcp_pymnt then contributor&j.="PAYMENT_METHOD_FCP;";
	else if level&j.=man_issued then contributor&j.="PAYMENT_METHOD_MANUAL;";
	else if level&j.=ng_fcp_pymnt then contributor&j.="PAYMENT_METHOD_NG_FCP;";
	else if level&j.=freq_pymnt_nm then contributor&j.="FREQUENT_PYMNTS_TO_SAME_NAME;";
	else if level&j.=freq_pymnt_add then contributor&j.="FREQUENT_PYMNTS_TO_SAME_ADDRESS;";
	else if level&j.=high_techrvw then contributor&j.="HIGH_TECH_REVIEW_MOS;";
	else if level&j.=supp_cnt_g_2 then contributor&j.="SUPPLEMENT_COUNT_GREATER_THAN_2;";
	else if level&j.=supp_g_est then contributor&j.="SUPPLEMENT_AMT_GREATER_ESTIMATE;";
	else if level&j.=inj_party then contributor&j.="INJURED_PARTY;";
	else if level&j.=exp then contributor&j.="EXPENSE_PAYMENT;";
	else if level&j.=ls_peril_amls then contributor&j.="LOSS_PERIL_ANIMALS;";
	else if level&j.=ls_peril_van then contributor&j.="LOSS_PERIL_VANDALISM;";
	else if level&j.=ls_peril_wind then contributor&j.="LOSS_PERIL_WINDSTORM;";	
	else if level&j.=auth_req then contributor&j.="PAYMENT_REQUIRED_ADDITIONAL_AUTHORITY;";		

%end;
run;
%mend contributor;
%contributor;


data data.dsm_req_vars_fin(keep = 
	N_ORG_REFN
	N_CLAIM_NUMBER
	D_CLAIM_ENTERED
	CHK_NBR
	n_pymnt_id
	N_USER_ID
	A_FIN_ENT_AMT
	C_PYMNT_METH
	D_ISSUE_DT
	Coverage_Handling_Strategy 
	m_alpha_id
	payee_nm
	mail_to_nm
	PAYEE_STREET
	PAYEE_CITY
	PAYEE_STATE
	PAYEE_ZIP
	EMP_FIRST_NM
	EMP_LAST_NM
	SUPPLEMENT_FREQUENCY
	REI_COUNT
	AVERAGE_RBI_SCORE
	m_first_name
	m_last_name
	N_MODEL_YEAR_NBR
	M_MAKE_NM
	M_MODEL_NM
	new_dist_payee_emp
	fm_Dist_payee_emp
	num_participant
	num_part_fnolplus30
	num_passenger
	num_pass_fnolplus30
	EST_SW_SUPPLEMENT_NUMBER
	flag_nbr_spplmt_gt_50pct_int_est
	CPE_PAYEE_ADDR_LN
	CPE_PAYEE_CITY_NM 
	CPE_PAYEE_ST_CD
	CPE_PAYEE_ZIP_CD
	loss_date
	reported_by
	agent_name
	agent_code
	C_LOSS_CD_desc
	C_ORG_PERIL_CD_desc
	C_LOSS_DETAIL_CD_desc
	C_ORG_SUB_PERIL_CD_desc
	line_of_business
	p_1
	T_OTH_REPORTED_BY
	C_line_type
	contributor1
	contributor2
	contributor3
	contributor4
	contributor5
	contributor6
	contributor7
	contributor8
	contributor9
	contributor10
	contributor11
	contributor12
	contributor13
	contributor14
	contributor15
	contributor16
	contributor17
	contributor18
	contributor19
	contributor20
	rename = (N_ORG_REFN = MCO
			PAYEE_STREET = MAIL_TO_STREET
			PAYEE_CITY = MAIL_TO_CITY
			PAYEE_STATE = MAIL_TO_STATE
			PAYEE_ZIP = MAIL_TO_ZIP
			m_first_name = insured_first_nm
			m_last_name = insured_last_nm
			CPE_PAYEE_ADDR_LN = PAYEE_ADDR_LN
			CPE_PAYEE_CITY_NM = PAYEE_CITY_NM
			CPE_PAYEE_ST_CD = PAYEE_ST_CD
			CPE_PAYEE_ZIP_CD = PAYEE_ZIP_CD
			reported_by = c_reported_by
			C_LOSS_CD_desc = loss_type
			C_ORG_PERIL_CD_desc = Peril
			C_LOSS_DETAIL_CD_desc = Detail_loss_type
			C_ORG_SUB_PERIL_CD_desc = Sub_peril
			A_FIN_ENT_AMT = payment_amount
			C_PYMNT_METH = payment_method
			N_USER_ID = NTID
			EST_SW_SUPPLEMENT_NUMBER = max_SUPPLEMENT_NUMBER
			new_dist_payee_emp = distance_mailto_emp
			fm_Dist_payee_emp = dist_missing_treated
			p_1 = score)
	);
	set data.dsm_total_scored_fin_&version.;
run;

/*Adding percentile score*/
proc rank data= data.dsm_req_vars_fin out = data.score_req_vars_percentile_fin groups = 100;
   var Score;
   ranks percentile_score;
run;

/*******************************DSM Data*********************************/
data cpat.dsm_all;
    set data.score_req_vars_percentile_fin;
run;

/**MERGING THE DESCRIPTIONS FOR C_LINE_TYPE**/
proc sql;
create table cpat.dsm_all as
	select 
		a.*,
		b.t_long_desc as c_line_type_desc
	from source.ewt_code_DECODE_ng as b,
		cpat.dsm_all as a
	wherE b.c_category = 20 
		and b.c_code = a.c_line_type 
	;
quit;

data cpat.dsm_all (drop=m_alpha_id payee_addr_ln payee_st_cd insured_first_nm insured_last_nm
rename=(m_alpha_id_2=m_alpha_id payee_addr_ln_2=payee_addr_ln payee_st_cd_2=payee_st_cd));
set cpat.dsm_all;
format m_alpha_id_2 $8.;
informat m_alpha_id_2 $8.;
m_alpha_id_2=m_alpha_id;

format payee_addr_ln_2 $40.;
informat payee_addr_ln_2 $40.;
payee_addr_ln_2=payee_addr_ln;

format payee_st_cd_2 $8.;
informat payee_st_cd_2 $8.;
payee_st_cd_2=payee_st_cd;

format c_line_type $8.;
informat c_line_type $8.;

format insured_name $200.;
informat insured_name $200.;
insured_name=(trim(insured_first_nm)||" "||trim(insured_last_nm));
run;

proc sql;
	create table cpat.dsm as
	select
		n_pymnt_id,
		score,
		percentile_score,
		MCO,
		n_claim_number,
		chk_nbr,
		payment_amount,
		d_issue_dt,
		payment_method,
		c_line_type_desc,
		m_alpha_id,
		payee_nm,
		insured_name,
		mail_to_nm,
		payee_addr_ln,
		mail_to_street,
		payee_city_nm,
		mail_to_city,
		payee_st_cd,
		mail_to_state,
		payee_zip_cd,
		mail_to_zip,
		max_supplement_number,
		average_rbi_score,
		rei_count,
		supplement_frequency,
		flag_nbr_spplmt_gt_50pct_int_est,
		n_model_year_nbr,
		m_make_nm,
		m_model_nm,
		num_participant,
		num_part_fnolplus30,
		num_passenger,
		loss_type,
		emp_first_nm,
		emp_last_nm,
		ntid,
		line_of_business,
		detail_loss_type,
		coverage_handling_strategy,
		peril,
		sub_peril,
		loss_date,
		d_claim_entered,
		c_reported_by,
		t_oth_reported_by,
		distance_mailto_emp,
		dist_missing_treated,
		num_pass_fnolplus30,
		agent_code,
		agent_name,
		c_line_type,
		contributor1,
		contributor2,
		contributor3,
		contributor4,
		contributor5,
		contributor6,
		contributor7,
		contributor8,
		contributor9,
		contributor10,
		contributor11,
		contributor12,
		contributor13,
		contributor14,
		contributor15 
	from cpat.dsm_all;
quit;

data cpat.DSM;
set cpat.dsm;
cpe_cd1_payee_zip_plus4=substr(payee_zip_cd,6);
source = 'DSM';
run;

data cpat.temp(keep = n_pymnt_id e19_n_pt_loss_yr e19_c_pt_clm_line_cd e19_c_pt_loss_st_cd e19_n_adw_claim_id 
rename = (e19_n_pt_loss_yr = n_pt_loss_yr 
e19_c_pt_clm_line_cd = c_pt_clm_line_cd
e19_c_pt_loss_st_cd = c_pt_loss_st_cd
e19_n_adw_claim_id = claim_id
));
set data.dsm_base_pymnts;
run;

proc sort data = cpat.temp;
by n_pymnt_id;
run;
proc sort data = cpat.dsm;
by n_pymnt_id;
run;
data cpat.dsm;
merge cpat.dsm(in =a) cpat.temp(in =b);
by n_pymnt_id;
if a;
run;

data dsm;
set cpat.dsm;
  year=year(d_issue_dt);
    fdoy=mdy(1,1,year);
    if year <= 2006 then do;
      fdo_apr=intnx('month',fdoy,3);
      dst_beg=intnx('week.1',fdo_apr,(weekday(fdo_apr) ne 1));
      fdo_oct=intnx('month',fdoy,9);
      dst_end=intnx('week.1',fdo_oct,(weekday(fdo_oct) in (6,7))+4);
    end;
    else do;  
      fdo_mar=intnx('month',fdoy,2);
      dst_beg=intnx('week.1',fdo_mar, (weekday(fdo_mar) in (2,3,4,5,6,7))+1);
      fdo_nov=intnx('month',fdoy,10);
      dst_end=intnx('week.1',fdo_nov,(weekday(fdo_nov) ne 1));
    end;
run;

data dsm;
set dsm;
  year2=year(d_claim_entered);
    fdoy2=mdy(1,1,year2);
    /* For years prior to 2007, daylight time begins in the United States on */
    /* the first Sunday in April and ends on the last Sunday in October.     */
    if year2 <= 2006 then do;
      fdo_apr2=intnx('month',fdoy2,3);
      dst_beg2=intnx('week.1',fdo_apr2,(weekday(fdo_apr2) ne 1));
      fdo_oct2=intnx('month',fdoy2,9);
      dst_end2=intnx('week.1',fdo_oct2,(weekday(fdo_oct2) in (6,7))+4);
    end;
    /* Starting in March 2007, daylight time will begin on the second Sunday */
	/* in March and end on the first Sunday in November 					 */
    else do;  
      fdo_mar2=intnx('month',fdoy2,2);
      dst_beg2=intnx('week.1',fdo_mar2, (weekday(fdo_mar2) in (2,3,4,5,6,7))+1);
      fdo_nov2=intnx('month',fdoy2,10);
      dst_end2=intnx('week.1',fdo_nov2,(weekday(fdo_nov2) ne 1));
    end;
run;

data dsm;
set dsm;
dst_beg1=dst_beg+8/24;
dst_end1=dst_end+7/24;
dst_beg3=dst_beg2+8/24;
dst_end3=dst_end2+7/24;
run;

data dsm (drop=year fdoy fdo_apr fdo_oct fdo_mar fdo_nov dst_beg dst_beg1 dst_end dst_end1 
year2 fdoy2 fdo_apr2 fdo_oct2 fdo_mar2 fdo_nov2 dst_beg2 dst_beg3 dst_end2 dst_end3 d_claim_entered d_issue_dt);
set dsm;
if d_issue_dt ge dst_beg1 and d_issue_dt lt dst_end1 
then d_issue_dt_cst = d_issue_dt - 5/24;
else d_issue_dt_cst = d_issue_dt - 6/24;
if d_claim_entered ge dst_beg3 and d_claim_entered lt dst_end3 
then d_claim_entered_cst = d_claim_entered - 5/24;
else d_claim_entered_cst = d_claim_entered - 6/24;
run;

data dsm (rename=(d_claim_entered_cst=d_claim_entered d_issue_dt_cst=d_issue_dt));
set dsm;
run;

data cpat.dsm (rename=(score=model_score));
set dsm;
run;

data cpat.dsm;
set cpat.dsm;
format payment_amount dollar14.2;
informat payment_amount dollar14.2;
format d_claim_entered mmddyy10.;
informat d_claim_entered mmddyy10.;
format loss_date mmddyy10.;
informat loss_date mmddyy10.;
format d_issue_dt mmddyy10.;
informat d_issue_dt mmddyy10.;
run;

proc sql;
create table cpat.map_insured_nm as
select distinct a.claim_id ,b.m_named_insd,b.e32_d_atomic_ts
from cpat.dsm as a
left join source.ewt_policy_ng as b
on a.claim_id = b.e32_n_adw_claim_id
;
quit;

proc sort data = cpat.map_insured_nm;
by claim_id descending e32_d_atomic_ts;
run;

proc sort data = cpat.map_insured_nm nodupkey;
by claim_id;
run;

proc sort data = cpat.dsm;
by claim_id;
run;

data cpat.map_insured_nm (drop=e32_d_atomic_ts rename=(m_named_insd=insured_name));
set cpat.map_insured_nm;
run;

data cpat.dsm;
merge cpat.dsm(in=a drop=insured_name) cpat.map_insured_nm(in =b);
by claim_id;
if a;
run;



