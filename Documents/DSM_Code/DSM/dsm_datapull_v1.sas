/*===========================================================================
Project: DSM Model Refresh 2012												
Version: 1.0								
Purpose: Get all source tables from Oracle		
Author: NagaGautami Kodali							
Date: 6/23/2014						
Sub Macros: 						
Reviewer: 					
Notes: 				
=============================================================================
AMENDMENT HISTORY:							
									
									
23-June-2014 First Version							
===========================================================================*/
%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas ";

proc sql;
connect to oracle as ngprodq(user='sra29' password='Page@724' path='@ewsop000');
/*ngprod.ewt_performer_ng P*/

create table source.ewt_performer_ng_1 as select * from connection to ngprodq 
(select P.*
    from ngprod.ewt_performer_ng P
	where p.E14_C_ADW_RCD_DEL = 'N'
	and P.e14_n_pt_loss_yr > '2010' );

disconnect from ngprodq;
quit;
	
