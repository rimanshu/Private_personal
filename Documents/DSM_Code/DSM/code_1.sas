libname data "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/EFT";
libname sra29 oracle user= 'sra29' pw= 'Page@724' path=EWSOP000 schema=sra29 buffsize=5000;
libname sra29ng oracle user= 'sra29' pw= 'Real@123' path=NGP1B schema=sra29 buffsize=5000;
/*libname sra29ng "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/EFT";*/

/*===============================================================================
* DECLARE FILENAMES AND SYSTEM OPTIONS
================================================================================*/
options errors = 1 compress = yes reuse = yes;
options symbolgen macrogen mprint mlogic;

/*data sra29ng.CLIENT_EFT;*/
/*set work.client_eft_data;*/
/*run;*/

proc sql;
create table data.eft_sel_uni as 
select unique n_eft_acct_nbr 
from sra29ng.CLIENT_EFT where 
n_eft_acct_nbr like '%-%';
run;

data data.eft_sel_uni_1;
set data.eft_sel_uni;
acct_nbr = _n_;
run;
data data.eft_sel_uni_2;
set data.eft_sel_uni_1;
acct_nbr_1 = acct_nbr + 165392496378543;
run;
data data.eft_sel_uni_2;
set data.eft_sel_uni_2;
format acct_nbr_1 25.;
informat acct_nbr_1 25.;
run;
proc sql;
create table data.eft_sel as 
select n_eft_id,n_eft_acct_nbr,n_routing_nbr 
from sra29ng.CLIENT_EFT where 
n_eft_acct_nbr like '%-%';
run;
proc sql;
create table data.eft_sel_2 as 
select a.n_eft_id,a.n_routing_nbr,b.acct_nbr_1 as acct_nbr_cipher from 
data.eft_sel a,data.eft_sel_uni_2 b where 
a.n_eft_acct_nbr=b.n_eft_acct_nbr;
run;

proc sql;
create table data.eft_sel_part2 as 
select n_eft_id,n_eft_acct_nbr,n_routing_nbr 
from sra29ng.CLIENT_EFT where 
n_eft_acct_nbr not like '%-%';
run;

data data.eft_sel_part2_1;
set data.eft_sel_part2;
format acct_nbr_0 25.;
informat acct_nbr_0 25.;
acct_nbr_0=(((compress(strip(n_eft_acct_nbr)) * 1))+127456949382995);
run;

data data.eft_sel_part2_2;
set data.eft_sel_part2_1;
acct_nbr_1=put(acct_nbr_0,25.);
acct_nbr=strip(acct_nbr_1);
run;
data data.eft_sel_part2_3;
set data.eft_sel_part2_2;
if length(acct_nbr)>=1 then f1=substr(acct_nbr,1,1); else f1="";
if length(acct_nbr)>=2 then f2=substr(acct_nbr,2,1); else f2="";
if length(acct_nbr)>=3 then f3=substr(acct_nbr,3,1); else f3="";
if length(acct_nbr)>=4 then f4=substr(acct_nbr,4,1); else f4="";
if length(acct_nbr)>=5 then f5=substr(acct_nbr,5,1); else f5="";
if length(acct_nbr)>=6 then f6=substr(acct_nbr,6,1); else f6="";
if length(acct_nbr)>=7 then f7=substr(acct_nbr,7,1); else f7="";
if length(acct_nbr)>=8 then f8=substr(acct_nbr,8,1); else f8="";
if length(acct_nbr)>=9 then f9=substr(acct_nbr,9,1); else f9="";
if length(acct_nbr)>=10 then f10=substr(acct_nbr,10,1); else f10="";
if length(acct_nbr)>=11 then f11=substr(acct_nbr,11,1); else f11="";
if length(acct_nbr)>=12 then f12=substr(acct_nbr,12,1); else f12="";
if length(acct_nbr)>=13 then f13=substr(acct_nbr,13,1); else f13="";
if length(acct_nbr)>=14 then f14=substr(acct_nbr,14,1); else f14="";
if length(acct_nbr)>=15 then f15=substr(acct_nbr,15,1); else f15="";
if length(acct_nbr)>=16 then f16=substr(acct_nbr,16,1); else f16="";
if length(acct_nbr)>=17 then f17=substr(acct_nbr,17,1); else f17="";
if length(acct_nbr)>=18 then f18=substr(acct_nbr,18,1); else f18="";
if length(acct_nbr)>=19 then f19=substr(acct_nbr,19,1); else f19="";
if length(acct_nbr)>=20 then f20=substr(acct_nbr,20,1); else f20="";
if length(acct_nbr)>=21 then f21=substr(acct_nbr,21,1); else f21="";
if length(acct_nbr)>=22 then f22=substr(acct_nbr,22,1); else f22="";
if length(acct_nbr)>=23 then f23=substr(acct_nbr,23,1); else f23="";
if length(acct_nbr)>=24 then f24=substr(acct_nbr,24,1); else f24="";
if length(acct_nbr)>=25 then f25=substr(acct_nbr,25,1); else f25="";
run;

%macro replace();
data data.eft_sel_part2_4;
set data.eft_sel_part2_3;
%do i=1 %to 25;
if f&i=1 then f&i=5;
else if f&i=2 then f&i=3;
else if f&i=3 then f&i=9;
else if f&i=4 then f&i=2;
else if f&i=5 then f&i=8;
else if f&i=6 then f&i=1;
else if f&i=7 then f&i=4;
else if f&i=8 then f&i=6;
else if f&i=9 then f&i=0;
else if f&i=0 then f&i=7;
else if f&i="" then f&i="";
%end;
run;
%mend replace;
%replace();

data data.eft_sel_part2_5;
set data.eft_sel_part2_4;
acct_nbr_cipher=(strip(f1))||(strip(f2))||(strip(f3))||(strip(f4))||(strip(f5))||(strip(f6))
||(strip(f7))||(strip(f8))||(strip(f9))||(strip(f10))||(strip(f11))||(strip(f12))||(strip(f13))||(strip(f14))
||(strip(f15))||(strip(f16))||(strip(f17))||(strip(f18))||(strip(f19))||(strip(f20))||(strip(f21))||(strip(f22))
||(strip(f23))||(strip(f24))||(strip(f25));
run;
data data.eft_sel_part2_6(keep= n_eft_id n_routing_nbr acct_nbr_cipher);
set data.eft_sel_part2_5;
run;

data data.eft_sel_3;
set data.eft_sel_2;
acct_nbr_1=put(acct_nbr_cipher,25.);
acct_nbr_cipher_1=strip(acct_nbr_1);
run;
data data.eft_sel_4(keep=n_eft_id  n_routing_nbr acct_nbr_cipher_1);
set data.eft_sel_3;
run;
data data.eft_sel_5(rename = acct_nbr_cipher_1=acct_nbr_cipher);
set data.eft_sel_4;
run;

data data.eft_dec_sas;
set data.eft_sel_part2_6 data.eft_sel_5;
run ;

data sra29.eft_dec_sas;
set data.eft_dec_sas;
run;
