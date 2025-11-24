-- Pipeline Overview KPIs
select
    count(distinct opp.opportunity_id) as total_opportunities,
    count(distinct case when stg.name = 'Sourced' then opp.opportunity_id end) as sourced_count,
    count(distinct case when stg.name = 'Screening' then opp.opportunity_id end) as screening_count,
    count(distinct case when stg.name = 'Investment Committee' then opp.opportunity_id end) as ic_count,
    count(distinct case when stg.name = 'Term Sheet' then opp.opportunity_id end) as term_sheet_count,
    count(distinct case when stg.name = 'Signed' then opp.opportunity_id end) as signed_count,
    sum(opp.amount) as total_forecasted_exposure,
    avg(opp.amount) as avg_ticket_size,
    median(opp.amount) as median_ticket_size,
    -- Expected deployment in next 12 months (active stages only)
    sum(case 
        when stg.name not in ('Lost', 'Signed') 
        and opp.close_date <= current_date + interval '12 months'
        then opp.amount 
        else 0 
    end) as expected_deployment_12m
from dim_opportunities opp
inner join dim_stages stg on opp.stage_id = stg.stage_id
where stg.name not in ('Lost', 'Declined')
