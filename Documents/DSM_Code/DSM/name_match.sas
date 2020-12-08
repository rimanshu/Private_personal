%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_AUG_15/Dat/Dsm/Codes/00_LibNames.sas ";

proc sql;
create table DSM_Name_Match_aug2015_a1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_a  f,
sra29.EWT_CLAIM_EMPLOYEE_a_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table DSM_Name_Match_aug2015_b1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_b  f,
sra29.EWT_CLAIM_EMPLOYEE_b_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table DSM_Name_Match_aug2015_c1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_c  f,
sra29.EWT_CLAIM_EMPLOYEE_c_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table DSM_Name_Match_aug2015_d1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_d  f,
sra29.EWT_CLAIM_EMPLOYEE_d_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;


proc sql;
create table DSM_Name_Match_aug2015_e1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_e  f,
sra29.EWT_CLAIM_EMPLOYEE_e_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table DSM_Name_Match_aug2015_f1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_f  f,
sra29.EWT_CLAIM_EMPLOYEE_f_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table DSM_Name_Match_aug2015_g1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_g  f,
sra29.EWT_CLAIM_EMPLOYEE_g_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table DSM_Name_Match_aug2015_h1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_h  f,
sra29.EWT_CLAIM_EMPLOYEE_h_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table DSM_Name_Match_aug2015_i1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_i  f,
sra29.EWT_CLAIM_EMPLOYEE_i_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table DSM_Name_Match_aug2015_j1 as
(Select distinct f.chk_nbr, f.payee_nm, 'Y' as PAYEE_EMPLOYEE_NAME_MATCH from 
sra29.DSM_Name_Match_aug2015_j  f,
sra29.EWT_CLAIM_EMPLOYEE_j_aug2015 ECE
WHERE
f.payee_nm is not null and 
(UPPER(f.Payee_nm) like '%'||' '||(ece.employee_name)||' '||'%' OR
UPPER(f.payee_nm) like (ece.employee_name)||' '||'%' or
UPPER(f.payee_nm) like '%'||' '||(ece.employee_name) or
UPPER(f.payee_nm) = ece.employee_name
)
);
run;

proc sql;
create table sra29.DSM_Name_Match_aug2015 
as
select * from DSM_Name_Match_aug2015_a1
union
select * from DSM_Name_Match_aug2015_b1
union
select * from DSM_Name_Match_aug2015_c1
union
select * from DSM_Name_Match_aug2015_d1
union
select * from DSM_Name_Match_aug2015_e1
union
select * from DSM_Name_Match_aug2015_f1
union
select * from DSM_Name_Match_aug2015_g1
union
select * from DSM_Name_Match_aug2015_h1
union
select * from DSM_Name_Match_aug2015_i1
union
select * from DSM_Name_Match_aug2015_j1;
run;

