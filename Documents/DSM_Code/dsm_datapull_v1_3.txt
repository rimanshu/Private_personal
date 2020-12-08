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

data source.ewt_performer_ng;
set source.ewt_performer_ng_1 source.ewt_performer_ng_2;
run;

	
