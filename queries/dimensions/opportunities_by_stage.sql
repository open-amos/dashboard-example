-- Purpose: List opportunities grouped by stage for deal flow page
-- Source: dim_opportunities with related dimensions
-- Filters for active pipeline opportunities (not Declined or Committed)

with latest_company_info as (
    select distinct on (company_id)
        company_id,
        primary_country,
        primary_industry
    from metrics_company_performance
    order by company_id, period_end_date desc
)
select
    opp.opportunity_id,
    opp.name as opportunity_name,
    comp.name as company_name,
    lci.primary_country,
    lci.primary_industry,
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
left join latest_company_info lci
    on opp.company_id = lci.company_id
where stg.name not in ('Declined', 'Committed')
  and opp.close_date is not null
order by stg."order" desc, opp.close_date