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

/*ngprod.ewt_payment_ng*/

create table source.ewt_payment_ng as select * from connection to ngprodq
(select pt.n_pymnt_id, 
           pt.c_pymnt_meth,
           pt.d_issue_dt,
           pt.e71_c_adw_rcd_del,
           pt.c_pymnt_typ
          from ngprod.ewt_payment_ng pt
	where pt.d_issue_dt >= '01-DEC-12'
		and pt.D_ISSUE_DT <= '30-NOV-14'
		and pt.e71_c_adw_rcd_del = 'N');

/*ngprod.ngprod.ewt_payment_dtl_ng*/

create table source.ewt_payment_dtl_ng as select * from connection to ngprodq
(select pd.n_pymnt_id, 
           pd.e19_n_pt_loss_yr,
           pd.e19_c_pt_clm_line_cd, 
           pd.e19_c_pt_loss_st_cd, 
           pd.e19_n_adw_claim_id,
		   pd.n_pymnt_dtl_id,
           pd.n_line_id,
		   pd.d_srvc_start_dt,
		   pd.d_srvc_end_dt,
		   pd.N_PYMNT_ID, 
		   pd.e19_c_adw_rcd_del,
           pd.c_after_close_ind, 
           pd.c_method_stlmt_cd
	from ngprod.ewt_payment_dtl_ng pd
	where pd.e19_c_adw_rcd_del = 'N');

/*ngprod.ewt_check_pymnt_ng*/

create table source.ewt_check_pymnt_ng as select * from connection to ngprodq
(select cp.N_CHK_PYMNT_ID,
           cp.N_PYMNT_NBR,
           cp.M_MAIL_TO_NAME,
           cp.M_PAYEE_NAME,
           cp.C_ZIP,
		   cp.m_city,
           cp.c_state,
		   cp.t_street,
		   cp.E53_C_ADW_RCD_DEL
	from ngprod.ewt_check_pymnt_ng cp
	where cp.E53_C_ADW_RCD_DEL = 'N');

/*ewt_claim_employee*/


/*ngprod.ewt_org_entity_ng*/

create table source.ewt_org_entity_ng as select * from connection to ngprodq
(select * from ngprod.ewt_org_entity_ng oe);


/** ngprod.EWT_FINANCIAL_TX_NG fin*/

create table source.EWT_FINANCIAL_TX_NG as select * from connection to ngprodq
(select fin.D_FIN_TX_POST_DT,
           fin.E17_n_PT_LOSS_YR,
           fin.E17_c_PT_CLM_LINE_CD,
           fin.e17_c_PT_LOSS_ST_CD,
           fin.e17_n_ADW_CLAIM_ID,
		   fin.N_FIN_DTL_ID,
		   fin.C_FIN_TX_ENTRY_TYP,
		   fin.a_fin_tx_amt,
		   fin.e17_c_adw_rcd_del
	from ngprod.EWT_FINANCIAL_TX_NG fin
	where fin.e17_c_adw_rcd_del = 'N');

/** ngprod.ewt_ref_entry_offset_ng ref */

create table source.ewt_ref_entry_offset_ng as select * from connection to ngprodq
(select ref.N_BAL_MULTIPLIER,
           ref.C_ENTRY_TYP
	from ngprod.ewt_ref_entry_offset_ng ref);

/*ngprod.ewt_policy_ng pol pol*/

create table source.ewt_policy_ng as select * from connection to ngprodq 
(select pol.n_policy,
           pol.d_pol_inception_dt,
           pol.E32_N_ADW_CLAIM_ID,
		   pol.n_policy_co_nbr,
		   pol.E32_C_ADW_RCD_DEL,
		   pol.n_policy_id,
		   pol.m_named_insd,
		   pol.e32_d_atomic_ts,
		   pol.E32_N_PT_LOSS_YR,
		   pol.E32_C_PT_CLM_LINE_CD,
		   pol.E32_C_PT_LOSS_ST_CD,
		   pol.E32_C_ADW_RCD_DEL
	from ngprod.ewt_policy_ng pol);

/* ngprod.ewt_claim_ng as claim */

create table source.ewt_claim_ng as select * from connection to ngprodq 
(	select claim.d_claim_entered,
           claim.n_claim_number,
           claim.c_lob,
		   claim.n_entered_by,
		   claim.n_loss_id,
		   claim.n_policy_id,
           claim.E38_N_ADW_CLAIM_ID,
           claim.E38_C_ADW_RCD_DEL,
		   claim.E38_N_PT_LOSS_YR,
		   claim.E38_C_PT_CLM_LINE_CD,
		   claim.E38_C_PT_LOSS_ST_CD
	from ngprod.ewt_claim_ng claim
	);
/*ngprod.ewt_payee_payor_dtl_ng*/

create table source.ewt_payee_payor_dtl_ng as select * from connection to ngprodq 
(	select  n_pymnt_id,
			n_payee_pyr_dtl_id,
			n_invl_role_id,
			n_name_id,
			n_tax_id,
			n_pymnt_id,
			e42_c_adw_rcd_del
	from ewt_payee_payor_dtl_ng dtl
	);

/*ngprod.ewt_ins_involvement_ng inv*/

create table source.ewt_ins_involvement_ng as select * from connection to ngprodq 
(select inv.n_ins_invl_id,
           inv.d_create_ts,
		   inv.e44_n_pt_loss_yr,
		   inv.e44_c_pt_clm_line_cd,
		   inv.e44_c_pt_loss_st_cd,
		   inv.e44_n_adw_claim_id,
		   inv.m_leg_inv_id,
		   inv.n_client_id,
		   inv.e44_c_adw_rcd_del,
		   inv.c_rcd_del
    from ngprod.ewt_ins_involvement_ng inv
	where inv.E44_C_ADW_RCD_DEL = 'N');

/*ngprod.ewt_involvement_role_ng inr*/

create table source.ewt_involvement_role_ng as select * from connection to ngprodq
(select inr.C_INVL_ROLE,
		   inr.N_INVL_ROLE_ID,
		   inr.n_ins_invl_id,
		   inr.e43_n_pt_loss_yr,
		   inr.e43_c_pt_clm_line_cd,
		   inr.e43_n_adw_claim_id,
		   inr.e43_c_pt_loss_st_cd,
		   inr.e43_c_adw_rcd_del,
		   inr.c_rcd_del
    from ngprod.ewt_involvement_role_ng inr
	where inr.E43_C_ADW_RCD_DEL = 'N');

/*ngprod.ewt_code_decode_ng*/

create table source.ewt_code_decode_ng as select * from connection to ngprodq 
(select c.t_long_desc,
	       c.c_code,
		   c.c_category
    from ngprod.ewt_code_decode_ng c);


/*ngprod.EWT_ORG_ENTITY_RELSHP_NG oer*/

create table source.EWT_ORG_ENTITY_RELSHP_NG as select * from connection to ngprodq 
(select OER.N_ORG_ENTY_ID1,
	       OER.N_ORG_ENTY_ID2,
		   OER.C_RPT_OFFICE_IND,
		   oer.E69_C_ADW_RCD_DEL,
		   oer.C_RCD_DEL,oer.D_last_updt_TS
    from ngprod.EWT_ORG_ENTITY_RELSHP_NG OER
	where oer.E69_C_ADW_RCD_DEL = 'N' and oer.C_RCD_DEL = 'N');



/*pcprod.ewv_or_all_estimates est*/

create table source.ewv_or_all_estimates as select * from connection to ngprodq 
(select est.d70_pt_loss_yr,
           est.d70_pt_clm_line_cd,
           est.d70_pt_loss_st_cd,
           est.d70_adw_claim_id, 
           est.claim_number, 
           est.involved_party_id,
           est.coverage_code,
		   est.estimate_id,
		   est.sw_supplement_number,
		   est.uploaded_by_user_id,
		   est.upload_package_received_date,
		   est.is_final,
		   est.est_sw_ttl_gross_total_amount,
		   est_sw_ttl_net_supplement_amou,
		   est.moi_id,
		   est.sw_supplement_number,
		   est.upload_package_received_date,
		   est.back_end_audit_score
    from pcprod.ewv_or_all_estimates est
	where              
		est.upload_package_received_date >= '01-DEC-12'
        AND est.upload_package_received_date <= '30-NOV-14');

/*pcprod.ewv_user_pc upc*/

create table source.ewv_user_pc as select * from connection to ngprodq
(select upc.xm_org_entity_nm,
	       upc.xm_alpha_id,
		   upc.xc_user_id,
		   upc.n_org_enty_id 
    from pcprod.ewv_user_pc upc	);
/*pcprod.ewv_or_reinspection_ng reip*/

create table source.ewv_or_reinspection_ng as select * from connection to ngprodq
(select reip.d72_pt_loss_yr,
           reip.d72_pt_clm_line_cd,
           reip.d72_pt_loss_st_cd,
		   reip.d72_adw_claim_id,
		   reip.estimate_id,
		   reip.xc_rein_type_cd,
		   reip.reinspection_id
    from pcprod.ewv_or_reinspection_ng reip	);

/*ngprod.ewv_job_code_lkup jcl*/

create table source.ewv_job_code_lkup as select * from connection to ngprodq
(select jcl.t_long_desc,
	       jcl.c_code
    from ngprod.ewv_job_code_lkup jcl);

/*pcprod.ewv_or_reinspect_excpt exnd*/

create table source.ewv_or_reinspect_excpt as select * from connection to ngprodq
(select exnd.d76_pt_loss_yr,
	       exnd.d76_pt_clm_line_cd,
		   exnd.d76_pt_loss_st_cd,
		   exnd.d76_adw_claim_id,
		   exnd.reinspection_id,
		   exnd.reinspection_excptn_subtype_id
    from pcprod.ewv_or_reinspect_excpt exnd	);

/*ngprod.ewt_claimant_role_ng cr*/

create table source.ewt_claimant_role_ng as select * from connection to ngprodq 
(select cr.n_claimant_role_id,
	       cr.e39_n_pt_loss_yr,
		   cr.e39_c_pt_loss_st_cd,
		   cr.e39_c_pt_clm_line_cd,
		   cr.e39_n_adw_claim_id,
		   cr.e39_c_adw_rcd_del,
		   cr.c_rcd_del
    from ngprod.ewt_claimant_role_ng cr	);

/*ngprod.claim_party_role cpr*/

create table source.claim_party_role as select * from connection to ngprodq 
(select cpr.n_item_invl_id,
	       cpr.n_invl_role_id,
		   cpr.r05_n_pt_loss_yr,
		   cpr.r05_c_pt_loss_st_cd,
		   cpr.r05_c_pt_clm_line_cd,
		   cpr.r05_n_adw_claim_id,
		   cpr.r05_d_end_atomic_ts,
		   cpr.r05_c_adw_rcd_del,
		   cpr.c_rcd_del
    from ngprod.claim_party_role cpr);

/*pcprod.ewt_estimate_pc e*/

create table source.ewt_estimate_pc as select * from connection to ngprodq 
(select e.estimate_id, 
		   e.moi_id,
		   e.VEHICLE_YEAR,
		   e.VEHICLE_MAKE_DESCRIPTION, 
		   e.VEHICLE_MODEL,
           e.d71_adw_claim_id,
           e.claim_id,
		   e.d71_pt_clm_line_cd,
		   e.d71_pt_loss_st_cd,
		   e.d71_pt_loss_yr,
		   e.upload_package_guid,
		   e.EST_SW_SUPPLEMENT_NUMBER,
		   e.net_amount,
		   e.is_final
    from pcprod.ewt_estimate_pc e);


/*pcprod.ewt_claim_pc c*/

create table source.ewt_claim_pc as select * from connection to ngprodq
(select c.involved_party_id,
	       c.claim_id,
		   c.d70_adw_claim_id,
		   c.d70_pt_clm_line_cd,
		   c.d70_pt_loss_st_cd,
		   c.d70_pt_loss_yr       
    from pcprod.ewt_claim_pc c);

/*pcprod.ewt_upload_package_pc upc*/

create table source.ewt_upload_package_pc as select * from connection to ngprodq
(select upc.upload_package_received_date,
	       upc.upload_package_guid,
		   upc.d75_adw_claim_id,
		   upc.d75_pt_clm_line_cd,
		   upc.d75_pt_loss_st_cd,
		   upc.d75_pt_loss_yr            
   from pcprod.ewt_upload_package_pc upc);


/*ngprod.ewt_line_ng line*/

create table source.ewt_line_ng as select * from connection to ngprodq 
(select line.E24_N_PT_LOSS_YR,
	       line.E24_C_PT_CLM_LINE_CD,
		   line.E24_C_PT_LOSS_ST_CD,
		   line.E24_N_ADW_CLAIM_ID,
		   line.n_line_id,
		   line.d_creation,
		   line.d_fin_close_dt,
	       line.d_fin_reopen_dt,
		   line.c_cov_hndlng_cd,
		   line.c_line_type,
		   line.N_DAMAGE_ID,
		   line.E24_C_ADW_RCD_DEL       
    from ngprod.ewt_line_ng line);

/*ngprod.ewt_damage_ng dmg*/

create table source.ewt_damage_ng as select * from connection to ngprodq 
(select dmg.N_DAMAGE_ID,
	    dmg.N_ITEM_INVL_ID,
		dmg.D52_N_PT_LOSS_YR ,
		dmg.D52_C_PT_CLM_LINE_CD, 
		dmg.D52_C_PT_LOSS_ST_CD,
		dmg.D52_N_ADW_CLAIM_ID,
		dmg.D52_C_ADW_RCD_DEL        
    from ngprod.ewt_damage_ng dmg);

/*ngprod.ewt_item_involvement_ng itinv*/

create table source.ewt_item_involvement_ng as select * from connection to ngprodq 
(select itinv.N_ITEM_INVL_ID,
		itinv.E33_N_PT_LOSS_YR,
		itinv.E33_C_PT_CLM_LINE_CD,
		itinv.E33_C_PT_LOSS_ST_CD,
		itinv.e33_n_ADW_CLAIM_ID,
		itinv.N_ITEM_INVL_ID,
	    itinv.e33_C_ADW_RCD_DEL        
    from ngprod.ewt_item_involvement_ng itinv);

/*ngprod.ewt_ref_auth_lvl_ng b*/

create table source.ewt_ref_auth_lvl_ng as select * from connection to ngprodq 
(select b.N_AUTH_LMT,
	       b.C_AUTH_LVL,
		  b.D55_C_ADW_RCD_DEL
    from ngprod.ewt_ref_auth_lvl_ng b);

/*ngprod.ewt_authority_ng a*/

create table source.ewt_authority_ng as select * from connection to ngprodq 
(select a.N_ORG_ENTY_ID, 
		a.C_LINE_TYPE, 
		a.C_AUTH_LVL, 
		a.N_AUTH_ID, 
		a.c_fin_ctgy,
		a.d_create_ts,
        a.D51_C_ADW_RCD_DEL 
    from ngprod.ewt_authority_ng a	
	where a.D51_C_ADW_RCD_DEL = 'N');

/*ngprod.ewt_line_authority_ng a*/

create table source.ewt_line_authority_ng as select * from connection to ngprodq 
(select a.a_approved, 
		a.d_auth_exp_dt,
		a.c_fin_ctgy,
		a.d_create_ts,
		a.n_line_id,
		a.d_create_ts,
		a.c_rcd_del,
		a.c_fin_ctgy
    from ngprod.ewt_line_authority_ng a	
	where a.c_rcd_del = 'N' and a.c_fin_ctgy in ('600', '620'));

/*ngprod.ewt_loss_ng loss*/
create table source.ewt_loss_ng as select * from connection to ngprodq
(select loss.c_loss_type, 
		loss.c_loss_cd, 
		loss.c_loss_detail_cd,
		loss.c_org_peril_cd,
		loss.c_org_sub_peril_cd,
		loss.E45_N_ADW_CLAIM_ID,
		loss.E45_N_PT_LOSS_YR,
		loss.E45_C_PT_CLM_LINE_CD,
		loss.E45_C_PT_LOSS_ST_CD,
		loss.E45_C_ADW_RCD_DEL,
		loss.D_DATE,
		loss.T_OTH_REPORTED_BY,
		loss.C_REPORTED_BY,
		loss.n_loss_id
    from ngprod.ewt_loss_ng loss	
	where loss.E45_C_ADW_RCD_DEL = 'N');

/*NGPROD.ewt_client_name_ng clnt_nm*/

create table source.ewt_client_name_ng as select * from connection to ngprodq
(select clnt_nm.N_CLIENT_ID,
				clnt_nm.M_first_name,
				clnt_nm.M_last_name,
				clnt_nm.m_org_name,
				clnt_nm.n_name_id,
				clnt_nm.e58_c_adw_rcd_del,
				clnt_nm.n_default_flag
    from NGPROD.ewt_client_name_ng clnt_nm	
	where clnt_nm.e58_c_adw_rcd_del = 'N');

/*ngprod.ewt_agent_ng a*/

create table source.ewt_agent_ng as select * from connection to ngprodq
(select a.n_agt_code,
           a.m_agt_name,
           a.n_policy_id,
	       a.e01_N_ADW_CLAIM_ID,
		   a.E01_N_PT_LOSS_YR,
		   a.E01_C_PT_CLM_LINE_CD,
		   a.E01_C_PT_LOSS_ST_CD,
           a.E01_C_ADW_RCD_DEL 
    from ngprod.ewt_agent_ng a	
	where a.E01_C_ADW_RCD_DEL = 'N');

/*DBprod.ewt_claim_payment clm_pay*/

create table source.ewt_claim_payment as select * from connection to ngprodq
(select clm_pay.CPE_PAYEE_ADDR_LN,
 		clm_pay.CPE_PAYEE_CITY_NM,
		clm_pay.CPE_PAYEE_ST_CD,
		clm_pay.CPE_PAYEE_ZIP_CD,
		clm_pay.CPE_CLAIM_NBR,
		clm_pay.CPE_CLM_CHECK_NBR
    from DBprod.ewt_claim_payment clm_pay);

/*sra29.ewt_clm_check_Det_dim chk*/

create table source.ewt_clm_check_Det_dim as select * from connection to ngprodq 
(select chk.src_fin_act_id,
	       chk.clm_check_det_sk_id     
    from ewt_clm_check_Det_dim chk);

/*sra29.ewt_clm_fin_tran_fact factl*/

create table source.ewt_clm_fin_tran_fact as select * from connection to ngprodq
(select FACTL.clm_check_Det_sk_id,
	       factl.CLM_FIN_TRAN_PROF_SK_ID,
		   factl.CLM_COV_CD_SK_ID,
		   factl.POST_DOL_AMT,
		   factl.CLM_COV_DET_SK_ID,
		   factl.LS_PERIL_TY_SK_ID,
		   factl.POST_DOL_AMT,
		   FACTL.COV_ALLOC_OFC_SK_ID
    from ewt_clm_fin_tran_fact factl);

/*sra29.EWT_CLM_COV_DET_DIM covdet*/

create table source.EWT_CLM_COV_DET_DIM as select * from connection to ngprodq
(select COVDET.ACTL_METH_OF_INSP_NM,
	       COVDET.CUR_DED_RTN_STS_NM,
	       COVDET.fst_pmt_meth_stlmt_cd,
		   COVDET.INJ_IND,
		   COVDET.cur_tot_ls_ind,
		   COVDET.CLM_COV_DET_SK_ID
    from EWT_CLM_COV_DET_DIM covdet);

/*sra29.ewt_clm_ofc_dim ofc*/

create table source.ewt_clm_ofc_dim as select * from connection to ngprodq
(select OFC.OFC_CLM_SRV_AREA_NM,
	       OFC.CLM_OFC_SK_ID
    from ewt_clm_ofc_dim ofc);

/*sra29.EWT_CLM_FIN_TRAN_PROF_DIM prof*/

create table source.EWT_CLM_FIN_TRAN_PROF_DIM as select * from connection to ngprodq 
(select PROF.LS_EXP_CD,
	       PROF.PMT_METH_NM,
           PROF.PMT_REQ_ADDL_AUTHRTY_IND,
		   PROF.CLM_FIN_TRAN_PROF_SK_ID,
		   PROF.PMT_METH_STLMT_CD,
		   prof.LS_EXP_CD
    from EWT_CLM_FIN_TRAN_PROF_DIM prof);

/*sra29.EWT_LS_PERIL_TY_DIM lperil*/

create table source.EWT_LS_PERIL_TY_DIM as select * from connection to ngprodq
(select LPERIL.LS_PERIL_TY_NM,
		LPERIL.CLM_LN_CD,
	       LPERIL.LS_PERIL_TY_SK_ID
    from EWT_LS_PERIL_TY_DIM lperil);

/*sra29.EWT_CLM_COV_CD_DIM */

create table source.EWT_CLM_COV_CD_DIM as select * from connection to ngprodq
(select CLM_COV_CD_SK_ID,
	       CLM_COV_GP_NM,
		   NXTGN_CLM_COV_CD
    from EWT_CLM_COV_CD_DIM );

/*sra29.EWV_CLM_DIM */

create table source.EWV_CLM_DIM as select * from connection to ngprodq 
(select EWV_CLM_DIM.ADW_CLM_ID,
			EWV_CLM_DIM.CLM_SK_ID,
			 EWV_CLM_DIM.CLM_NBR
    from EWV_CLM_DIM );

/*sra29.EWV_CLM_GP_DIM */

create table source.EWV_CLM_GP_DIM as select * from connection to ngprodq 
(select EWV_CLM_GP_DIM.CAT_LEG_CD,
			EWV_CLM_GP_DIM.CLM_GP_SK_ID,
			EWV_CLM_GP_DIM.FIN_CAT_DESC
			 from EWV_CLM_GP_DIM );

/*sra29.EWV_CLM_COV_SNPSHT_FACT */
create table source.EWV_CLM_COV_SNPSHT_FACT as select * from connection to ngprodq
(select EWV_CLM_COV_SNPSHT_FACT.CLM_SK_ID,
			EWV_CLM_COV_SNPSHT_FACT.CLM_GP_SK_ID
			 from EWV_CLM_COV_SNPSHT_FACT );

disconnect from ngprodq;
quit;
	
