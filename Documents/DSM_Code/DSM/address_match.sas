%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas";

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
 data cpat.ewt_claim_employee_1;
set data.ewt_claim_employee_total_&version.;
run;

%stan_address(cpat.ewt_claim_employee_1,CLE_EMP_ADDRESS_LN1,
cle_emp_city_nm,cle_emp_state_cd,emp_Stan_address);

data sra29.ewt_claim_employee_1;
set cpat.ewt_claim_employee_1;
run;

