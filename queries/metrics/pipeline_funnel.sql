-- Purpose: Aggregate opportunity counts and values by stage for funnel chart
-- Source: dim_opportunities with related dimensions
-- Excludes Lost (terminal state, shown separately)
-- Respects canonical stage progression order

select
    stg.name as stage_name,
    stg."order" as stage_order,
    count(distinct opp.opportunity_id) as opportunity_count,
    sum(opp.amount) as total_expected_investment
from dim_opportunities opp
inner join dim_stages stg 
    on opp.stage_id = stg.stage_id
where stg.name not in ('Lost', 'Declined')  -- Exclude terminal Lost state from funnel
  and opp.close_date is not null
  and (opp.fund_id = '${inputs.fund.value}' or '${inputs.fund.value}' = 'ALL' or '${inputs.fund.value}' is null)
group by stg.name, stg."order"
order by stg."order" ASC  -- Ascending order for funnel (Sourced first)
