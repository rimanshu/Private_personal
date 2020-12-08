libname data "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm";
libname lib "/work/ew07/projects/prod/icf/dat";
libname cpat "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Cpat";
libname sra29 oracle user= 'sra29' pw= 'Page@724' path=EWSOP000 schema=sra29 buffsize=5000;

/*new location to store dataset containing next run dates*/
libname rundates "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Rundates";

/*new location to store only the output dataset*/
libname new "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Output_dataset";


libname employee "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Employee_details";

/*proc sql;*/
/*select next_run_key into:run_key from rundates.nxt_run_dates;*/
/*quit;*/


data rundates.nxt_run_dates;
/*next_run_key=&run_key.+1;*/
next_to_day=30;
next_to_month=11;
next_to_year=2014;
next_to_date=MDY(next_to_month,next_to_day,next_to_year);
next_from_day=01;
next_from_month=12;
next_from_year=2012;
next_from_date=MDY(next_from_month,next_from_day,next_from_year);
next_run_key=27;
run;

data rundates.nxt_run_dates_format;
set rundates.nxt_run_dates;
format next_from_date date9.;
format next_to_date date9.;
run;

proc print data=rundates.nxt_run_dates_format;
format next_from_date date9.;
format next_to_date date9.;
run;

