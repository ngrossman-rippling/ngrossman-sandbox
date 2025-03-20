
--------------------
-- DATA EXTRACTION --
--------------------

------------------------------------------------------------------------------
-- Companies in corp card risk data and potentially in crypto per Pitchbook --
------------------------------------------------------------------------------

create table ngrossman_cc_crypto_5 as
select distinct cc.company_id               as cc_company_id,
                sf.id                       as sf_account_id,
                pb.company_id               as pb_company_id,
                cc.company_name             as cc_company_name,
                sf.name                     as sf_account_name,
                pb.company_name             as pb_company_name,
                cc.actual_industry_type     as cc_industry,
                case when lower(pb.keywords)          like '%crypto%'
                       or lower(pb.description_short) like '%crypto%'
                       or lower(pb.description)       like '%crypto%'
                       or lower(sf.description)       like '%crypto%'
                     then 1
                     else 0
                end                         as crypto_company,
    pb.keywords                             as pb_keywords,
    pb.description_short                    as pb_description_short,
    pb.description                          as pb_description,
    sf.description                          as sf_description,
    sf.industry                             as sf_industry,
    sf.website                              as sf_website
from      prod_rippling_dwh.risk.daily_risk_corporate_cards       as cc
left join prod_rippling_dwh.sfdc.account                          as sf on cc.company_id = sf.rippling_company_id_c
left join prod_rippling_dwh.growth.pitchbook_integration_company  as pb on sf.website    = pb.website;

select count(*), count(distinct(cc_company_id)) from dev_rippling_db.public.ngrossman_cc_crypto_5;
-- 1394, 1377

select * from dev_rippling_db.public.ngrossman_cc_crypto_5;


----------------------
-- DATA EXPLORATION --
----------------------

create table ngrossman_cc_crypto_1 as
select distinct cc.company_id,
                sf.id                       as sf_account_id,
                pb.company_id_from_provider as pb_company_id,
                cc.company_name,
                sf.name                     as sf_account_name,
                ic.company_name             as pb_company_name,
                case when lower(ic.keywords)          like '%crypto%'
                       or lower(ic.description_short) like '%crypto%'
                       or lower(ic.description)       like '%crypto%'
                     then 1
                     else 0
                end                         as crypto_company,
    ic.keywords,
    ic.description_short,
    ic.description,
    sf.domain_text_for_matching_c
from      prod_rippling_dwh.risk.daily_risk_corporate_cards       as cc
left join prod_rippling_dwh.sfdc.account                          as sf on sf.rippling_company_id_c      = cc.company_id
left join prod_rippling_dwh.growth.pitchbook_companies            as pb on sf.domain_text_for_matching_c = pb.website
left join prod_rippling_dwh.growth.pitchbook_integration_company  as ic on pb.company_id_from_provider   = ic.company_id;

select count(*), count(distinct(company_id)) from dev_rippling_db.public.ngrossman_cc_crypto_1;
-- 1490, 1377

select * from prod_rippling_dwh.growth.pitchbook_integration_company;


create table ngrossman_cc_crypto_2 as
select distinct cc.company_id,
                sf.id                       as sf_account_id,
                pb.company_id               as pb_company_id,
                cc.company_name,
                sf.name                     as sf_account_name,
                pb.company_name             as pb_company_name,
                cc.actual_industry_type     as cc_industry,
                case when lower(pb.keywords)          like '%crypto%'
                       or lower(pb.description_short) like '%crypto%'
                       or lower(pb.description)       like '%crypto%'
                     then 1
                     else 0
                end                         as crypto_company,
    pb.keywords,
    pb.description_short,
    pb.description,
    sf.domain_text_for_matching_c
from      prod_rippling_dwh.risk.daily_risk_corporate_cards       as cc
left join prod_rippling_dwh.sfdc.account                          as sf on cc.company_id                 = sf.rippling_company_id_c
left join prod_rippling_dwh.growth.pitchbook_integration_company  as pb on sf.domain_text_for_matching_c = pb.website;

select count(*), count(distinct(company_id)) from dev_rippling_db.public.ngrossman_cc_crypto_2;
-- 1392, 1377

select * from prod_rippling_dwh.risk.daily_risk_corporate_cards;
select count(*), count(distinct(company_id)) from prod_rippling_dwh.risk.daily_risk_corporate_cards;

select industry, industry_segment_c, corporate_card_vendor_c, corporate_cards_c, corporate_country_c,
       description, naics_code_c, rippling_risk_rating_c, ticker_symbol, vc_backed_c,
       website, domain_text_for_matching_c
from prod_rippling_dwh.sfdc.account limit 20;
create table ngrossman_test_3 as
select * from prod_rippling_dwh.risk.daily_risk_corporate_cards limit 20;

select * from dev_rippling_db.public.ngrossman_test_3;

select distinct(primary_industry_sector) from prod_rippling_dwh.growth.pitchbook_integration_company;

-- Companies in crypto according to Pitchbook
select distinct company_id, company_name, company_legal_name, keywords, description_short, description,
                primary_industry_sector, primary_industry_group, primary_industry_code, row_id
from prod_rippling_dwh.growth.pitchbook_integration_company
where lower(keywords) like '%crypto%' and lower(company_name) like 'a%'
order by company_name;

-- Companies in crypto according to Crunchbase
select uuid, name, legal_name, short_description,
       category_list, category_groups_list
from prod_rippling_dwh.crunchbase.organizations
where lower(short_description) like '%crypto%'
limit 10; 

-- Companies in corp card risk data
select distinct company_id, company_name
from prod_rippling_dwh.risk.daily_risk_corporate_cards
where lower(company_name) like 'a%'
order by company_name;

-- Companies in crypto per Pitchbook and in cord card risk data
select distinct r.company_id, r.company_name,
                p.company_id, p.company_name, p.keywords
from prod_rippling_dwh.risk.daily_risk_corporate_cards r
join prod_rippling_dwh.growth.pitchbook_integration_company p on r.company_name = p.company_name
-- where lower(p.keywords) like '%crypto%'
order by r.company_name;

-- Companies in crypto per Crunchbase and in cord card risk data
select distinct r.company_id, r.company_name,
                c.uuid, c.name, c.short_description,
from prod_rippling_dwh.risk.daily_risk_corporate_cards r
join prod_rippling_dwh.crunchbase.organizations        c on r.company_name = c.name
-- where lower(c.short_description) like '%crypto%'
order by r.company_name;


