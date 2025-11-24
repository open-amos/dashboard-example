-- Purpose: List active opportunities for investment pipeline page
-- Source: dim_opportunities with dimension joins using bridge tables
-- Excludes Lost and Declined (terminal states shown separately)

select
    opp.opportunity_id,
    opp.name as opportunity_name,
    comp.name as company_name,
    c.name as primary_country,
    ind.name as primary_industry,
    opp.stage_id,
    stg.name as stage_name,
    stg."order" as stage_order,
    opp.amount as expected_investment_amount,
    opp.close_date as expected_close_date,
    f.name as fund_name
from dim_opportunities opp
inner join dim_stages stg 
    on opp.stage_id = stg.stage_id
inner join dim_funds f 
    on opp.fund_id = f.fund_id
left join dim_companies comp 
    on opp.company_id = comp.company_id
left join br_opportunity_countries boc
    on opp.opportunity_id = boc.opportunity_id
    and boc.primary_flag = true
left join dim_countries c
    on boc.country_code = c.country_iso2_code
left join br_opportunity_industries boi
    on opp.opportunity_id = boi.opportunity_id
    and boi.primary_flag = true
left join dim_industries ind
    on boi.industry_id = ind.industry_id
where stg.name not in ('Lost', 'Declined')  -- Exclude terminal states
  and opp.close_date is not null
order by stg."order" asc, opp.close_date  -- Ascending order (Sourced first)