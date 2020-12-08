%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas";
/*DSM Enhancements*/

/*NG open closed dates*/
proc sql;
create table data.ng_cov_dates_pymnt_detail as 
select distinct a.*, l.d_creation, l.d_fin_close_dt, l.d_fin_reopen_dt
from data.dsm_base_pymnt_dtl a left join source.ewt_line_ng l
on a.e19_n_pt_loss_yr = l.e24_n_pt_loss_yr
and a.e19_c_pt_clm_line_cd = l.e24_c_pt_clm_line_cd
and a.e19_c_pt_loss_st_cd = l.e24_c_pt_loss_st_cd
and a.e19_n_adw_claim_id = l.e24_n_adw_claim_id
and a.n_line_id = l.n_line_id
and l.E24_C_ADW_RCD_DEL='N'
;
quit;

proc sort data = data.ng_cov_dates_pymnt_detail out = data.ng_cov_dates_payment_level (keep = 
						n_pymnt_id
						a_fin_tx_amt
						n_line_id
						d_creation
						d_fin_close_dt
						d_fin_reopen_dt
						c_line_type) nodupkey;
	by n_pymnt_id descending a_fin_tx_amt;
run;

proc sort data = data.ng_cov_dates_payment_level(drop=a_fin_tx_amt) nodupkey; 
	by n_pymnt_id;
run;

/*data data.ng_cov_dates_payment_level;*/
/*set data.ng_cov_dates_payment_level;*/
/*if d_fin_reopen_dt != not null then d_creation=d_fin_reopen_dt;*/
/*else d_creation=d_creation;*/
/*run;*/

proc sort data=cpat.dsm nodupkey;
by n_pymnt_id;
run;

proc sql;
create table cpat.dsm_final as
select a.*, b.d_creation as coverage_open_date, b.d_fin_close_dt as coverage_closed_date
from cpat.dsm a left join data.ng_cov_dates_payment_level b
on a.n_pymnt_id=b.n_pymnt_id
;
quit;

/**************************Combined Data*************************
append here*/

data cpat.legacy_only_final_fixed;
set cpat.legacy_only_final;
PAYEE_ZIP_CD_1 = put(PAYEE_ZIP_CD, $10.);
MAIL_TO_ZIP_1 = put(MAIL_TO_ZIP, $10.);
run;

data cpat.legacy_only_final_fixed(drop = PAYEE_ZIP_CD MAIL_TO_ZIP) ;
set cpat.legacy_only_final_fixed;
run;

data cpat.appended;
set cpat.dsm_final cpat.legacy_only_final_fixed(rename=(PAYEE_ZIP_CD_1=PAYEE_ZIP_CD MAIL_TO_ZIP_1=MAIL_TO_ZIP));
run;

/*pulling employee data*/
proc sort data =cpat.appended;
by ntid;
run;

proc sort data =data.employee_data out = cpat.employee_data nodupkey;
by ntid;
run;	

/*next merge employee details*/
data cpat.base;
merge cpat.appended (in =a )  cpat.employee_data (in =b keep = NTID e_street e_city e_region employee_zip);
by NTID;
if a;
run;

/*pulling suppliment count n estimate count at an adjuster level*/
proc sql;
create table cpat.adjuster_sup_est as
SELECT adjuster_alpha_id as m_alpha_id, total_est_count, total_supp, cnt_nd_rei_exceptions, cnt_nvd_rei_exceptions,
cnt_rp_rei_exceptions
FROM data.est_1;
quit;

proc sort data =cpat.adjuster_sup_est;
by m_alpha_id;
run;

proc sort data =cpat.base;
by m_alpha_id;
run;

/*to be merged with appended data*/
data cpat.base;
merge cpat.base(in =a) cpat.adjuster_sup_est(in =b);
by m_alpha_id;
if a;
run;


/*New method to create the standaridised address*/
%macro stan_address(table,field,city,state,output);
data &table.;
set &table.;
	Stan_Add = upcase(&field.);
	Stan_Add = tranwrd(Stan_Add,".",' ');
	Stan_Add = tranwrd(Stan_Add," AVE ",' ');
	Stan_Add = tranwrd(Stan_Add," AVENUE ",' ');
	Stan_Add = tranwrd(Stan_Add," DR ",' ');
	Stan_Add = tranwrd(Stan_Add," DRIVE",' ');
	Stan_Add = tranwrd(Stan_Add," ROAD",' ');
	Stan_Add = tranwrd(Stan_Add," RD ",' ');
	Stan_Add = tranwrd(Stan_Add," HIGHWAY ",' ');
	Stan_Add = tranwrd(Stan_Add," HWY ",' ');
	Stan_Add = tranwrd(Stan_Add," CT ",' ');
	Stan_Add = tranwrd(Stan_Add," COURT ",' ');
	Stan_Add = tranwrd(Stan_Add," PL ",' ');
	Stan_Add = tranwrd(Stan_Add," PLACE ",' ');
	Stan_Add = tranwrd(Stan_Add," PKWY ",' ');
	Stan_Add = tranwrd(Stan_Add," PARKWAY ",' ');
	Stan_Add = tranwrd(Stan_Add," E ",' ');
	Stan_Add = tranwrd(Stan_Add," EAST ",' ');
	Stan_Add = tranwrd(Stan_Add," WEST ",' ');
	Stan_Add = tranwrd(Stan_Add," S ",' ');
	Stan_Add = tranwrd(Stan_Add," SOUTH ",' ');
	Stan_Add = tranwrd(Stan_Add," N ",' ');
	Stan_Add = tranwrd(Stan_Add," NORTH ",' ');
	Stan_Add = tranwrd(Stan_Add," BLVD ",' ');
	Stan_Add = tranwrd(Stan_Add," BOULEVARD ",' ');
	Stan_Add = tranwrd(Stan_Add," ST ",' ');
	Stan_Add = tranwrd(Stan_Add," STREET ",' ');
	Stan_Add = tranwrd(Stan_Add," FLOOR ",' ');
	Stan_Add = tranwrd(Stan_Add,",",' ');
	Stan_Add = tranwrd(Stan_Add,"$",' ');
	Stan_Add = tranwrd(Stan_Add,"#",' ');
	Stan_Add = tranwrd(Stan_Add,"*",' ');
	Stan_Add = tranwrd(Stan_Add,"!",' ');
	Stan_Add = tranwrd(Stan_Add,"@",' ');
	Stan_Add = tranwrd(Stan_Add,"&",' ');
	Stan_Add = tranwrd(Stan_Add,"(",' ');
	Stan_Add = tranwrd(Stan_Add,")",' ');
	Stan_Add = tranwrd(Stan_Add,"[",' ');
	Stan_Add = tranwrd(Stan_Add,"]",' ');
	Stan_Add = tranwrd(Stan_Add,"{",' ');
	Stan_Add = tranwrd(Stan_Add,"}",' ');
	Stan_Add = tranwrd(Stan_Add,"/",' ');
	Stan_Add = tranwrd(Stan_Add,"\",' ');
	Stan_Add = tranwrd(Stan_Add," SQ ",' ');
	Stan_Add = tranwrd(Stan_Add," CIRCLE ",' ');
	Stan_Add = upcase(compress(Stan_Add)); 
run;
/*Combining standardised address with city and state*/

data &table.;
set &table.;
&output. = upcase(compress(Stan_Add||&city.||&state.));
run;
%mend stan_address;



/*making standard adresses for payee and employee*/
 data cpat.base;
set cpat.base;
comp_payee_city_nm=compress(payee_city_nm);
comp_payee_st_cd=compress(payee_st_cd);
comp_e_city=compress(e_city);
comp_e_region=compress(e_region);
comp_mail_to_city=compress(mail_to_city);
comp_mail_to_state=compress(mail_to_state);
run;


%stan_address(cpat.base,payee_addr_ln,comp_payee_city_nm,comp_payee_st_cd,std_payee_Addr);
%stan_address(cpat.base,e_street,comp_e_city,comp_e_region,std_e_addr);
%stan_address(cpat.base,mail_to_street,comp_mail_to_city,comp_mail_to_state,std_mailto_Addr);




/*pulling created by ntid and created by alpha id*/
proc sql;
create table cpat.n_ent_clm as
select  distinct a.claim_id ,b.n_entered_by 
from cpat.base as a 
left join source.ewt_claim_ng as b
on  b.e38_n_adw_claim_id = a.claim_id;
quit;

proc sql;
create table cpat.map_n_entby_id as
select distinct a.* , b.m_alpha_id as ent_by_m_alpha_id ,b.n_user_id as ent_by_n_user_id,b.E68_D_ATOMIC_TS,b.m_org_first_uc as ent_by_fname,b.m_org_last_uc as ent_by_lname
from cpat.n_ent_clm as a
left join source.ewt_org_entity_ng as b
on a.n_entered_by = n_org_enty_id;
quit;

proc sort data = cpat.map_n_entby_id;
by  n_entered_by descending E68_D_ATOMIC_TS;
run;

proc sort data = cpat.map_n_entby_id out = cpat.ent_by_map(drop = claim_id) nodupkey;
by  n_entered_by ;
run;

proc sort data = cpat.n_ent_clm;
by n_entered_by;
run;

data cpat.n_ent_by_clm_dtl;
merge cpat.n_ent_clm(in =a) cpat.ent_by_map(in =b drop = e68_d_atomic_ts);
by n_entered_by;
if a;
run;

proc sort data = cpat.base;
by claim_id;
run;

proc sort data = cpat.n_ent_by_clm_dtl;
by claim_id;
run;

data cpat.base;
merge cpat.base(in =a) cpat.n_ent_by_clm_dtl(in =b drop = n_entered_by);
by claim_id;
if a;
run;

/*adding run key and run description*/
data cpat.base;
set cpat.base;
run_key = &run_key.;
run_description = "&run_description.";
run;

/*column P*/
proc sql;
create table cpat.base_temp as select a.*, avg(average_rbi_score) as avg_rbi_office, count(m_alpha_id) as num_adjustors
from cpat.base a
group by MCO;
quit;

data cpat.base_temp;
set cpat.base_temp;
sum_supp_est= total_est_count+total_supp;
oversight_rei=rei_count/sum_supp_est;
twenty_pct_adjustors=(0.2*num_adjustors);
run;

data base;
set cpat.base_temp;
twenty_pct_adjustors=round(twenty_pct_adjustors,1);
run;

proc rank data=base out=cpat.base_p;
by MCO;
var oversight_rei;
   ranks rank_oversight_rei;
run;

data cpat.base_p;
set cpat.base_p;
if average_rbi_score ge avg_rbi_office and
rank_oversight_rei le twenty_pct_adjustors then
check_mark_p=1;
else check_mark_p=0;
run;

data cpat.base_p;
set cpat.base_p;
if rank_oversight_rei=. then check_mark_p=0;
run;

/*column q*/
proc sql;
create table cpat.base_pq as 
select a.*, sum(total_supp) as sum_supp_office, sum(total_est_count) as sum_est_office
from cpat.base_p a
group by MCO;
quit;

data cpat.base_pq;
set cpat.base_pq;
sum_sup_est_office= sum_supp_office+sum_est_office;
sum_sup_est= total_supp+total_est_count;
run;

data cpat.base_pq;
set cpat.base_pq;
supp_freq_office= sum_supp_office/sum_sup_est_office;
run;

data cpat.base_pq;
set cpat.base_pq;
if supplement_frequency gt 1.5*supp_freq_office or 
supplement_frequency lt 0.5*supp_freq_office 
then check_mark_q=1;
else check_mark_q=0;
run;

/*column r*/
data cpat.base_pqr;
set cpat.base_pq;
sum_nodam_novisdam= cnt_nd_rei_exceptions+cnt_nvd_rei_exceptions;
run;

proc rank data=cpat.base_pqr out=cpat.base_pqr descending;
by MCO;
var sum_nodam_novisdam;
   ranks rank_sum_nodam_novisdam;
run;

data cpat.base_pqr;
set cpat.base_pqr;
if rank_sum_nodam_novisdam le twenty_pct_adjustors then
check_mark_r=1;
else check_mark_r=0;
run;

data cpat.base_pqr;
set cpat.base_pqr;
if rank_sum_nodam_novisdam=. then check_mark_r=0;
run;

data cpat.base_pqr (drop=avg_rbi_office num_adjustors 
					sum_supp_est twenty_pct_adjustors rank_oversight_rei sum_est_office sum_supp_office 
					supp_freq_office rank_sum_nodam_novisdam sum_sup_est_office);
set cpat.base_pqr;
Label sum_sup_est='NUMBER OF ESTIMATES AND SUPPLEMENTS'; 
Label total_supp='NUMBER OF SUPPLEMENTS';
Label oversight_rei='OVERSIGHT REI %';
Label sum_nodam_novisdam='NUMBER OF DAMAGE OR NO VISIBLE DAMAGE REI EXCEPTIONS';
Label cnt_rp_rei_exceptions='NUMBER OF RECYCLED PARTS REI EXCEPTIONS';
Label check_mark_p='AVERAGE RBI SCORE >OFFICE AAVERAGE RBI SCORE AND AVERAGE REI % IN BOTTOM (20%)';
Label check_mark_q='SUPPLEMENT FREQUENCY EITHER 50% ABOVE OR BELOW OFFICE AVERAGE';
Label check_mark_r='TOP 20% OF [NUMBER OF NO DAMAGE REI EXCEPTIONS] + [NUMBER OF NO VISIBLE DAMAGE REI EXCEPTIONS]';
run;

data cpat.base_pqr;
set cpat.base_pqr;
if source='DSM' then n_claim_number=substr(n_claim_number,3);
run;

data cpat.base_pqr (drop = num_part_fnolplus30 num_pass_fnolplus30
			rename = (num_pass_fnolplus30_1 = num_pass_fnolplus30 num_part_fnolplus30_1 = num_part_fnolplus30));
	set cpat.base_pqr;
	Label average_rbi_score = 'AVERAGE RBI SCORE';
	Label chk_nbr = 'CHECK NUMBER';
	Label d_claim_entered = 'DATE OF REPORT';
	Label d_issue_dt = 'CHECK ISSUE DATE';
	Label emp_first_nm = 'EMPLOYEE FIRST NAME';
	Label emp_last_nm = 'EMPLOYEE LAST NAME';
	Label flag_nbr_spplmt_gt_50pct_int_est = 'NUM OF SUPP > 50% OF ORG EST';
	Label line_of_business = 'LINE CODE';
	Label loss_date = 'DATE OF LOSS';
	Label m_make_nm = 'VEHICLE MAKE';
	Label m_model_nm = 'VEHICLE MODEL';
	Label mail_to_nm = 'MAILED TO NAME';
	Label n_claim_number = 'CLAIM NUMBER';
	Label n_model_year_nbr = 'VEHICLE MODEL YEAR';
	Label n_pymnt_id = 'PAYMENT ID';
	Label num_participant = 'NUMBER OF PARTICIPANT';
	Label num_passenger = 'NUMBER OF PASSENGERS';
	Label payee_nm = 'PAYEE';
	Label rei_count = 'REI COUNT';
	Label supplement_frequency = 'SUPPLEMENT FREQUENY';
	Label coverage_handling_strategy = 'COVERAGE HANDLING STRATEGY';
	Label payment_method = 'CHECK GENERATION CODE';
	Label model_score = 'MODEL SCORE';
	Label loss_type = 'LOSS TYPE';
	Label peril = 'PERIL';
	Label detail_loss_type = 'DETAILED LOSS TYPE';
	Label sub_peril = 'SUBPERIL';
	Label payment_amount = 'PAYMENT AMOUNT';
	Label ntid = 'NT ID';
	Label mail_to_zip = 'MAILED TO ZIP';
	Label mail_to_street = 'MAILED TO STREET';
	Label mail_to_city = 'MAILED TO CITY';
	Label mail_to_state = 'MAILED TO STATE';
	Label max_supplement_number = 'SUPPLEMENT NUMBER';
	Label distance_mailto_emp = 'DIST MAILED TO EMPLOYEE';
	Label MCO = 'MCO';
	Label c_reported_by = 'REPORTED BY';
	Label insured_name = 'INSURED NAME';
	Label payee_addr_ln = 'PAYEE STREET';
	Label payee_city_nm = 'PAYEE CITY';
	Label payee_st_cd = 'PAYEE STATE';
	Label payee_zip_cd = 'PAYEE ZIP';
	Label agent_code = 'AGENT CODE';
	Label agent_name = 'AGENT NAME';
	Label percentile_score = 'PERCENTILE SCORE';
	Label m_alpha_id = 'ALPHA ID';
	Label t_oth_reported_by = 'REPORTED BY DESCRIPTION';
	Label c_line_type = 'COVERAGE CODE';
	Label c_line_type_desc='COVERAGE CODE DESCRIPTION';
	Label cpe_cd1_payee_zip_plus4 = 'PAYEE +4';
	Label claim_id = 'CLAIM ID';
	Label cpe_approve_ind = 'APPROVAL INDICATOR';
	Label source = 'SOURCE';
	Label ent_by_fname='CREATED BY FIRST NAME';
	Label ent_by_lname='CREATED BY LAST NAME';
	Label ent_by_m_alpha_id = 'CREATED BY ALPHA ID';
 	Label ent_by_n_user_id='CREATED BY NTID';
	Label std_e_addr='EMPLOYEE STANDARDIZED ADDRESS';
 	Label std_payee_addr='PAYEE STANDARDIZED ADDRESS';
	Label std_mailto_addr='MAILED TO STANDARDIZED ADDRESS';
	Label e_city='EMPLOYEE CITY';
 	Label e_region='EMPLOYEE STATE';
 	Label e_street='EMPLOYEE STREET';
	Label C_PT_CLM_LINE_CD ='C_PT_CLM_LINE_CD ';
	Label C_PT_LOSS_ST_CD='C_PT_LOSS_ST_CD';
	Label N_PT_LOSS_YR='N_PT_LOSS_YR';
	Label run_key = 'RUN KEY';
 	Label run_description = 'RUN DESCRIPTION';

	Label contributor1 = 'PRIMARY DRIVER OF SCORE';
	Label contributor2 = 'CONTRIBUTOR 2';
	Label contributor3 = 'CONTRIBUTOR 3';
	Label contributor4 = 'CONTRIBUTOR 4';
	Label contributor5 = 'CONTRIBUTOR 5';
	Label contributor6 = 'CONTRIBUTOR 6';
	Label contributor7 = 'CONTRIBUTOR 7';
	Label contributor8 = 'CONTRIBUTOR 8';
	Label contributor9 = 'CONTRIBUTOR 9';
	Label contributor10 = 'CONTRIBUTOR 10';
	Label contributor11 = 'CONTRIBUTOR 11';
	Label contributor12 = 'CONTRIBUTOR 12';
	Label contributor13 = 'CONTRIBUTOR 13';
	Label contributor14 = 'CONTRIBUTOR 14';
	Label contributor15 = 'CONTRIBUTOR 15';

	if dist_missing_treated = 1 then distance_mailto_emp = .;
	num_part_fnolplus30_1 = num_participant - num_part_fnolplus30;
	num_pass_fnolplus30_1 = num_passenger - num_pass_fnolplus30;
run;

data cpat.base_pqr (drop=dist_missing_treated);
	set cpat.base_pqr;
	Label num_part_fnolplus30 = 'PARTICIPANT ADDED 30 DAYS AFTER FNOL';
	Label num_pass_fnolplus30 = 'NUM OF PASSENGER ADDED 30 DAYS AFTER FNOL';
	Label employee_zip='EMPLOYEE ZIP';
run;

/*DSM Enhancements*/

/*names of payees*/
proc sql;
create table data.dsm_payee_new_attribute as
select distinct n_pymnt_id, n_payee_pyr_dtl_id, n_invl_role_id, n_name_id, n_tax_id
from source.ewt_payee_payor_dtl_ng
where n_pymnt_id in (select distinct n_pymnt_id from data.dsm_base_pymnt_dtl)
and e42_c_adw_rcd_del='N';
quit;

proc sql;
create table data.dsm_payee_names_new_atr as
select distinct a.*, b.m_first_name, b.m_last_name, b.m_org_name
from data.dsm_payee_new_attribute a left join source.ewt_client_name_ng b
on a.n_name_id=b.n_name_id
and b.e58_c_adw_rcd_del='N';
quit;

data data.dsm_payee_names_input (keep = n_pymnt_id payee);
set data.dsm_payee_names_new_atr;
if m_org_name = "" then payee = trim(m_first_name)||" "||trim(m_last_name)||";";
else payee=trim(m_org_name)||";";
run;

proc sort data=data.dsm_payee_names_input out=data.dsm_payee_names_sort;
by n_pymnt_id;
run;

PROC TRANSPOSE DATA=data.dsm_payee_names_sort OUT=data.dsm_payee_names_trans prefix=payee;
BY n_pymnt_id;
var payee;
RUN;

proc sql;
create table data.count as select n_pymnt_id, count(payee) as count from data.dsm_payee_names_input
group by n_pymnt_id;
quit;

data data.dsm_payee_names_trans_final;
merge data.dsm_payee_names_trans(in=a) data.count(in=b);
by n_pymnt_id;
run;

data data.dsm_payee_names_pre_final;
set data.dsm_payee_names_trans_final;
  length payee_others $200;
  array allvars [*] _character_;
	  do i=5 to dim(allvars);
	    if substr(upcase(vname(allvars[i])),1,5) = 'PAYEE' and count>4 then
	      payee_others = trim(payee_others)||' '||left(put(allvars[i],8.));
	  end;
run;

data data.attribute3_final (keep = n_pymnt_id payee1 payee2 payee3 payee4 payee_others);
set data.dsm_payee_names_pre_final;
run;


/*tax ids of payees*/
data data.dsm_payee_tax_input (keep = n_pymnt_id tax_id);
set data.dsm_payee_new_attribute;
tax_id=trim(n_tax_id)||";";
run;

proc sort data=data.dsm_payee_tax_input out=data.dsm_payee_tax_sort;
by n_pymnt_id;
run;

PROC TRANSPOSE DATA=data.dsm_payee_tax_sort OUT=data.dsm_payee_tax_trans prefix=tax_id;
BY n_pymnt_id;
var tax_id;
RUN;

proc sql;
create table data.count_tax as select n_pymnt_id, count(tax_id) as count from data.dsm_payee_tax_input
group by n_pymnt_id;
quit;

data data.dsm_payee_tax_trans_final;
merge data.dsm_payee_tax_trans(in=a) data.count_tax(in=b);
by n_pymnt_id;
run;

data data.dsm_payee_tax_pre_final;
set data.dsm_payee_tax_trans_final;
  length tax_others $200;
  array allvars [*] _character_;
	  do i=5 to dim(allvars);
	    if substr(upcase(vname(allvars[i])),1,5) = 'TAX_ID' and count>4 then
	      tax_others = trim(tax_others)||' '||left(put(allvars[i],8.));
	  end;
run;

data data.attribute4_final (keep = n_pymnt_id tax_id1 tax_id2 tax_id3 tax_id4 tax_others);
set data.dsm_payee_tax_pre_final;
run;


/*check from and to dates*/
proc sql;
create table data.check_dates_pymnt_detail as 
select distinct a.*, pd.d_srvc_start_dt, pd.d_srvc_end_dt
from data.dsm_base_pymnt_dtl a left join source.ewt_payment_dtl_ng pd
on a.E19_N_PT_LOSS_YR = pd.E19_N_PT_LOSS_YR
and a.E19_C_PT_CLM_LINE_CD = pd.E19_C_PT_CLM_LINE_CD
and a.E19_C_PT_LOSS_ST_CD = pd.E19_C_PT_LOSS_ST_CD
and a.E19_n_ADW_CLAIM_ID = pd.E19_N_ADW_CLAIM_ID
and a.n_line_id = pd.n_line_id
and pd.E19_C_ADW_RCD_DEL = 'N'
;
quit;

proc sort data = data.check_dates_pymnt_detail out = data.check_dates_payment_level (keep = 
						n_pymnt_id
						a_fin_tx_amt
						e19_n_pt_loss_yr
						e19_c_pt_clm_line_cd
						e19_c_pt_loss_st_cd
						e19_n_adw_claim_id
						n_line_id
						d_srvc_start_dt
						d_srvc_end_dt
						c_line_type) nodupkey;
	by n_pymnt_id descending a_fin_tx_amt;
run;

proc sort data = data.check_dates_payment_level(drop=a_fin_tx_amt) nodupkey; /*to merge with dsm_base_pymnts*/
	by n_pymnt_id;
run;

/*merging new attributes*/
proc sql;
create table cpat.base_pqr_final as
select a.*, b.payee1, b.payee2, b.payee3, b.payee4, b.payee_others, 
c.tax_id1, c.tax_id2, c.tax_id3, c.tax_id4, c.tax_others,
d.d_srvc_start_dt as chk_from_dt, d.d_srvc_end_dt as chk_to_dt
from cpat.base_pqr a left join data.attribute3_final b
on a.n_pymnt_id=b.n_pymnt_id
left join data.attribute4_final c
on a.n_pymnt_id=c.n_pymnt_id
left join data.check_dates_payment_level d
on a.n_pymnt_id=d.n_pymnt_id
;
quit;

/*data cpat.base_pqr_final;*/
/*set cpat.base_pqr_final;*/
/*chk_from_dt = datepart(chk_from_dt);*/
/*chk_to_dt = datepart(chk_to_dt);*/
/*coverage_open_date = datepart(coverage_open_date);*/
/*coverage_closed_date = datepart(coverage_closed_date);*/
/*run;*/

/*data cpat.base_pqr_final;*/
/*set cpat.base_pqr_final;*/
/*format chk_from_dt mmddyy10.;*/
/*informat chk_from_dt mmddyy10.;*/
/*format chk_to_dt mmddyy10.;*/
/*informat chk_to_dt mmddyy10.;*/
/*format coverage_open_date mmddyy10.;*/
/*informat coverage_open_date mmddyy10.;*/
/*format coverage_closed_date mmddyy10.;*/
/*informat coverage_closed_date mmddyy10.;*/
/*run;*/

data cpat.final (drop=cnt_nd_rei_exceptions cnt_nvd_rei_exceptions total_est_count);
set cpat.base_pqr_final;
run;

data cpat.final;
set cpat.final;
primary_contributors=trim(trim(contributor1)||" "||trim(contributor2)||" "||trim(contributor3)||" "
||trim(contributor4)||" "||trim(contributor5)||" "||trim(contributor6)||" "||trim(contributor7)||" "
||trim(contributor8)||" "||trim(contributor9)||" "||trim(contributor10)||" "||trim(contributor11)||" "
||trim(contributor12)||" "||trim(contributor13)||" "||trim(contributor14)||" "||trim(contributor15));
Label primary_contributors = 'PRIMAY CONTRIBUTORS';
primary_contributors = upcase( primary_contributors );
run;

proc sql; 
create table cpat.final_upload as 
select 
	run_key,
	run_description,
	n_pymnt_id,
	claim_id,
	N_PT_LOSS_YR,
	C_PT_CLM_LINE_CD,
	C_PT_LOSS_ST_CD,
	percentile_score,
	model_score,
	primary_contributors,
	mco,
	n_claim_number,
	chk_nbr,
	payment_amount,
	d_issue_dt,
	payment_method,
	c_line_type,
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
	cpe_cd1_payee_zip_plus4,
	mail_to_zip,
	std_payee_addr,
	std_mailto_addr,
	max_supplement_number,
	average_rbi_score,
	rei_count,
	supplement_frequency,
	check_mark_p,
	check_mark_q,
	check_mark_r,
	flag_nbr_spplmt_gt_50pct_int_est,
	average_estimate,
	average_supplement,
	n_model_year_nbr,
	m_make_nm,
	m_model_nm,
	num_participant,
	num_part_fnolplus30,
	num_passenger,
	num_pass_fnolplus30,
	emp_first_nm,
	emp_last_nm,
	ntid,
	e_street,
	e_city,
	e_region,
	employee_zip,
	std_e_addr,
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
	agent_code,
	agent_name,
	ent_by_m_alpha_id,
 	ent_by_n_user_id,
	ent_by_fname,
	ent_by_lname,
	cpe_approve_ind,
	coverage_open_date,
	coverage_closed_date,
	payee1,
	payee2,
	payee3,
	payee4,
	payee_others, 
	tax_id1,
	tax_id2,
	tax_id3,
	tax_id4,
	tax_others,
	chk_from_dt,
	chk_to_dt,
	source
from cpat.final;
quit;

data cpat.final_upload (rename=(flag_nbr_spplmt_gt_50pct_int_est=supp_50pct_int_est check_mark_p=CHECK_MRK_1_IND
	check_mark_q=CHECK_MRK_2_IND
	check_mark_r=CHECK_MRK_3_IND));
	Label average_estimate = 'AVERAGE ESTIMATE';
	Label average_supplement = 'AVERAGE SUPPLEMENT';
	Label coverage_open_date = 'COVERAGE OPEN DATE';
	Label coverage_closed_date = 'COVERAGE CLOSED DATE';
	Label payee1 = 'PAYEE1';
	Label payee2 = 'PAYEE2';
	Label payee3 = 'PAYEE3';
	Label payee4 = 'PAYEE4';
	Label payee_others = 'PAYEE_OTHERS';
	Label tax_id1 = 'TAX ID1';
	Label tax_id2 = 'TAX ID2';
	Label tax_id3 = 'TAX ID3';
	Label tax_id4 = 'TAX ID4';
	Label tax_others = 'TAX ID OTHERS';
	Label chk_from_dt = 'CHECK FROM DATE';
	Label chk_to_dt = 'CHECK TO DATE';
set cpat.final_upload;
run;

data cpat.final_upload_&version.;
set cpat.final_upload;
 primary_contributors = upcase( primary_contributors );
 run_description  = upcase( run_description );
 n_pymnt_id = upcase( n_pymnt_id);
 N_PT_LOSS_YR = upcase( N_PT_LOSS_YR);
 C_PT_CLM_LINE_CD = upcase( C_PT_CLM_LINE_CD);
 C_PT_LOSS_ST_CD = upcase( C_PT_LOSS_ST_CD);
 mco = upcase( mco);
 n_claim_number = upcase( n_claim_number);
 chk_nbr = upcase( chk_nbr);
 payment_method = upcase( payment_method);
 c_line_type = upcase( c_line_type);
 c_line_type_desc = upcase( c_line_type_desc);
 m_alpha_id = upcase( m_alpha_id);
 payee_nm = upcase( payee_nm);
 insured_name = upcase( insured_name);
 mail_to_nm = upcase( mail_to_nm);
 payee_addr_ln = upcase( payee_addr_ln);
 mail_to_street = upcase( mail_to_street);
 payee_city_nm = upcase( payee_city_nm);
 mail_to_city = upcase( mail_to_city);
 payee_st_cd = upcase( payee_st_cd);
 mail_to_state = upcase( mail_to_state);
 payee_zip_cd = upcase( payee_zip_cd);
 cpe_cd1_payee_zip_plus4 = upcase( cpe_cd1_payee_zip_plus4);
 mail_to_zip = upcase( mail_to_zip);
 std_payee_addr = upcase( std_payee_addr);
 std_mailto_addr = upcase( std_mailto_addr);
 max_supplement_number = upcase( max_supplement_number);
 n_model_year_nbr = upcase( n_model_year_nbr);
 m_make_nm = upcase( m_make_nm);
 m_model_nm = upcase( m_model_nm);
 emp_first_nm = upcase( emp_first_nm);
 emp_last_nm = upcase( emp_last_nm);
 ntid = upcase( ntid);
 e_street = upcase( e_street);
 e_city = upcase( e_city);
 e_region = upcase( e_region);
 employee_zip = upcase( employee_zip);
 std_e_addr = upcase( std_e_addr);
 line_of_business = upcase( line_of_business);
 detail_loss_type = upcase( detail_loss_type);
 coverage_handling_strategy = upcase( coverage_handling_strategy);
 peril = upcase( peril);
 sub_peril = upcase( sub_peril);
 c_reported_by = upcase( c_reported_by);
 t_oth_reported_by = upcase( t_oth_reported_by);
 agent_code = upcase( agent_code);
 agent_name = upcase( agent_name);
 ent_by_m_alpha_id = upcase( ent_by_m_alpha_id);
 ent_by_n_user_id = upcase(  ent_by_n_user_id);
 ent_by_fname = upcase( ent_by_fname);
 ent_by_lname = upcase( ent_by_lname);
 cpe_approve_ind = upcase( cpe_approve_ind);
 payee1 = upcase(payee1);
 payee2 = upcase(payee2);
 payee3 = upcase(payee3);
 payee4 = upcase(payee4);
 payee_others = upcase(payee_others);
 source = upcase(source);
 run;
data new.final_output_&version.;
set cpat.final_upload_&version.;
run;

/*proc sql;*/
/*drop table nkoda.DSM_pymnt_vehicle_info_final;*/
/*quit;*/


