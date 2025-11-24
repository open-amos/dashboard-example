-- Pipeline Overview KPIs
-- Respects canonical stage progression
-- Lost is tracked separately as terminal state

with active_pipeline as (
    select opp.*, stg.name as stage_name, stg."order" as stage_order
    from dim_opportunities opp
    inner join dim_stages stg on opp.stage_id = stg.stage_id
    where stg.name not in ('Lost', 'Declined')
),
lost_deals as (
    select opp.*, stg.name as stage_name
    from dim_opportunities opp
    inner join dim_stages stg on opp.stage_id = stg.stage_id
    where stg.name = 'Lost'
)
select
    -- Active pipeline counts
    count(distinct ap.opportunity_id) as total_opportunities,
    count(distinct case when ap.stage_name = 'Sourced' then ap.opportunity_id end) as sourced_count,
    count(distinct case when ap.stage_name = 'Screening' then ap.opportunity_id end) as screening_count,
    count(distinct case when ap.stage_name = 'Due Diligence' then ap.opportunity_id end) as diligence_count,
    count(distinct case when ap.stage_name = 'Investment Committee' then ap.opportunity_id end) as ic_count,
    count(distinct case when ap.stage_name = 'Term Sheet' then ap.opportunity_id end) as term_sheet_count,
    count(distinct case when ap.stage_name = 'Signed' then ap.opportunity_id end) as signed_count,
    count(distinct case when ap.stage_name = 'Closed' then ap.opportunity_id end) as closed_count,
    
    -- Lost deals (separate)
    (select count(distinct opportunity_id) from lost_deals) as lost_count,
    
    -- Value metrics
    sum(ap.amount) as total_forecasted_exposure,
    avg(ap.amount) as avg_ticket_size,
    
    -- Expected deployment in next 12 months (Term Sheet, Signed, Closed only)
    sum(case 
        when ap.stage_name in ('Term Sheet', 'Signed', 'Closed')
        and ap.close_date <= current_date + interval '12 months'
        then ap.amount 
        else 0 
    end) as expected_deployment_12m
from active_pipeline ap
