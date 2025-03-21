
--------------------
-- DATA EXTRACTION --
--------------------

------------------------------------------------------------------------------
-- Companies in corp card risk data and potentially in crypto per Pitchbook --
------------------------------------------------------------------------------

create table ngrossman_cc_crypto as
select distinct cc.company_id                        as cc_company_id,
                sf.id                                as sf_account_id,
                pb.company_id                        as pb_company_id,
                cc.company_name                      as cc_company_name,
                sf.name                              as sf_account_name,
                pb.company_name                      as pb_company_name,
                case when lower(sf.description) like '%crypto%'  or lower(sf.description) like '%blockchain%' or lower(sf.description) like '%nft%'
                       or lower(sf.description) like '%bitcoin%' or lower(sf.description) like '%ethereum%'   or lower(sf.description) like '%ledger%'                
                       or lower(pb.keywords)    like '%crypto%'  or lower(pb.keywords)    like '%blockchain%' or lower(pb.keywords)    like '%nft%'
                       or lower(pb.keywords)    like '%bitcoin%' or lower(pb.keywords)    like '%ethereum%'   or lower(pb.keywords)    like '%ledger%'
                       or lower(pb.description) like '%crypto%'  or lower(pb.description) like '%blockchain%' or lower(pb.description) like '%nft%'                       
                       or lower(pb.description) like '%bitcoin%' or lower(pb.description) like '%ethereum%'   or lower(pb.description) like '%ledger%'
                     then 1
                     else 0
                end as potential_crypto_company,
                sf.description                       as sf_description,
                pb.keywords                          as pb_keywords,
                pb.description                       as pb_description,
                cc.actual_industry_type              as cc_industry,
                sf.industry                          as sf_industry,
                sf.no_of_intnl_full_time_employees_c as sf_int_ft_emp_cnt,
                sf.no_of_us_full_time_employees_c    as sf_us_ft_emp_cnt,
                sf.website                           as sf_website
from      prod_rippling_dwh.risk.daily_risk_corporate_cards       as cc
left join prod_rippling_dwh.sfdc.account                          as sf on cc.company_id = sf.rippling_company_id_c
left join prod_rippling_dwh.growth.pitchbook_integration_company  as pb on sf.website    = pb.website;

select count(*), count(distinct(cc_company_id)) from dev_rippling_db.public.ngrossman_cc_crypto;
-- 1394, 1377

select * from dev_rippling_db.public.ngrossman_cc_crypto;

select * from dev_rippling_db.public.ngrossman_cc_crypto order by potential_crypto_company desc, cc_company_name;


----------------------
-- DATA EXPLORATION --
----------------------

select * from prod_rippling_dwh.risk.daily_risk_corporate_cards;

select * from prod_rippling_dwh.sfdc.account;

select * from prod_rippling_dwh.growth.pitchbook_integration_company;

select * from prod_dbt_db.core_growth.mart_growth__crunchbase_companies;


