create table dsm_pymnt_vehicle_info_final as
select /*+ parallel(dtl,7) parallel(l,7) parallel(ir,7) parallel(cpr, 7) parallel(ii,7) parallel(veh,7)*/ distinct
    veh.d57_n_ADw_claim_id,
        veh.N_MODEL_YEAR_NBR,
        veh.M_MAKE_NM,
        veh.M_MODEL_NM,
        veh.n_item_id,
        DTL.N_PYMNT_ID,
        DTL.N_PYMNT_DTL_ID
from   NGPROD.ewt_payment_ng pymnt inner join ngprod.ewt_payment_dtl_ng dtl on
                pymnt.n_pymnt_id = DTL.N_PYMNT_ID
             inner join NGPROD.EWT_LINE_NG l on
           DTL.E19_N_ADW_CLAIM_ID = L.E24_N_ADW_CLAIM_ID and
           DTL.E19_C_PT_CLM_LINE_CD = L.E24_C_PT_CLM_LINE_CD and
           DTL.E19_C_PT_LOSS_ST_CD = L.E24_C_PT_LOSS_ST_CD and
           DTL.E19_N_PT_LOSS_YR = L.E24_N_PT_LOSS_YR 
                                       inner join NGPROD.EWT_CLAIMANT_ROLE_NG CR on
           L.E24_C_PT_CLM_LINE_CD = CR.E39_C_PT_CLM_LINE_CD and
           L.E24_C_PT_LOSS_ST_CD = CR.E39_C_PT_LOSS_ST_CD and
           L.E24_N_ADW_CLAIM_ID = CR.E39_N_ADW_CLAIM_ID and
           L.E24_N_PT_LOSS_YR = CR.E39_N_PT_LOSS_YR and
           L.N_CLAIMANT_ROLE_ID = CR.N_CLAIMANT_ROLE_ID 
                                       inner join ngprod.EWT_involvement_role_NG ir on
           CR.E39_C_PT_CLM_LINE_CD = IR.E43_C_PT_CLM_LINE_CD and
           CR.E39_C_PT_LOSS_ST_CD = IR.E43_C_PT_LOSS_ST_CD and
           CR.E39_N_ADW_CLAIM_ID = IR.E43_N_ADW_CLAIM_ID and
          CR.E39_N_PT_LOSS_YR = IR.E43_N_PT_LOSS_YR and
           CR.N_CLAIMANT_ROLE_ID = IR.N_INVL_ROLE_ID
                                       inner join NGPROD.claim_party_role cpr on
           cpr.N_INVL_ROLE_ID = ir.N_INVL_ROLE_ID and
           cpr.R05_N_PT_LOSS_YR = ir.E43_N_PT_LOSS_YR and
           cpr.R05_C_PT_LOSS_ST_CD = ir.E43_C_PT_LOSS_ST_CD and
           cpr.R05_C_PT_CLM_LINE_CD = ir.E43_C_PT_CLM_LINE_CD and
           cpr.R05_N_ADW_CLAIM_ID = ir.E43_N_ADW_CLAIM_ID
                                       inner join NGPROD.EWT_item_involvement_NG ii on
           cpr.N_ITEM_INVL_ID = ii.N_ITEM_INVL_ID and
           cpr.R05_N_PT_LOSS_YR = ii.E33_N_PT_LOSS_YR and
           cpr.R05_C_PT_LOSS_ST_CD = ii.E33_C_PT_LOSS_ST_CD and
           cpr.R05_C_PT_CLM_LINE_CD = ii.E33_C_PT_CLM_LINE_CD and
           cpr.R05_N_ADW_CLAIM_ID = ii.E33_N_ADW_CLAIM_ID
                                       inner join ngprod.ewt_vehicle_ng veh on
           ii.n_item_id = veh.n_item_id and
           ii.e33_n_pt_loss_yr = veh.d57_n_pt_loss_yr and 
           ii.e33_c_pt_clm_line_cd = veh.d57_c_pt_clm_line_cd and
           ii.e33_c_pt_loss_st_cd = veh.d57_c_pt_loss_st_cd and
           ii.e33_n_adw_claim_id = veh.d57_n_adw_claim_id 
where cpr.R05_D_END_ATOMIC_TS = TO_TIMESTAMP('9999-12-31 23:59:59.999999','YYYY-MM-DD HH24:MI:SS.FF6')
       and l.E24_C_ADW_RCD_DEL = 'N'
       and cr.E39_C_ADW_RCD_DEL = 'N'
       and ir.E43_C_ADW_RCD_DEL = 'N'
       and cpr.R05_C_ADW_RCD_DEL = 'N'
      and II.E33_C_ADW_RCD_DEL = 'N'
       and VEH.D57_C_ADW_RCD_DEL = 'N' 
    and trunc(PYMNT.D_ISSUE_DT) between to_Date('06/01/2011','mm/dd/yyyy') and to_Date('05/31/2013','mm/dd/yyyy')

