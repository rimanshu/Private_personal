libname data "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm";
libname lib "/work/ew07/projects/prod/icf/dat";
libname cpat "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Cpat";
libname source "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Source";
libname sra29 oracle user= 'sra29' pw= 'Page@724' path=EWSOP000 schema=sra29 buffsize=5000;

/*new location to store dataset containing next run dates*/
libname rundates "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Rundates";

/*new location to store only the output dataset*/
libname new "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Output_dataset";

libname employee "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Employee_details";
%let employee_details = /work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Employee_details/employee_details.csv;

/*===============================================================================
* DECLARE FILENAMES AND SYSTEM OPTIONS
================================================================================*/
options errors = 1 compress = yes reuse = yes;
options symbolgen macrogen mprint mlogic;

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
%let run_description = &monthname.;

