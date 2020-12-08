
create table dsm_name_match_old_aug
as select n_pymnt_id,payee_employee_name_match from dsm_apr_output_15 where payee_employee_name_match='Y';

select count(*) from dsm_name_match_old_aug--27198


create table dsm_latest2mon_aug as
select * from dsm_aug_output_1 where d_issue_dt >= '31-MAR-15';
select count(*) from dsm_latest2mon_aug --1648048

drop index SRA29.a_name ;
drop index SRA29.b_name ;
drop index SRA29.c_name ;
drop index SRA29.d_name ;
drop index SRA29.e_name ;
drop index SRA29.f_name ;
drop index SRA29.g_name ;
drop index SRA29.h_name ;
drop index SRA29.i_name ;
drop index SRA29.j_name ;
drop index SRA29.P_IDX ;
drop index SRA29.payee_name1 ;
drop index SRA29.emp_first ;
drop index SRA29.emp_last ;

CREATE INDEX SRA29.P_IDX ON SRA29.dsm_latest2mon_aug 
(UPPER("PAYEE_NM"));



CREATE INDEX a_name ON SRA29.EWT_CLAIM_EMPLOYEE_a_aug2015 
('%'||"EMPLOYEE_NAME"||'%');

CREATE INDEX payee_name1 ON SRA29.dsm_aug_output_1
(UPPER(payee_nm));

CREATE INDEX emp_first ON SRA29.dsm_aug_output_1 
('%'||UPPER( emp_first_nm )||'%');

CREATE INDEX emp_last ON SRA29.dsm_aug_output_1 
('%'||UPPER( emp_last_nm )||'%');
CREATE INDEX b_name ON SRA29.EWT_CLAIM_EMPLOYEE_b_aug2015 
('%'||"EMPLOYEE_NAME"||'%');
 CREATE INDEX c_name ON SRA29.EWT_CLAIM_EMPLOYEE_c_aug2015 
('%'||"EMPLOYEE_NAME"||'%');
CREATE INDEX d_name ON SRA29.EWT_CLAIM_EMPLOYEE_d_aug2015 
('%'||"EMPLOYEE_NAME"||'%');
 CREATE INDEX e_name ON SRA29.EWT_CLAIM_EMPLOYEE_e_aug2015 
('%'||"EMPLOYEE_NAME"||'%');
CREATE INDEX f_name ON SRA29.EWT_CLAIM_EMPLOYEE_f_aug2015 
('%'||"EMPLOYEE_NAME"||'%');
CREATE INDEX g_name ON SRA29.EWT_CLAIM_EMPLOYEE_g_aug2015 
('%'||"EMPLOYEE_NAME"||'%');
CREATE INDEX h_name ON SRA29.EWT_CLAIM_EMPLOYEE_h_aug2015 
('%'||"EMPLOYEE_NAME"||'%');
CREATE INDEX i_name ON SRA29.EWT_CLAIM_EMPLOYEE_i_aug2015 
('%'||"EMPLOYEE_NAME"||'%');
CREATE INDEX j_name ON SRA29.EWT_CLAIM_EMPLOYEE_j_aug2015 
('%'||"EMPLOYEE_NAME"||'%');

 CREATE INDEX add_name ON ewt_claim_employee_1
('%'|| UPPER(emp_Stan_address)|| '%');

CREATE INDEX emp_add_name ON SRA29.ewt_claim_employee_1
('%'|| UPPER(CLE_EMP_ADDRESS_LN1)|| '%');

CREATE INDEX mail_add ON SRA29.dsm_aug_output_5 
(UPPER (std_mailto_addr ));

CREATE INDEX street_add ON SRA29.dsm_aug_output_5 
(UPPER (mail_to_street));
create table DSM_Name_Match_aug2015_a as
SELECT/*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_a_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
   

   
 
create table DSM_Name_Match_aug2015_b as
SELECT /*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_b_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
  
create table DSM_Name_Match_aug2015_c as
SELECT /*+ parallel(8) */DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_c_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
   
create table DSM_Name_Match_aug2015_d as
SELECT /*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_d_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
  
create table DSM_Name_Match_aug2015_e as
SELECT /*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_e_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
   
create table DSM_Name_Match_aug2015_f as
SELECT /*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_f_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
   
create table DSM_Name_Match_aug2015_g as
SELECT /*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_g_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
   
create table DSM_Name_Match_aug2015_h as
SELECT /*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_h_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
   
create table DSM_Name_Match_aug2015_i as
SELECT /*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_i_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
   
create table DSM_Name_Match_aug2015_j as
SELECT /*+ parallel(8) */ DISTINCT f.chk_nbr, f.payee_nm, 'Y' AS PAYEE_EMPLOYEE_NAME_MATCH 
  FROM dsm_latest2mon_aug f, EWT_CLAIM_EMPLOYEE_j_aug2015 ECE 
 WHERE     f.payee_nm IS NOT NULL 
   AND UPPER(f.Payee_nm) like '%'|| (ece.employee_name) ||'%';
   
  
   
   