select * from dsm_aug_output_1

select count(*) from dsm_aug_output_1--19099706

select count(*) from dsm_aug_output_1 where source='DSM'--18802415
                                                            
select count(*) from dsm_aug_output_1 where source='IFM'--  297291

select count(n_pymnt_id) from dsm_aug_output_1--18641765

select count(distinct n_pymnt_id) from dsm_aug_output_1--18641765

select max(d_issue_dt),min(d_issue_dt) from dsm_aug_output_1
29-MAY-15	31-MAY-13



select * from dsm_aug_output_1 where model_score is null
select * from dsm_aug_output_1 where percentile_score is null

Create Table DSM_aug_loss_exp AS 
select 
A.n_pymnt_id, 
(CASE 
WHEN ( D.C_FIN_TX_ENTRY_TYP) in ('600') THEN 'Loss Payment' 
WHEN ( D.C_FIN_TX_ENTRY_TYP) in ('620') THEN 'Expense Payment'  
WHEN ( D.C_FIN_TX_ENTRY_TYP) in ('605') THEN 'Loss Payment Offset'  
WHEN ( D.C_FIN_TX_ENTRY_TYP) in ('622') THEN 'Expense Payment Offset'
ELSE 'Legacy - Payment' END) 
AS LOSS_EXPENSE_IND
from 
dsm_aug_output_1 A 
LEFT JOIN
EWT_FINANCIAL_ENTITY_NG B
ON A.N_PYMNT_ID =B.N_FIN_ENT_ID
LEFT JOIN 
EWT_FINANCIAL_TX_GRP_NG C
ON  
B.N_FIN_ENT_ID = C.N_FIN_ENT_ID
LEFT JOIN 
EWT_FINANCIAL_TX_NG D
ON
C.N_FIN_TX_GRP_ID = D.N_FIN_TX_GRP_ID
where (C.C_RCD_DEL = 'N' AND B.C_RCD_DEL ='N' AND D.C_RCD_DEL='N') OR N_PYMNT_ID IS NULL; 

create table DSM_aug_loss_exp_1 AS 
select distinct * from DSM_aug_loss_exp;

create table DSM_aug_loss_exp_2 as 
select distinct n_pymnt_id ,listagg(LOSS_EXPENSE_IND,';') WITHIN GROUP (ORDER BY n_pymnt_id) AS LOSS_EXPENSE_IND
from DSM_aug_loss_exp_1 group by n_pymnt_id;

Create Table dsm_aug_auth_11 AS 
WITH b AS 
(select distinct chk.src_fin_act_id,
prof.pmt_req_addl_authrty_ind,
fact1.authrz_by_sk_id,
aut.aut_perfmer_alpha_id,
aut.aut_perfmer_nm, 
aut.aut_perfmer_titl_nm,
fact1.clm_cov_cd_sk_id,
cov.nxtgn_clm_cov_cd,
aut.AUT_CUR_REC_IND
from dsm_aug_output_1 dsm left join ewt_clm_check_det_dim chk on dsm.n_pymnt_id = chk.src_fin_act_id
inner join ewt_clm_fin_tran_fact fact1 on chk.clm_check_det_sk_id = fact1.clm_check_det_sk_id
inner join ewt_clm_fin_tran_prof_dim prof on fact1.clm_fin_tran_prof_sk_id = prof.clm_fin_tran_prof_sk_id 
inner join ewv_perfmer_authrzr_dim aut on fact1.authrz_by_sk_id = aut.aut_clm_perfmer_sk_id
inner join EWV_CLM_COV_CD_DIM cov on fact1.clm_cov_cd_sk_id =cov.clm_cov_cd_sk_id
where prof.pmt_req_addl_authrty_ind = 'Payment Required Additional Authority' and 
aut.AUT_CUR_REC_IND = 'Current')
select a.*, nvl(b.aut_perfmer_alpha_id, 'Auth. Not Req')AS aut_perfmer_alpha_id,
nvl(b.aut_perfmer_nm, 'Auth. Not Req')AS aut_perfmer_nm,
nvl(b.aut_perfmer_titl_nm,'Auth. Not Req') AS aut_perfmer_titl_nm ,
nvl(b.AUT_CUR_REC_IND,'Auth. Not Req') AS aut_cur_rec_ind
from dsm_aug_output_1 a LEFT JOIN b ON a.n_pymnt_id = b.src_fin_act_id AND a.c_line_type=b.nxtgn_clm_cov_cd;


create table dsm_aug_auth_12 as
select distinct n_pymnt_id,aut_perfmer_alpha_id,
aut_perfmer_nm, 
aut_perfmer_titl_nm,
AUT_CUR_REC_IND from dsm_aug_auth_11 where n_pymnt_id in
(select n_pymnt_id from dsm_aug_auth_11 group by n_pymnt_id having count(n_pymnt_id)>1 ) and aut_perfmer_alpha_id not in('Auth. Not Req');


create table dsm_aug_auth_13 as
SELECT distinct
    n_pymnt_id,
    listagg(aut_perfmer_alpha_id,';') WITHIN GROUP (ORDER BY n_pymnt_id,aut_perfmer_alpha_id) AS aut_perfmer_alpha_id,
    listagg(aut_perfmer_nm,';') WITHIN GROUP (ORDER BY n_pymnt_id,aut_perfmer_alpha_id) AS aut_perfmer_nm,
    listagg(aut_perfmer_titl_nm,';') WITHIN GROUP (ORDER BY n_pymnt_id,aut_perfmer_alpha_id) AS aut_perfmer_titl_nm
from dsm_aug_auth_12 group by n_pymnt_id;

MERGE INTO dsm_aug_auth_11 USING dsm_aug_auth_13
ON (dsm_aug_auth_11.n_pymnt_id=dsm_aug_auth_13.n_pymnt_id)
WHEN MATCHED THEN UPDATE SET dsm_aug_auth_11.aut_perfmer_alpha_id = dsm_aug_auth_13.aut_perfmer_alpha_id ;

MERGE INTO dsm_aug_auth_11 USING dsm_aug_auth_13
ON (dsm_aug_auth_11.n_pymnt_id=dsm_aug_auth_13.n_pymnt_id)
WHEN MATCHED THEN UPDATE SET dsm_aug_auth_11.aut_perfmer_nm = dsm_aug_auth_13.aut_perfmer_nm; 
          
MERGE INTO dsm_aug_auth_11 USING dsm_aug_auth_13
ON (dsm_aug_auth_11.n_pymnt_id=dsm_aug_auth_13.n_pymnt_id)
WHEN MATCHED THEN UPDATE SET dsm_aug_auth_11.aut_perfmer_titl_nm = dsm_aug_auth_13.aut_perfmer_titl_nm; 
commit;


create table dsm_aug_auth_21 as select distinct * from dsm_aug_auth_11;


create table unit_dsm_1_aug2015 as select distinct dsm.n_pymnt_id, perf.ISR_CUR_PERFMER_TEAM_NM,
perf.isr_perfmer_deactv_dt, perf.ISR_PERFMER_TITL_NM,perf.isr_perfmer_src_id,
(dsm.d_issue_dt - perf.isr_process_ts) as diff
from dsm_aug_output_1 dsm, EWV_PERFMER_ISSR_DIM perf, ewt_clm_check_det_dim chk
where dsm.n_pymnt_id = chk.src_fin_act_id and 
chk.iss_by_perfmer_src_id=perf.isr_perfmer_src_id;

create table unit_dsm_2_aug2015 as select distinct n_pymnt_id,min(diff) as mi ,isr_perfmer_src_id
from unit_dsm_1_aug2015
where isr_perfmer_src_id is not null
and diff > '0 0:0:0.0'
group by n_pymnt_id, isr_perfmer_src_id ;

create table unit_dsm_3_aug2015 as
select distinct base.n_pymnt_id, base.ISR_CUR_PERFMER_TEAM_NM, base.ISR_PERFMER_TITL_NM,base.isr_perfmer_deactv_dt 
from unit_dsm_1_aug2015 base 
inner join unit_dsm_2_aug2015 base2 on base.n_pymnt_id = base2.n_pymnt_id and
base.isr_perfmer_src_id = base2.isr_perfmer_src_id and base.diff = base2.mi;



create table  iss_t1_aug2015 as (
select distinct base.n_pymnt_id ,base.d_issue_dt,perf.PROCESS_TS,PERF.PERFMER_TITL_NM,PERF.PERFMER_src_ID,
(base.d_issue_dt  - PERF.PROCESS_TS) as diff 
from dsm_aug_output_1 base
left join ewt_clm_check_det_dim chk on 
base.n_pymnt_id = chk.src_fin_act_id 
left join ewt_clm_perfmer_dim perf on
CHK.ISS_BY_PERFMER_src_ID = PERF.PERFMER_src_ID);

create table iss_t2_aug2015 as
select distinct n_pymnt_id,PERFMER_src_ID,min(diff) as mi 
from iss_t1_aug2015 
where PERFMER_src_ID is not null
and diff > '0 0:0:0.0'
group by n_pymnt_id, PERFMER_src_ID; 


create table iss_t3_aug2015 as
select distinct base.n_pymnt_id, base.perfmer_titl_nm , base.d_issue_dt
from iss_t1_aug2015 base 
inner join iss_t2_aug2015 base2 on base.n_pymnt_id = base2.n_pymnt_id and
base.PERFMER_src_ID = base2.PERFMER_src_ID and base.diff = base2.mi;




create table dsm_aug_output_2 as
select a.*,b.aut_perfmer_alpha_id,b.aut_perfmer_nm,b.aut_perfmer_titl_nm
from dsm_aug_output_1 a left join dsm_aug_auth_21 b on a.n_pymnt_id=b.n_pymnt_id;


update dsm_aug_output_2 set aut_perfmer_alpha_id='Legacy Payment' where source='IFM';
update dsm_aug_output_2 set aut_perfmer_nm='Legacy Payment' where source='IFM';
update dsm_aug_output_2 set aut_perfmer_titl_nm='Legacy Payment' where source='IFM';
commit;


select count(*) from dsm_aug_output_2--19099706
select count(*) from dsm_aug_output_2 where source ='DSM'--18802415
select count(*) from dsm_aug_output_2 where source ='IFM'--297291

create table dsm_aug_output_3 as 
select a.*,b.LOSS_EXPENSE_IND from 
dsm_aug_output_2 a left join DSM_aug_loss_exp_2 b 
on a.n_pymnt_id=b.n_pymnt_id;

update dsm_aug_output_3 set LOSS_EXPENSE_IND='Legacy Payment' where source='IFM';
commit;

select count(*) from dsm_aug_output_3--19099706
select count(*) from dsm_aug_output_3 where source ='DSM'--18802415
select count(*) from dsm_aug_output_3 where source ='IFM'--297291

create table dsm_aug_output_4 as 
select a.*,b.perfmer_titl_nm as issuer_title from 
dsm_aug_output_3 a left join iss_t3_aug2015 b
on a.n_pymnt_id=b.n_pymnt_id;

select count(*) from dsm_aug_output_4--19099706
select count(*) from dsm_aug_output_4 where source ='DSM'--18802415
select count(*) from dsm_aug_output_4 where source ='IFM'--297291

update dsm_aug_output_4 set Issuer_title='Legacy Payment' where source='IFM';
commit;

create table dsm_aug_output_5 
as select a.*,b.isr_cur_perfmer_team_nm as perfmer_team,b.isr_perfmer_titl_nm as perfmer_titl,
b.isr_perfmer_deactv_dt as perfmer_deact_dt from dsm_aug_output_4 a left join unit_dsm_3_aug2015  b on a.n_pymnt_id=b.n_pymnt_id;

update dsm_aug_output_5 set perfmer_team='Legacy Payment' where source='IFM';
update dsm_aug_output_5 set perfmer_titl='Legacy Payment' where source='IFM';


commit;



select count(*) from dsm_aug_output_5--19099706
select count(*) from dsm_aug_output_5 where source='DSM'--18802415
select count(*) from dsm_aug_output_5 where source='IFM'--297291

create table dsm_aug_output_6 as 
select a.*,
(NVL2(REPLACE(TRIM(TAX_ID1),';'), REPLACE(TRIM(TAX_ID1),';') || ';' , '') ||
NVL2(REPLACE(TRIM(TAX_ID2),';'), REPLACE(TRIM(TAX_ID2),';') || ';' , '')|| 
NVL2(REPLACE(TRIM(TAX_ID3),';'), REPLACE(TRIM(TAX_ID3),';') || ';' , '') || 
NVL2(REPLACE(TRIM(TAX_ID4),';'), REPLACE(TRIM(TAX_ID4),';') || ';' , '') ||
NVL2(REPLACE(TRIM(TAX_OTHERS),';'), REPLACE(TRIM(TAX_OTHERS),';') || ';' , '')) AS TAX_ID
from dsm_aug_output_5 a;

alter table dsm_aug_output_5 drop column tax_id1;

alter table dsm_aug_output_6 drop column tax_id1;
alter table dsm_aug_output_6 drop column tax_id2;
alter table dsm_aug_output_6 drop column tax_id3;
alter table dsm_aug_output_6 drop column tax_id4;
alter table dsm_aug_output_6 drop column TAX_OTHERS;
commit;



create table Address_Match_Claims_aug2015 as
(Select distinct DSM.n_pymnt_id, DSM.chk_nbr, 'Y' as ADDRESS_MATCH_FLAG
from 
dsm_aug_output_5 DSM,
ewt_claim_employee_1 ECE
WHERE
ECE.CLE_EMP_ZIP_CD is not null AND 
ECE.CLE_EMP_ADDRESS_LN1 is not null AND
ECE.emp_Stan_address IS NOT NULL AND
DSM.payee_zip_cd=ECE.CLE_EMP_ZIP_CD AND
(UPPER (DSM.std_mailto_addr ) LIKE '%'|| UPPER(ECE.emp_Stan_address)|| '%'
OR UPPER (DSM.mail_to_street) LIKE '%'|| UPPER(ECE.CLE_EMP_ADDRESS_LN1)|| '%' ) )

select count(*) from Address_Match_Claims_aug2015--6020

Create table payee_Match_Claims_aug2015 as
select * from
(select n_pymnt_id , emp_first_nm , emp_last_nm ,payee_nm,
case when UPPER(SUBSTR(payee_nm,1,1)) = UPPER(SUBSTR( emp_first_nm ,1,1)) AND
UPPER(payee_nm) like '%'||UPPER( emp_first_nm )||'%' AND
UPPER(payee_nm) like '%'||UPPER( emp_last_nm )||'%'
then 'Y' else 'N' end as Flag
from dsm_aug_output_1)
where Flag = 'Y'


select count(*) from payee_Match_Claims_aug2015--38


select count(*) from DSM_NAME_MATCH_aug2015--2862



create table dsm_aug_output_7 as
select a.*,b.PAYEE_EMPLOYEE_NAME_MATCH from dsm_aug_output_6  a
left join dsm_name_match_old_aug b on a.n_pymnt_id=b.n_pymnt_id;


select count(*) from dsm_aug_output_7--19099706
select count(*) from dsm_aug_output_7 where source='DSM'--18802415
select count(*) from dsm_aug_output_7 where source='IFM'--297291


merge into dsm_aug_output_7 a
using (select distinct chk_nbr,payee_nm,PAYEE_EMPLOYEE_NAME_MATCH
from DSM_Name_Match_aug2015) b
on (a.payee_nm=b.payee_nm and a.chk_nbr=b.chk_nbr)
when matched then update
set
a.PAYEE_EMPLOYEE_NAME_MATCH=b.PAYEE_EMPLOYEE_NAME_MATCH;
commit;


drop table dsm_aug_output_91
create table dsm_aug_output_8 as
select a.*,b.flag as payee_payer_name_match from dsm_aug_output_7 a left join
payee_Match_Claims_aug2015 b on a.n_pymnt_id=b.n_pymnt_id;

select count(*) from dsm_aug_output_8--19099706
select count(*) from dsm_aug_output_8 where source='DSM'--18802415
select count(*) from dsm_aug_output_8 where source='IFM'--297291

create table dsm_aug_output_91 as
select a.*,b.ADDRESS_MATCH_FLAG from dsm_aug_output_8 a left join
Address_Match_Claims_aug2015 b on a.n_pymnt_id=b.n_pymnt_id;

select count(*) from dsm_aug_output_91--19099706
select count(*) from dsm_aug_output_91 where source='DSM'--18802415
select count(*) from dsm_aug_output_91 where source='IFM'--297291

update dsm_aug_output_91 set ADDRESS_MATCH_FLAG='N' where ADDRESS_MATCH_FLAG is null;
update dsm_aug_output_91 set payee_EMPLOYEE_NAME_MATCH='N' where payee_EMPLOYEE_NAME_MATCH is null;
update dsm_aug_output_91 set PAYEE_PAYER_NAME_MATCH='N' where PAYEE_PAYER_NAME_MATCH is null;
commit;


alter table dsm_aug_output_91 rename column  N_CLAIM_NUMBER to  CLAIM_NUMBER;
alter table dsm_aug_output_91 rename column  CHK_NBR to  CHECK_NUMBER;
alter table dsm_aug_output_91 rename column  D_ISSUE_DT to  CHECK_ISSUE_DATE;
alter table dsm_aug_output_91 rename column  PAYMENT_METHOD to  CHECK_GENERATION_CODE;
alter table dsm_aug_output_91 rename column  C_LINE_TYPE to  COVERAGE_CODE;
alter table dsm_aug_output_91 rename column  C_LINE_TYPE_DESC to  COVERAGE_CODE_DESCRIPTION;
alter table dsm_aug_output_91 rename column  M_ALPHA_ID to  ALPHA_ID;
alter table dsm_aug_output_91 rename column  PAYEE_NM to  PAYEE;
alter table dsm_aug_output_91 rename column  MAIL_TO_NM to  MAILED_TO_NAME;
alter table dsm_aug_output_91 rename column  PAYEE_ADDR_LN to  PAYEE_STREET;
alter table dsm_aug_output_91 rename column  MAIL_TO_STREET to  MAILED_TO_STREET;
alter table dsm_aug_output_91 rename column  PAYEE_CITY_NM to  PAYEE_CITY;
alter table dsm_aug_output_91 rename column  MAIL_TO_CITY to  MAILED_TO_CITY;
alter table dsm_aug_output_91 rename column  PAYEE_ST_CD to  PAYEE_STATE;
alter table dsm_aug_output_91 rename column  MAIL_TO_STATE to  MAILED_TO_STATE;
alter table dsm_aug_output_91 rename column  PAYEE_ZIP_CD to  PAYEE_ZIP;
alter table dsm_aug_output_91 rename column  CPE_CD1_PAYEE_ZIP_PLUS4 to  PAYEE_ZIP_PLUS_4;
alter table dsm_aug_output_91 rename column  MAIL_TO_ZIP to  MAILED_TO_ZIP;
alter table dsm_aug_output_91 rename column  STD_PAYEE_ADDR to  PAYEE_STANDARDIZED_ADDRESS;
alter table dsm_aug_output_91 rename column  STD_MAILTO_ADDR to  MAILED_TO_STANDARDIZED_ADDRESS;
alter table dsm_aug_output_91 rename column  MAX_SUPPLEMENT_NUMBER to  SUPPLEMENT_NUMBER;
alter table dsm_aug_output_91 rename column  SUPP_50PCT_INT_EST to  NUM_OF_SUPP_GT_50_ORG_EST;
alter table dsm_aug_output_91 rename column  N_MODEL_YEAR_NBR to  VEHICLE_MODEL_YEAR;
alter table dsm_aug_output_91 rename column  M_MAKE_NM to  VEHICLE_MAKE;
alter table dsm_aug_output_91 rename column  M_MODEL_NM to  VEHICLE_MODEL;
alter table dsm_aug_output_91 rename column  NUM_PARTICIPANT to  NUMBER_OF_PARTICIPANT;
alter table dsm_aug_output_91 rename column  NUM_PART_FNOLPLUS30 to  PART_ADD_30_DAYS_AFTER_FNOL;
alter table dsm_aug_output_91 rename column  NUM_PASSENGER to  NUMBER_OF_PASSENGERS;
alter table dsm_aug_output_91 rename column  NUM_PASS_FNOLPLUS30 to  NUM_OF_PASS_ADD_30_DAYS__FNOL;
alter table dsm_aug_output_91 rename column  EMP_FIRST_NM to  EMPLOYEE_FIRST_NAME;
alter table dsm_aug_output_91 rename column  EMP_LAST_NM to  EMPLOYEE_LAST_NAME;
alter table dsm_aug_output_91 rename column  NTID to  NT_ID;
alter table dsm_aug_output_91 rename column  E_STREET to  EMPLOYEE_STREET;
alter table dsm_aug_output_91 rename column  E_CITY to  EMPLOYEE_CITY;
alter table dsm_aug_output_91 rename column  E_REGION to  EMPLOYEE_STATE;
alter table dsm_aug_output_91 rename column  STD_E_ADDR to  EMPLOYEE_STANDARDIZED_ADDRESS;
alter table dsm_aug_output_91 rename column  LINE_OF_BUSINESS to  LINE_CODE;
alter table dsm_aug_output_91 rename column  DETAIL_LOSS_TYPE to  DETAILED_LOSS_TYPE;
alter table dsm_aug_output_91 rename column  SUB_PERIL to  SUBPERIL;
alter table dsm_aug_output_91 rename column  LOSS_DATE to  DATE_OF_LOSS;
alter table dsm_aug_output_91 rename column  D_CLAIM_ENTERED to  DATE_OF_REPORT;
alter table dsm_aug_output_91 rename column  C_REPORTED_BY to  REPORTED_BY;
alter table dsm_aug_output_91 rename column  T_OTH_REPORTED_BY to  REPORTED_BY_DESCRIPTION;
alter table dsm_aug_output_91 rename column  DISTANCE_MAILTO_EMP to  DIST_MAILED_TO_EMPLOYEE;
alter table dsm_aug_output_91 rename column  ENT_BY_M_ALPHA_ID to  ENTERED_BY_ALPHA_ID;
alter table dsm_aug_output_91 rename column  ENT_BY_N_USER_ID to  ENTERED_BY_NT_ID;
alter table dsm_aug_output_91 rename column  ENT_BY_FNAME to  ENTERED_BY_FIRST_NAME;
alter table dsm_aug_output_91 rename column  ENT_BY_LNAME to  ENTERED_BY_LAST_NAME;
alter table dsm_aug_output_91 rename column  CPE_APPROVE_IND to  APPROVAL_INDICATOR;
alter table dsm_aug_output_91 rename column  ADDRESS_MATCH_FLAG to  PAYEE_EMPLOYEE_ADDRESS_MATCH;
alter table dsm_aug_output_91 rename column  SUPPLEMENT_FREQUENCY to  SUPPLEMENT_FREQUENY;

create table dsm_aug_output_10 as
select a.*,b.d_date,b.d_reported from dsm_aug_output_91 a
left join ewt_loss_ng b on a.claim_id = b.e45_n_adw_claim_id;

create table dsm_aug_output_11 as
select a.*,b.CLM_OFC_CD from dsm_aug_output_10 a
left join mco_map_aug b on a.n_pymnt_id = b.n_pymnt_id;



update dsm_aug_output_11 set d_date = date_of_loss where source='IFM';
update dsm_aug_output_11 set d_reported = date_of_report where source='IFM';
update dsm_aug_output_11 set CLM_OFC_CD = mco where source='IFM';
alter table dsm_aug_output_11 drop column mco;
alter table dsm_aug_output_11 rename column CLM_OFC_CD to mco;
alter table dsm_aug_output_11 drop column date_of_loss;
alter table dsm_aug_output_11 rename column d_date to date_of_loss;
alter table dsm_aug_output_11 drop column date_of_report;
alter table dsm_aug_output_11 rename column d_reported to date_of_report;
commit;

create table dsm_aug_output_12 as
select a.*,b.d_issue_dt from dsm_aug_output_11 a
left join ewt_payment_ng b on a.n_pymnt_id = b.n_pymnt_id;

update dsm_aug_output_12 set d_issue_dt = CHECK_ISSUE_DATE where source='IFM';
alter table dsm_aug_output_12 drop column CHECK_ISSUE_DATE;
alter table dsm_aug_output_12 rename column d_issue_dt to CHECK_ISSUE_DATE;
commit;

select count(*) from dsm_aug_output_12--19099706
select count(*) from dsm_aug_output_12 where source='DSM'--18802415
select count(*) from dsm_aug_output_12 where source='IFM'--297291

select  * from dsm_aug_output_12

select count(*) from dsm_aug_output_12--19099706
select count(n_pymnt_id) from dsm_aug_output_12--18802415
select count(distinct n_pymnt_id) from dsm_aug_output_12--18802415


select count(*) from dsm_aug_output_12	where PAYEE_PAYER_NAME_MATCH='Y'--38
select count(*) from dsm_aug_output_12 where PAYEE_EMPLOYEE_NAME_MATCH='Y'--28619
select count(*) from dsm_aug_output_12 where PAYEE_EMPLOYEE_ADDRESS_MATCH='Y'--6020

alter table dsm_aug_output_12 drop column PAYEE_PAYER_NAME_MATCH
commit;


select count(*) from dsm_aug_output_12	where PAYEE_PAYER_NAME_MATCH='Y'--38
select count(*) from dsm_aug_output_12 where PAYEE_EMPLOYEE_NAME_MATCH='Y'--28619
select count(*) from dsm_aug_output_12 where PAYEE_EMPLOYEE_ADDRESS_MATCH='Y'--6020


select max(check_issue_date),min(check_issue_date) from dsm_aug_output_12


