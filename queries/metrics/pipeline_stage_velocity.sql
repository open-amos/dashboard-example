-- Pipeline stage velocity and conversion metrics
with opportunity_ages as (
    select
        opp.opportunity_id,
        stg.name as stage_name,
        stg."order" as stage_order,
        current_date - opp.created_at::date as days_in_pipeline,
        opp.close_date::date - current_date as days_to_close
    from dim_opportunities opp
    inner join dim_stages stg on opp.stage_id = stg.stage_id
    where stg.name not in ('Lost', 'Declined', 'Signed')
      and (opp.fund_id = '${inputs.fund.value}' or '${inputs.fund.value}' = 'ALL' or '${inputs.fund.value}' is null)
),
stage_metrics as (
    select
        stage_name,
        stage_order,
        count(*) as deal_count,
        avg(days_in_pipeline) as avg_days_in_stage,
        avg(days_to_close) as avg_days_to_close
    from opportunity_ages
    group by stage_name, stage_order
),
conversion_metrics as (
    select
        count(distinct case when stg.name = 'Sourced' then opp.opportunity_id end) as sourced_total,
        count(distinct case when stg.name in ('Investment Committee', 'Term Sheet', 'Signed') then opp.opportunity_id end) as reached_ic,
        count(distinct case when stg.name = 'Signed' then opp.opportunity_id end) as closed_total
    from dim_opportunities opp
    inner join dim_stages stg on opp.stage_id = stg.stage_id
    where (opp.fund_id = '${inputs.fund.value}' or '${inputs.fund.value}' = 'ALL' or '${inputs.fund.value}' is null)
)
select
    sm.*,
    cm.sourced_total,
    cm.reached_ic,
    cm.closed_total,
    case when cm.sourced_total > 0 then cm.reached_ic::float / cm.sourced_total else 0 end as sourced_to_ic_rate,
    case when cm.reached_ic > 0 then cm.closed_total::float / cm.reached_ic else 0 end as ic_to_closed_rate
from stage_metrics sm
cross join conversion_metrics cm
order by sm.stage_order
