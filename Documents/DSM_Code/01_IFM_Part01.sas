libname internal '/work/ew07/projects/prod/icf/dat';
libname it '/work/ew07/projects/prod/icf/dat/inter';

data _NULL_;
 d = date();/*Change*/
 call symput('monthname',substr(put(intnx('month',d,0),monyy.),1,3)||'20'||substr(put(intnx('month',d,0),monyy.),4,2)); 
run;
/* Delete SAS Log file if it is already there with the same name*/

/*%let saslogfile = /work/ew07/projects/prod/icf/programs/logs/icfsascode_&monthname._log.log;*/
/*X "%str(rm %"&saslogfile%")";*/

/*PROC PRINTTO LOG ="/work/ew07/projects/prod/icf/programs/logs/icfsascode_&monthname._log.log";*/
/*RUN;*/

/* Delete folder which is more than six months old */
/*data _NULL_;*/
/*	d = date();change*/
/*	call symput('monthname1',substr(put(intnx('month',d,-6),monyy.),1,3)||'20'||*/
/*		substr(put(intnx('month',d,-7),monyy.),4,2)); 		*/
/*run;*/
/**/
/*%let prtxtfi1 = /work/ew07/projects/prod/icf/output/&monthname1._output;*/

X "%str(rm -rf %"&prtxtfi1%")";

/* Delete previous month input files */

/*data _NULL_;*/
/* d = date();*/
/* call symput('lastmonthday1',"20"||substr(put(intnx('month',d,-1,'e'),yymmdd6.),1,4)||"15");*/
/*run;*/

/*%let abi_inputfile = internal.icf_p2_&lastmonthday1._2yr.dat;*/
/*%let sas_inputfile = internal.icf_p2_&lastmonthday1._2yr;*/

/*X "%str(rm %"&abi_inputfile%")";*/
/*X "%str(rm %"&sas_inputfile%")";*/

/* Put the previous month name and year value into monthname variable */

data _NULL_;/*change*/
 d = date();
 call symput('lastmonthday',"20"||substr(put(intnx('month',d,-0,'e'),yymmdd6.),1,4)||"01");
run;


data _NULL_;
	d = date();/*change*/
	call symput('monthname2',substr(put(intnx('month',d,0),monyy.),1,3)||'20'||
		substr(put(intnx('month',d,0),monyy.),4,2)); 		
run;


/*%let prtxtfi =/work/ew07/projects/prod/icf/output/&monthname2._output/;*/

/* Create folder with Previous Monthname */
/*X "%str(mkdir %"&prtxtfi%")";*/

/* Move Previous Run XLS files to Previous Monthname folder */
/*X "mv /work/ew07/projects/prod/icf/output/*.xls &prtxtfi";*/

%let cpat = it.no_problems;
%let scored_data = internal.ICF_&monthname._scored_data;


data internal.icf_p2_&lastmonthday._2yr;
     infile
 "/work/ew07/projects/prod/icf/dat/icf_p2_&lastmonthday._2yr.dat" dlm='01'x
 recfm=v lrecl=2000 dsd missover;
     input
       cpe_claim_id :$13.
       cpe_clm_check_nbr :$10.
       cpe_clm_check_amt
       cpe_claim_nbr :$10.
       cpe_check_trans_dt :yymmdd8.
       cpe_check_genr_t_cd $
       cpe_clm_rep_id $
       cpe_desk_loc_cd $
       cpe_payee_nm :$234.
       cpe_mail_to_nm :$40.
       cpv_cov_cd $
       cpv_invl_party_id $
       wci_injury_cd $
       wcm_clm_line_cd $
       wcm_company_cd $
       wcm_loss_rpt_dt : yymmdd8.
       wcm_mco_cd $
       cpe_approve_ind $
       pnm_insured_nm :$200.
       cpe_cd1_mail_to_address :$40.
       cpe_cd1_mail_to_city :$15.
       cpe_cd1_mail_to_state $
       cpe_cd1_mail_to_zip_code_1 $
       cpe_cd1_mail_to_zip_plus4 $
       cpe_cd1_payee_address :$40.
       cpe_cd1_payee_city :$15.
       cpe_cd1_payee_state $
       cpe_cd1_payee_zip_code_1 $
       cpe_cd1_payee_zip_plus4 $
       emp_alpha_id $
       emp_dco_cd $
       emp_ro_cd $
       emp_emply_roc_cd $
       emp_company_id :$10.
       emp_desk_loc_id $
       emp_location_id $
       emp_first_name :$20.
       emp_middle_name $
       emp_last_name :$30.
       emp_bi_per_inj_amt
       emp_bi_per_fle_amt
       emp_cpl_bi_inj_amt
       emp_med_pr_inj_amt
       emp_med_pr_fle_amt
       emp_pip_pr_inj_amt
       emp_pip_pr_fle_amt
       emp_ni_auto_amt
       emp_ni_prop_amt
       emp_cpl_prpop_amt
       emp_expense_amt
       emp_loss_use_amt
       emp_adj_st_reg_nbr $
       emp_empl_status_cd $
       emp_location_desc :$25.
       emp_org_level1_cd
       emp_org_level2_cd
       emp_org_level3_cd
       emp_org_level4_cd
       emp_org_level5_cd
       emp_org_level6_cd
       emp_org_level7_cd
       emp_org_level8_cd
       emp_org_level9_cd       
       emp_cd1_address :$40.
       emp_cd1_city :$15.
       emp_cd1_state $
       emp_cd1_zip_cd_1 $
       emp_cd1_zip_4 $       
       emp_selected_amt;

	   if wci_injury_cd = 'Y'
	   then wci_injury_cd = '4';

run;
/********************************************************************************************************************
****************************** MAINFRAME TO SAS CONVERSION - ADDITION OF LATITUDE AND LOGITUDE***********************
********************************************************************************************************************/

Data internal.icf_p2_&lastmonthday._2yr_1 (drop = cpe_cd1_mail_to_zip_code_1 cpe_cd1_payee_zip_code_1 emp_cd1_zip_cd_1 
mail_to_zip_clean payee_zip_clean emp_zip_clean);
set internal.icf_p2_&lastmonthday._2yr;
if length(cpe_cd1_mail_to_zip_code_1) < 5 
			then mail_to_zip_clean = catt(repeat('0',5-length(cpe_cd1_mail_to_zip_code_1)),cpe_cd1_mail_to_zip_code_1);
else if length(cpe_cd1_mail_to_zip_code_1) >= 5 
			then mail_to_zip_clean = substr(compress(cpe_cd1_mail_to_zip_code_1),1,5);
if length(cpe_cd1_payee_zip_code_1) < 5 
			then payee_zip_clean = catt(repeat('0',5-length(cpe_cd1_payee_zip_code_1)),cpe_cd1_payee_zip_code_1);
else if length(cpe_cd1_payee_zip_code_1) >= 5 
			then payee_zip_clean = substr(compress(cpe_cd1_payee_zip_code_1),1,5);
if length(emp_cd1_zip_cd_1) < 5 
			then emp_zip_clean = catt(repeat('0',5-length(emp_cd1_zip_cd_1)),emp_cd1_zip_cd_1);
else if length(emp_cd1_zip_cd_1) >= 5 
			then emp_zip_clean = substr(compress(emp_cd1_zip_cd_1),1,5);
emp_cd1_zip_cd= emp_zip_clean*1;
cpe_cd1_payee_zip_code = payee_zip_clean*1;
cpe_cd1_mail_to_zip_code = mail_to_zip_clean*1;

run;

proc sql;
create table internal.icf_p2_&lastmonthday._2yr as 
(Select a.*,
b.y as emp_cd1_ycor,
b.x as emp_cd1_xcor
from
internal.icf_p2_&lastmonthday._2yr_1 as a  left join 
sashelp.zipcode as b on a.emp_cd1_zip_cd = b.zip);
quit;

proc sql;
create table internal.icf_p2_&lastmonthday._2yr_1 as 
(Select a.*,
b.y as cpe_cd1_payee_ycor,
b.x as cpe_cd1_payee_xcor
from	
internal.icf_p2_&lastmonthday._2yr as a  left join 
sashelp.zipcode as b on a.cpe_cd1_payee_zip_code = b.zip);
quit;

proc sql;
create table internal.icf_p2_&lastmonthday._2yr as 
(Select a.*,
b.y as cpe_cd1_mail_to_ycor,
b.x as cpe_cd1_mail_to_xcor
from
internal.icf_p2_&lastmonthday._2yr_1 as a  left join 
sashelp.zipcode as b on a.cpe_cd1_mail_to_zip_code = b.zip);
quit;
proc sql;
drop table internal.icf_p2_&lastmonthday._2yr_1;
quit;


/*data internal.icf_p2_&lastmonthday._2yr (drop = emp_cd1_ycor1);*/
/*set internal.icf_p2_&lastmonthday._2yr;*/
/*emp_cd1_ycor = input(emp_cd1_ycor1,best12.);*/
/*run;*/

proc sort data=internal.icf_p2_&lastmonthday._2yr;
     by cpe_claim_id cpe_clm_check_nbr cpe_clm_check_amt;
run;

data it.no_problems;
   set internal.icf_p2_&lastmonthday._2yr; /*Update with latest month Dataset Name*/     
	if cpe_clm_rep_id not in (' ','0000');
run;

*******MUST SET*****************;
/* Data set to be used as base*/
%let cpat = it.no_problems;
*%let cpat = test10k_complete;
/*Dataset to be output*/
%let scored_data = internal.ICF_&monthname._scored_data;/*Update with latest month information*/    
*%let scored_data = internal.test_scored_output;
********************************;

/*Calculate the number of times a name-address pair appear as payee and the percentage of that
  payee a the rep has written*/

*Keep only vars needed for calculations;
data it.limited(keep=cpe_payee_nm cpe_cd1_payee_address cpe_claim_id cpe_claim_nbr cpe_clm_rep_id cpe_clm_check_amt cpe_clm_check_nbr);
  set &cpat;
/*This removes some of the coverages and very small check amounts from the data-this was done for Connie's report;
don't think we want this here*/
  *if cpv_cov_cd not in ('VA','UU','SS','SU','CC','CX') and cpe_clm_check_amt > 4.50;
run;

*Count how many times a name-address combo occur;
proc sort data=it.limited;
  by cpe_payee_nm cpe_cd1_payee_address cpe_clm_rep_id;
run;

data it.count_payee (keep=cpe_payee_nm cpe_cd1_payee_address payee_count);
  set it.limited;
  by  cpe_payee_nm cpe_cd1_payee_address;
  retain payee_count;
  if first.cpe_cd1_payee_address then payee_count = 0;
  payee_count = payee_count+1;
  if last.cpe_cd1_payee_address then output it.count_payee;
run;

*Calculate how many times a name-address combo occurs for each rep;
data it.rep_pct(keep=cpe_payee_nm cpe_cd1_payee_address cpe_clm_rep_id payee_num_rep_payment
                        payee_avg_rep_payment cpe_clm_check_nbr);
  set it.limited;
  by cpe_payee_nm cpe_cd1_payee_address cpe_clm_rep_id;
  retain count amt;
  if first.cpe_clm_rep_id then do;
      count=0;
          amt=0;
        end;
  count = count+1;
  amt = amt+cpe_clm_check_amt;
  if last.cpe_clm_rep_id then do;
     payee_avg_rep_payment = round(amt/count,.01);
         payee_num_rep_payment = count;
         output it.rep_pct;
   end;
run;

/*Aggregate payee and rep info from last 2 steps and join with limited data*/
proc sql;
  create table it.payee_rep_info as
  select l.*, c.payee_count, r.payee_num_rep_payment, round(r.payee_num_rep_payment/c.payee_count,.0001) as payee_rep_pct
  from it.limited l, it.count_payee c, it.rep_pct r
  where l.cpe_payee_nm = c.cpe_payee_nm = r.cpe_payee_nm and
                l.cpe_cd1_payee_address = c.cpe_cd1_payee_address = r.cpe_cd1_payee_address and
                l.cpe_clm_rep_id = r.cpe_clm_rep_id;
quit;


/*Keep only vars to be used in calculating derived variables*/
data it.limited (keep= wcm_clm_line_cd wcm_mco_cd cpe_claim_id cpv_cov_cd cpe_clm_check_amt cpe_clm_rep_id
                    cpe_check_trans_dt cpe_clm_check_nbr cpe_claim_nbr wcm_loss_rpt_dt cpe_desk_loc_cd cpv_invl_party_id
                                        cpe_payee_nm cpe_cd1_payee_address 
                        compress=yes);
   set &cpat;
run;

/*3. Relative total payment amount by coverage*/

proc sort data=it.limited;
  by cpe_claim_id cpv_cov_cd;
run;

/*Add up check payments per claim by coverage*/
data it.temp (keep= cpe_claim_id wcm_clm_line_cd wcm_mco_cd cpv_cov_cd cov_pay cpe_claim_nbr compress=yes);
  set it.limited;
by cpe_claim_id cpv_cov_cd;
retain cov_pay;
/*exclude BI*/
if wcm_clm_line_cd in ('010','012','016','019','037') then do; /*Auto lines*/
        if substr(cpv_cov_cd,1,1) not in ('A','S');/*exlcude BI & UM*/
end;
else if cpv_cov_cd not in ('XX','YY');/*exclude HO lines liability*/if first.cpv_cov_cd then cov_pay = 0;
cov_pay = cov_pay+ cpe_clm_check_amt;
if last.cpv_cov_cd then output;
run;

/*Find average claim payment by mco & line & coverage*/
proc sort data= it.temp;
   by wcm_mco_cd wcm_clm_line_cd cpv_cov_cd;
run;

data it.temp2 (keep= wcm_clm_line_cd wcm_mco_cd cpv_cov_cd avg_cov_pay cpe_claim_nbr compress=yes);
  set it.temp;
by wcm_mco_cd wcm_clm_line_cd cpv_cov_cd;
retain num_claims tot_cov_pay;
if first.cpv_cov_cd then do;
        tot_cov_pay = 0;
        num_claims=0;
end;
        tot_cov_pay = tot_cov_pay+ cov_pay;
        num_claims = num_claims+1;
if last.cpv_cov_cd then do;
        avg_cov_pay = tot_cov_pay/num_claims;
        output;
end;
run;
/*Aggregate individual claim and average payment amount info - calc relativity*/
proc sql;
  create table it.t_rel_cov_pay as
  select t1.wcm_clm_line_cd, t1.wcm_mco_cd, t1.cpe_claim_id,t1.cpe_claim_nbr, t1.cpv_cov_cd, (t1.cov_pay/t2.avg_cov_pay) as rel_cov_pay
  from it.temp t1, it.temp2 t2
  where t1.wcm_clm_line_cd = t2.wcm_clm_line_cd and
        t1.wcm_mco_cd = t2.wcm_mco_cd and
                t1.cpv_cov_cd = t2.cpv_cov_cd;
quit;
/*#5. Relative number of single payment claims*/

proc sort data=it.limited;
  by cpe_claim_nbr;
run;

/*Count # of check payments per claim - exclude Auto Express offices*/
data it.temp (keep= cpe_claim_nbr wcm_mco_cd wcm_clm_line_cd one_pay compress=yes);
  set it.limited;
by cpe_claim_nbr;
retain num_pay;
*if wcm_mco_cd not in ('8300','8310','8280') and cpe_desk_loc_cd not in ('XP1','XP2','XP3'); *Identifies Auto Express Codes;
if first.cpe_claim_nbr then num_pay = 0;
num_pay = num_pay+1;
if last.cpe_claim_nbr then do;
        if num_pay = 1 then one_pay=1;
    else one_pay=0;
        output;
end;
run;

proc sql;
  create table it.temp2 as
  select t.*, c.cpe_clm_rep_id, c.cpe_clm_check_nbr
  from it.limited c left join it.temp t
    on c.cpe_claim_nbr = t.cpe_claim_nbr and
                c.wcm_mco_cd = t.wcm_mco_cd and
                c.wcm_clm_line_cd = t.wcm_clm_line_cd;
quit;

/*Find # of one payments by alpha ID*/
proc sort data= it.temp2;
   by cpe_clm_rep_id;
run;

data it.temp3 (keep= cpe_clm_rep_id wcm_mco_cd wcm_clm_line_cd tot_one_pay compress=yes);
  set it.temp2;
by cpe_clm_rep_id;
retain tot_one_pay;
if first.cpe_clm_rep_id then tot_one_pay = 0;
        tot_one_pay = tot_one_pay+one_pay;
if last.cpe_clm_rep_id then output;
run;

/*Find average # of one payments by line mco*/
proc sort data=it.temp3;
 by wcm_mco_cd wcm_clm_line_cd cpe_clm_rep_id;
run;

data it.temp4 (keep= wcm_clm_line_cd wcm_mco_cd line_one_check avg_one_check compress=yes);
  set it.temp3;
by wcm_mco_cd wcm_clm_line_cd;
retain line_one_check num_reps;
if first.wcm_clm_line_cd then do;
                line_one_check = 0;
                num_reps = 0;
end;
        line_one_check = line_one_check + tot_one_pay;
        num_reps = num_reps+1;
if last.wcm_clm_line_cd then do;
        avg_one_check = line_one_check/num_reps;
        output;
end;
run;
/*Aggregate individual rep and line/mco info - calc relativity*/

proc sql;
  create table it.t_rel_single_pay_temp as
  select t3.cpe_clm_rep_id, t3.wcm_mco_cd, t3.wcm_clm_line_cd, t3.tot_one_pay,
                 t4.line_one_check, t4.avg_one_check
  from  it.temp3 t3, it.temp4 t4
  where t3.wcm_mco_cd = t4.wcm_mco_cd and
                t3.wcm_clm_line_cd = t4.wcm_clm_line_cd;

  create table it.t_rel_single_pay as
  select t2.cpe_claim_nbr, t2.cpe_clm_check_nbr, t2.one_pay, t.*, (t.tot_one_pay/t.avg_one_check) as rel_single_pay
  from it.temp2 t2 left join it.t_rel_single_pay_temp t
  on t2.cpe_clm_rep_id = t.cpe_clm_rep_id
 order by cpe_clm_rep_id, wcm_clm_line_cd, wcm_mco_cd;
quit;

data it.t_rel_single_pay;
  set it.t_rel_single_pay;
  if rel_single_pay = . then rel_single_pay = 1;
run;

/*7. Relative duration of payments */

proc sort data= it.limited;
   by cpe_claim_id cpe_check_trans_dt;
run;

/*Calc days between first payment and last payment */
data it.temp (keep= wcm_clm_line_cd wcm_mco_cd cpe_claim_id cpe_claim_nbr pay_duration compress=yes);
  set it.limited;
by cpe_claim_id cpe_check_trans_dt;
retain pay_duration check1;
if first.cpe_claim_id then check1 = cpe_check_trans_dt;
if last.cpe_claim_id then do;
        pay_duration = cpe_check_trans_dt - check1;
        output;
end;
run;

/*Find average duration by mco & line*/
proc sort data= it.temp;
   by wcm_mco_cd wcm_clm_line_cd;
run;

data it.temp2 (keep= wcm_clm_line_cd wcm_mco_cd avg_pay_duration compress=yes);
  set it.temp;
by wcm_mco_cd wcm_clm_line_cd;
retain num_claims tot_duration;
if first.wcm_clm_line_cd then do;
        tot_duration = 0;
        num_claims=0;
end;
        tot_duration = tot_duration+pay_duration;
        num_claims = num_claims+1;
if last.wcm_clm_line_cd then do;
        avg_pay_duration = tot_duration/num_claims;
        output;
end;
run;
/*Aggregate individual claim and average duration - calc relativity*/
proc sql;
  create table it.t_rel_pay_duration as
  select t1.wcm_clm_line_cd, t1.wcm_mco_cd, t1.cpe_claim_id, t1.cpe_claim_nbr,(t1.pay_duration/t2.avg_pay_duration) as rel_pay_duration
  from it.temp t1, it.temp2 t2
  where t1.wcm_clm_line_cd = t2.wcm_clm_line_cd and
        t1.wcm_mco_cd = t2.wcm_mco_cd;
quit;

data it.t_rel_pay_duration;
  set it.t_rel_pay_duration;
  if rel_pay_duration = . then rel_pay_duration = 1;
run;


/*#17. Rel number of last payouts for a claim*/

proc sort data = it.limited;
 by cpe_claim_nbr cpe_check_trans_dt;
run;

/*Count # of last checks*/
data it.temp (keep= cpe_clm_rep_id cpe_clm_check_nbr cpe_claim_nbr cpe_claim_nbr wcm_mco_cd
                        wcm_clm_line_cd cpe_payee_nm cpe_cd1_payee_address last_pay compress=yes);
  set it.limited;
by cpe_claim_nbr cpe_check_trans_dt;
*if wcm_mco_cd not in ('8300','8310','8280') and cpe_desk_loc_cd not in ('XP1','XP2','XP3'); *Identifies Auto Express Codes;
if last.cpe_check_trans_dt then last_pay = 1;
else last_pay=0;
output;
run;

/*Find # of one payments by alpha ID*/
proc sort data= it.temp;
   by cpe_clm_rep_id;
run;

data it.temp2 (keep= cpe_clm_rep_id wcm_mco_cd wcm_clm_line_cd tot_last_pay compress=yes);
  set it.temp;
by cpe_clm_rep_id;
retain tot_last_pay;
if first.cpe_clm_rep_id then tot_last_pay = 0;
        tot_last_pay = tot_last_pay+last_pay;
if last.cpe_clm_rep_id then output;
run;

/*Find average # of one payments by line mco*/
proc sort data=it.temp2;
 by wcm_mco_cd wcm_clm_line_cd cpe_clm_rep_id;
run;

data it.temp3 (keep= wcm_clm_line_cd wcm_mco_cd line_last_check avg_last_pay compress=yes);
  set it.temp2;
by wcm_mco_cd wcm_clm_line_cd;
retain line_last_check num_reps;
if first.wcm_clm_line_cd then do;
                line_last_check = 0;
                num_reps = 0;
end;
        line_last_check = line_last_check + tot_last_pay;
        num_reps = num_reps+1;
if last.wcm_clm_line_cd then do;
        avg_last_pay = line_last_check/num_reps;
        output;
end;
run;
/*Aggregate individual rep and line/mco info - calc relativity*/

proc sql;
  create table it.t_rel_last_pay_temp as
  select t2.cpe_clm_rep_id, t2.wcm_mco_cd, t2.wcm_clm_line_cd, t2.tot_last_pay,
                 t3.line_last_check, t3.avg_last_pay
  from  it.temp2 t2, it.temp3 t3
  where t2.wcm_mco_cd = t3.wcm_mco_cd and
                t2.wcm_clm_line_cd = t3.wcm_clm_line_cd;

  create table it.t_rel_last_pay as
  select t1 cpe_claim_nbr, t1.cpe_clm_check_nbr, t1.cpe_payee_nm, t1.cpe_cd1_payee_address, t.*, (t.tot_last_pay/t.avg_last_pay) as rel_last_pay
  from it.temp t1 left join it.t_rel_last_pay_temp t
  on t1.cpe_clm_rep_id = t.cpe_clm_rep_id
 order by cpe_clm_rep_id, wcm_clm_line_cd, wcm_mco_cd;
quit;

/*3a. Number of involved parties - limiting to those getting checks*/

proc sort data= it.limited;
   by cpe_claim_nbr cpv_invl_party_id;
run;

/*Count # of involved parties w/checks per claim*/
data it.t_num_ip (keep= cpe_claim_nbr num_ip compress=yes);
  set it.limited;
by cpe_claim_nbr cpv_invl_party_id;
retain num_ip;
if first.cpe_claim_nbr then num_ip = 0;
if first.cpv_invl_party_id then num_ip = num_ip+1;
if last.cpe_claim_nbr then output;
run;

%let ID_var =
wcm_mco_cd
cpe_claim_nbr
cpe_clm_rep_id
cpe_claim_id
cpe_clm_check_nbr
;

%let report_var=
	 wcm_loss_rpt_dt
	 cpe_approve_ind
	 cpe_clm_check_amt
	 cpe_check_genr_t_cd
	 cpe_check_trans_dt
	 cpv_cov_cd
	 pnm_insured_nm
	 cpe_payee_nm
	 cpe_cd1_payee_address
	 cpe_cd1_payee_city
	 cpe_cd1_payee_state
	 cpe_cd1_payee_zip_code
	 cpe_cd1_payee_zip_plus4
	 cpe_cd1_mail_to_address
	 cpe_cd1_mail_to_city
	 cpe_cd1_mail_to_state
	 cpe_cd1_mail_to_zip_code
	 cpe_cd1_mail_to_zip_plus4
	 emp_first_name
	 emp_last_name 
;

data it.match (keep= &ID_var &report_var  wcm_clm_line_cd 
			wcm_company_cd emp_selected_amt wci_injury_cd
             cpe_cd1_payee_xcor cpe_cd1_payee_ycor emp_cd1_xcor emp_cd1_ycor);
	set &cpat;
run;

/*Delete temporary datasets to make space*/
/*proc datasets nolist;*/
/*delete it.temp it.temp2;*/
/*run;*/

/*Put all derivered variables into one dataset*/

proc sql;
        /*All of these are at the claim level*/
        create table it.derived1 as
        select t1.*, t7.rel_pay_duration
        from it.match t1 left join it.t_rel_pay_duration t7
        on t1.cpe_claim_nbr = t7.cpe_claim_nbr;
                
       create table it.derived1a as
        select t1.*, t3a.num_ip
        from it.derived1 t1 left join it.t_num_ip t3a
        on t1.cpe_claim_nbr = t3a.cpe_claim_nbr;

quit;

proc sql;                
        /*T3 is larger than above datasets - adds in coverages*/
        create table it.derived3 as
        select d.*, t3.rel_cov_pay
        from it.derived1a d left join it.t_rel_cov_pay t3
                on d.cpe_claim_nbr = t3.cpe_claim_nbr and
                d.wcm_clm_line_cd = t3.wcm_clm_line_cd and
                d.wcm_mco_cd = t3.wcm_mco_cd and
                d.cpv_cov_cd = t3.cpv_cov_cd;

         /*T5 is larger than above datasets - counts by claim reps*/

		create table it.derived4 as
        select d.*, t5.one_pay
        from it.derived3 d left join  it.t_rel_single_pay t5
        on   d.cpe_claim_nbr = t5.cpe_claim_nbr and
                        d.cpe_clm_check_nbr = t5.cpe_clm_check_nbr;

        
        /*T17 is smaller than above datasets - mco claim rep*/
        create table it.derived6a as
        select d.*, t17.rel_last_pay, t17.cpe_payee_nm, t17.cpe_cd1_payee_address
        from it.derived4 d left join it.t_rel_last_pay t17
                on d.cpe_claim_nbr = t17.cpe_claim_nbr and
                          d.cpe_clm_check_nbr = t17.cpe_clm_check_nbr;
quit;

proc sql;
/*Add in payee appearance counts*/
  create table it.derived  as
  select d.*, p.payee_count, p.payee_num_rep_payment, p.payee_rep_pct
  from it.derived6a d left join it.payee_rep_info p
  on d.cpe_payee_nm = p.cpe_payee_nm  and
                d.cpe_cd1_payee_address = p.cpe_cd1_payee_address and
                d.cpe_clm_rep_id = p.cpe_clm_rep_id and
                d.cpe_claim_nbr = p.cpe_claim_nbr and
        d.cpe_clm_check_nbr = p.cpe_clm_check_nbr;
quit;


proc sql;
        /*Merge derived variables with main dataset*/
        create table it.whole as
        select c.*, d.num_ip,d.one_pay, d.payee_count, d.payee_num_rep_payment,d.payee_rep_pct, 
					d.rel_cov_pay, d.rel_last_pay,d.rel_pay_duration
        from &cpat c , it.derived d
           where c.cpe_claim_nbr = d.cpe_claim_nbr and
                  c.cpe_clm_check_nbr = d.cpe_clm_check_nbr;
quit;

/***************************************************************************************************************
******************************* DISTANCE CALCULATION FROM MAINFRAM TO SAS **************************************
***************************************************************************************************************/

data it.data_short (drop = employee_lat_rad payee_lat_rad employee_lat_rad employee_long_rad);
set it.whole;
	/*fill in 500 1's and the rest 0 for fraud - arbitrary but scoring won't run without it a mixture*/
        if _n_ le 500 then fraud = 1;
		 else fraud=0;
	 /*Calculate distances between employee, mail to and payee addresses using latitude and longitude*/

	employee_lat_rad = atan(1)/45 * emp_cd1_xcor;
    employee_long_rad = atan(1)/45 * emp_cd1_ycor;
	payee_lat_rad = atan(1)/45 * cpe_cd1_payee_xcor;
	payee_long_rad = atan(1)/45 * cpe_cd1_payee_ycor;

	payee_emp_dist = abs (round(3949.99 * arcos( sin( employee_lat_rad ) * sin( payee_lat_rad ) +
                 cos( employee_lat_rad ) * cos( payee_lat_rad ) *
                 cos( employee_long_rad - payee_long_rad ) )) );
run;


/*Make missing characher variables into category "MISSING"*/
proc contents data= it.data_short out=it.cont noprint;
quit;

data it.char_v (keep = name) ;
  set it.cont;
  if type =2 then output it.char_v;
  if name in ('cpe_check_genr_t_cd','cpv_cov_cd','wci_injury_cd','wcm_clm_line_cd','wcm_company_cd','wcm_mco_cd');
run;
/*Greate macros for each character variable name*/
data _null_;
        set  it.char_v end=no_more;
        call symputx('char_var'||left(_n_),name);
        if no_more then call symputx('count',_n_);
run;

%macro char_miss;
        data it.data_short;
                set it.data_short;
        %do i=1 %to &count;
          if &&char_var&i= ' ' then &&char_var&i='MISSING';
        %end;
		if one_pay=. then one_pay=0;
		if rel_cov_pay=. then rel_cov_pay=0;
	    run;
%mend char_miss;
%char_miss;


%let num_var =
cpe_clm_check_amt
emp_selected_amt
payee_count
payee_emp_dist
payee_num_rep_payment
payee_rep_pct
rel_cov_pay
rel_pay_duration
;


/*Impute missing values from training data and replace missing values in the validation data with the same values*/
proc stdize data=internal.train_samp1
                        reponly
                        method=median
                        out=it.train
                        OUTSTAT=med;
        var &num_var;
quit;

proc stdize data=it.data_short
                        reponly
                        method=in(med)
                        out=it.data_short_std;
        var &num_var;
quit;

data it.data_short_std;
  set it.data_short_std;

if wcm_company_cd not in ('010','060','063','065','068') then wcm_company_cd2='OTH';
  else wcm_company_cd2 = wcm_company_cd;

if payee_num_rep_payment = 0 then log_payee_num_rep_payment = log(.001);
   else log_payee_num_rep_payment = log(payee_num_rep_payment);
if payee_emp_dist = 0 then log_payee_emp_dist = log(.001);
   else log_payee_emp_dist= log(payee_emp_dist);
if payee_rep_pct = 0 then log_payee_rep_pct = log(.001);
   else log_payee_rep_pct = log(payee_rep_pct);
if rel_cov_pay = 0 then log_rel_cov_pay = log(.001);
   else log_rel_cov_pay = log(rel_cov_pay);
if cpe_clm_check_amt = 0 then log_cpe_clm_check_amt = log(.001);
   else log_cpe_clm_check_amt= log(cpe_clm_check_amt);
if emp_selected_amt = 0 then log_emp_selected_amt = log(.001);
   else log_emp_selected_amt= log(emp_selected_amt);
if rel_last_pay = 0 then log_rel_last_pay = log(.001);
   else log_rel_last_pay = log(rel_last_pay);
run;

proc sort data=it.data_short_std;
  by descending fraud;
run;

proc logistic data=it.data_short_std inest= internal.boot_params desc;
 class wcm_company_cd2 wci_injury_cd cpe_check_genr_t_cd one_pay;
 model fraud = wcm_company_cd2
					  log_payee_num_rep_payment
					  log_payee_emp_dist*cpe_check_genr_t_cd
					  cpe_check_genr_t_cd*wci_injury_cd
				 	  log_payee_rep_pct
					  log_rel_cov_pay
					  log_payee_rep_pct*log_payee_num_rep_payment
					  cpe_check_genr_t_cd*log_emp_selected_amt
					  log_cpe_clm_check_amt
					  one_pay
					  num_ip
					  log_rel_last_pay
  /maxiter=0;
 output out= &scored_data p=P_1;
quit;
