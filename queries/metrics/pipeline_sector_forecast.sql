-- Forecast exposure by sector
select
    coalesce(i.name, 'Unknown') as industry_name,
    sum(opp.amount) as forecasted_exposure,
    count(distinct opp.opportunity_id) as deal_count
from dim_opportunities opp
inner join dim_stages stg on opp.stage_id = stg.stage_id
left join br_opportunity_industries boi on opp.opportunity_id = boi.opportunity_id and boi.primary_flag = true
left join dim_industries i on boi.industry_id = i.industry_id
where stg.name not in ('Lost', 'Declined')
    and ('${inputs.fund.value}' = 'ALL' or opp.fund_id = '${inputs.fund.value}')
    and ('${inputs.stage.value}' = 'ALL' or opp.stage_id = '${inputs.stage.value}')
group by i.name
order by forecasted_exposure desc
