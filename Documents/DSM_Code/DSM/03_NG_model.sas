%include "/work/ew07/projects/dev/DSM_Refresh_Run/DSM_DEC_14/Dat/Dsm/Codes/00_LibNames.sas";

proc sql;
create table data.ds_est as
SELECT 
               adj_mco.mco_id as mco_id,
               allest.claim_number as claim_number, 
               upc.xm_org_entity_nm AS adjuster_wrote_est,
               upc.xm_alpha_id AS adjuster_alpha_id,
               est.uploaded_by_user_id AS uploaded_by_user_id,
               jcl.t_long_desc AS perf_job_title,
               allest.coverage_code AS coverage_code,
               est.estimate_id AS estimate_id,
               allest.est_type AS est_type,               
               CASE 
                    WHEN est_type='E' THEN est.est_sw_ttl_gross_total_amount
                    WHEN est_type='S' THEN est.est_sw_ttl_net_supplement_amou
               END AS est_or_supp_amt,               
               est.back_end_audit_score AS rbi_score,
               reip.cnt_reinsp as cnt_reinsp,       
               excp_nd.cnt_exnd as cnt_exnd,
               excp_nvd.cnt_exnvd as cnt_exnvd,
               excp_rp.cnt_exrp as cnt_exrp,
			   allest.upload_package_received_date,
			   allest.d70_pt_loss_yr, 
			   allest.d70_pt_clm_line_cd, 
			   allest.d70_pt_loss_st_cd,
		       allest.d70_adw_claim_id, 
			   allest.involved_party_id
            FROM data.all_estimates allest INNER JOIN source.ewv_or_all_estimates est
	            ON allest.d70_pt_loss_yr = est.d70_pt_loss_yr
	            AND allest.d70_pt_clm_line_cd = est.d70_pt_clm_line_cd
	            AND allest.d70_pt_loss_st_cd = est.d70_pt_loss_st_cd
	            AND allest.d70_adw_claim_id = est.d70_adw_claim_id
	            AND allest.estimate_id = est.estimate_id
	            AND allest.upload_package_received_date = est.upload_package_received_date    
	            INNER JOIN source.ewv_user_pc upc ON est.uploaded_by_user_id = upc.xc_user_id 
	            INNER JOIN (SELECT n_org_enty_id1 AS n_org_enty_id, n_org_enty_id2 AS mco_id
                    FROM source.ewt_org_entity_relshp_ng oer
                    where c_rpt_office_ind = 'Y'
                    AND e69_c_adw_rcd_del  = 'N'                    
                    AND c_rcd_del = 'N'                    
                    ) adj_mco
                    ON upc.n_org_enty_id = adj_mco.n_org_enty_id
		            INNER JOIN source.ewt_org_entity_ng oe
		             ON upc.n_org_enty_id = oe.n_org_enty_id
		             AND datepart(oe.d_org_deactive) EQ '01JAN1800'D
		             AND oe.c_rcd_del = 'N'
		            AND datepart(oe.e68_d_end_atomic_ts) GT '31DEC2100'D                      
		            INNER JOIN source.ewv_job_code_lkup jcl on oe.c_job_code = jcl.c_code
		            LEFT OUTER JOIN 
		                    (   SELECT 
		                            reip.d72_pt_loss_yr, reip.d72_pt_clm_line_cd, reip.d72_pt_loss_st_cd, 
		                            reip.d72_adw_claim_id, reip.estimate_id, reip.xc_rein_type_cd,
		                            COUNT(reip.estimate_id) as cnt_reinsp
		                        FROM source.ewv_or_reinspection_ng reip
		                        WHERE reip.xc_rein_type_cd=2
		                        GROUP BY reip.d72_pt_loss_yr, reip.d72_pt_clm_line_cd, reip.d72_pt_loss_st_cd, 
		                        reip.d72_adw_claim_id, reip.estimate_id, reip.xc_rein_type_cd
		                    ) reip
		                    ON est.d70_pt_loss_yr = reip.d72_pt_loss_yr
		                    AND est.d70_pt_clm_line_cd = reip.d72_pt_clm_line_cd
		                    AND est.d70_pt_loss_st_cd = reip.d72_pt_loss_st_cd
		                    AND est.d70_adw_claim_id = reip.d72_adw_claim_id
		                    AND est.estimate_id = reip.estimate_id
		            LEFT OUTER JOIN 
		                    (
		                        select  
		                        exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, 
								exnd.d76_adw_claim_id, reip.estimate_id,
		                        count(exnd.reinspection_id) as cnt_exnd
		                        from source.ewv_or_reinspection_ng reip inner join source.ewv_or_reinspect_excpt exnd
		                        on reip.reinspection_id = exnd.reinspection_id
		                        and reip.xc_rein_type_cd=2
		                        where  exnd.reinspection_excptn_subtype_id = 215                
		                        group by exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, 
											exnd.d76_adw_claim_id, reip.estimate_id 
		                    ) excp_nd
		                    ON est.d70_pt_loss_yr = excp_nd.d76_pt_loss_yr
		                    AND est.d70_pt_clm_line_cd = excp_nd.d76_pt_clm_line_cd
		                    AND est.d70_pt_loss_st_cd = excp_nd.d76_pt_loss_st_cd
		                    AND est.d70_adw_claim_id = excp_nd.d76_adw_claim_id
		                    AND est.estimate_id = excp_nd.estimate_id            
		            LEFT OUTER JOIN 
		                    (
		                        select  
		                        exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, 
								exnd.d76_adw_claim_id, reip.estimate_id,
		                        count(exnd.reinspection_id) as cnt_exnvd
		                        from source.ewv_or_reinspection_ng reip inner join source.ewv_or_reinspect_excpt exnd
		                        on reip.reinspection_id = exnd.reinspection_id
		                        and reip.xc_rein_type_cd=2
		                        where  exnd.reinspection_excptn_subtype_id = 216                
		                        group by exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, 
										exnd.d76_adw_claim_id, reip.estimate_id 
		                    ) excp_nvd
		                    ON est.d70_pt_loss_yr = excp_nvd.d76_pt_loss_yr
		                    AND est.d70_pt_clm_line_cd = excp_nvd.d76_pt_clm_line_cd
		                    AND est.d70_pt_loss_st_cd = excp_nvd.d76_pt_loss_st_cd
		                    AND est.d70_adw_claim_id = excp_nvd.d76_adw_claim_id
		                    AND est.estimate_id = excp_nvd.estimate_id
		            LEFT OUTER JOIN 
		                    (
		                        select  
		                        exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, 
								exnd.d76_adw_claim_id, reip.estimate_id,
		                        count(exnd.reinspection_id) as cnt_exrp
		                        from source.ewv_or_reinspection_ng reip inner join source.ewv_or_reinspect_excpt exnd
		                        on reip.reinspection_id = exnd.reinspection_id
		                        and reip.xc_rein_type_cd=2
		                        where  exnd.reinspection_excptn_subtype_id = 229                
		                        group by exnd.d76_pt_loss_yr, exnd.d76_pt_clm_line_cd, exnd.d76_pt_loss_st_cd, 
										exnd.d76_adw_claim_id, reip.estimate_id 
		                    ) excp_rp
		                    ON est.d70_pt_loss_yr = excp_rp.d76_pt_loss_yr
		                    AND est.d70_pt_clm_line_cd = excp_rp.d76_pt_clm_line_cd
		                    AND est.d70_pt_loss_st_cd = excp_rp.d76_pt_loss_st_cd
		                    AND est.d70_adw_claim_id = excp_rp.d76_adw_claim_id
		                    AND est.estimate_id = excp_rp.estimate_id;
quit;

proc sql;
	create table ds_latest_e01_temp as
	select temp.*,
		  allest.est_type,
		  allest.est_or_supp_amt,
		  allest.estimate_id
			from 
		(select count(distinct estimate_id) as e01count,
			max(upload_package_received_date) as max_date,
			coverage_code,
				d70_pt_loss_yr, 
			    d70_pt_clm_line_cd, 
			    d70_pt_loss_st_cd,
		        d70_adw_claim_id, 
			    involved_party_id
		from data.ds_est
		where est_type = 'E' and
				d70_adw_claim_id in (select distinct e19_n_adw_claim_id from data.dsm_base_claims)
		group by coverage_code,
				d70_pt_loss_yr, 
			    d70_pt_clm_line_cd, 
			    d70_pt_loss_st_cd,
		        d70_adw_claim_id, 
			    involved_party_id) as temp inner join data.ds_est allest
						on temp.coverage_code = allest.coverage_code 
						and temp.d70_pt_loss_yr = allest.d70_pt_loss_yr
						and temp.d70_pt_clm_line_cd = allest.d70_pt_clm_line_cd
						and temp.d70_pt_loss_st_cd = allest.d70_pt_loss_st_cd
						and temp.d70_adw_claim_id = allest.d70_adw_claim_id
						and temp.involved_party_id = allest.involved_party_id
						and temp.max_date = allest.upload_package_received_date
		where allest.est_type = 'E';
quit;
					
proc sql;
	create table ds_all_supp_temp as
	select temp.*,
		  allest.est_type,
		  allest.est_or_supp_amt,
		  allest.estimate_id
			from 
		(select count(distinct estimate_id) as supp_count,
			max(upload_package_received_date) as max_date,
			coverage_code,
				d70_pt_loss_yr, 
			    d70_pt_clm_line_cd, 
			    d70_pt_loss_st_cd,
		        d70_adw_claim_id, 
			    involved_party_id
		from data.ds_est
		where est_type = 'S' and
			d70_adw_claim_id in (select distinct e19_n_adw_claim_id from data.dsm_base_claims)
		group by coverage_code,
				d70_pt_loss_yr, 
			    d70_pt_clm_line_cd, 
			    d70_pt_loss_st_cd,
		        d70_adw_claim_id, 
			    involved_party_id) as temp inner join data.ds_est allest
						on temp.coverage_code = allest.coverage_code 
						and temp.d70_pt_loss_yr = allest.d70_pt_loss_yr
						and temp.d70_pt_clm_line_cd = allest.d70_pt_clm_line_cd
						and temp.d70_pt_loss_st_cd = allest.d70_pt_loss_st_cd
						and temp.d70_adw_claim_id = allest.d70_adw_claim_id
						and temp.involved_party_id = allest.involved_party_id
						and temp.max_date = allest.upload_package_received_date
		where allest.est_type = 'S';
quit;
		
proc sql;
	create table ds_est_final_base as 
			select 
			LATESTE.D70_ADW_CLAIM_ID,
			LATESTE.D70_PT_CLM_LINE_CD,
			LATESTE.D70_PT_LOSS_ST_CD,
			LATESTE.D70_PT_LOSS_YR,
			LATESTE.INVOLVED_PARTY_ID,
			LATESTE.COVERAGE_CODE,
			LATESTE.est_or_supp_amt as E01Est_Amt,
			LATESTE.ESTIMATE_ID as E01Est_id,
			LATESTE.max_date as e01uploaddt,
			LATESTE.E01COUNT,
			allsupp.supp_count,
			allsupp.est_or_supp_amt as Sest_Amt,
			allsupp.ESTIMATE_ID as sEst_id,
			allsupp.max_date as suploaddt
			from 
			ds_latest_e01_temp latestE left outer join ds_all_supp_temp allsupp 
			    on LATESTE.D70_ADW_CLAIM_ID = allsupp.D70_ADW_CLAIM_ID
			    and LATESTE.INVOLVED_PARTY_ID = allsupp.INVOLVED_PARTY_ID
			    and LATESTE.COVERAGE_CODE = allsupp.COVERAGE_CODE
				and LATESTE.D70_PT_CLM_LINE_CD = allsupp.D70_PT_CLM_LINE_CD
				and LATESTE.D70_PT_LOSS_ST_CD = allsupp.D70_PT_LOSS_ST_CD
				and LATESTE.D70_PT_LOSS_YR = allsupp.D70_PT_LOSS_YR;
quit;

data cpat.ds_supp_g_est(keep = D70_ADW_CLAIM_ID var_supp_g_est);
	set ds_est_final_base;
	if e01est_amt > 1000 and
		(sest_amt - e01est_amt) > (1.5 * e01est_amt)
	then var_supp_g_est = 1;
	else delete;
run;

data cpat.ds_supp_cnt_g_2 (keep = D70_ADW_CLAIM_ID var_supp_cnt_g_2);
	set ds_est_final_base;
	if supp_count > 2 and 
		sest_amt > 2000
	then var_supp_cnt_g_2 = 1;
	else delete;
run;


proc sql;
Create table cpat.dsm_other_atts_fin as 
select distinct
base.n_pymnt_id,
COVDET.ACTL_METH_OF_INSP_NM,
OFC.OFC_CLM_SRV_AREA_NM,
COVDET.CUR_DED_RTN_STS_NM,
COVDET.INJ_IND,
PROF.LS_EXP_CD,
LPERIL.LS_PERIL_TY_NM,
PROF.PMT_METH_NM,
PROF.PMT_REQ_ADDL_AUTHRTY_IND
from data.dsm_base_pymnt_dtl base 
        left join source.ewt_clm_check_Det_dim chk on  base.N_PYMNT_ID = chk.src_fin_act_id
        left join source.ewt_clm_fin_tran_fact factl on chk.clm_check_det_sk_id = FACTL.clm_check_Det_sk_id
        left join source.EWT_CLM_COV_DET_DIM covdet on FACTL.CLM_COV_DET_SK_ID = COVDET.CLM_COV_DET_SK_ID
        left join source.ewt_clm_ofc_dim ofc on FACTL.COV_ALLOC_OFC_SK_ID = OFC.CLM_OFC_SK_ID
        left join source.EWT_CLM_FIN_TRAN_PROF_DIM prof on FACTL.CLM_FIN_TRAN_PROF_SK_ID = PROF.CLM_FIN_TRAN_PROF_SK_ID
        left join source.EWT_LS_PERIL_TY_DIM lperil on FACTL.LS_PERIL_TY_SK_ID = LPERIL.LS_PERIL_TY_SK_ID;
quit;

proc sql;
create table cpat.ds_high_techrvw as
select distinct
base.n_pymnt_id,
1 as var_high_techrvw
from data.dsm_base_pymnt_dtl base 
        inner join source.ewt_clm_check_Det_dim chk on  base.N_PYMNT_ID = chk.src_fin_act_id
        inner join source.ewt_clm_fin_tran_fact factl on chk.clm_check_det_sk_id = FACTL.clm_check_Det_sk_id
        inner join source.EWT_CLM_FIN_TRAN_PROF_DIM prof on factl.CLM_FIN_TRAN_PROF_SK_ID = PROF.CLM_FIN_TRAN_PROF_SK_ID
        inner join source.EWT_CLM_COV_CD_DIM covcd on factl.CLM_COV_CD_SK_ID = COVCD.CLM_COV_CD_SK_ID
where PROF.PMT_METH_STLMT_CD in ('TREB','TRIA','TRNAE','TRS','TRSD','TRSDI') and
factl.POST_DOL_AMT > 2000 and
upcase(COVCD.CLM_COV_GP_NM) in ('COLLISION/COMP', 'COMPREHENSIVE AUTO','COLLISION');
quit;


proc sql;
	create table cpat.ds_hgh_auto_pymnt as
	select n_pymnt_id,
			1 as var_hgh_auto_pmt_no_sub
	from 
		(select base.n_line_id,
				count(base.n_pymnt_dtl_id) as pymnt_count
		from data.dsm_base_pymnt_dtl base 
		inner join source.ewt_clm_check_Det_dim chk on  base.N_PYMNT_ID = chk.src_fin_act_id
        inner join source.ewt_clm_fin_tran_fact factl on chk.clm_check_det_sk_id = FACTL.clm_check_Det_sk_id 
		inner join source.EWT_CLM_COV_DET_DIM cov on factl.CLM_COV_DET_SK_ID =  cov.CLM_COV_DET_SK_ID
		inner join source.EWT_LS_PERIL_TY_DIM lperil on factl.LS_PERIL_TY_SK_ID = LPERIL.LS_PERIL_TY_SK_ID
         inner join source.EWT_CLM_COV_CD_DIM covcd on factl.CLM_COV_CD_SK_ID = COVCD.CLM_COV_CD_SK_ID
		where lperil.CLM_LN_CD in ('010', '011', '012', '014', '015', '016', '019', '037', '038', '096') and
        		upcase(covcd.CLM_COV_GP_NM) in ('COLLISION/COMP', 'COMPREHENSIVE AUTO', 'COLLISION') and
				upcase(cov.fst_pmt_meth_stlmt_cd) in ('FLD', 'DRI') and
				upcase(cov.cur_tot_ls_ind) <> 'TOTAL LOSS'
		group by base.n_line_id) as temp inner join data.dsm_base_pymnt_dtl base
			on temp.n_line_id = base.n_line_id
	where temp.pymnt_count = 1 and
		base.a_fin_tx_amt  > 2000
;
quit;

proc sql;
create table cpat.ds_mvar_pymnt_authlmt as
select distinct 
n_pymnt_id,
'1' as var_pmt_lt_auth_lmt from 
(SELECT distinct
  factl.POST_DOL_AMT,
  base.n_pymnt_id, 
  AUTH.C_AUTH_LVL,
  AUTHLVL.N_AUTH_LMT,
  case when (prof.LS_EXP_CD = 'LOS' and auth.c_fin_Ctgy = '600') then 'LOS'
        when (prof.ls_exp_cd = 'EXP' and auth.c_fin_Ctgy = '620') then 'EXP' end as LS_EXP_CTGY,
  (AUTHLVL.n_auth_lmt - factl.post_dol_amt)/AUTHLVL.n_auth_lmt as  perct_auth_pymnt                            
from data.dsm_base_pymnt_dtl base 
		inner join source.ewt_clm_check_Det_dim chk on  base.N_PYMNT_ID = chk.src_fin_act_id
        inner join source.ewt_clm_fin_tran_fact factl on chk.clm_check_det_sk_id = FACTL.clm_check_Det_sk_id 
        inner join source.EWT_CLM_COV_CD_DIM covcd on factl.CLM_COV_CD_SK_ID = COVCD.CLM_COV_CD_SK_ID
        inner join source.EWT_CLM_FIN_TRAN_PROF_DIM prof on factl.CLM_FIN_TRAN_PROF_SK_ID = PROF.CLM_FIN_TRAN_PROF_SK_ID
        inner join source.EWT_AUTHORITY_NG auth on base.N_ORG_ENTY_ID = AUTH.N_ORG_ENTY_ID
            							and COVCD.NXTGN_CLM_COV_CD = AUTH.C_LINE_TYPE
        inner join source.EWT_REF_AUTH_LVL_NG authlvl on AUTH.C_AUTH_LVL = AUTHLVL.C_AUTH_LVL
    WHERE 
      AUTHLVL.D55_C_ADW_RCD_DEL = 'N' AND
      AUTH.D51_C_ADW_RCD_DEL = 'N' AND
      factl.POST_DOL_AMT < authlvl.N_AUTH_LMT and
      factl.POST_DOL_AMT > 0
      )
      where perct_auth_pymnt < 12 and
      LS_EXP_CTGY is not null;
quit;

