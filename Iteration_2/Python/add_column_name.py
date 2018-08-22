#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 15 14:50:02 2018

@author: yuchenli
@content: add column name to AMEX data
"""

import pandas as pd
import numpy as np

# Eligibility, rename the columns such that it aligns with Nicole's SAS code
df = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/'\
                 'Opioid_progression/Iteration_2/Data/'\
                 'amex_opioid_elig_1212278.csv', sep = ',',
                 index_col = False, header = None, dtype = np.str,
                 encoding = 'utf-8')

df.columns = ['year',
            'enrolid',
            'employer_cd',
            'elig_start_dt',
            'sex',
            'mdst_age_grp_cd',
            'age_years',
            'zip_cd',
            'state_cd',
            'msa_cd',
            'years_svc',
            'salary_ind',
            'union_worker_ind',
            'business_unit_cd',
            'mdst_plan_model_cd',
            'mdst_plan_model',
            'family_id',
            'mdst_relation_cd',
            'medical_covg_ind',
            'drug_covg_ind',
            'dental_covg_ind',
            'plan_cd',
            'plan',
            'table']

df.to_csv('/Users/yuchenli/Box Sync/Yuchen_project/'\
          'Opioid_progression/Iteration_2/Data/'\
          'amex_opioid_elig_1212278_with_column_names.csv', encoding = 'utf-8',
          index = False)


# Claims
df = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/'\
                 'Opioid_progression/Iteration_2/Data/'\
                 'amex_opioid_claims_1212277.csv', sep = ',',
                 index_col = False, header = None, encoding = 'utf-8',
                 dtype = np.str)

df.columns = ['year_paid',
            'enrolid',
            'employer_cd',
            'claim_id',
            'line_nbr',
            'svcdate',
            'tsvcdate',
            'dstatus',
            'cap_svc_ind',
            'paiddt',
            'pay',
            'chg',
            'netpay',
            'paid_in_ntwk_ind',
            'ntwk_prov_ind',
            'coins_copay_deduct',
            'coins',
            'copay',
            'deduct',
            'proc1',
            'proc_system_cd',
            'proc_cat_cd',
            'procgrp',
            'dxcat',
            'clincond',
            'dx1',
            'dx2',
            'dx3',
            'dx4',
            'dx5',
            'dx6',
            'dx7',
            'dx8',
            'dx9',
            'dx10',
            'dxver',
            'drg',
            'svcscat',
            'mdst_svc_subcat_cd',
            'mdc',
            'ndcnum',
            'dtl_ther_class_cd',
            'int_ther_class_cd',
            'stdplac',
            'prov_id',
            'mdst_prov_type',
            'stdprov',
            'npi',
            'prov_name',
            'std_hosp',
            'ord_prov',
            'ord_prov_name',
            'daysupp',
            'rx_refill_nbr',
            'compound_cd',
            'epi_id',
            'adm_id',
            'revcode',
            'rb_flag',
            'mdst_place_grp_cd',
            'table']


# Read redbook
redbook  = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/'
                             'Opioid_progression/Iteration_2/Nicole/'
                             'data/redbook.csv', sep = ',',
                 index_col = False, encoding = 'utf-8',
                 dtype = np.str)

NDCNUM_GENERID = dict()
for i in range(len(redbook)):
    NDCNUM_GENERID[redbook.loc[i,'NDCNUM']] = redbook.loc[i,'GENERID']


# Map NDCNUM to GENERID
GENERID_list = list()
for i in range(len(df)):
    if (i%50000==0):
        print(i)
    ndcnum = df.loc[i,'ndcnum']
    try:
        GENERID = NDCNUM_GENERID[ndcnum]
    except KeyError:
        GENERID = 'NA'        
    GENERID_list.append(GENERID)

df['GENERID'] = GENERID_list

df.to_csv('/Users/yuchenli/Box Sync/Yuchen_project/'\
          'Opioid_progression/Iteration_2/Data/'\
          'amex_opioid_claims_1212277_with_GENERID.csv', encoding = 'utf-8',
          index = False, header = False)


# Admission
df = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/'\
                 'Opioid_progression/Iteration_2/Data/'\
                 'amex_opioid_admit_1212284.csv', sep = ',',
                 index_col = False, header = None, encoding = 'utf-8',
                 dtype = np.str)

df.columns = ['year',
            'enrolid',
            'employer_cd',
            'adm_id',
            'admdate',
            'pddate',
            'svcdate',
            'proc1',
            'drg',
            'pdx',
            'dxver',
            'totchg',
            'totpay',
            'totnetpay',
            'los',
            'table']

df.to_csv('/Users/yuchenli/Box Sync/Yuchen_project/'\
          'Opioid_progression/Iteration_2/Data/'\
          'amex_opioid_admit_1212284_with_column_names.csv', encoding = 'utf-8',
          index = False)


# Episode
df = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/'\
                 'Opioid_progression/Iteration_2/Data/'\
                 'amex_opioid_epis_1212285.csv', sep = ',',
                 index_col = False, header = None, encoding = 'utf-8',
                 dtype = np.str)

df.columns = ['year',
            'enrolid',
            'employer_cd',
            'epi_id',
            'epi_adm_cnt',
            'epi_rx_cnt',
            'svcdate',
            'tsvcdat',
            'epi_days_cnt',
            'epi_grp_cd',
            'epi_incomplete_ind',
            'epi_proc_type_cd',
            'epi_disease_stg_cd',
            'epi_pay',
            'epi_submit',
            'epi_netpay',
            'epi_op_pay',
            'epi_op_submit',
            'epi_op_netpay',
            'Allowed Amount Med Epis',
            'Charge Submitted Med Epis',
            'Net Payment Med Epis',
            'epi_rx_pay',
            'epi_rx_submit',
            'epi_rx_netpay',
            'epi_tot_pay',
            'epi_tot_submit',
            'epi_tot_netpay',
            'prov_id',
            'mng_phys_type',
            'mng_phys_type_cd',
            'prov_id',
            'mdst_phys_type',
            'stdprov',
            'table']

df.to_csv('/Users/yuchenli/Box Sync/Yuchen_project/'\
          'Opioid_progression/Iteration_2/Data/'\
          'amex_opioid_epis_1212285_with_column_names.csv', encoding = 'utf-8',
          index = False)


# Read random sas7bdat file
df = pd.read_sas('/Users/yuchenli/Box Sync/Yuchen_project/'
                 'Opioid_progression/Iteration_2/SAS/elig.sas7bdat')


df = pd.read_sas('/Users/yuchenli/Box Sync/Yuchen_project/'
                 'Opioid_progression/Iteration_2/SAS/'
                 'opioid_vs_2017.sas7bdat')