-- Purpose: Aggregate opportunity counts and values by stage for funnel chart
-- Source: dim_opportunities with related dimensions
-- Filters for active pipeline opportunities (not Declined or Committed)

select
    stg.name as stage_name,
    stg."order" as stage_order,
    count(distinct opp.opportunity_id) as opportunity_count,
    sum(opp.amount) as total_expected_investment
from dim_opportunities opp
inner join dim_stages stg 
    on opp.stage_id = stg.stage_id
where stg.name not in ('Declined', 'Committed')
  and opp.close_date is not null
group by stg.name, stg."order"
order by stg."order" DESC
